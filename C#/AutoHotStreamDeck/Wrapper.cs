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
using OpenMacroBoard.SDK;
using StreamDeckSharp;

namespace AutoHotStreamDeck
{
    public class Wrapper
    {
        private readonly ConcurrentDictionary<int, KeyCanvas> _loadedCanvases = new ConcurrentDictionary<int, KeyCanvas>();
        public readonly IMacroBoard Deck;

        //public Client Deck { get; }

        public Wrapper()
        {
            var allConnectedDevices = StreamDeck
                .EnumerateDevices()
                .Select(x => x.Open())
                .ToList();

            //var decks = StreamDeck.EnumerateDevices();
            //var deck = decks.First();
            //deck.Open();
            Deck = allConnectedDevices.First(); ;
            Deck.KeyStateChanged += KeyHandler;


            //deck.KeyPressed += KeyHandler;

            //Deck = new Client();
            //Deck.Open();
            //Deck.KeyPressed += KeyHandler;
        }

        public string OkCheck()
        {
            return "OK";
        }

        public KeyCanvas CreateKeyCanvas(dynamic callback)
        {
            //return new KeyCanvas(Deck.KeyWidthInpixels, Deck.KeyHeightInpixels, callback);
            //return new KeyCanvas(Deck.Keys.Area.Width, Deck.Keys.Area.Height, callback);
            return new KeyCanvas(Deck.Keys[0].Width, Deck.Keys[0].Height, callback);
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
            //Deck.SetKeyBitmap(key, Deck.CreateKeyFromWpfElement(canvas.Canvas));
            Deck.SetKeyBitmap(key, KeyBitmap.Create.FromWpfElement(Deck.Keys[key].Width, Deck.Keys[key].Height, canvas.Canvas));
        }

        private int ValidateAndGetKeyId(int index)
        {
            //if (index < 1 || index > Deck.KeyCount) throw new ArgumentOutOfRangeException($"Expecting value between 1 and {Deck.KeyCount}");
            if (index < 1 || index > Deck.Keys.Count) throw new ArgumentOutOfRangeException($"Expecting value between 1 and {Deck.Keys.Count}");
            return index - 1;
        }

        public void RefreshKey(int index)
        {
            var key = ValidateAndGetKeyId(index);
            if (!_loadedCanvases.ContainsKey(key)) return;
            //Deck.SetKeyBitmap(key, Deck.CreateKeyFromWpfElement(_loadedCanvases[key].Canvas));
            //Deck.SetKeyBitmap(key, KeyBitmap.Create.FromWpfElement(Deck.Keys.Area.Width, Deck.Keys.Area.Height, _loadedCanvases[key].Canvas));
            Deck.SetKeyBitmap(key, KeyBitmap.Create.FromWpfElement(Deck.Keys[key].Width, Deck.Keys[key].Height, _loadedCanvases[key].Canvas));
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
            if (_loadedCanvases.ContainsKey(e.Key))
            {
                _loadedCanvases[e.Key].FireCallback(e.IsDown ? 1 : 0);
            }
        }
    }
}
