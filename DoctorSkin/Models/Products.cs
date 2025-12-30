using System;
using System.CodeDom;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Products
    {
        [Key]
        public int idp { set; get; }
        public String namep { set; get; }
        public int? typep { set; get; }
        public string newprice { set; get; }
        public string oldprice { set; get; }
        public string descr { set; get; }
        public Nullable<System.DateTime> date_up { get; set; }
        public Boolean hide { set; get; }
        public string statep { set; get; }
        public string img { set; get; }
        //public String nameshort { set; get; }
        public int idbrand { set; get; }
        public string metap { set; get; }
        public string avilability { set; get; }

        public string rated { set; get; }

        public string listimg { set; get; }

    }
}