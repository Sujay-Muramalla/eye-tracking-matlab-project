// Cylinder.cs by Charles Petzold

using System;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Media3D;

namespace Petzold.MeshGeometries
{
    public class Cylinder : ModelVisualBase
    {
        // Dependency properties
        public static readonly DependencyProperty SlicesProperty =
            DependencyProperty.Register("Slices", typeof(int), typeof(Cylinder),
                new PropertyMetadata(12, EverythingChanged),
                    ValidateSlices);

        public static readonly DependencyProperty StacksProperty =
            DependencyProperty.Register("Stacks", typeof(int), typeof(Cylinder),
                new PropertyMetadata(1, EverythingChanged),
                    ValidateStacks);

        public static readonly DependencyProperty Point1Property =
            DependencyProperty.Register("Point1", typeof(Point3D), typeof(Cylinder),
                new PropertyMetadata(new Point3D(0, 1, 0), PositionsChanged));

        public static readonly DependencyProperty Point2Property =
            DependencyProperty.Register("Point2", typeof(Point3D), typeof(Cylinder),
                new PropertyMetadata(new Point3D(0, 0, 0), PositionsChanged));

        public static readonly DependencyProperty Radius1Property =
            DependencyProperty.Register("Radius1", typeof(double), typeof(Cylinder),
                new PropertyMetadata(1.0, PositionsChanged),
                    ValidateNonNegative);

        public static readonly DependencyProperty Radius2Property =
            DependencyProperty.Register("Radius2", typeof(double), typeof(Cylinder),
                new PropertyMetadata(1.0, PositionsChanged),
                    ValidateNonNegative);

        public static readonly DependencyProperty Fold1Property =
            DependencyProperty.Register("Fold1", typeof(double), typeof(Cylinder),
                new PropertyMetadata(0.1, TextureCoordinatesChanged),
                    ValidateTextureRange);

        public static readonly DependencyProperty Fold2Property =
            DependencyProperty.Register("Fold2", typeof(double), typeof(Cylinder),
                new PropertyMetadata(0.9, TextureCoordinatesChanged),
                    ValidateTextureRange);

        public static readonly DependencyProperty TextureTypeProperty =
            DependencyProperty.Register("TextureType", typeof(TextureType), typeof(Cylinder),
                new PropertyMetadata(TextureType.Drawing, TextureCoordinatesChanged));

        // CLR properties
        public int Slices
        {
            get { return (int)GetValue(SlicesProperty); }
            set { SetValue(SlicesProperty, value); }
        }

        public int Stacks
        {
            get { return (int)GetValue(StacksProperty); }
            set { SetValue(StacksProperty, value); }
        }

        public Point3D Point1
        {
            get { return (Point3D)GetValue(Point1Property); }
            set { SetValue(Point1Property, value); }
        }

        public Point3D Point2
        {
            get { return (Point3D)GetValue(Point2Property); }
            set { SetValue(Point2Property, value); }
        }

        public double Radius1
        {
            get { return (double)GetValue(Radius1Property); }
            set { SetValue(Radius1Property, value); }
        }

        public double Radius2
        {
            get { return (double)GetValue(Radius2Property); }
            set { SetValue(Radius2Property, value); }
        }

        public double Fold1
        {
            get { return (double)GetValue(Fold1Property); }
            set { SetValue(Fold1Property, value); }
        }

        public double Fold2
        {
            get { return (double)GetValue(Fold2Property); }
            set { SetValue(Fold2Property, value); }
        }

        public TextureType TextureType
        {
            get { return (TextureType)GetValue(TextureTypeProperty); }
            set { SetValue(TextureTypeProperty, value); }
        }

        // Private validate methods
        static bool ValidateSlices(object value)
        {
            return (int)value > 2;
        }

        static bool ValidateStacks(object value)
        {
            return (int)value > 0;
        }

