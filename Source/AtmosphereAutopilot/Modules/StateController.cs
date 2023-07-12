/*
	This file is part of Atmosphere Autopilot /L Unleashed
		© 2018-2023 Lisias T : http://lisias.net <support@lisias.net>
		© 2015-2020 Baranin Alexander aka Boris-Barboris

	Atmosphere Autopilot /L Unleashed is licensed as follows:
		* GPL 3.0 : https://www.gnu.org/licenses/gpl-3.0.txt

	Atmosphere Autopilot /L Unleashed is free software: you can redistribute
	it and/or modify it under the terms of the GNU General Public License as
	published by the Free Software Foundation, either version 3 of the License,
	or (at your option) any later version.

	Atmosphere Autopilot /L Unleashed is distributed in the hope that
	it will be useful, but WITHOUT ANY WARRANTY; without even the implied
	warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

	You should have received a copy of the GNU General Public License 3.0 along
	with Atmosphere Autopilot /L Unleashed. If not, see <https://www.gnu.org/licenses/>.

*/
namespace AtmosphereAutopilot
{
    /// <summary>
    /// Flight control state controller base class
    /// </summary>
    public abstract class StateController : AutopilotModule
    {
        protected StateController(Vessel cur_vessel, string module_name, int wnd_id)
            : base(cur_vessel, wnd_id, module_name)
        { }

        /// <summary>
        /// Main control function of high-level autopilot.
        /// </summary>
        /// <param name="cntrl">Control state to change</param>
        public abstract void ApplyControl(FlightCtrlState cntrl);

    }

    /// <summary>
    /// Flight control state controller with SIMO base class
    /// </summary>
    public abstract class SISOController : AutopilotModule
    {
        protected SISOController(Vessel cur_vessel, string module_name, int wnd_id)
            : base(cur_vessel, wnd_id, module_name)
        { }

        /// <summary>
        /// Main control function of service autopilot.
        /// </summary>
        /// <param name="cntrl">Control state to change</param>
        /// <param name="target_value">Desired controlled value</param>
        public abstract float ApplyControl(FlightCtrlState cntrl, float target_value);
    }

    public static class ControlUtils
    {
        public const int PITCH = 0;
        public const int ROLL = 1;
        public const int YAW = 2;

        public static float get_neutralized_user_input(FlightCtrlState state, int axis)
        {
            switch (axis)
            {
                case PITCH:
                    return state.pitch - state.pitchTrim;
                case ROLL:
                    return state.roll - state.rollTrim;
                case YAW:
                    return state.yaw - state.yawTrim;
                default:
                    return 0.0f;
            }
        }

        public static void neutralize_user_input(FlightCtrlState state, int axis)
        {
            switch (axis)
            {
                case PITCH:
                    state.pitch = state.pitchTrim;
                    break;
                case ROLL:
                    state.roll = state.rollTrim;
                    break;
                case YAW:
                    state.yaw = state.yawTrim;
                    break;
            }
        }

        public static void set_raw_output(FlightCtrlState state, int axis, float output)
        {
            switch (axis)
            {
                case PITCH:
                    state.pitch = output;
                    break;
                case ROLL:
                    state.roll = output;
                    break;
                case YAW:
                    state.yaw = output;
                    break;
            }
        }

        public static void set_trim(int axis, float value)
        {
            switch (axis)
            {
                case PITCH:
                    FlightInputHandler.state.pitchTrim = value;
                    break;
                case ROLL:
                    FlightInputHandler.state.rollTrim = value;
                    break;
                case YAW:
                    FlightInputHandler.state.yawTrim = value;
                    break;
            }
        }

        public static float getControlFromState(FlightCtrlState state, int axis)
        {
            if (axis == PITCH)
                return state.pitch;
            if (axis == ROLL)
                return state.roll;
            if (axis == YAW)
                return state.yaw;
            return 0.0f;
        }
    }
}
