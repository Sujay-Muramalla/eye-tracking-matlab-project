using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Petzold.MeshGeometries;
using Tobii.EyeTracking.IO;
using ThreeDEyes;
using Point3D=System.Windows.Media.Media3D.Point3D;

namespace ThreeDEyes
{
    /// <summary>
    /// Interaction logic for Window1.xaml
    /// </summary>
    public partial class Window1 : Window
    {
        private readonly EyeTrackerBrowser _browser;
        private readonly EyePair _eyePair;

        private bool _tracking;
        private IEyeTracker _tracker;

        private Point3D _leftPos;
        private Point3D _rightPos;
        private Point3D _leftGaze;
        private Point3D _rightGaze;
        private bool _showLeft;
        private bool _showRight;
        private readonly Cylinder _leftGazeVector;
        private Cylinder _rightGazeVector;
        private List<Cylinder> _trackBox = new List<Cylinder>();
        private Screen _screen;


        public Window1()
        {
            InitializeComponent();

            Library.Init();

            _screen = new Screen();

            _browser = new EyeTrackerBrowser();
            _browser.EyeTrackerFound += _browser_EyetrackerFound;
            _browser.EyeTrackerRemoved += _browser_EyetrackerRemoved;
            _browser.EyeTrackerUpdated += _browser_EyetrackerUpdated;

            MouseHelper mh = new MouseHelper(camera);
            mh.EventSource = viewPort;

            _eyePair = new EyePair(visualModel);


            const double radius = 0.05;
            DiffuseMaterial cylinderMaterial = new DiffuseMaterial();
            cylinderMaterial.Brush = Brushes.OrangeRed;
            
            _leftGazeVector = new Cylinder();
            _leftGazeVector.Radius1 = radius;
            _leftGazeVector.Radius2 = radius;
            _leftGazeVector.Material = cylinderMaterial;

            _rightGazeVector = new Cylinder();
            _rightGazeVector.Radius1 = radius;
            _rightGazeVector.Radius2 = radius;
            _rightGazeVector.Material = cylinderMaterial;

            DiffuseMaterial axisMaterial = new DiffuseMaterial(Brushes.Lime);

            Cylinder xAxis = new Cylinder();
            xAxis.Radius1 = radius;
            xAxis.Radius2 = radius;
            xAxis.Point1 = new Point3D(0.0, 0.0, 0.0);
            xAxis.Point2 = new Point3D(1.0, 0.0, 0.0);
            xAxis.Material = axisMaterial;

            Cylinder yAxis = new Cylinder();
            yAxis.Radius1 = radius;
            yAxis.Radius2 = radius;
            yAxis.Point1 = new Point3D(0.0, 0.0, 0.0);
            yAxis.Point2 = new Point3D(0.0, 1.0, 0.0);
            yAxis.Material = axisMaterial;

            Cylinder zAxis = new Cylinder();
            zAxis.Radius1 = radius;
            zAxis.Radius2 = radius;
            zAxis.Point1 = new Point3D(0.0, 0.0, 0.0);
            zAxis.Point2 = new Point3D(0.0, 0.0, 1.0);
            zAxis.Material = axisMaterial;

            visualModel.Children.Add(_leftGazeVector);
            visualModel.Children.Add(_rightGazeVector);
            visualModel.Children.Add(_screen);
            visualModel.Children.Add(xAxis);
            visualModel.Children.Add(yAxis);
            visualModel.Children.Add(zAxis);
            

            for (int i = 0; i < 12; i++)
            {
                Cylinder edge = new Cylinder();
                edge.Radius1 = 0.1;
                edge.Radius2 = 0.1;
                edge.Point1 = new Point3D(0.0, 0.0, 0.0);
                edge.Point2 = new Point3D(0.0, 0.0, 1.0);
                edge.Material = cylinderMaterial;

                _trackBox.Add(edge);
                visualModel.Children.Add(edge);
            }

            
        }

