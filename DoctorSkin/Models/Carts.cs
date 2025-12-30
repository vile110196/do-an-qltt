using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Carts
    {
        [Key]
        public int stt { set; get; }
        public String iduser { set; get; }
        public int idp { set; get; }
        public int quanlity { set; get; }

    }
}