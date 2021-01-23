//
// Copyright Aliaksei Levin (levlam@telegram.org), Arseny Smirnov (arseny30@gmail.com) 2014-2020
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//

// Conveted to Kotlin.
package org.drinkless.tdlib

/**
 * Main class for interaction with the TDLib using JSON interface.
 */
object JsonClient {
    external fun create(): Long
    external fun send(client: Long, request: String?)
    external fun receive(client: Long, timeout: Double): String?
    external fun execute(client: Long, request: String?): String?
    external fun destroy(client: Long)

    init {
        try {
            System.loadLibrary("tdjsonandroid")
        } catch (e: UnsatisfiedLinkError) {
            e.printStackTrace()
        }
    }
}