        void _browser_EyetrackerUpdated(object sender, EyeTrackerInfoEventArgs e)
        {
            int index = _trackerCombo.Items.IndexOf(e);

            if (index >= 0)
            {
                _trackerCombo.Items[index] = e.EyeTrackerInfo;
            }  
        }

        void _browser_EyetrackerRemoved(object sender, EyeTrackerInfoEventArgs e)
        {
            _trackerCombo.Items.Remove(e.EyeTrackerInfo);
        }

        private void _browser_EyetrackerFound(object sender, EyeTrackerInfoEventArgs e)
        {
            _trackerCombo.Items.Add(e.EyeTrackerInfo);
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            _browser.StartBrowsing();
        }

        private void Window_Closed(object sender, EventArgs e)
        {
            _browser.StopBrowsing();

            if(_tracker != null)
            {
                _tracker.Dispose();
            }
        }

        private void _trackButton_Click(object sender, RoutedEventArgs e)
        {
            if(_tracking)
            {
                _tracker.GazeDataReceived -= _tracker_GazeDataReceived;
                _tracker.StopTracking();
                
                _tracker.Dispose();
                _trackButton.Content = "Track";
                _tracking = false;
            }
            else
            {
                EyeTrackerInfo etInfo = _trackerCombo.SelectedItem as EyeTrackerInfo;
                if(etInfo != null)
                {
                    _tracker = etInfo.Factory.CreateEyeTracker();

                    UpdateTrackBox();
                    UpdateScreen();

                    _tracker.StartTracking();

                    _tracker.GazeDataReceived += _tracker_GazeDataReceived;
                    _tracker.TrackBoxChanged += _tracker_TrackBoxChanged;             
                    _tracker.XConfigurationChanged += _tracker_XConfigurationChanged;
                    
                    _trackButton.Content = "Stop";
                    _tracking = true;
                }
               
            }
        }

        void _tracker_XConfigurationChanged(object sender, XConfigurationChangedEventArgs e)
        {
            Console.WriteLine("XConfig changed notification!");
            UpdateScreen();
        }

        private void _tracker_GazeDataReceived(object sender, GazeDataEventArgs e)
        {
            // Convert to centimeters
            const double D = 10.0;

            _leftPos.X = e.GazeDataItem.LeftEyePosition3D.X / D;
            _leftPos.Y = e.GazeDataItem.LeftEyePosition3D.Y / D;
            _leftPos.Z = e.GazeDataItem.LeftEyePosition3D.Z / D;

            _rightPos.X = e.GazeDataItem.RightEyePosition3D.X / D;
            _rightPos.Y = e.GazeDataItem.RightEyePosition3D.Y / D;
            _rightPos.Z = e.GazeDataItem.RightEyePosition3D.Z / D;

            _leftGaze.X = e.GazeDataItem.LeftGazePoint3D.X / D;
            _leftGaze.Y = e.GazeDataItem.LeftGazePoint3D.Y / D;
            _leftGaze.Z = e.GazeDataItem.LeftGazePoint3D.Z / D;

            _rightGaze.X = e.GazeDataItem.RightGazePoint3D.X / D;
            _rightGaze.Y = e.GazeDataItem.RightGazePoint3D.Y / D;
            _rightGaze.Z = e.GazeDataItem.RightGazePoint3D.Z / D;

            // Set which eyes to show
            _showLeft = e.GazeDataItem.LeftValidity < 2;
            _showRight = e.GazeDataItem.RightValidity < 2;

            Action update = delegate()
            {
                if (_showLeft)
                {
                    _eyePair.LeftEyePosition = _leftPos;
                    _leftGazeVector.Point1 = _leftPos;
                    _leftGazeVector.Point2 = _leftGaze;
                }
                else
                {
                    Point3D farAway = new Point3D(1000.0, 1000.0, 1000.0);
                    _eyePair.LeftEyePosition = farAway;
                    _leftGazeVector.Point1 = farAway;
                    _leftGazeVector.Point2 = farAway;
                }

                if (_showRight)
                {
                    _eyePair.RightEyePosition = _rightPos;
                    _rightGazeVector.Point1 = _rightPos;
                    _rightGazeVector.Point2 = _rightGaze;
                }
                else
                {
                    Point3D farAway = new Point3D(1000.0, 1000.0, 1000.0);
                    _eyePair.RightEyePosition = farAway;
                    _rightGazeVector.Point1 = farAway;
                    _rightGazeVector.Point2 = farAway;
                }

            };

            Dispatcher.BeginInvoke(update);
        }

