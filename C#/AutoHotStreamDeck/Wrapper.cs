using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SharpLib.StreamDeck;

namespace AutoHotStreamDeck
{
    public class Wrapper
    {
        private readonly Client _deck;

        public int KeyCount => _deck.KeyCount;

        public Wrapper()
        {
            _deck = new Client();
            _deck.Open();
        }

        public string OkCheck()
        {
            return "OK";
        }

        public void SetKeyColor(int key, byte r, byte g, byte b)
        {
            _deck.SetKeyBitmap(key, KeyBitmap.FromRGBColor(r, g, b));
        }

        public void SetBrightness(byte brightness)
        {
            _deck.SetBrightness(brightness);
        }
    }
}
