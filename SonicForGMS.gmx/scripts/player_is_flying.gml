/// player_is_flying(phase)

var phase = argument0;

switch (phase) {
case "start":
    if (on_the_ground) {
        ground_id = noone;
        on_the_ground = false;

        game_pc_translate_speed(self, x_speed, local_direction);
        game_pc_redirect(self, gravity_direction);
        game_pc_align(self, gravity_direction);
    }

    spinning = false;

    flight_force = flight_base_force;
    flight_link = instance_create(x_int, y_int + flight_link_offset, TailsFlightLink);
    flight_link.source = self;

    game_pc_animate(self, "flight");
    game_pc_camera_direct(self, game_pc_camera_state_aerial);
    break;

case "finish":
    if (audio_is_playing(flight_soundid)) {
        audio_stop_sound(flight_soundid);
    }
    if (instance_exists(flight_link)) {
        instance_destroy(flight_link);
    }
    break;

case "step":
    if (input_action_pressed and flight_time and 
        y_speed >= flight_threshold) {
        flight_force = -flight_ascend_force;
    }

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
        if (x_speed != 0) {
            return game_pc_perform(self, player_is_running);
        } else {
            return game_pc_perform(self, player_is_standing);
        }
    }

    if (underwater) {
        return game_pc_perform(self, player_is_swimming);
    }

    if (y_speed < 0 and y_speed > -jump_release_force) {
        if (abs(x_speed) > air_friction_threshold) {
            x_speed *= air_friction;
        }
    }

    y_speed += flight_force;

    if (y_speed < flight_threshold or ceiling_id != noone) {
        flight_force = flight_base_force;
    }

    if (flight_time > 0) {
        flight_time--;
    }
    
    if (flight_time) {
        game_pc_animate(self, "flight");
        if (not audio_is_playing(FlightSound)) {
            audio_stop_sound(flight_soundid);
            flight_soundid = game_pc_play_sound(self, FlightSound, true);
        }
    } else {
        game_pc_animate(self, "flight_fall");
        if (not audio_is_playing(FlightFallSound)) {
            audio_stop_sound(flight_soundid);
            flight_soundid = game_pc_play_sound(self, FlightFallSound, 0);
        }
    }
    break;
}
