namespace UpgradeSample
{
    partial class Form1
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
            this._trackerCombo = new System.Windows.Forms.ComboBox();
            this._upgradeButton = new System.Windows.Forms.Button();
            this._openFileDialog = new System.Windows.Forms.OpenFileDialog();
            this._progressBar = new System.Windows.Forms.ProgressBar();
            this._statusLabel = new System.Windows.Forms.Label();
            this._cancelButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // _trackerCombo
            // 
            this._trackerCombo.FormattingEnabled = true;
            this._trackerCombo.Location = new System.Drawing.Point(12, 12);
            this._trackerCombo.Name = "_trackerCombo";
            this._trackerCombo.Size = new System.Drawing.Size(228, 21);
            this._trackerCombo.TabIndex = 0;
            this._trackerCombo.SelectedIndexChanged += new System.EventHandler(this._trackerCombo_SelectedIndexChanged);
            // 
            // _upgradeButton
            // 
            this._upgradeButton.Enabled = false;
            this._upgradeButton.Location = new System.Drawing.Point(246, 10);
            this._upgradeButton.Name = "_upgradeButton";
            this._upgradeButton.Size = new System.Drawing.Size(104, 23);
            this._upgradeButton.TabIndex = 2;
            this._upgradeButton.Text = "Upgrade...";
            this._upgradeButton.UseVisualStyleBackColor = true;
            this._upgradeButton.Click += new System.EventHandler(this._upgradeButton_Click);
            // 
            // _openFileDialog
            // 
            this._openFileDialog.Filter = "Tobii Firmware Packages|*.tobiipkg";
            this._openFileDialog.Title = "Select Upgrade Package";
            // 
            // _progressBar
            // 
            this._progressBar.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this._progressBar.Location = new System.Drawing.Point(12, 95);
            this._progressBar.Name = "_progressBar";
            this._progressBar.Size = new System.Drawing.Size(448, 23);
            this._progressBar.TabIndex = 3;
            // 
            // _statusLabel
            // 
            this._statusLabel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this._statusLabel.AutoSize = true;
            this._statusLabel.Location = new System.Drawing.Point(15, 72);
            this._statusLabel.Name = "_statusLabel";
            this._statusLabel.Size = new System.Drawing.Size(0, 13);
            this._statusLabel.TabIndex = 4;
            // 
            // _cancelButton
            // 
            this._cancelButton.Enabled = false;
            this._cancelButton.Location = new System.Drawing.Point(356, 10);
            this._cancelButton.Name = "_cancelButton";
            this._cancelButton.Size = new System.Drawing.Size(104, 23);
            this._cancelButton.TabIndex = 5;
            this._cancelButton.Text = "Cancel";
            this._cancelButton.UseVisualStyleBackColor = true;
            this._cancelButton.Click += new System.EventHandler(this._cancelButton_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(477, 132);
            this.Controls.Add(this._cancelButton);
            this.Controls.Add(this._statusLabel);
            this.Controls.Add(this._progressBar);
            this.Controls.Add(this._upgradeButton);
            this.Controls.Add(this._trackerCombo);
            this.Name = "Form1";
            this.Text = "Upgrade Sample Application";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ComboBox _trackerCombo;
        private System.Windows.Forms.Button _upgradeButton;
        private System.Windows.Forms.OpenFileDialog _openFileDialog;
        private System.Windows.Forms.ProgressBar _progressBar;
        private System.Windows.Forms.Label _statusLabel;
        private System.Windows.Forms.Button _cancelButton;
    }
}

