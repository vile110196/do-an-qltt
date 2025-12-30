using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Patients
    {
        [Key]
        public int stt { set; get; }
        public string name { set; get; }
        public string gender { set; get; }
        public int age { set; get; }
        public string phone { set; get; }
        public string diagnose { set; get; }
        public string prescription { set; get; }
        public string pay { set; get; }
        public Nullable<System.DateTime> date { set; get; }
        public string doctor { set; get; }
        public Nullable<System.DateTime> date_re { set; get; }

    }
}