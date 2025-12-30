using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Banners
    {
        [Key]
        public int stt { set; get; }
        public string link { set; get; }
        public bool homepage { set; get; }
        public bool servicepage { set; get; }
        public bool blogpage { set; get; }
        public bool productpage { set; get; }

    }
}