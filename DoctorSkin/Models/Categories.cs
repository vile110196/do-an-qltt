using System;
using System.CodeDom;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Categories
    {
        [Key]
        public int typep { set; get; }
        public String namec { set; get; }
        public Boolean hide { set; get; }
        public Nullable<System.DateTime> date_up { set; get; }
        public String meta { set; get; }
    }
}