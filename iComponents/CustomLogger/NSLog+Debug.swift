//
//  NSLog+Debug.swift
//  CrashLogsDemo
//
//  Created by Ranosys Technologies on 23/01/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

// DLog implementation
// http://stackoverflow.com/questions/26890537/disabling-nslog-for-production-in-swift-project

// File Manager
// http://apple.co/2jgBGuH
// https://teamtreehouse.com/community/simple-text-file-creation-in-ios-using-swift-read-write-etc
// http://www.techotopia.com/index.php/Working_with_Files_in_Swift_on_iOS_8
// https://www.ioscreator.com/tutorials/file-management-tutorial-ios8-swift


import Foundation
import MessageUI


let DIRECTORY_FOLDER_NAME = "APIResponseLog"
let RESPONSE_FILE_NAME = "api_response.doc"


public class Logs: NSObject {
    
    // MARK: Singleton class creation
    public static let instance = Logs()
    public var isEnableResponseLogFile: Bool = false
    public var viewDelegate = UIViewController()

    override init() {
        // uncomment this line if your class has been inherited from any other class
        // super.init()

    }
    
    // Print in console if DEBUG mode, else write in log file
    public class func DLog<T>( object: @autoclosure() -> T, file: String = #file, function: String = #function, line: Int = #line) {
        let value = object()
        var stringRepresentation: String
        
        // Convert value object to to the string
        if let value = value as? CustomDebugStringConvertible {
            stringRepresentation = value.debugDescription
        } else if let value = value as? CustomStringConvertible {
            stringRepresentation = value.description
        } else {
            fatalError("DLog only works for values that conform to CustomDebugStringConvertible or CustomStringConvertible")
        }
        
        // Convert stringRepresentation in json format
        stringRepresentation = stringRepresentation.replacingOccurrences(of: "\\\"", with: "\"")
        stringRepresentation = stringRepresentation.replacingOccurrences(of: "\\n", with: "\n")

        let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        let gFormatter = DateFormatter()
        gFormatter.dateFormat = "HH:mm:ss:SSS"
        let timestamp = gFormatter.string(from: NSDate() as Date)
        let logString = ("\(timestamp) \(queue) = \(fileURL) | \(function)[\(line)]: " + stringRepresentation)
        
        
        // Checking for the condition that if app is in debug mode, print logs in console
        // If in production mode, print logs in "response.doc" file
        #if DEBUG
            // Debug Mode
            // Print logs
            print(logString)
            
        #else
            // Production Mode
            // Check if logging permission is set to 'true'
            if Logs.instance.isEnableResponseLogFile {
                
                let docsDir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                // Create directory path
                let newDirPath = docsDir.appendingPathComponent(DIRECTORY_FOLDER_NAME)
                
                // Check if directory created
                let isDirectoryCreated: Bool = createDirectory(directoryPath: newDirPath.path)
                if isDirectoryCreated {
                    // Create file path
                    let responseFilePath = newDirPath.appendingPathComponent(RESPONSE_FILE_NAME)
                    
                    // Check if file created
                    let isFileCreated: Bool = createFile(filePath: responseFilePath.path)
                    if isFileCreated {
                        
                        // Wrire data into the file
                        writeToFile(filePath: responseFilePath.path, content: logString)
                        
                    } else {
                        NSLog("Unable to create log file.")
                    }
                }

            }
        #endif
    }
    
    
    public class func createDirectory(directoryPath: String) -> Bool {
        // Check if directory alredy exist
        NSLog("Directory Path: \(directoryPath)")
        
        var isDirectoryExist: Bool = false
        if FileManager.default.fileExists(atPath: directoryPath) {
            isDirectoryExist = true
        } else {
            do {
                try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
                isDirectoryExist = true
            } catch let error as NSError {
                NSLog("Unable to create directory: \(error.debugDescription)")
            }
        }
        
        return isDirectoryExist
    }
    
    
    public class func createFile(filePath: String) -> Bool {
        // Check if file alredy exist
        // If Yes, just write into file
        // If Not, create file first, then write into file
        
        var isFileExist: Bool = false
        if FileManager.default.fileExists(atPath: filePath) {
            isFileExist = true
        } else {
            isFileExist = FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        
        return isFileExist
    }
    
    public class func writeToFile(filePath: String, content: String?) {
        if content != nil {
            let existingData = checkExistingContent(filePath: filePath)
            let finalContent = existingData.appending("\n\n \(content!)")
            
            do {
                // Write into the file
                try finalContent.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
                
            } catch let err as NSError {
                NSLog("Unable to write into file: \(err.debugDescription)")
            }
            
        }
    }
    
    class func checkExistingContent(filePath: String) -> String {
        var existContent: String = ""
        
        // Check length of existing content
        let file: FileHandle? = FileHandle(forReadingAtPath: filePath)
        if file != nil {
            let databuffer = file?.readDataToEndOfFile()
            if databuffer != nil {
                existContent = NSString.init(data: databuffer!, encoding: 4) as! String
            }
            file?.closeFile()
        } else {
            print("File open failed")
        }
        
        return existContent
    }
    
    // MARK: Clear contents of file
    class func clearContentsOfResponseLogFile() {
        let docsDir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // Create directory path
        var newDirPath = docsDir.appendingPathComponent(DIRECTORY_FOLDER_NAME)
        newDirPath = newDirPath.appendingPathComponent(RESPONSE_FILE_NAME)
        
        if FileManager.default.fileExists(atPath: newDirPath.path) {
            // Clear the file at this path
            let file: FileHandle = FileHandle(forReadingAtPath: newDirPath.path)!
            file.truncateFile(atOffset: 0)
        }
    }
}



// MARK:
// MARK: Send email file log file

extension Logs: MFMailComposeViewControllerDelegate {
    
    public func getResponseFilePath() -> String {
        let docsDir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var filePath = docsDir.appendingPathComponent(DIRECTORY_FOLDER_NAME)
        filePath = filePath.appendingPathComponent(RESPONSE_FILE_NAME)

        return filePath.path
    }
    
    public func sendEmail(vc: UIViewController) {
        viewDelegate = vc
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["ankit.jayaswal@ranosys.com","kritika.middha@ranosys.com","ashish.solanki@ranosys.com"])
            mail.setSubject("API Response Logs")
            mail.setMessageBody("<p>-- FYI -- <br> API Response Logs: To Check Crash in the App </br></p>", isHTML: true)
            
            // Create directory path
            let path = getResponseFilePath()
            if FileManager.default.fileExists(atPath: path) {
                if let fileData = NSData(contentsOfFile: path) {
                    // File data loaded
                    mail.addAttachmentData(fileData as Data, mimeType: "application/msword", fileName: "RespnseLogs")
                }
            }
            viewDelegate.present(mail, animated: true)
            
        } else {
            // Show alert for email failure
            let alert = UIAlertController.init(title: "Alert", message: "Unable to send email this time", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
            viewDelegate.present(alert, animated: true, completion: nil)
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var alertMsg = ""
        switch result {
        case .cancelled:
            alertMsg = "Email sending cancelled"
            break
        case .saved:
            alertMsg = "Email saved"
            break
        case .sent:
            alertMsg = "Email sent"
            Logs.clearContentsOfResponseLogFile()
            break
        default:
            alertMsg = "Email sending failed: \(error?.localizedDescription)"
            break
        }
        
        // Show alert for email failure
        let alert = UIAlertController.init(title: "Alert", message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        viewDelegate.present(alert, animated: true, completion: nil)

        // Dismiss MFMailComposeViewController view
        controller.dismiss(animated: true)
    }
}
