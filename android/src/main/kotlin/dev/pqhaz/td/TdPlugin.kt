package dev.pqhaz.td

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.drinkless.tdlib.JsonClient
import org.drinkless.tdlib.JsonClient.execute
import org.drinkless.tdlib.JsonClient.send


/** TdPlugin */
class TdPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var eventsChannel: EventChannel

  private var clientId: Long = 0;
  private var clientThread: Thread? = null


  class ClientEventsThread(val clientId: Long, val events: EventChannel.EventSink?) : Thread() {
    override fun run() {
      while (true) {
        if (!interrupted()) {
          val response: String? = JsonClient.receive(clientId, 1.0);
          Handler(Looper.getMainLooper()).post {
            events?.success(response)
          }
        } else {
          break
        }
      }
    }
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "channel/to/tdlib")
    eventsChannel = EventChannel(flutterPluginBinding.binaryMessenger, "channel/to/tdlib/receive")
    eventsChannel.setStreamHandler(object: EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d("TdPlugin", "Listen called")
        if (clientThread != null) return
        clientThread = ClientEventsThread(clientId, events)
        clientThread?.start()
      }

      override fun onCancel(arguments: Any?) {
        // TODO("Not yet implemented")
      }
    })
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    Log.d("TdPlugin", "Receiving method call -> " + call.method)

    when (call.method) {
      "clientCreate" -> {
        if (clientId.toInt() != 0) {
          // Should occur after hot restart
          Log.d("TdPlugin", "Client exists, recreating")
          clientThread?.interrupt()
          clientThread?.join()
          clientThread = null
          JsonClient.destroy(clientId)
        }

        clientId = JsonClient.create()
        result.success(clientId)
      }
      "clientDestroy" -> {
        if (clientId.toInt() == 0) {
          result.error("ERROR", "NOT_FOUND", "Client not found")
          return
        }
        JsonClient.destroy(clientId)
        return result.success(null)
      }
      "clientSend" -> {
        send(clientId, call.argument("query") as String?)
        result.success(null)
      }
      "clientExecute" -> {
        val res = execute(clientId, call.argument("query") as String?)
        result.success(res)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    eventsChannel.setStreamHandler(null);
  }
}