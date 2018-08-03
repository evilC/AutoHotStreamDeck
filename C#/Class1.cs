using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SharpLib.StreamDeck;

namespace AutoHotStreamDeck
{
    public class Class1
    {
        public Class1()
        {
            var red = KeyBitmap.FromRGBColor(237, 41, 57);
            var white = KeyBitmap.FromRGBColor(255, 255, 255);
            var rowColors = new KeyBitmap[] { red, white, red };

            //Open the Stream Deck device

            using (Client deck = new Client())
            {
                deck.Open();
                deck.SetBrightness(100);

                //Send the bitmap informaton to the device
                for (int i = 0; i < deck.KeyCount; i++)
                    deck.SetKeyBitmap(i, rowColors[i / 5]);
                Console.ReadLine();
            }
        }
    }
}
