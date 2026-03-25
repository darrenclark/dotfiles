#!/usr/bin/env swift

import AVFoundation
import Foundation

/// Check if any audio input device is currently being used by another process
func isMicrophoneInUse() -> Bool {
    // Get the default input device
    var deviceID = AudioDeviceID(0)
    var propertySize = UInt32(MemoryLayout<AudioDeviceID>.size)
    
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDefaultInputDevice,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    
    let status = AudioObjectGetPropertyData(
        AudioObjectID(kAudioObjectSystemObject),
        &address,
        0,
        nil,
        &propertySize,
        &deviceID
    )
    
    guard status == noErr, deviceID != kAudioDeviceUnknown else {
        // If we can't determine, err on the side of caution
        return false
    }
    
    // Check if the device is being used (running)
    var isRunning: UInt32 = 0
    propertySize = UInt32(MemoryLayout<UInt32>.size)
    
    address = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyDeviceIsRunningSomewhere,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    
    let runningStatus = AudioObjectGetPropertyData(
        deviceID,
        &address,
        0,
        nil,
        &propertySize,
        &isRunning
    )
    
    guard runningStatus == noErr else {
        return false
    }
    
    return isRunning != 0
}

// Get command line arguments (skip the script name)
let args = Array(CommandLine.arguments.dropFirst())

// If mic is in use, exit silently
if isMicrophoneInUse() {
    exit(0)
}

// Forward all arguments to `say`
let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/bin/say")
process.arguments = args

do {
    try process.run()
    process.waitUntilExit()
    exit(process.terminationStatus)
} catch {
    fputs("Error running say: \(error.localizedDescription)\n", stderr)
    exit(1)
}
