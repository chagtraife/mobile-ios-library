//
//  ServiceQualityManager.swift
//  PIALibrary
//  
//  Created by Jose Blaya on 24/3/21.
//  Copyright © 2021 Private Internet Access, Inc.
//
//  This file is part of the Private Internet Access iOS Client.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software 
//  without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to 
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//

import Foundation
import PIAKPI

public class ServiceQualityManager: NSObject {

    private var kpiToken = "123456"
    private let connectionType = "manual"
    public static let shared = ServiceQualityManager()
    private var kpiManager: KPIAPI!

    public override init() {
        super.init()
        
        if Client.environment == .staging {
            kpiManager = KPIBuilder()
                .setAppVersion(appVersion: "3.2.0")
                .setKPIFlushEventMode(kpiSendEventMode: .perBatch)
                .setKPIClientStateProvider(kpiClientStateProvider: PIAKPIClientStateProvider())
                .build()
        } else {
            kpiManager = KPIBuilder()
                .setAppVersion(appVersion: "3.2.0")
                .setKPIFlushEventMode(kpiSendEventMode: .perBatch)
                .setKPIClientStateProvider(kpiClientStateProvider: PIAKPIStagingClientStateProvider())
                .build()
        }

    }
    
    deinit {
    }

    public func start() {
        guard kpiManager != nil else {
            return
        }
        kpiManager.start()
    }

    public func stop() {
        guard kpiManager != nil else {
            return
        }
        kpiManager.stop()
    }
    
    public func connectionAttemptEvent() {
        guard kpiManager != nil else {
            return
        }
        kpiManager.submit(event: KPIClientEvent(eventCountry: nil, eventName: KPIConnectionEvent.connectionAttempt, eventProperties: KPIClientEvent.EventProperties(connectionSource: "manual", data: nil, preRelease: Client.environment == .staging ? true : false, reason: nil, serverIdentifier: nil, userAgent: PIAWebServices.userAgent, vpnProtocol: Client.providers.vpnProvider.currentVPNType), eventToken: kpiToken)) { (error) in
            print("sent")
        }
    }

    public func connectionEstablishedEvent() {
        guard kpiManager != nil else {
            return
        }
        kpiManager.submit(event: KPIClientEvent(eventCountry: nil, eventName: KPIConnectionEvent.connectionEstablished, eventProperties: KPIClientEvent.EventProperties(connectionSource: "manual", data: nil, preRelease: Client.environment == .staging ? true : false, reason: nil, serverIdentifier: nil, userAgent: PIAWebServices.userAgent, vpnProtocol: Client.providers.vpnProvider.currentVPNType), eventToken: kpiToken)) { (error) in
            print("sent")
        }
    }

    public func connectionCancelledEvent() {
        guard kpiManager != nil else {
            return
        }
        kpiManager.submit(event: KPIClientEvent(eventCountry: nil, eventName: KPIConnectionEvent.connectionCanceled, eventProperties: KPIClientEvent.EventProperties(connectionSource: "manual", data: nil, preRelease: Client.environment == .staging ? true : false, reason: nil, serverIdentifier: nil, userAgent: PIAWebServices.userAgent, vpnProtocol: Client.providers.vpnProvider.currentVPNType), eventToken: kpiToken)) { (error) in
            print("sent")
        }
    }

    public func availableData(completion: @escaping (([String]) -> Void)) {
        guard kpiManager != nil else {
            return
        }
        kpiManager.recentEvents { events in
            completion(events)
        }
    }

}
