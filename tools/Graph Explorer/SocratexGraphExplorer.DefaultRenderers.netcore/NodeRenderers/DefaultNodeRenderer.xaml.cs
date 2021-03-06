﻿using Neo4j.Driver;
using SocratexGraphExplorer.Common;
using System;
using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;

namespace SocratexGraphExplorer.DefaultsPlugin
{
    /// <summary>
    /// Interaction logic for the Default node renderer, that is used when
    /// no other, more specialized, renderer is available.
    /// </summary>
    public partial class DefaultNodeRenderer : UserControl, INodeRenderer
    {
        public ObservableCollection<PropertyItem> Properties { get; private set; }
        private IModel Model { get; set; }
        private INode node { get; set; }

        public DefaultNodeRenderer(IModel model)
        {
            InitializeComponent();

            this.Properties = new ObservableCollection<PropertyItem>();
            this.Model = model;

            this.DataContext = this;
        }

        /// <summary>
        /// Called when the user releases the right mouse in the property grid.
        /// </summary>
        /// <param name="sender">The control that is selected</param>
        /// <param name="args">The arguments. Not used.</param>
        public void OnMouseRightButtonUp(object sender, EventArgs args)
        {
            TextBlock control = sender as TextBlock;
            Clipboard.SetText(control.Text);
        }

        public void SelectNodeAsync(INode node)
        {
            this.node = node;

            this.Header.Text = string.Format("Node {0}", node.Labels[0]);
            this.Properties.Add(new PropertyItem() { Key = "Id", Value = node.Id.ToString() });

            foreach (var property in node.Properties)
            {
                this.Properties.Add(new PropertyItem() { Key = property.Key, Value = property.Value.ToString() });
            }
        }
    }
}
