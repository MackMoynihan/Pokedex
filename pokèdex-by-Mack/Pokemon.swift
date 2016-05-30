//
//  Pokemon.swift
//  pokèdex-by-Mack
//
//  Created by Mack Moynihan on 5/29/16.
//  Copyright © 2016 White Bunny Dev Co. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionLvl: String!
    private var _nextEvolutionMethod: String!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionMethod: String {
        if _nextEvolutionMethod == nil {
            _nextEvolutionMethod = ""
        }
        return _nextEvolutionMethod
    }
    
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete){
        let url = NSURL(string: _pokemonURL)!
        Alamofire.request(.GET, url).responseJSON {
            response in let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let type = types[0]["name"] {
                        self._type = type
                        
                        if types.count > 1 {
                            for x in 1 ..< types.count {
                                if let name = types[x]["name"] {
                                    self._type! += " / \(name)"
                                }
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                if let descriptionArr = dict["descriptions"] as? [Dictionary<String, String>] where descriptionArr.count > 0 {
                    
                    if let url = descriptionArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            
                            let dictResult = response.result
                            
                            if let desDict = dictResult.value as? Dictionary<String, AnyObject> {
                            
                                if let description = desDict["description"] as? String {
                                    self._description = description
                                    
                                }
                            }
                            completed()
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        
                        if to.rangeOfString("mega") == nil {
                            if let uri: String = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionId = num
                                self._nextEvolutionName = to
                            }
                        }
                        
                    }
                    
                    if let level = evolutions[0]["level"] as? String {
                        self._nextEvolutionLvl = String(level)
                    }
                    if let methodEvo = evolutions[0]["method"] as? String {
                        self._nextEvolutionMethod = methodEvo
                    }
                }
                
                
            }
            
            
        }
    }
}