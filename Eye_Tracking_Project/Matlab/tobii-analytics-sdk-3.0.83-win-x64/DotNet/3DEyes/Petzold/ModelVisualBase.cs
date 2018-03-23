// ModelVisualBase.cs by Charles Petzold

using System;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Media3D;

namespace Petzold.MeshGeometries
{
    public abstract class ModelVisualBase : ModelVisual3D
    {
        // Private fields
        MeshGeometry3D meshgeo;
        GeometryModel3D geomodel;

        // Public parameterless constructor
        public ModelVisualBase()
        {
            meshgeo = new MeshGeometry3D();
            geomodel = new GeometryModel3D();
            Geometry = meshgeo;
            Content = geomodel;
        }

        // Material and BackMaterial dependency properties
        public static readonly DependencyProperty GeometryProperty =
            GeometryModel3D.GeometryProperty.AddOwner(typeof(ModelVisualBase),
            new PropertyMetadata(null, OnPropertyChanged));

        public static readonly DependencyProperty MaterialProperty =
            GeometryModel3D.MaterialProperty.AddOwner(typeof(ModelVisualBase),
            new PropertyMetadata(null, OnPropertyChanged));

        public static readonly DependencyProperty BackMaterialProperty =
            GeometryModel3D.BackMaterialProperty.AddOwner(typeof(ModelVisualBase),
            new PropertyMetadata(null, OnPropertyChanged));

        // Material and BackMaterial CLR properties
        public Geometry3D Geometry
        {
            get { return (Geometry3D)GetValue(GeometryProperty); }
            set { SetValue(GeometryProperty, value); }
        }
        public Material Material
        {
            get { return (Material)GetValue(MaterialProperty); }
            set { SetValue(MaterialProperty, value); }
        }
        public Material BackMaterial
        {
            get { return (Material)GetValue(BackMaterialProperty); }
            set { SetValue(BackMaterialProperty, value); }
        }

        // Material and BackMaterial OnChanged handler.
        static void OnPropertyChanged(DependencyObject obj,
                            DependencyPropertyChangedEventArgs args)
        {
            ModelVisualBase modbase = (ModelVisualBase)obj;

            if (args.Property == GeometryProperty)
                modbase.geomodel.Geometry = (Geometry3D)args.NewValue;

            else if (args.Property == MaterialProperty)
                modbase.geomodel.Material = (Material)args.NewValue;

            else
                modbase.geomodel.BackMaterial = (Material)args.NewValue;
        }
    }
}
