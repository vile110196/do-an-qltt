using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Medicines
    {
        [Key]
        public int id { set; get; }
        public string name { set; get; }
        public string price { set; get; }
        public string uses { set; get; }
        public bool hide { set; get; }
    }
}