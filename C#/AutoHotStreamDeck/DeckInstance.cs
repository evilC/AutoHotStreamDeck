using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenMacroBoard.SDK;
using StreamDeckSharp;

namespace AutoHotStreamDeck
{
    public class DeckInstance
    {
        public int KeyCount => Deck.Keys.Count;
        public int RowCount => Deck.Keys.KeyCountY;
        public int ColCount => Deck.Keys.KeyCountX;

        private IStreamDeckBoard Deck;
        private readonly ConcurrentDictionary<int, KeyCanvas> _loadedCanvases = new ConcurrentDictionary<int, KeyCanvas>();

        public DeckInstance(IStreamDeckRefHandle connectedDevice)
        {
            Deck = connectedDevice.Open();

            Deck.KeyStateChanged += KeyStateChanged;
        }

        public KeyCanvas CreateKeyCanvas(dynamic callback)
        {
            //return new KeyCanvas(Deck.KeyWidthInpixels, Deck.KeyHeightInpixels, callback);
            //return new KeyCanvas(Deck.Keys.Area.Width, Deck.Keys.Area.Height, callback);
            return new KeyCanvas(Deck.Keys.KeyWidth, Deck.Keys.KeyHeight, callback);
        }

        public void RefreshKey(int index)
        {
            var key = ValidateAndGetKeyId(index);
            if (!_loadedCanvases.ContainsKey(key)) return;
            //Deck.SetKeyBitmap(key, Deck.CreateKeyFromWpfElement(_loadedCanvases[key].Canvas));
            //Deck.SetKeyBitmap(key, KeyBitmap.Create.FromWpfElement(Deck.Keys.Area.Width, Deck.Keys.Area.Height, _loadedCanvases[key].Canvas));
            Deck.SetKeyBitmap(key, KeyBitmap.Create.FromWpfElement(Deck.Keys.KeyWidth, Deck.Keys.KeyHeight, _loadedCanvases[key].Canvas));
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

        public void SetBrightness(byte brightness)
        {
            Deck.SetBrightness(brightness);
        }

        private int ValidateAndGetKeyId(int index)
        {
            //if (index < 1 || index > Deck.KeyCount) throw new ArgumentOutOfRangeException($"Expecting value between 1 and {Deck.KeyCount}");
            if (index < 1 || index > Deck.Keys.Count) throw new ArgumentOutOfRangeException($"Expecting value between 1 and {Deck.Keys.Count}");
            return index - 1;
        }

        private void KeyStateChanged(object sender, KeyEventArgs e)
        {
            if (_loadedCanvases.ContainsKey(e.Key))
            {
                _loadedCanvases[e.Key].FireCallback(e.IsDown ? 1 : 0);
            }
        }

    }
}
