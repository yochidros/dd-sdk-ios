/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation

extension RUMDevice {
    init(from device: MobileDevice, telemetry: Telemetry?) {
        self.init(
            brand: device.brand,
            model: device.model,
            name: device.name,
            type: {
                if let type = RUMDeviceType(from: device.model) {
                    return type
                } else {
                    telemetry?.debug("Couldn't read `RUMDeviceType` from `device.model`: \(device.model)")
                    return .other
                }
            }()
        )
    }
}

private extension RUMDevice.RUMDeviceType {
    init?(from deviceModel: String) {
        let lowercasedModel = deviceModel.lowercased()

        if lowercasedModel.hasPrefix("iphone") || lowercasedModel.hasPrefix("ipod") {
            self = .mobile
        } else if lowercasedModel.hasPrefix("ipad") {
            self = .tablet
        } else if lowercasedModel.hasPrefix("appletv") {
            self = .tv
        } else {
            return nil
        }
    }
}
