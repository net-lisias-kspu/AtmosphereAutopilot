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
using System;
using UnityEngine;

namespace AtmosphereAutopilot
{
    using KspModuleControlSurface = global::ModuleControlSurface;

    /// <summary>
    /// Synchronised ModuleControlSurface implementation, greatly simplifies control and flight model regression 
    /// by making all control surfaces move in one phase.
    /// </summary>
    public partial class SyncModuleControlSurface : KspModuleControlSurface
    {
        public const float CSURF_SPD = 2.0f;

        // normalized [-1.0, 1.0] previous actions for separate axes
        protected float prev_pitch_normdeflection = 0.0f;
        protected float prev_roll_normdeflection = 0.0f;
        protected float prev_yaw_normdeflection = 0.0f;

        protected bool was_deployed = false;
        protected bool already_checked = false;

        public override void OnStart(PartModule.StartState state)
        {
            base.OnStart(state);

            if (!HighLogic.LoadedSceneIsFlight) return;

            if (this.already_checked) return;
            this.already_checked = true;

            if (this.usesMirrorDeploy) return;

            // This code is needed due savegames previous from the AA first installation (as well crafts, and also ones
            // downloaded or copied from other savegames) looses the condiguration when loaded with AA.
            // Only savegames and crafts made after AA installation have their Control Surfaces settings restored!
            // Once this small inconvenience =P is fixed, this code can go away.
            this.mirrorDeploy = false;
            if (part.symMethod == SymmetryMethod.Mirror &&
                part.symmetryCounterparts != null &&
                part.symmetryCounterparts.Count > 0)
            {
                Part p = part.symmetryCounterparts[0];
                this.mirrorDeploy =
                    (Mathf.Abs(part.transform.localRotation.w) < Mathf.Abs(p.transform.localRotation.w))
                    ||
                    (Mathf.Abs(part.transform.localRotation.w) == Mathf.Abs(p.transform.localRotation.w)
                        && part.transform.localRotation.x < p.transform.localRotation.x)
                    ;
            }
        }

        public override void OnLoad(ConfigNode node)
        {
            // Hack to recoer the ModuleControlSurface settings!
            // TODO: check the loading vessel for the ConfigNode, then use it instead!
            base.OnLoad(node);
        }

        public override void OnSave(ConfigNode node)
        {
            base.OnSave(node);

            // Hack to prevent AA to hijack the savagames and craft files.
            // MODULE sections with name="ModuleControlSurface" not only is ignored by this partModule, but once this is 
            // saved with name="SyncModuleControlSurface", only KSP installments with AA installed will correctly handle it,
            // and that disconfigure all Contol Surfaces parts when you uninstall AA!!      
            //node.SetValue("name", "ModuleControlSurface", false);
            //node.SetValue("AtmosphericAutopilot", true, true);
        }
    }
}
