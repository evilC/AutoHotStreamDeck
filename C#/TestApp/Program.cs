using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoHotStreamDeck;

namespace TestApp
{
    class Program
    {
        [STAThread]
        static void Main(string[] args)
        {
            var wrapper = new Wrapper();

            var deck = wrapper.GetDeck(1);

            var switchHOn = wrapper.CreateImageFromFileName($@"{Directory.GetCurrentDirectory()}\..\..\..\..\SwitchHOn.png");
            var switchHOff = wrapper.CreateImageFromFileName($@"{Directory.GetCurrentDirectory()}\..\..\..\..\SwitchHOff.png");

            var keyOne = deck.CreateKeyCanvas(new Action<int>((value) =>
            {
                Console.WriteLine("Subscription Value: " + value);
            }));

            keyOne.AddImage("Off", switchHOff, 36);
            keyOne.AddImage("On", switchHOn, 36);
                
            keyOne.SetImageVisible("On", false);

            var mainText = keyOne.CreateTextBlock("MainText One").SetHeight(36);
            keyOne.AddTextBlock("Main", mainText);

            var subText = keyOne.CreateTextBlock("Subtext One").SetHeight(36).SetTop(36);
            keyOne.AddTextBlock("Sub", subText);

            deck.SetKeyCanvas(1, keyOne);

            Console.ReadLine();
            keyOne.SetImageVisible("Off", false);
            keyOne.SetImageVisible("On", true);
            mainText.SetText("MainText Two");
            subText.SetText("SubText Two");

            deck.RefreshKey(1);

            Console.ReadLine();
        }
    }
}
