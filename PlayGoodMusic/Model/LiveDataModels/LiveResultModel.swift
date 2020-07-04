//
//  LiveResultModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on June 22, 2020
//
import Foundation

struct LiveResultModel: Codable {

	let code: Int
	let result: Result

	private enum CodingKeys: String, CodingKey {
		case code = "code"
		case result = "result"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		code = try values.decode(Int.self, forKey: .code)
		result = try values.decode(Result.self, forKey: .result)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(code, forKey: .code)
		try container.encode(result, forKey: .result)
	}

}