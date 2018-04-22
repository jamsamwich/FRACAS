//
//  TileManager.swift
//  RDRescue
//
//  Created by James Marshall on 15/03/2018.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import Foundation
import SpriteKit

class TileMapManager{
    
    //variables
    var landBackground:SKTileMapNode!
    var objectsMap:SKTileMapNode!
    var effectsMap:SKTileMapNode!
    
   
    
    func BackgroundTileType(row : Int, column : Int) -> TileType{
        if let tile:SKTileDefinition? = landBackground.tileDefinition(atColumn: column, row: row){
            if let tileName = tile?.name{
                return TileType(rawValue: tileName)!
            }
        }
        return TileType.empty
    }
    
    func ObjectTileType(row : Int, column : Int) -> TileType{
        if let tile:SKTileDefinition? = objectsMap.tileDefinition(atColumn: column, row: row){
            if let tileName = tile?.name{
                return TileType(rawValue: tileName)!
            }
        }
        return TileType.empty
    }
    
    func IsOpenPassage(row : Int, column : Int) -> Bool{
        if(BackgroundTileType(row: row, column: column) == TileType.floo_top || BackgroundTileType(row: row, column: column) == TileType.floor_left || BackgroundTileType(row: row, column: column) == TileType.floor_top_end || BackgroundTileType(row: row, column: column) == TileType.floor_left_top || BackgroundTileType(row: row, column: column) == TileType.floor_top_start || BackgroundTileType(row: row, column: column) == TileType.floor_left_start){
            if(column <= landBackground.numberOfColumns || column >= 0 && row <= landBackground.numberOfRows || row >= 0){
                return true
            }
            else{
                return false
            }
        }
        else{
            return false
        }
    }
    
    func IsBoulder(row : Int, column : Int) -> Bool{
        if(ObjectTileType(row: row, column: column) == TileType.boulder){
            return true
        }
        else{
            return false
        }
    }
    
    func IsFire(row : Int, column : Int) -> Bool{
        if(ObjectTileType(row: row, column: column) == TileType.fire_vertical ||
            ObjectTileType(row: row, column: column) ==  TileType.fire_horizontal ||
            ObjectTileType(row: row, column: column) ==  TileType.fire_end_top ||
            ObjectTileType(row: row, column: column) ==  TileType.fire_end_bottom ||
            ObjectTileType(row: row, column: column) ==  TileType.fire_end_left ||
            ObjectTileType(row: row, column: column) ==  TileType.fire_end_right ||
            ObjectTileType(row: row, column: column) == TileType.fire_t_left ||
            ObjectTileType(row: row, column: column) == TileType.fire_t_right ||
            ObjectTileType(row: row, column: column) == TileType.fire_t_top ||
            ObjectTileType(row: row, column: column) == TileType.fire_t_bottom ||
            ObjectTileType(row: row, column: column) == TileType.fire_x ||
            ObjectTileType(row: row, column: column) ==  TileType.fire_bend_bottom_left ||
            ObjectTileType(row: row, column: column) == TileType.fire_bend_bottom_right ||
            ObjectTileType(row: row, column: column) == TileType.fire_bend_top_left ||
            ObjectTileType(row: row, column: column) == TileType.fire_bend_top_right){
            return true
        }
        else{
            return false
        }
    }
    
}
