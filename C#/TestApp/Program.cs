using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoHotStreamDeck;

namespace TestApp
{
    class Program
    {
        static void Main(string[] args)
        {
            var wrapper = new Wrapper();

            var keyCount = wrapper.Deck.KeyCount;

            for (byte i = 0; i < keyCount; i++)
            {
                wrapper.SetKeyBitmap(i, wrapper.CreateBitmapFromColor((byte)(i * 15), 0, 0));
            }

            Console.ReadLine();
        }
    }
}
