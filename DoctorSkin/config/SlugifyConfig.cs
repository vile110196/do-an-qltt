using DoctorSkin.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

namespace DoctorSkin.config
{
    public class SlugifyConfig
    {
        public string slugify(string text)
        {
            string normalizedString = text.Normalize(NormalizationForm.FormD); //loại bỏ các dấu diacritic và chuyển đổi các ký tự có dấu thành ký tự không dấu 
            StringBuilder slugBuilder = new StringBuilder(); //Khởi tạo một đối tượng StringBuilder để xây dựng chuỗi slugify mới.

            foreach (char c in normalizedString)
            {
                UnicodeCategory unicodeCategory = CharUnicodeInfo.GetUnicodeCategory(c); //Xác định danh mục Unicode
                if (unicodeCategory != UnicodeCategory.NonSpacingMark)
                {
                    
                    if (Char.IsLetterOrDigit(c) || c == ' ')
                    {
                        slugBuilder.Append(c);
                    }
                    else if (c == '-')
                    {
                        slugBuilder.Append('-');
                    }
                }
            }

            //loại bỏ khoảng trắng thừa, chuyển đôi thành chữ thường
            string slug = slugBuilder.ToString().Trim().ToLowerInvariant();

            //Thay thế một hoặc nhiều khoảng trắng liên tiếp bằng dấu gạch ngang "-".
            slug = Regex.Replace(slug, @"\s+", "-");

            //Thay thế các dấu gạch ngang liên tiếp thừa bằng một dấu gạch ngang duy nhất.
            slug = Regex.Replace(slug, @"-+", "-");

            return slug;
        }
    }
}