using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Input;
using System.Windows.Media.Media3D;
using System.Windows.Markup;

public class MouseHelper
{
    private PerspectiveCamera _camera;
    private FrameworkElement _eventSource;
    private Point _position;
    private double _diffX = 0;

    public MouseHelper(PerspectiveCamera camera)
    {
        _camera = camera;
    }


    public FrameworkElement EventSource
    {
        get { return _eventSource; }

        set
        {
            if (_eventSource != null)
            {
                _eventSource.MouseDown -= this.OnMouseDown;
                _eventSource.MouseUp -= this.OnMouseUp;
                _eventSource.MouseMove -= this.OnMouseMove;
            }

            _eventSource = value;

            _eventSource.MouseDown += this.OnMouseDown;
            _eventSource.MouseUp   += this.OnMouseUp;
            _eventSource.MouseMove += this.OnMouseMove;
        }
    }

    private void OnMouseDown(object sender, MouseEventArgs e)
    {
        Mouse.Capture(EventSource, CaptureMode.Element);
        _position = e.GetPosition(EventSource);
        _diffX = 0;
    }

    private void OnMouseUp(object sender, MouseEventArgs e)
    {
        Mouse.Capture(EventSource, CaptureMode.None);
    }

    private void OnMouseMove(object sender, MouseEventArgs e)
    {
        Point currentPosition = e.GetPosition(EventSource);

        _diffX = 0;

        if (e.LeftButton == MouseButtonState.Pressed)
        {        
            _diffX = (_position.Y - currentPosition.Y) * 0.5;
            _camera.FieldOfView -= _diffX;

        }

        _position = currentPosition;
    }
}
