//
//  TileTypes.swift
//  RDRescue
//
//  Created by James Marshall on 10/03/2018.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import Foundation

enum TileType : String {
    case bomb
    case boulder
    case boulder2
    case boulder3
    case empty
    case fire_vertical
    case fire_horizontal
    case fire_end_top
    case fire_end_bottom
    case fire_end_left
    case fire_end_right
    case fire_t_left
    case fire_t_right
    case fire_t_top
    case fire_t_bottom
    case fire_x
    case fire_bend_bottom_left
    case fire_bend_bottom_right
    case fire_bend_top_left
    case fire_bend_top_right
    case ruby
    case emerald
    case floo_top
    case floor_left
    case floor_left_top
    case floor_top_end
    case floor_top_start
    case floor_left_start
    case fire
    case life
    case fireBullet
    case fireBulletsItem
    case wall_x_junction
    case wall_bend_bottom_left
    case wall_bend_bottom_right
    case wall_bend_top_left
    case wall_bend_top_right
    case wall_bottom_2
    case wall_centre_horizontal_2
    case wall_centre_vertical_2
    case wall_left_2
    case wall_right_2
    case wall_top_2
    case wall_t_bottom
    case wall_t_top
    case wall_t_left
    case wall_t_right
    case floor_left_start_2
    case floor_left_top_2
    case floor_top_end_2
    case floor_top_start_2
    
    case spike0_left
    case spike0_right
    case spike0_top
    case spike0_bottom
    
    case spike
    
    case spike1_left
    case spike1_right
    case spike1_top
    case spike1_bottom
    
    case spike2_left
    case spike2_right
    case spike2_top
    case spike2_bottom
    
    case spike3_left
    case spike3_right
    case spike3_top
    case spike3_bottom
    
    case stile_1
    case stile_2
    
    var description: String {
        return self.rawValue
    }
}
