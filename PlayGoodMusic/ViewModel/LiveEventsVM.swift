//
//  LiveEventsVM.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 20/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation

class LiveEventsVM: Request {
    var liveEvents: [Live]?
    private var selectedEvent: Live?
    private var selectedEventIndex: Int?
    
    func getSelectedEvent() -> (event :Live?,selectedIndex: Int?) {
        return (self.selectedEvent,selectedEventIndex)
    }
    func updateCurrentSelectedEvent(liveEvent: Live?, withIndex index: Int) {
        selectedEvent = liveEvent
        selectedEventIndex = index
    }
    
    
    func getLiveEvents(completion: @escaping (Result<Bool?, ASError>)->Void) {
        if let url = URL(string: RequestBuilder.EndPoint.liveEvents("\(10)").path) {
            var request = URLRequest(url: url)
            request.httpMethod = HttpMethod.get.rawValue
            self.request(request, LiveEventsModel.self) { (result) in
                switch result {
                case .success(let model):
                    if let liveEvents = model?.result.live, liveEvents.count > 0 {
                        self.liveEvents = liveEvents
                        completion(.success(true))
                    } else {
                        completion(.failure(.apiError("No Data Found")))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
