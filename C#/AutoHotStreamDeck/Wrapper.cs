using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Media.Imaging;
using SharpLib.StreamDeck;

namespace AutoHotStreamDeck
{
    public class Wrapper
    {
        private readonly ConcurrentDictionary<int, dynamic> _callbacks = new ConcurrentDictionary<int, dynamic>();
        private readonly ConcurrentDictionary<int, KeyCanvas> _loadedCanvases = new ConcurrentDictionary<int, KeyCanvas>();

        public Client Deck { get; }

        public Wrapper()
        {
            Deck = new Client();
            Deck.Open();
            Deck.KeyPressed += KeyHandler;
        }

        public string OkCheck()
        {
            return "OK";
        }

        public void SubscribeKey(int index, dynamic callback)
        {
            var key = ValidateAndGetKeyId(index);
            _callbacks.TryAdd(key, callback);
        }

        public KeyCanvas CreateKeyCanvas()
        {
            return new KeyCanvas(Deck.KeyWidthInpixels, Deck.KeyHeightInpixels);
        }

        public void SetKeyCanvas(int index, KeyCanvas canvas)
        {
            var key = ValidateAndGetKeyId(index);
            
            if (_loadedCanvases.ContainsKey(key))
            {
                Deck.ClearKey(key);
                _loadedCanvases.TryRemove(key, out _);
            }

            _loadedCanvases.TryAdd(key, canvas);
            Deck.SetKeyBitmap(key, Deck.CreateKeyFromWpfElement(canvas.Canvas));
        }

        private int ValidateAndGetKeyId(int index)
        {
            if (index < 1 || index > Deck.KeyCount) throw new ArgumentOutOfRangeException($"Expecting value between 1 and {Deck.KeyCount}");
            return index - 1;
        }

        public void RefreshKey(int index)
        {
            var key = ValidateAndGetKeyId(index);
            if (!_loadedCanvases.ContainsKey(key)) return;
            Deck.SetKeyBitmap(key, Deck.CreateKeyFromWpfElement(_loadedCanvases[key].Canvas));
        }

        public Image CreateImageFromFileName(string fileName)
        {
            var bmp = new BitmapImage(new Uri(fileName));

            var image = new Image
            {
                Width = bmp.PixelWidth,
                Height = bmp.PixelHeight,
                Source = bmp
            };
            return image;
        }

        public void SetBrightness(byte brightness)
        {
            Deck.SetBrightness(brightness);
        }

        private void KeyHandler(object sender, KeyEventArgs e)
        {
            if (_callbacks.ContainsKey(e.Key))
            {
                ThreadPool.QueueUserWorkItem(cb => _callbacks[e.Key](e.IsDown ? 1 : 0));
            }
        }
    }
}
