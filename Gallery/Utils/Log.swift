//
//  Log.swift
//  Gallery
//
//  Created by Marek Baláž on 19/04/2023.
//

import Foundation

/// Enum which maps an appropiate symbol which added as prefix for each log message
///
/// - error: Log type error
/// - info: Log type info
/// - debug: Log type debug
/// - verbose: Log type verbose
/// - warning: Log type warning
/// - severe: Log type severe
enum LogEvent: String
{
    case e = "[E]" // error
    case i = "[I]" // info
    case d = "[D]" // debug
    case v = "[V]" // verbose
    case w = "[W]" // warning
    case s = "[S]" // severe
}


/// Wrapping Swift.print() within DEBUG flag
///
/// - Note: *print()* might cause [security vulnerabilities](https://codifiedsecurity.com/mobile-app-security-testing-checklist-ios/)
///
/// - Parameter object: The object which is to be logged
///
func print(_ object: Any)
{
    // Only allowing in DEBUG mode
    #if DEBUG
        Swift.print(object)
    #endif
}

class Log
{
    
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    // MARK: - Loging methods
    
    
    /// Logs error messages on console with prefix [E]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - funcName: Name of the function from where the logging is done
    class func e( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function)
    {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.e.rawValue) \(sourceFileName(filePath: filename)):\(line) \(funcName) -> \(object)")
        }
    }
    
    /// Logs info messages on console with prefix [I]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - funcName: Name of the function from where the logging is done
    class func i( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function)
    {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.i.rawValue) \(sourceFileName(filePath: filename)):\(line) \(funcName) -> \(object)")
        }
    }
    
    /// Logs debug messages on console with prefix [D]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - funcName: Name of the function from where the logging is done
    class func d( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function)
    {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.d.rawValue) \(sourceFileName(filePath: filename)):\(line) \(funcName) -> \(object)")
        }
    }
    
    /// Logs messages verbosely on console with prefix [V]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - funcName: Name of the function from where the logging is done
    class func v( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function)
    {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.v.rawValue) \(sourceFileName(filePath: filename)):\(line) \(funcName) -> \(object)")
        }
    }
    
    /// Logs warnings verbosely on console with prefix [W]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - funcName: Name of the function from where the logging is done
    class func w( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function)
    {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.w.rawValue) \(sourceFileName(filePath: filename)):\(line) \(funcName) -> \(object)")
        }
    }
    
    /// Logs severe events on console with prefix [S]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - funcName: Name of the function from where the logging is done
    class func s( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function)
    {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.s.rawValue) \(sourceFileName(filePath: filename)):\(line) \(funcName) -> \(object)")
        }
    }

    /// Logs severe events on console with prefix [S]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - funcName: Name of the function from where the logging is done
    class func remotely( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function)
    {
        // TODO: odslať log na server
        Log.e(object, filename: filename, line: line, funcName: funcName)
    }

    /// Extract the file name from the file path
    ///
    /// - Parameter filePath: Full file path in bundle
    /// - Returns: File Name with extension
    private class func sourceFileName(filePath: String) -> String
    {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date
{
    func toString() -> String
    {
        return Log.dateFormatter.string(from: self as Date)
    }
}

// eof
