/// player_is_glide_falling(phase)

var phase = argument0;

switch (phase) {
case "start":
    if (on_the_ground) {
        ground_id = noone;
        on_the_ground = false;
    }

    game_pc_translate_speed(self, x_speed, local_direction);
    game_pc_redirect(self, gravity_direction);
    game_pc_align(self, gravity_direction);

    x_speed *= 0.25;

    game_pc_animate(self, "glide_fall");
    image_angle = gravity_direction;

    game_pc_camera_direct(self, game_pc_camera_state_aerial);
    break;

case "step":
    if (horizontal_axis_value != 0) {
        facing_sign = horizontal_axis_value;
        if (abs(x_speed) < speed_cap or sign(x_speed) != horizontal_axis_value) {
            x_speed += air_acceleration * horizontal_axis_value;
            if (abs(x_speed) > speed_cap and sign(x_speed) == horizontal_axis_value) {
                x_speed = speed_cap * horizontal_axis_value;
            }
        }
    }

    game_pc_move_in_air(self);
    if (state_changed) {
        return false;
    }

    if (on_the_ground) {
        if (mask_direction != gravity_direction) {
            			control_lock_time = default_slide_lock_time;
            return game_pc_perform(self, player_is_running);
        } else {
            game_pc_play_sound(self, LandingSound);
            return game_pc_perform(self, player_is_glide_landing);
        }
    }

    if (y_speed < 0 and y_speed > -jump_release_force) {
        if (abs(x_speed) > air_friction_threshold) {
            x_speed *= air_friction;
        }
    }

    y_speed += gravity_speed;
    break;
}
