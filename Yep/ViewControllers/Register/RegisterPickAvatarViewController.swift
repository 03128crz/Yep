//
//  RegisterPickAvatarViewController.swift
//  Yep
//
//  Created by NIX on 15/3/18.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import AVFoundation

class RegisterPickAvatarViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var cameraPreviewView: CameraPreviewView!

    lazy var sessionQueue = {
        return dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL)
        }()

    lazy var session: AVCaptureSession = {
        let _session = AVCaptureSession()
        _session.sessionPreset = AVCaptureSessionPreset640x480

        return _session
        }()

    let mediaType = AVMediaTypeVideo

    lazy var videoDeviceInput: AVCaptureDeviceInput = {
        var error: NSError? = nil
        let videoDevice = self.deviceWithMediaType(self.mediaType, preferringPosition: .Front)
        return AVCaptureDeviceInput(device: videoDevice!, error: &error)
        }()

    lazy var stillImageOutput: AVCaptureStillImageOutput = {
        let _stillImageOutput = AVCaptureStillImageOutput()
        _stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        return _stillImageOutput
        }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tryOpenCamera()
    }

    // Helpers

    func deviceWithMediaType(mediaType: String, preferringPosition position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devicesWithMediaType(mediaType)
        var captureDevice = devices.first as? AVCaptureDevice
        for device in devices as! [AVCaptureDevice] {
            if device.position == position {
                captureDevice = device
                break
            }
        }

        return captureDevice
    }

    // Actions

    func tryOpenCamera() {

        AVCaptureDevice.requestAccessForMediaType(mediaType, completionHandler: { (granted) -> Void in
            if granted {
                self.openCamera()

            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    YepAlert.alertSorry(message: NSLocalizedString("Yep doesn't have permission to use Camera, please change privacy settings", comment: ""), inViewController: self)
                }
            }
        })
    }

    func openCamera() {

        dispatch_async(sessionQueue) {
            //[self setBackgroundRecordingID:UIBackgroundTaskInvalid];

            if self.session.canAddInput(self.videoDeviceInput) {
                self.session.addInput(self.videoDeviceInput)

                dispatch_async(dispatch_get_main_queue()) {
                    self.cameraPreviewView.session = self.session
                    let orientation = AVCaptureVideoOrientation(rawValue: UIInterfaceOrientation.Portrait.rawValue)!
                    (self.cameraPreviewView.layer as! AVCaptureVideoPreviewLayer).connection.videoOrientation = orientation

                    self.session.startRunning()
                }
            }

            if self.session.canAddOutput(self.stillImageOutput){
                self.session.addOutput(self.stillImageOutput)
            }
        }
    }

}
