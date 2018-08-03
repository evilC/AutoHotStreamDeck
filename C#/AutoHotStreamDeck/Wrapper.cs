﻿using System;
using System.Collections.Concurrent;
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
        private readonly ConcurrentDictionary<int, dynamic> _callbacks = new ConcurrentDictionary<int, dynamic>();

        public Client Deck => _deck;

        public Wrapper()
        {
            _deck = new Client();
            _deck.Open();
            _deck.KeyPressed += KeyHandler;
        }

        public string OkCheck()
        {
            return "OK";
        }

        public void SubscribeKey(int key, dynamic callback)
        {
            _callbacks.TryAdd(key, callback);
        }

        public KeyBitmap CreateBitmapFromColor(byte r, byte g, byte b)
        {
            return KeyBitmap.FromRGBColor(r, g, b);
        }

        public KeyBitmap CreateBitmapFromFile(string fileName)
        {
            return KeyBitmap.FromFile(fileName);
        }

        public void SetKeyBitmap(byte key, KeyBitmap bitmap)
        {
            _deck.SetKeyBitmap(key, bitmap);
        }

        public void SetBrightness(byte brightness)
        {
            _deck.SetBrightness(brightness);
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
