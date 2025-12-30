using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class ServicesDetails
    {
        [Key]
        public int id_sd { set; get; }
        public String name_sd { set; get; }
        public String img_sd { set; get; }
        public bool hide_sd { set; get; }
        public String price_sd { set; get; }
        public int id_dt { set; get; }

        public int amount { set; get; }
    }
}