/// game_pc_calc_wall_distance(character, ind, radius)
// ---------------------------------------------------------------
/*  
**  Calculates the distance needed to move the player's virtual
**  mask out of collision with the given instance, focusing only
**  on the arms. (horizontal sensor)
**
**  Arguments:
**      character   Real; player character instance index
**      ind         Real; instance index
**      radius      Real; distance in pixels to extend the mask
**                  (extends horizontally at BOTH ends)
**
**  Returns:
**      Real; distance in pixels to move outside, or undefined 
**          on failure to relocate
*/
// ---------------------------------------------------------------
var character = argument0;
var ind = argument1;
var radius = argument2;
// ---------------------------------------------------------------

var distance = undefined;

with (character) {
    var sine = dsin(mask_direction);
    var cosine = dcos(mask_direction);
    if (game_shape_in_point(ind, x_int, y_int)) {
        for (var ox = radius; ox < (radius * 2); ++ox) {
            if (not game_shape_in_point(ind, x_int + (cosine * ox), y_int - (sine * ox))) {
                distance = -(radius + ox); // right side
                break;
            } else if (not game_shape_in_point(ind, x_int - (cosine * ox), y_int + (sine * ox))) {
                distance = (radius + ox); // left side
                break;
            }
        }

        distance = 0; // no escape
    } else {
        for (var ox = radius; ox > -1; --ox) {
            if (not game_pc_arms_in_shape(self, ind, ox)) {
                if (game_shape_in_line(ind, x_int, y_int, x_int + (cosine * (ox + 1)), y_int - (sine * (ox + 1)))) {
                    distance = (radius - ox); // right side
                    break;
                } else if (game_shape_in_line(ind, x_int, y_int, x_int - (cosine * (ox + 1)), y_int + (sine * (ox + 1)))) {
                    distance = -(radius - ox); // left side
                    break;
                }
            }
        }
    }
}

return distance;
