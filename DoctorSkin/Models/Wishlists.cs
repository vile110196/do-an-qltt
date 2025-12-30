using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Wishlists
    {
        [Key]
        public int stt_wl { set; get; }
        public String iduser { set; get; }
        public int idp { set; get; }
    }
}