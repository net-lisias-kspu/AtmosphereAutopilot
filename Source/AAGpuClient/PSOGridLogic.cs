/*
	This file is part of Atmosphere Autopilot /L Unleashed
	© 2018-21 Lisias T : http://lisias.net <support@lisias.net>
	© 2015-20 Baranin Alexander aka Boris-Barboris

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

	You should have received a copy of the GNU General Public License 3.0
	Atmosphere Autopilot /L Unleashed. If not, see <https://www.gnu.org/licenses/>.

*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;
using System.ComponentModel.Design;
using AAGpuWrapper;

namespace AAGpuClient
{
    public partial class AppLogic
    {

        public class AoAGridExperiment
        {
            public delegate void GridReport(int point_created);

            GridReport report_dlg;
            AoAPsoOptimization opt;

            public AoAGridExperiment(GridReport reporter)
            {
                report_dlg = reporter;
                opt = new AoAPsoOptimization(reporter_internal);
                opt.sas = 0.0f;     // we'll only use aerodynamic control
                opt.aerodynamics = AeroModel.StockAero;
                opt.dt = 0.05f;
                opt.experiment_length = 6.0f;

                // default spans
                Cl1_min = 0.0f;
                Cl1_max = 200.0f;
                Cl1_count = 6;

                Cl2_min = -10.0f;
                Cl2_max = 10.0f;
                Cl2_count = 6;

                Cm1_min = -10.0f;
                Cm1_max = 5.0f;
                Cm1_count = 15;

                Cm2_min = 0.2f;
                Cm2_max = 10.0f;
                Cm2_count = 10;

                // array inits
                phys_space_points[0] = Cl1_points;
                phys_space_points[1] = Cl2_points;
                phys_space_points[2] = Cm1_points;
                phys_space_points[3] = Cm2_points;

                matrix_space_points[0] = A00_points;
                matrix_space_points[1] = B0_points;
                matrix_space_points[2] = A10_points;
                matrix_space_points[3] = B1_points;
            }

            List<float> cur_point_best;

            void reporter_internal(int epoch, float value, List<float> best_p)
            {
                cur_point_best = best_p;
            }

            [Category("Time parameters")]
            [DisplayName("Seconds to optimize one point on grid")]
            public float SecondsOnPoint { get; set; }

            [Category("Corpus")]
            [DisplayName("Cl1 min")]
            public float Cl1_min { get; set; }

            [Category("Corpus")]
            [DisplayName("Cl1 max")]
            public float Cl1_max { get; set; }

            [Category("Corpus")]
            [DisplayName("Cl1 points")]
            public int Cl1_count { get; set; }

            [Category("Corpus")]
            [DisplayName("Cl2 min")]
            public float Cl2_min { get; set; }

            [Category("Corpus")]
            [DisplayName("Cl2 max")]
            public float Cl2_max { get; set; }

            [Category("Corpus")]
            [DisplayName("Cl2 points")]
            public int Cl2_count { get; set; }

            [Category("Corpus")]
            [DisplayName("Cm1 min")]
            public float Cm1_min { get; set; }

            [Category("Corpus")]
            [DisplayName("Cm1 max")]
            public float Cm1_max { get; set; }

            [Category("Corpus")]
            [DisplayName("Cm1 points")]
            public int Cm1_count { get; set; }

            [Category("Corpus")]
            [DisplayName("Cm2 min")]
            public float Cm2_min { get; set; }

            [Category("Corpus")]
            [DisplayName("Cm2 max")]
            public float Cm2_max { get; set; }

            [Category("Corpus")]
            [DisplayName("Cm2 points")]
            public int Cm2_count { get; set; }

            public List<float> Cl1_points = new List<float>();
            public List<float> Cl2_points = new List<float>();
            public List<float> Cm1_points = new List<float>();
            public List<float> Cm2_points = new List<float>();

            public List<float> A00_points = new List<float>();
            public List<float> B0_points = new List<float>();
            public List<float> A10_points = new List<float>();
            public List<float> B1_points = new List<float>();

            List<float>[] phys_space_points = new List<float>[4];
            List<float>[] matrix_space_points = new List<float>[4];

            public void build_points()
            {
                for (int i = 0; i < phys_space_points.Length; i++)
                {
                    phys_space_points[i].Clear();
                    matrix_space_points[i].Clear();
                }
                for (int i = 0; i < Cl1_count; i++)
                {
                    Cl1_points.Add(Cl1_min + i * (Cl1_max - Cl1_min) / (float)(Cl1_count - 1));

                }
                for (int i = 0; i < Cl1_count; i++)
                    Cl2_points.Add(Cl2_min + i * (Cl2_max - Cl2_min) / (float)(Cl2_count - 1));
                for (int i = 0; i < Cm1_count; i++)
                    Cm1_points.Add(Cm1_min + i * (Cm1_max - Cm1_min) / (float)(Cm1_count - 1));
                for (int i = 0; i < Cm2_count; i++)
                    Cm2_points.Add(Cm2_min + i * (Cm2_max - Cm2_min) / (float)(Cm2_count - 1));
            }

            public int Cl1_index = 0;
            public int Cl2_index = 0;
            public int Cm1_index = 0;
            public int Cm2_index = 0;

            public void reset_indexes()
            {
                Cl1_index = Cl2_index = Cm1_index = Cm2_index = 0;
            }
        }

    }
}
