//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "60C2C257-071D-406D-9A49-557BEE892C64"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        print(currency)
        let urlString = baseURL + currency + "/USD?apikey=" + apiKey
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }else{
                    parseJSON(data: data!, currency: currency)
                    let dataAsString = String(data: data!, encoding: .utf8)
                    print(dataAsString!)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(data: Data, currency: String){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let priceString = String(format: ".%2f", decodedData.rate)
            delegate?.didUpdatePrice(price: priceString, currency: currency)
        }catch{
            delegate?.didFailWithError(error: error)
            print(error)
        }
    }
}
