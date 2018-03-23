using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Media.Media3D;
using ThreeDEyes;

namespace ThreeDEyes
{
    public class BallCubeBuilder
    {
        private ModelVisual3D _mv3D;

        public BallCubeBuilder(ModelVisual3D modelVisual3D)
        {
            _mv3D = modelVisual3D;
        }

        public void BuildSlice( string imageSrc, double offsetZ )
        {
            Point3D p3D = new Point3D(0, 0, offsetZ);
            for (int x = 0; x < 3; x++)
            {
                for (int y = -1; y < 2; y++)
                {
                    Ball ball = new Ball();
                    ball.ImageSource = imageSrc;
                    p3D.X = (x * 2.0) - 2.0;
                    p3D.Y = (y * 2.0);
                    ball.Offset = p3D;
                    Console.WriteLine(p3D.ToString());
                    _mv3D.Children.Add(ball);
                }
            }
        }
    }
}