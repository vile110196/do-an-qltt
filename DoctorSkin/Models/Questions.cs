using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Questions
    {
        [Key]
        public int stt { set; get; }
        public string iduser { set; get; }
        public string question { set; get; }
        public bool rep { set; get; }
        public Nullable<System.DateTime> datequestion { set; get; }
        public string repquestion { set; get; }
        public string iduserrep { set; get; }
    }
}