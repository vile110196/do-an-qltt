using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class ListViewModel
    {
        public List<BlogDetails> BlogDetailData { set; get; }
        public List<Products> ProductsData { set; get; }

        public List<Categories> CategoryData { set; get; }
    }
}