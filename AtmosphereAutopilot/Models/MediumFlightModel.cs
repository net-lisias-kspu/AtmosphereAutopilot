﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using UnityEngine;
using System.IO;

namespace AtmosphereAutopilot
{
	/// <summary>
	/// Class for medium-term model approximation
	/// </summary>
	class MediumFlightModel : GUIWindow, IAutoSerializable
	{
		public const int PITCH = 0;
		public const int ROLL = 1;
		public const int YAW = 2;

		Vessel vessel;

        public MediumFlightModel(Vessel v):
            base("Medium-term flight model", 8459383, new Rect(50.0f, 80.0f, 220.0f, 50.0f))
		{
			vessel = v;
			vessel.OnPreAutopilotUpdate += new FlightInputCallback(OnPreAutopilot);
		}

		static readonly int BUFFER_SIZE = 10;

        public CircularBuffer<double> aoa_pitch = new CircularBuffer<double>(BUFFER_SIZE, true);
        public CircularBuffer<double> aoa_yaw = new CircularBuffer<double>(BUFFER_SIZE, true);
        public CircularBuffer<double> g_force = new CircularBuffer<double>(BUFFER_SIZE, true);

        [AutoGuiAttr("global angles", false, null)]
        public double[] global_angle = new double[3];

        [AutoGuiAttr("surface angles", false, null)]
        public double[] surface_angle = new double[3];

        [AutoGuiAttr("max angular v", false, null)]
        public double[] max_angular_v = new double[3];

        [AutoGuiAttr("max angular acc", false, null)]
        public double[] max_angular_dv = new double[3];

        [AutoGuiAttr("lever arms", false, null)]
        public double[] lever_arm = new double[3];

		double prev_dt = 1.0;		// dt in previous call
		int stable_dt = 0;			// counts amount of stable dt intervals
        int cycle_counter = 0;

		void OnPreAutopilot(FlightCtrlState state)	// update all flight characteristics
		{
			double dt = TimeWarp.fixedDeltaTime;
			check_dt(dt);
			update_buffers();
            update_angles();
			prev_dt = dt;
            if (cycle_counter == 0)
                calculate_limits();
            cycle_counter = (cycle_counter + 1) % 500;
		}

		void check_dt(double new_dt)
		{
			if (Math.Abs(new_dt / prev_dt - 1.0) < 0.1)
				stable_dt = Math.Min(1000, stable_dt + 1);
			else
				stable_dt = 0;
		}

		void update_buffers()
		{
            Vector3 up_srf_v = vessel.ReferenceTransform.up * Vector3.Dot(vessel.ReferenceTransform.up, vessel.srf_velocity.normalized);
            Vector3 fwd_srf_v = vessel.ReferenceTransform.forward * Vector3.Dot(vessel.ReferenceTransform.forward, vessel.srf_velocity.normalized);
            Vector3 right_srf_v = vessel.ReferenceTransform.right * Vector3.Dot(vessel.ReferenceTransform.right, vessel.srf_velocity.normalized);
            Vector3 tmpVec = up_srf_v + fwd_srf_v;
            double aoa_p = Math.Asin(Vector3.Dot(vessel.ReferenceTransform.forward.normalized, tmpVec.normalized));
            aoa_pitch.Put(aoa_p);
            tmpVec = up_srf_v + right_srf_v;
            double aoa_y = Math.Asin(Vector3.Dot(vessel.ReferenceTransform.forward.normalized, tmpVec.normalized));
            aoa_yaw.Put(aoa_y);
            g_force.Put(vessel.geeForce_immediate);
		}

        void update_angles()
        {
            for (int i = 0; i < 3; i++)
            {
                global_angle[i] = vessel.transform.rotation.eulerAngles[i];
                surface_angle[i] = vessel.transform.localRotation.eulerAngles[i];
            }
        }

        [GlobalSerializable("max_part_acceleration")]
        [AutoGuiAttr("max part accel", true, "G8")]
        public double max_part_acceleration = 30.0;			// approx 3g

        void calculate_limits()
        {
            for (int i = 0; i < 3; i++)
            {
                lever_arm[i] = max_part_offset_from_com(i);
                max_angular_v[i] = Math.Sqrt(Math.Abs(max_part_acceleration) / lever_arm[i]);
                max_angular_dv[i] = max_part_acceleration / lever_arm[i];
            }
        }

        double max_part_offset_from_com(int axis)
        {
            double max_offset = 1.0;
            Vector3 com = vessel.findWorldCenterOfMass();
            foreach (var part in vessel.Parts)
            {
                Vector3 part_v = part.transform.position - com;
                double offset = 0.0;
                switch (axis)
                {
                    case PITCH:
                        offset = Vector3.Cross(part_v, vessel.transform.right).magnitude;
                        break;
                    case ROLL:
                        offset = Vector3.Cross(part_v, vessel.transform.up).magnitude;
                        break;
                    case YAW:
                        offset = Vector3.Cross(part_v, vessel.transform.forward).magnitude;
                        break;
                }
                if (offset > max_offset)
                    max_offset = offset;
            }
            return max_offset;
        }

        #region Serialization

        [GlobalSerializable("window_x")]
        public float WindowLeft { get { return window.xMin; } set { window.xMin = value; } }

        [GlobalSerializable("window_y")]
        public float WindowTop { get { return window.yMin; } set { window.yMin = value; } }

        [GlobalSerializable("window_width")]
        public float WindowWidth { get { return window.width; } set { window.width = value; } }

        public bool Deserialize()
        {
            return AutoSerialization.Deserialize(this, "MediumFlightModel",
                KSPUtil.ApplicationRootPath + "GameData/AtmosphereAutopilot/Global_settings.cfg",
                typeof(GlobalSerializable));
        }

        public void Serialize()
        {
            AutoSerialization.Serialize(this, "MediumFlightModel",
                KSPUtil.ApplicationRootPath + "GameData/AtmosphereAutopilot/Global_settings.cfg",
                typeof(GlobalSerializable));
        }

        #endregion


        #region GUI

		protected override void _drawGUI(int id)
		{
			GUILayout.BeginVertical();
			GUILayout.Label("AOA pitch = " + aoa_pitch.getLast().ToString("G8"), GUIStyles.labelStyleLeft);
            GUILayout.Label("AOA yaw = " + aoa_yaw.getLast().ToString("G8"), GUIStyles.labelStyleLeft);
            GUILayout.Label("G-force = " + g_force.getLast().ToString("G8"), GUIStyles.labelStyleLeft);
            AutoGUI.AutoDrawObject(this);
			GUILayout.EndVertical();
			GUI.DragWindow();
        }

        #endregion
    }
}
