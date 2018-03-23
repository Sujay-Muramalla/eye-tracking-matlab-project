namespace BasicEyetrackingSample
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this._box1 = new System.Windows.Forms.GroupBox();
            this._connectButton = new System.Windows.Forms.Button();
            this._trackerInfoLabel = new System.Windows.Forms.Label();
            this._trackerList = new System.Windows.Forms.ListView();
            this._statusStrip = new System.Windows.Forms.StatusStrip();
            this._connectionStatusLabel = new System.Windows.Forms.ToolStripStatusLabel();
            this._box2 = new System.Windows.Forms.GroupBox();
            this._calibrateButton = new System.Windows.Forms.Button();
            this._trackButton = new System.Windows.Forms.Button();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.fileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this._saveCalibrationMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this._viewCalibrationMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this._loadCalibrationMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.propertiesToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this._framerateMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this._openFileDialog = new System.Windows.Forms.OpenFileDialog();
            this._saveFileDialog = new System.Windows.Forms.SaveFileDialog();
            this._trackStatus = new BasicEyetrackingSample.TrackStatusControl();
            this._box1.SuspendLayout();
            this._statusStrip.SuspendLayout();
            this._box2.SuspendLayout();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // _box1
            // 
            this._box1.Controls.Add(this._connectButton);
            this._box1.Controls.Add(this._trackerInfoLabel);
            this._box1.Controls.Add(this._trackerList);
            this._box1.Location = new System.Drawing.Point(13, 38);
            this._box1.Name = "_box1";
            this._box1.Size = new System.Drawing.Size(237, 373);
            this._box1.TabIndex = 1;
            this._box1.TabStop = false;
            this._box1.Text = "Eyetrackers Found on the  Network";
            // 
            // _connectButton
            // 
            this._connectButton.Enabled = false;
            this._connectButton.Location = new System.Drawing.Point(45, 334);
            this._connectButton.Name = "_connectButton";
            this._connectButton.Size = new System.Drawing.Size(142, 27);
            this._connectButton.TabIndex = 2;
            this._connectButton.Text = "Connect to Eyetracker";
            this._connectButton.UseVisualStyleBackColor = true;
            this._connectButton.Click += new System.EventHandler(this._connectButton_Click);
            // 
            // _trackerInfoLabel
            // 
            this._trackerInfoLabel.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)));
            this._trackerInfoLabel.Location = new System.Drawing.Point(19, 225);
            this._trackerInfoLabel.Name = "_trackerInfoLabel";
            this._trackerInfoLabel.Size = new System.Drawing.Size(196, 95);
            this._trackerInfoLabel.TabIndex = 1;
            // 
            // _trackerList
            // 
            this._trackerList.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)));
            this._trackerList.Location = new System.Drawing.Point(19, 33);
            this._trackerList.MultiSelect = false;
            this._trackerList.Name = "_trackerList";
            this._trackerList.ShowItemToolTips = true;
            this._trackerList.Size = new System.Drawing.Size(196, 179);
            this._trackerList.TabIndex = 0;
            this._trackerList.UseCompatibleStateImageBehavior = false;
            this._trackerList.View = System.Windows.Forms.View.SmallIcon;
            this._trackerList.SelectedIndexChanged += new System.EventHandler(this._trackerList_SelectedIndexChanged);
            // 
            // _statusStrip
            // 
            this._statusStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this._connectionStatusLabel});
            this._statusStrip.Location = new System.Drawing.Point(0, 418);
            this._statusStrip.Name = "_statusStrip";
            this._statusStrip.Size = new System.Drawing.Size(665, 22);
            this._statusStrip.TabIndex = 2;
            this._statusStrip.Text = "statusStrip1";
            // 
            // _connectionStatusLabel
            // 
            this._connectionStatusLabel.Name = "_connectionStatusLabel";
            this._connectionStatusLabel.Size = new System.Drawing.Size(71, 17);
            this._connectionStatusLabel.Text = "Disconnected";
            // 
            // _box2
            // 
            this._box2.Controls.Add(this._calibrateButton);
            this._box2.Controls.Add(this._trackStatus);
            this._box2.Controls.Add(this._trackButton);
            this._box2.Location = new System.Drawing.Point(256, 38);
            this._box2.Name = "_box2";
            this._box2.Size = new System.Drawing.Size(395, 373);
            this._box2.TabIndex = 3;
            this._box2.TabStop = false;
            this._box2.Text = "Eyetracker Status";
            // 
            // _calibrateButton
            // 
            this._calibrateButton.Location = new System.Drawing.Point(197, 334);
            this._calibrateButton.Name = "_calibrateButton";
            this._calibrateButton.Size = new System.Drawing.Size(111, 27);
            this._calibrateButton.TabIndex = 2;
            this._calibrateButton.Text = "Run Calibration";
            this._calibrateButton.UseVisualStyleBackColor = true;
            this._calibrateButton.Click += new System.EventHandler(this._calibrateButton_Click);
            // 
            // _trackButton
            // 
            this._trackButton.Location = new System.Drawing.Point(74, 334);
            this._trackButton.Name = "_trackButton";
            this._trackButton.Size = new System.Drawing.Size(111, 27);
            this._trackButton.TabIndex = 0;
            this._trackButton.Text = "Start Tracking";
            this._trackButton.UseVisualStyleBackColor = true;
            this._trackButton.Click += new System.EventHandler(this._trackButton_Click);
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.fileToolStripMenuItem,
            this.propertiesToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(665, 24);
            this.menuStrip1.TabIndex = 4;
            this.menuStrip1.Text = "_menuStrip";
            // 
            // fileToolStripMenuItem
            // 
            this.fileToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this._saveCalibrationMenuItem,
            this._viewCalibrationMenuItem,
            this._loadCalibrationMenuItem});
            this.fileToolStripMenuItem.Name = "fileToolStripMenuItem";
            this.fileToolStripMenuItem.Size = new System.Drawing.Size(35, 20);
            this.fileToolStripMenuItem.Text = "File";
            // 
            // _saveCalibrationMenuItem
            // 
            this._saveCalibrationMenuItem.Name = "_saveCalibrationMenuItem";
            this._saveCalibrationMenuItem.Size = new System.Drawing.Size(163, 22);
            this._saveCalibrationMenuItem.Text = "Save Calibration";
            this._saveCalibrationMenuItem.Click += new System.EventHandler(this._saveCalibrationMenuItem_Click);
            // 
            // _viewCalibrationMenuItem
            // 
            this._viewCalibrationMenuItem.Name = "_viewCalibrationMenuItem";
            this._viewCalibrationMenuItem.Size = new System.Drawing.Size(163, 22);
            this._viewCalibrationMenuItem.Text = "View Calibration";
            this._viewCalibrationMenuItem.Click += new System.EventHandler(this._viewCalibrationMenuItem_Click);
            // 
            // _loadCalibrationMenuItem
            // 
            this._loadCalibrationMenuItem.Name = "_loadCalibrationMenuItem";
            this._loadCalibrationMenuItem.Size = new System.Drawing.Size(163, 22);
            this._loadCalibrationMenuItem.Text = "Load Calibration";
            this._loadCalibrationMenuItem.Click += new System.EventHandler(this._loadCalibrationMenuItem_Click);
            // 
            // propertiesToolStripMenuItem
            // 
            this.propertiesToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this._framerateMenuItem});
            this.propertiesToolStripMenuItem.Name = "propertiesToolStripMenuItem";
            this.propertiesToolStripMenuItem.Size = new System.Drawing.Size(68, 20);
            this.propertiesToolStripMenuItem.Text = "Properties";
            // 
            // _framerateMenuItem
            // 
            this._framerateMenuItem.Name = "_framerateMenuItem";
            this._framerateMenuItem.Size = new System.Drawing.Size(152, 22);
            this._framerateMenuItem.Text = "FrameRate...";
            this._framerateMenuItem.Click += new System.EventHandler(this._framerateMenuItem_Click);
            // 
            // _openFileDialog
            // 
            this._openFileDialog.DefaultExt = "calib";
            this._openFileDialog.FileName = "file";
            this._openFileDialog.Filter = "Calibration Files |*.calib";
            this._openFileDialog.Title = "Load Calibration File";
            // 
            // _saveFileDialog
            // 
            this._saveFileDialog.DefaultExt = "calib";
            this._saveFileDialog.FileName = "file";
            this._saveFileDialog.Filter = "Calibration Files|*.calib";
            this._saveFileDialog.Title = "Save Calibration File";
            // 
            // _trackStatus
            // 
            this._trackStatus.BackColor = System.Drawing.Color.Black;
            this._trackStatus.Location = new System.Drawing.Point(74, 33);
            this._trackStatus.Name = "_trackStatus";
            this._trackStatus.Size = new System.Drawing.Size(234, 179);
            this._trackStatus.TabIndex = 1;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(665, 440);
            this.Controls.Add(this._box2);
            this.Controls.Add(this._statusStrip);
            this.Controls.Add(this.menuStrip1);
            this.Controls.Add(this._box1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "MainForm";
            this.Text = "SDK - Basic Eyetracking Sample";
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MainForm_FormClosing);
            this._box1.ResumeLayout(false);
            this._statusStrip.ResumeLayout(false);
            this._statusStrip.PerformLayout();
            this._box2.ResumeLayout(false);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.GroupBox _box1;
        private System.Windows.Forms.ListView _trackerList;
        private System.Windows.Forms.Label _trackerInfoLabel;
        private System.Windows.Forms.Button _connectButton;
        private System.Windows.Forms.StatusStrip _statusStrip;
        private System.Windows.Forms.ToolStripStatusLabel _connectionStatusLabel;
        private System.Windows.Forms.GroupBox _box2;
        private System.Windows.Forms.Button _trackButton;
        private TrackStatusControl _trackStatus;
        private System.Windows.Forms.Button _calibrateButton;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem fileToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem _saveCalibrationMenuItem;
        private System.Windows.Forms.ToolStripMenuItem _viewCalibrationMenuItem;
        private System.Windows.Forms.ToolStripMenuItem _loadCalibrationMenuItem;
        private System.Windows.Forms.OpenFileDialog _openFileDialog;
        private System.Windows.Forms.SaveFileDialog _saveFileDialog;
        private System.Windows.Forms.ToolStripMenuItem propertiesToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem _framerateMenuItem;

    }
}

