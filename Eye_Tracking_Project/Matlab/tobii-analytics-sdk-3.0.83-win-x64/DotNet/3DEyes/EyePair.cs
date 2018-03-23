using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Media.Media3D;

namespace ThreeDEyes
{
    public class EyePair
    {
        private readonly ModelVisual3D _model;
        private readonly Ball _leftEye;
        private readonly Ball _rightEye;

        public EyePair(ModelVisual3D model)
        {
            _model = model;

            _leftEye = new Ball();
            _rightEye = new Ball();

            _leftEye.Offset = new Point3D(3.0, 0.0, 70.0);
            _rightEye.Offset = new Point3D(-3.0, 0.0, 70.0);

            _model.Children.Add(_leftEye);
            _model.Children.Add(_rightEye);

        }

        public Point3D LeftEyePosition
        {
            set
            {
                _leftEye.Offset = value;
            }
        }

        public Point3D RightEyePosition
        {
            set
            {
                _rightEye.Offset = value;
            }
        }

    }
}