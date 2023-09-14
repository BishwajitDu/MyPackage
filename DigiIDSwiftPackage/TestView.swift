//
//  TestView.swift
//  
//
//  Created by D, Bishwajit (Consumer Servicing & Engagement) on 14/09/23.
//

import UIKit
import YotiButtonSDK

public class TestView: UIView {
    
    private enum Constants {
        static let usecaseID = "test_ios"
        static let sdkId = "f6fcff99-02d7-4e42-b915-0497b7dddbb2"
        static let scenarioId = "24a66d72-baef-4496-a0bf-ffc8b4698aab"
        static let callBackUrl = "https://android-test-yoti.herokuapp.com/profile-json"
    }
    
    private lazy var yotiBtn : YotiButton = {
        let btn = YotiButton(frame: YotiButton.defaultFrame)
        btn.useCaseID = Constants.usecaseID
        btn.theme = .yoti
        btn.action = { [weak self] (button)  in
            self?.handleButtonTap(button)
        }
        return btn
    }()
    
    public func check() {
        
    }
    
    private lazy var messageLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.font = UIFont.systemFont(ofSize: 16.0)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.textColor = UIColor.black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var loadigIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.hidesWhenStopped = true
        activity.color = UIColor.black
        return activity
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupConfiguration()
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfiguration() {
        do {
            guard let url = URL(string: Constants.callBackUrl) else {
                return
            }
            //Here we need to add as many scenarios as we want. each scenario is linked to a button in the Main.storyboard.
            let scenario = try ScenarioBuilder().setUseCaseID(Constants.usecaseID)
                .setClientSDKID(Constants.sdkId)
                .setScenarioID(Constants.scenarioId)
                .setCallbackBackendURL(url)
                .create()
            YotiSDK.add(scenario: scenario)
        } catch {
            // handle error code here
            print("init error ... \(error.localizedDescription)")
        }
    }
    
    private func layoutView() {
        self.addSubview(yotiBtn)
        self.addSubview(messageLabel)
        self.addSubview(loadigIndicator)
        let btnHeignt = yotiBtn.theme == .partnership ? 100 : 50
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-400-[mv]-40-[bv(\(btnHeignt))]", metrics: nil, views: ["bv" : yotiBtn, "mv" : messageLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[bv]-8-|", metrics: nil, views: ["bv" : yotiBtn]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[mv]-8-|", metrics: nil, views: ["mv" : messageLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[lv]-|", metrics: nil, views: ["lv" : loadigIndicator]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[lv]-|", metrics: nil, views: ["lv" : loadigIndicator]))
    }
    
    @objc private func launchYoti() {
        handleLoading()
        do {
            try YotiSDK.startScenario(for: Constants.usecaseID, with: self)
        } catch {
            // Handle error here
            print("Its an error at launch yoti... \(error.localizedDescription)")
            handleLoading()
            messageLabel.text = "Its an error at launch yoti... \(error.localizedDescription)"
        }
    }
    
    private func handleButtonTap(_ sender: YotiButton) {
        messageLabel.text = ""
        messageLabel.isHidden = true
        handleLoading()
        guard let useCaseID = sender.useCaseID else {
            return
        }
        do {
            try YotiSDK.startScenario(for: useCaseID, with: self)
        } catch {
            // Handle error here
            print("Its an error at button tap... \(error.localizedDescription)")
            handleLoading()
            messageLabel.isHidden = false
            messageLabel.text = "Its an error at button tap... \(error.localizedDescription)"
        }
    }
    
    private func handleSetupError(_ error: SetupError) {
        switch error as SetupError {
            case .noIDAppInstalled(let url): UIApplication.shared.open(url, options: [:])
            default: break
        }
    }
    
    private func handleLoading() {
        if loadigIndicator.isAnimating {
            loadigIndicator.stopAnimating()
            return
        }
        loadigIndicator.startAnimating()
    }
}

extension TestView : SDKDelegate, BackendDelegate {
    
    public func yotiSDKDidFail(for useCaseID: String, appStoreURL: URL?, with error: Error) {
        print("Yoti SDK did fail ... \(error.localizedDescription)")
        messageLabel.isHidden = false
        messageLabel.text = "Yoti SDK did fail ... \(error.localizedDescription)"
        if let setupError = error as? SetupError {
            handleSetupError(setupError)
        }
    }
    
    public func yotiSDKDidSucceed(for useCaseID: String, baseURL: URL?, token: String?, url: URL?) {
        // Handle here the success of the opening of Yoti app for example by requesting a profile from the backend like below
        // Get the specific scenario by calling
        let scenario = YotiSDK.scenario(for: useCaseID)
        // Request the backend to get the profile linked to a specific scenario by passing the token returned and self as delegate for a callback
        print("Token received ... \(String(describing: token))")
        messageLabel.isHidden = false
        yotiBtn.isHidden = true
        messageLabel.text = "Token received \n \(String(describing: token))"
        YotiSDK.callbackBackend(scenario: scenario!, token: token!, with: self)
    }
    
    public func yotiSDKDidOpenYotiApp() {
        // Handle specific behaviour if needed when the Yoti App didOpen
    }
    public func backendDidFinish(with data: Data?, error: Error?) {
        print("backend call error ... \(String(describing: error?.localizedDescription))")
        messageLabel.isHidden = false
        messageLabel.text = "backend call error ... \(String(describing: error?.localizedDescription))"
        guard let data = data else {
            return
        }
//        do {
//          let decodedJson = try JSONDecoder().decode(ProfileDictionary.self, from: data)
//            responseObject = decodedJson
//          moveToProfile()
//        } catch let error {
//            print("backend call error ... \(error.localizedDescription)")
//        }
    }
}
