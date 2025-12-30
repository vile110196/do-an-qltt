using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Doctors
    {
        [Key]
        public int stt { set; get; }
        public String namedoc { set; get; }
        public String infordoc { set; get; }
        public String ava_doc { set; get; }
        public bool hide_doc { set; get; }
        public Nullable<System.DateTime> date_up_doc { set; get; }
        public string iddoc { set; get; }
    }
}