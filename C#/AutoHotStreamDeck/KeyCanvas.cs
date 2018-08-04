using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using SharpLib.StreamDeck;

namespace AutoHotStreamDeck
{
    public class KeyCanvas
    {
        private readonly Client _deck;

        public int? CurrentKeyId { get; private set; } = null;
        private readonly ConcurrentDictionary<string, KeyTextBlock> _textBlocks = new ConcurrentDictionary<string, KeyTextBlock>(StringComparer.OrdinalIgnoreCase);
        private Image _image = null;

        public Canvas Canvas { get; }

        public KeyCanvas(Client deck, int? keyId = null)
        {
            _deck = deck;
            Canvas = new Canvas
            {
                Width = _deck.KeyWidthInpixels,
                Height = _deck.KeyHeightInpixels,
                Background = Brushes.Black
            };

            _image = new Image();
            Canvas.Children.Add(_image);

            _image.Width = _deck.KeyWidthInpixels;
            _image.Height = _deck.KeyHeightInpixels;
            //Canvas.SetZIndex(_image, Int32.MinValue);

            SetKeyId(keyId);
        }

        public void SetKeyId(int? keyId)
        {
            if (keyId != null && CurrentKeyId == null)
            {
                // Load
                _deck.SetKeyBitmap((int)keyId, _deck.CreateKeyFromWpfElement(Canvas));
            }
            else if (keyId == null && CurrentKeyId != null)
            {
                // UnLoad
                _deck.ClearKey((int)CurrentKeyId);
            }
            else if (keyId != null && CurrentKeyId != null)
            {
                // Move
                _deck.ClearKey((int)CurrentKeyId);
                _deck.SetKeyBitmap((int)keyId, _deck.CreateKeyFromWpfElement(Canvas));
            }

            CurrentKeyId = keyId;
        }

        public KeyCanvas SetBackground(byte r, byte g, byte b)
        {
            Canvas.Background = new SolidColorBrush(Color.FromRgb(r, g, b));
            return this;
        }

        public KeyTextBlock CreateTextBlock(string text = "", bool centered = true)
        {
            var ktb = new KeyTextBlock(_deck, text, centered);

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

        public void Update()
        {
            if (CurrentKeyId == null) return;
            _deck.SetKeyBitmap((int)CurrentKeyId, _deck.CreateKeyFromWpfElement(Canvas));
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
                throw new Exception($"TextBlock {name} already exists");
            }
        }

        public KeyCanvas SetImageFromFileName(string fileName)
        {
            _image.Source = new BitmapImage(new Uri(fileName));
            return this;
        }
    }
}
