using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Brands
    {
        [Key]
        public int idbrand { set; get; }
        public String namebrand { set; get; }
        public bool hidebrand { set; get; }

        public string meta { set; get; }
    }
}