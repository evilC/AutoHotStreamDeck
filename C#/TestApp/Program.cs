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

            var switchHOn = wrapper.CreateImageFromFileName($@"{Directory.GetCurrentDirectory()}\..\..\..\..\SwitchHOn.png");
            var switchHOff = wrapper.CreateImageFromFileName($@"{Directory.GetCurrentDirectory()}\..\..\..\..\SwitchHOff.png");

            var keyOne = wrapper.CreateKeyCanvas(0);
            keyOne.AddImage("Off", switchHOff, 36);
            keyOne.AddImage("On", switchHOn, 36);
                
            keyOne.SetImageVisible("On", false);

            var mainText = keyOne.CreateTextBlock("MainText One").SetHeight(36);
            keyOne.AddTextBlock("Main", mainText);

            var subText = keyOne.CreateTextBlock("Subtext One").SetHeight(36).SetTop(36);
            keyOne.AddTextBlock("Sub", subText);

            keyOne.Update();

            Console.ReadLine();
            keyOne.SetImageVisible("Off", false);
            keyOne.SetImageVisible("On", true);
            mainText.SetText("MainText Two");
            subText.SetText("SubText Two");

            keyOne.Update();

            Console.ReadLine();
        }
    }
}