        static bool ValidateNonNegative(object value)
        {
            return (double)value >= 0;
        }

        static bool ValidateTextureRange(object value)
        {
            double d = (double)value;
            return d >= 0 && d <= 1;
        }

        // Static "Changed" event handlers 
        static void EverythingChanged(DependencyObject obj,
                        DependencyPropertyChangedEventArgs args)
        {
            Cylinder cyl = (Cylinder)obj;
            cyl.GeneratePositions();
            cyl.GenerateTriangleIndices();
            cyl.GenerateTextureCoordinates();
        }

        static void PositionsChanged(DependencyObject obj,
                        DependencyPropertyChangedEventArgs args)
        {
            Cylinder cyl = (Cylinder)obj;
            cyl.GeneratePositions();
        }

        static void TriangleIndicesChanged(DependencyObject obj,
                        DependencyPropertyChangedEventArgs args)
        {
            Cylinder cyl = (Cylinder)obj;
            cyl.GenerateTriangleIndices();
        }

        static void TextureCoordinatesChanged(DependencyObject obj,
                        DependencyPropertyChangedEventArgs args)
        {
            Cylinder cyl = (Cylinder)obj;
            cyl.GenerateTextureCoordinates();
        }

        // Objects reused by calls to GenerateMesh
        AxisAngleRotation3D rotate;
        RotateTransform3D xform;

        // Public constructor to initialize those fields, etc
        public Cylinder()
        {
            rotate = new AxisAngleRotation3D();
            xform = new RotateTransform3D(rotate);

            MeshGeometry3D mesh = (MeshGeometry3D)Geometry;
            mesh.Positions = new Point3DCollection((Slices + 1) * (Stacks + 5) - 2);
            mesh.Normals = new Vector3DCollection((Slices + 1) * (Stacks + 5) - 2);
            mesh.TriangleIndices = new Int32Collection(6 * Slices * (Stacks + 1));
            mesh.TextureCoordinates = new PointCollection((Slices + 1) * (Stacks + 5) - 2);

            // Initialize all collection based on default properties
            GeneratePositions();
            GenerateTriangleIndices();
            GenerateTextureCoordinates();
        }

        // Calculates the Positions and Normals collections
        // ------------------------------------------------
        void GeneratePositions()
        {
            // Unhook Positions property and prepare for new points
            MeshGeometry3D mesh = (MeshGeometry3D)Geometry;
            Point3DCollection points = mesh.Positions;
            mesh.Positions = null;
            points.Clear();

            // Unhook Normals property and prepare for new vectors
            Vector3DCollection norms = mesh.Normals;
            mesh.Normals = null;
            norms.Clear();

            // Copy properties to local variables to improve speed
            Point3D point1 = Point1;
            Point3D point2 = Point2;
            double radius1 = Radius1;
            double radius2 = Radius2;
            int slices = Slices;
            int stacks = Stacks;

            // vectRearRadius always points towards -Z (when possible)
            Vector3D vectCylinder = point2 - point1;
            Vector3D vectRearRadius;

            if (vectCylinder.X == 0 && vectCylinder.Y == 0)
            {
                // Special case: set rear-radius vector
                vectRearRadius = new Vector3D(0, -1, 0);
            }
            else
            {
                // Find vector axis 90 degrees from cylinder where Z == 0
                rotate.Axis = Vector3D.CrossProduct(vectCylinder, new Vector3D(0, 0, 1));
                rotate.Angle = -90;

                // Rotate cylinder 90 degrees to find radius vector
                vectRearRadius = vectCylinder * xform.Value;
                vectRearRadius.Normalize();
            }

            // Will rotate radius around cylinder axis
            rotate.Axis = vectCylinder;

            for (int i = 0; i <= slices; i++)
            {
                // Rotate rear-radius vector 
                rotate.Angle = i * 360 / slices;
                Vector3D vectRadius = vectRearRadius * xform.Value;

                for (int j = 0; j <= stacks; j++)
                {
                    // Find points from top to bottom
                    Point3D pointCenter = point1 + j * (point2 - point1) / stacks;
                    double radius = radius1 + j * (radius2 - radius1) / stacks;
                    points.Add(pointCenter + radius * vectRadius);

                    norms.Add(vectRadius);
                }

                // Points on top and bottom
                points.Add(point1 + radius1 * vectRadius);
                points.Add(point2 + radius2 * vectRadius);

                // But normals point towards ends
                norms.Add(point1 - point2);
                norms.Add(point2 - point1);
            }

            // Add multiple center points on top and bottom ends
            for (int i = 0; i < slices; i++)
            {
                points.Add(point1);     // top end
                points.Add(point2);     // bottom end

                norms.Add(point1 - point2);
                norms.Add(point2 - point1);
            }
            // Set Normals and Positions properties from re-calced vectors
            mesh.Normals = norms;
            mesh.Positions = points;
        }

