/* Copyright 2008 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */ 
package com.google.dataconnector.util;

/**
 * Exception for all connection related errors.
 * 
 * @author rayc@google.com (Ray Colline)
 */
public class ConnectionException extends Exception {

  /**
   * Creates the exception with the specified error message.
   * 
   * @param msg the error message.
   */
  public ConnectionException(String msg) {
    super(msg);
  }
  
  /**
   * Creates the exception with the specified underlying cause.
   * 
   * @param cause the underlying cause.
   */
  public ConnectionException(Throwable cause) {
    super(cause);
  }
  
  /**
   * Creates the exception with the specified error message and cause.
   * 
   * @param msg the error message.
   * @param cause the underlying cause.
   */
  public ConnectionException(String msg, Throwable cause) {
    super(msg, cause);
  }
}
