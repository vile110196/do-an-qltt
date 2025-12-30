using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace DoctorSkin.config
{
    public class GetImages
    {
        public List<string> listImageForProducts(string input)
        {
            string pattern = @"<img[^>]*src=""([^""]*)""[^>]*>";

            var srcList = new List<string>();

            MatchCollection matches = Regex.Matches(input, pattern);

            int count = 0;
            foreach(Match match in matches)
            {
                string srcValue = match.Groups[1].Value;
                srcList.Add(srcValue);
                count++;
                if (count == 3)
                    break;
            }

            return srcList;
        }
    }
}