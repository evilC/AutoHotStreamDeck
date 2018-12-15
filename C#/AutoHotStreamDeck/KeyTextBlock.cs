using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace AutoHotStreamDeck
{
    public class KeyTextBlock
    {
        private readonly OutlinedTextBlock _textBlock = new OutlinedTextBlock();
        private readonly Grid _grid;

        public Panel Get()
        {
            return _grid;
        }

        public KeyTextBlock(int w, int h, string text = "", bool centered = false)
        {
            _textBlock.Text = text;
            _textBlock.Width = w;
            // Setting height breaks vertical centering - Set Height on Grid instead
            //_textBlock.Height = _deck.KeyHeightInpixels;
            _textBlock.FontWeight = FontWeights.ExtraBold;
            _textBlock.StrokeThickness = 3;
            _textBlock.TextWrapping = TextWrapping.Wrap;
            _textBlock.TextAlignment = centered ? TextAlignment.Center : TextAlignment.Left;
            _textBlock.VerticalAlignment = VerticalAlignment.Center;

            _grid = new Grid
            {
                Width = w,
                Height = w,
                HorizontalAlignment = HorizontalAlignment.Center,
                VerticalAlignment = VerticalAlignment.Center
            };

            SetColor();
            SetOutlineColor();
            _grid.Children.Add(_textBlock);
        }

        public KeyTextBlock SetColor(byte r = 255, byte g = 255, byte b = 255, byte a = 255)
        {
            _textBlock.Fill = new SolidColorBrush(Color.FromArgb(a, r, g, b));
            return this;
        }

        public KeyTextBlock SetOutlineColor(byte r = 0, byte g = 0, byte b = 0, byte a = 127)
        {
            _textBlock.Stroke = new SolidColorBrush(Color.FromArgb(a, r, g, b));
            return this;
        }

        public KeyTextBlock SetOutlineSize(int size)
        {
            _textBlock.StrokeThickness = size;
            return this;
        }

        public KeyTextBlock SetFontSize(int size)
        {
            _textBlock.FontSize = size;
            return this;
        }

        public KeyTextBlock SetFontFamily(string fontFamily)
        {
            _textBlock.FontFamily = new FontFamily(fontFamily);
            return this;
        }

        public KeyTextBlock SetText(string text)
        {
            _textBlock.Text = text;
            return this;
        }

        public KeyTextBlock SetTop(int top)
        {
            Canvas.SetTop(_grid, top);
            return this;
        }

        public KeyTextBlock SetHeight(int height)
        {
            _grid.Height = height;
            return this;
        }
    }
}
