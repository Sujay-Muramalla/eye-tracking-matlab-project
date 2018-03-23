using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;

namespace ThreeDEyes
{
    public class Screen : ModelVisual3D
    {
        private Point3D LL;
        private Point3D UL;
        private Point3D UR;

        public Screen()
            : this(new Point3D(-16.9, 28.71, 10.68),
                   new Point3D(16.9, 28.71, 10.68),
                   new Point3D(-16.9, 3.5, 1.0)
            )
        {
            
        }

        public Screen(Point3D ul,Point3D ur, Point3D ll)
        {
            LL = ll;
            UL = ul;
            UR = ur;

            GeometryModel3D model = new GeometryModel3D();
            model.Geometry = CreateGeometry();

            DiffuseMaterial material = new DiffuseMaterial(Brushes.LightBlue);
            model.Material = material;

            Content = model;
        }

        private Geometry3D CreateGeometry()
        {
            MeshGeometry3D mesh = new MeshGeometry3D();

            mesh.Positions.Add(UL);
            mesh.Positions.Add(LL);
            mesh.Positions.Add(UR);

            mesh.TriangleIndices.Add(0);
            mesh.TriangleIndices.Add(1);
            mesh.TriangleIndices.Add(2);

            Vector3D verticalDirection = LL - UL;
            Vector3D horizontalDirection = UR - UL;

            
            Point3D LR = UL + verticalDirection + horizontalDirection;

            mesh.Positions.Add(UR);
            mesh.Positions.Add(LL);
            mesh.Positions.Add(LR);

            mesh.TriangleIndices.Add(3);
            mesh.TriangleIndices.Add(4);
            mesh.TriangleIndices.Add(5);

            mesh.Freeze();
            return mesh;
        }
    }
}
