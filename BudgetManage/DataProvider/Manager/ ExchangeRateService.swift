//
//   ExchangeRateService.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 25.07.2024.
//

import Foundation
import Alamofire

class ExchangeRateService {
    static let shared = ExchangeRateService()
    
    private let baseURL = "https://v6.exchangerate-api.com/v6"
    private let apiKey = "101cdbc7165053e8f3f581f6"
    private let baseCurrency = "USD"

    private var endpointURL: String {
        return "\(baseURL)/\(apiKey)/latest/\(baseCurrency)"
    }
    
    func fetchExchangeRates(completion: @escaping (Double?, Double?) -> Void) {
        AF.request(endpointURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let rates = json["conversion_rates"] as? [String: Double] {
                    let usdToTry = rates["TRY"]
                    let usdToEur = rates["EUR"]
                    completion(usdToTry, usdToEur)
                } else {
                    completion(nil, nil)
                }
            case .failure:
                completion(nil, nil)
            }
        }
    }
}

