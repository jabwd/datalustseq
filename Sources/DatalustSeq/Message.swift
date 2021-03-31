//
//  Message.swift
//  
//
//  Created by Antwan van Houdt on 10/09/2020.
//

import Foundation
import Logging

struct Message {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return dateFormatter
    }()

	final class MessageBox {
		let level: Logger.Level
		let file: String
		let function: String
		let line: UInt
		let message: String
		let metadata: [String: String]?

		init(
			level: Logger.Level,
			message: Logger.Message,
			file: String,
			function: String,
			line: UInt,
			metadata: Logger.Metadata?
		) {
			self.file = file
			self.function = function
			self.line = line
			self.message = message.description
			self.level = level
			self.metadata = metadata?.reduce([String: String]()) { (dict, value) -> [String: String] in
				var dict = dict
				dict[value.key] = value.value.description
				return dict
			}
		}
	}
	
	private let box: MessageBox
	
	init(
		level: Logger.Level,
		message: Logger.Message,
		file: String,
		function: String,
		line: UInt,
		metadata: Logger.Metadata?
	) {
		box = MessageBox(
			level: level,
			message: message,
			file: file,
			function: function,
			line: line,
			metadata: metadata
		)
	}
	
	var level: Logger.Level { box.level }
	var file: String { box.file }
	var function: String { box.function }
	var line: UInt { box.line }
	var message: String { box.message }

    var levelMsg: String {
        return level.rawValue
    }

    var clefMessage: String {
"""
{"@t": "\(Self.dateFormatter.string(from: Date()))", "@l": "\(levelMsg)", "@mt": "\(message), {function}:{line} in {file}", "function": "\(function)", "line": "\(line)", "file": "\(file)"}
"""
    }
}
