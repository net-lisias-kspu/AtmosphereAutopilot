/*
	This file is part of Atmosphere Autopilot /L Unleashed
	© 2018-2023 Lisias T : http://lisias.net <support@lisias.net>
	© 2015-2020 Baranin Alexander aka Boris-Barboris

	Atmosphere Autopilot /L Unleashed is licensed as follows:

	* GPL 3.0 : https://www.gnu.org/licenses/gpl-3.0.txt
		or, at your option, any later version

	Atmosphere Autopilot /L Unleashed is free software: you can redistribute
	it and/or modify it under the terms of the GNU General Public License as
	published by the Free Software Foundation, either version 3 of the License,
	or (at your option) any later version.

	Atmosphere Autopilot /L Unleashed is distributed in the hope that
	it will be useful, but WITHOUT ANY WARRANTY; without even the implied
	warranty of	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

	You should have received a copy of the GNU General Public License 3.0 along
	with Atmosphere Autopilot /L Unleashed. If not, see <https://www.gnu.org/licenses/>.

*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;

namespace AtmosphereAutopilot
{

    /// <summary>
    /// Proportional controller
    /// </summary>
    public class PController
    {
        /// <summary>
        /// Proportional gain coefficient
        /// </summary>
        public double KP { get { return kp; } set { kp = value; } }
        protected double kp = 1.0;

		/// <summary>
		/// Last error value. Error = desire - input
		/// </summary>
		public double LastError { get { return last_error; } }
		protected double last_error = 0.0;

        public double Control(double input, double desire)
        {
			last_error = desire - input;

            // proportional component
			double proportional = last_error * kp;

            return proportional;
        }
    }
}
