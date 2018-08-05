using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Media.Imaging;
using SharpLib.StreamDeck;

namespace AutoHotStreamDeck
{
    public class Wrapper
    {
        private readonly ConcurrentDictionary<int, dynamic> _callbacks = new ConcurrentDictionary<int, dynamic>();

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

        public void SubscribeKey(int key, dynamic callback)
        {
            _callbacks.TryAdd(key, callback);
        }

        public KeyCanvas CreateKeyCanvas(int? keyId = null)
        {
            return new KeyCanvas(Deck, keyId);
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
                _callbacks[e.Key](e.IsDown ? 1 : 0);
            }
        }
    }
}
