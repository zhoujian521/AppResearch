//
//  Log.swift
//  GethTest
//
//  Created by Ronald Mannak on 9/29/17.
//  Copyright © 2017 Indisputable. All rights reserved.
//

import Foundation
import Geth

/**
 * Log represents a contract log event. These events are generated by the LOG
 opcode and stored/indexed by the node.
 */
public struct Log {
    let address: Address
    let blockHash: Hash
    let blockNumber: Int64
    let data: Data
    let index: Int
    let topics: [Hash] // [Topic] ?
    let txHash: Hash
    let txIndex: Int
    
    init(gethLog: GethLog) throws {
        address     = Address(address: gethLog.getAddress())
        blockHash   = Hash(hash: gethLog.getBlockHash())
        blockNumber = gethLog.getBlockNumber()
        data        = gethLog.getData()
        index       = gethLog.getIndex()
        topics      = try gethLog.getTopics().array()
        txHash      = Hash(hash: gethLog.getTxHash())
        txIndex     = gethLog.getTxIndex()
    }
}
