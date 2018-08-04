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

            var keyOne = wrapper.CreateKeyCanvas(0);
            keyOne.SetImageFromFileName($@"{Directory.GetCurrentDirectory()}\..\..\..\..\ArrowUp.png");

            var mainText = keyOne.CreateTextBlock("MainText One").SetHeight(36);
            keyOne.AddTextBlock("Main", mainText);

            var subText = keyOne.CreateTextBlock("Subtext One").SetHeight(36).SetTop(36);
            keyOne.AddTextBlock("Sub", subText).Update();

            keyOne.Update();

            Console.ReadLine();
            keyOne.SetImageFromFileName($@"{Directory.GetCurrentDirectory()}\..\..\..\..\ArrowDown.png");
            mainText.SetText("MainText Two");
            subText.SetText("SubText Two");

            keyOne.Update();

            Console.ReadLine();
        }
    }
}