        private void UpdateScreen()
        {
            var config = _tracker.GetXConfiguration();
            Point3D ul = ToWpfPoint3D(config.UpperLeft, 0.1);
            Point3D ur = ToWpfPoint3D(config.UpperRight, 0.1);
            Point3D ll = ToWpfPoint3D(config.LowerLeft, 0.1);

            Screen screen = new Screen(ul,ur,ll);
            visualModel.Children.Remove(_screen);
            _screen = screen;
            visualModel.Children.Add(_screen);
        }

        void _tracker_TrackBoxChanged(object sender, TrackBoxChangedEventArgs e)
        {
            UpdateTrackBox();
        }

        private void UpdateTrackBox()
        {
            TrackBox box = _tracker.GetTrackBox();
            _trackBox[0].Point1 = ToWpfPoint3D(box.Point1, 0.1);
            _trackBox[0].Point2 = ToWpfPoint3D(box.Point2, 0.1);

            _trackBox[1].Point1 = ToWpfPoint3D(box.Point1, 0.1);
            _trackBox[1].Point2 = ToWpfPoint3D(box.Point4, 0.1);

            _trackBox[2].Point1 = ToWpfPoint3D(box.Point3, 0.1);
            _trackBox[2].Point2 = ToWpfPoint3D(box.Point4, 0.1);

            _trackBox[3].Point1 = ToWpfPoint3D(box.Point2, 0.1);
            _trackBox[3].Point2 = ToWpfPoint3D(box.Point3, 0.1);

            _trackBox[4].Point1 = ToWpfPoint3D(box.Point5, 0.1);
            _trackBox[4].Point2 = ToWpfPoint3D(box.Point8, 0.1);

            _trackBox[5].Point1 = ToWpfPoint3D(box.Point5, 0.1);
            _trackBox[5].Point2 = ToWpfPoint3D(box.Point6, 0.1);

            _trackBox[6].Point1 = ToWpfPoint3D(box.Point6, 0.1);
            _trackBox[6].Point2 = ToWpfPoint3D(box.Point7, 0.1);

            _trackBox[7].Point1 = ToWpfPoint3D(box.Point7, 0.1);
            _trackBox[7].Point2 = ToWpfPoint3D(box.Point8, 0.1);

            _trackBox[8].Point1 = ToWpfPoint3D(box.Point5, 0.1);
            _trackBox[8].Point2 = ToWpfPoint3D(box.Point1, 0.1);

            _trackBox[9].Point1 = ToWpfPoint3D(box.Point8, 0.1);
            _trackBox[9].Point2 = ToWpfPoint3D(box.Point4, 0.1);

            _trackBox[10].Point1 = ToWpfPoint3D(box.Point7, 0.1);
            _trackBox[10].Point2 = ToWpfPoint3D(box.Point3, 0.1);

            _trackBox[11].Point1 = ToWpfPoint3D(box.Point6, 0.1);
            _trackBox[11].Point2 = ToWpfPoint3D(box.Point2, 0.1);
        }

        private static Point3D ToWpfPoint3D(Tobii.EyeTracking.IO.Point3D pt, double scale)
        {
            double x = pt.X * scale;
            double y = pt.Y * scale;
            double z = pt.Z * scale;
            return new Point3D(x,y,z);
        }
    }
}
