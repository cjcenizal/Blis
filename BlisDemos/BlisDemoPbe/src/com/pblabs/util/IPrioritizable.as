/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.util
{
    /**
     * Minimal interface required by SimplePriorityQueue.
     * 
     * <p>Items are prioritized so that the highest priority is returned first.</p>
     * 
     * @see SimplePriorityQueue
     */
    public interface IPrioritizable
    {
        function get priority():int;
        
        /**
         * Change the priority. You only need to implement this if you want
         * SimplePriorityHeap.reprioritize to work. Otherwise it can
         * simply throw an Error.
         */
        function set priority(value:int):void;
    }
}