using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Medias
    {
        [Key]
        public int idmedia { set; get; }
        public String hrefmedia { set; get; }
        public String imgmedia { set; get; }
        public bool hidemedia { set; get; }
    }
}