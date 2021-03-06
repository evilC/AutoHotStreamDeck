﻿using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace AutoHotStreamDeck
{
    public class KeyCanvas
    {
        private readonly dynamic _callback;
        private readonly ConcurrentDictionary<string, KeyTextBlock> _textBlocks = new ConcurrentDictionary<string, KeyTextBlock>(StringComparer.OrdinalIgnoreCase);
        private readonly ConcurrentDictionary<string, Image> _images = new ConcurrentDictionary<string, Image>(StringComparer.OrdinalIgnoreCase);
        private readonly int _width;
        private readonly int _height;

        public Canvas Canvas { get; }

        public KeyCanvas(int w, int h, dynamic callback)
        {
            _callback = callback;
            _width = w;
            _height = h;
            Canvas = new Canvas
            {
                Width = _width,
                Height = _height,
                Background = Brushes.Black
            };
        }

        public KeyCanvas SetBackground(byte r, byte g, byte b)
        {
            Canvas.Background = new SolidColorBrush(Color.FromRgb(r, g, b));
            return this;
        }

        public KeyTextBlock CreateTextBlock(string text = "", bool centered = true)
        {
            var ktb = new KeyTextBlock(_width, _height, text, centered);

            return ktb;
        }

        public KeyCanvas AddTextBlock(string name, KeyTextBlock textBlock)
        {
            if (_textBlocks.ContainsKey(name))
            {
                throw new Exception($"TextBlock {name} already exists");
            }

            Canvas.Children.Add(textBlock.Get());
            _textBlocks.TryAdd(name, textBlock);
            return this;
        }

        public void AddImage(string imageName, Image image, int top = 0, int left = 0, int zIndex = int.MinValue)
        {
            if (_images.ContainsKey(imageName))
            {
                throw new Exception($"Image {imageName} already exists");
            }

            _images.TryAdd(imageName, image);
            Canvas.Children.Add(image);
            Canvas.SetTop(image, top);
            Canvas.SetLeft(image, left);
            Panel.SetZIndex(image, zIndex);
        }

        public KeyTextBlock GetTextBlock(string name)
        {
            CheckTextBlockExists(name);
            return _textBlocks[name];
        }

        public void CheckTextBlockExists(string name)
        {
            if (!_textBlocks.ContainsKey(name))
            {
                throw new Exception($"TextBlock {name} does not exist");
            }
        }

        public void CheckImageExists(string name)
        {
            if (!_images.ContainsKey(name))
            {
                throw new Exception($"Image {name} does not exist");
            }
        }

        public KeyCanvas SetImageVisible(string imageName, bool isVisible)
        {
            CheckImageExists(imageName);
            _images[imageName].Visibility = isVisible ? Visibility.Visible : Visibility.Hidden;
            return this;
        }

        public KeyCanvas SetTextBlockVisible(string textName, bool isVisible)
        {
            CheckTextBlockExists(textName);
            _textBlocks[textName].Get().Visibility = isVisible ? Visibility.Visible : Visibility.Hidden;
            return this;
        }

        public void FireCallback(int state)
        {
            if (_callback == null) return;
            ThreadPool.QueueUserWorkItem(cb => _callback(state));
        }
    }
}