        // Calculates the TriangleIndices collection
        void GenerateTriangleIndices()
        {
            MeshGeometry3D mesh = (MeshGeometry3D)Geometry;
            Int32Collection indices = mesh.TriangleIndices;
            mesh.TriangleIndices = null;
            indices.Clear();

            int slices = Slices;
            int stacks = Stacks;
            int indexTopPoints = (stacks + 3) * (slices + 1);

            for (int i = 0; i < slices; i++)
            {
                for (int j = 0; j < stacks; j++)
                {
                    // Triangles running length of cylinder
                    indices.Add((stacks + 3) * i + j);
                    indices.Add((stacks + 3) * i + j + stacks + 3);
                    indices.Add((stacks + 3) * i + j + 1);

                    indices.Add((stacks + 3) * i + j + 1);
                    indices.Add((stacks + 3) * i + j + stacks + 3);
                    indices.Add((stacks + 3) * i + j + stacks + 3 + 1);
                }

                // Triangles on top of cylinder
                indices.Add(indexTopPoints + 2 * i);
                indices.Add((stacks + 3) * i + (stacks + 3) * 2 - 2);
                indices.Add((stacks + 3) * i + (stacks + 3) - 2);

                // Triangles on bottom of cylinder
                indices.Add(indexTopPoints + 2 * i + 1);
                indices.Add((stacks + 3) * i + (stacks + 3) - 1);
                indices.Add((stacks + 3) * i + (stacks + 3) * 2 - 1);
            }
            mesh.TriangleIndices = indices;
        }

        // Calculates the TextureCoordinates collection
        void GenerateTextureCoordinates()
        {
            MeshGeometry3D mesh = (MeshGeometry3D)Geometry;
            PointCollection pts = mesh.TextureCoordinates;
            mesh.TextureCoordinates = null;
            pts.Clear();

            if (TextureType != TextureType.None)
            {
                int slices = Slices;
                int stacks = Stacks;

                for (int i = 0; i <= slices; i++)
                {
                    for (int j = 0; j <= stacks; j++)
                    {
                        pts.Add(new Point((double)i / slices, 
                                        Fold1 + j * (Fold2 - Fold1) / stacks));
                    }

                    pts.Add(new Point((double)i / slices, Fold1));
                    pts.Add(new Point((double)i / slices, Fold2));
                }

                if (TextureType == TextureType.Image)
                {
                    for (int i = 0; i < slices; i++)
                    {
                        pts.Add(new Point(0.5, 0));
                        pts.Add(new Point(0.5, 1));
                    }
                }
                else // TextureType == TextureType.Drawing
                {
                    for (int i = 0; i < slices; i++)
                    {
                        pts.Add(new Point((2 * i + 1) / (2.0 * slices), 0));
                        pts.Add(new Point((2 * i + 1) / (2.0 * slices), 1));
                    }
                }
            }
            mesh.TextureCoordinates = pts; 
        }
    }
}
