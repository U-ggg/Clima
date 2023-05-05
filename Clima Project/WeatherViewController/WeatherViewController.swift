//
//  WeatherViewController.swift
//  Clima Project
//
//  Created by sidzhe on 25.04.2023.
//

import UIKit
import SnapKit
import CoreLocation

class WeatherViewController: UIViewController {
    
//MARK: UI Elements
    
    private let myView = UIView()
    
    private var weatherManager = WeatherManager()
    
    private lazy var coreLocation: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: Const.Image.location), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(pressedLocationButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var findButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: Const.Image.find), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(pressedFindButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var weatherImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: Const.Image.weather)
        image.tintColor = UIColor(named: Const.Image.color)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = Const.Str.london
        label.font = .systemFont(ofSize: 40, weight: .heavy)
        label.textColor = UIColor(named: Const.Image.color)
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = Const.Str.twentyOne
        label.font = .systemFont(ofSize: 80, weight: .heavy)
        label.textAlignment = .right
        label.textColor = UIColor(named: Const.Image.color)
        return label
    }()
    
    private lazy var signLabel: UILabel = {
        let label = UILabel()
        label.text = Const.Str.temp
        label.font = .systemFont(ofSize: 100, weight: .thin)
        label.textAlignment = .right
        label.textColor = UIColor(named: Const.Image.color)
        return label
    }()
    
    private lazy var celsiusLabel: UILabel = {
        let label = UILabel()
        label.text = Const.Str.celsius
        label.font = .systemFont(ofSize: 100, weight: .thin)
        label.textAlignment = .right
        label.textColor = UIColor(named: Const.Image.color)
        return label
    }()
    
    private lazy var backgrImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: Const.Image.lightBackground)
        return image
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .trailing
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var temperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 1
        return stackView
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var headerTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = Const.Str.search
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.returnKeyType = .continue
        textField.autocapitalizationType = .words
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
//MARK: Private methods
    
    private func setupViews() {
        coreLocation.delegate = self
        coreLocation.requestLocation()
        weatherManager.delegate = self
        
        view.addSubview(backgrImage)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(textFieldStackView)
        stackView.addArrangedSubview(weatherImage)
        stackView.addArrangedSubview(temperatureStackView)
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(myView)
        
        temperatureStackView.addArrangedSubview(valueLabel)
        temperatureStackView.addArrangedSubview(signLabel)
        temperatureStackView.addArrangedSubview(celsiusLabel)
        
        textFieldStackView.addArrangedSubview(locationButton)
        textFieldStackView.addArrangedSubview(headerTextField)
        textFieldStackView.addArrangedSubview(findButton)
        
        backgrImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        
        weatherImage.snp.makeConstraints { make in
            make.size.equalTo(120)
        }
        
        textFieldStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        headerTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
        }
    }
    
//MARK: Taps methods
    
    @objc private func pressedLocationButton() {
        coreLocation.requestLocation()
    }
    
    @objc private func pressedFindButton() {
        guard let text = headerTextField.text else { return }
        weatherManager.fetchWeather(cityName: text)
        headerTextField.text = ""
        headerTextField.resignFirstResponder()
    }
}

//MARK: Extension WeaterDelegate, UITextFieldDelegate, CLLocationManagerDelegate

extension WeatherViewController: WeaterDelegate {
    func setWeather(_ weatherManager: WeatherManager, _ weaterModel: WeatherModel) {
        DispatchQueue.main.async {
            self.valueLabel.text = weaterModel.tempCelsius
            self.cityLabel.text = weaterModel.name
            self.weatherImage.image = UIImage(systemName: weaterModel.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}


extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        weatherManager.fetchWeather(cityName: text)
        textField.text = ""
    }
}


extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        coreLocation.startUpdatingLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherManager.fetchWeather(lat: lat, lon: lon)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
