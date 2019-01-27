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
        //private List<IDeviceReferenceHandle> _connectedDevices;
        private List<IStreamDeckRefHandle> _connectedDevices;
        private readonly ConcurrentDictionary<int, DeckInstance> _deckInstances = new ConcurrentDictionary<int, DeckInstance>();

        public Wrapper()
        {
            RefreshConnectedDevices();
        }

        public string OkCheck()
        {
            return "OK";
        }

        public void RefreshConnectedDevices()
        {
            _connectedDevices = StreamDeck.EnumerateDevices().ToList();
        }

        public DeckInstance GetDeck(int index)
        {
            var id = index - 1;
            if (id < 0 || _connectedDevices.Count <= id) throw new Exception($"Could not find device {index}");

            if (_deckInstances.ContainsKey(id)) return _deckInstances[id];
            var dev = new DeckInstance(_connectedDevices[id]);
            _deckInstances[id] = dev;
            return dev;
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
    }
}
