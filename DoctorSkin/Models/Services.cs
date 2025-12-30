using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Services
    {
        [Key]
        public int id_dt { set; get; }
        public String name_dt { set; get; }
        public String desc_dt { set; get; }
        public bool hide_dt { set; get; }
        public String img_dt { set; get; }
        public String meta { set; get; }
        public String slider_dt { set; get; }
    }
}