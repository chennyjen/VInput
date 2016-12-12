//
//  MostCommonValues.swift
//  VInput
//
//  Created by Michael Vander Lugt on 12/11/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation
import CoreData

class MostCommonValues : Values
{
    
    var commonValues : [Any]
    var index: Int
    var valueType: ValueUtil.VALUE_TYPE
    
    init(values: [String] = [], valueType: ValueUtil.VALUE_TYPE = .common_words, keyboardController: KeyboardViewController)
    {
        self.index = 0
        self.valueType = .common_words
        self.commonValues = []
        
        let context = keyboardController.persistentContainer!.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = NSEntityDescription.entity(forEntityName: "TypedWord", in: context)
        request.sortDescriptors = [NSSortDescriptor(key: "frequency", ascending: false)]
        
        do
        {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results
                {
                    let word: String = (result as! TypedWord).word!
                    let frequency = (result as! TypedWord).frequency
                    //Hack: not actually removing words from CoreData for now
                    if frequency > 0
                    {
                        self.commonValues.append(word)
                    }
                    print(word)
                    print(frequency)
                    
                }
            }
        } catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func shiftLeft()
    {
        if index > 0
        {
            index -= 1
        }
    }
    
    func shiftRight()
    {
        if index < commonValues.count - 1
        {
            index += 1
        }
    }
    
    func getCurrentValue() -> String
    {
        return String(describing: commonValues[index])
    }
    
    func resetIndexes()
    {
        index = 0
    }
    
    func getLeftIndex() -> Int
    {
        return index
    }
    
    func getRightIndex() -> Int
    {
        return index
    }
    
    func isSearchingResetAndAnounce() -> Bool
    {
        if index != 0
        {
            index = 0
            return true
        }
        return false
    }
    
    func getValueType() -> ValueUtil.VALUE_TYPE
    {
        return valueType
    }
    
    func isDone() -> Bool
    {
        return index == (commonValues.count - 1)
    }

    
}
