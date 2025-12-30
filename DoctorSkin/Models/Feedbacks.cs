using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Feedbacks
    {
        [Key]
        public int sttfb { set; get; }
        public string idbill { set; get; }
        public string cmt { set; get; }
        public Nullable<System.DateTime> datefb { set; get; }
        public bool hidefb { set; get; }
        public string iduser { set; get; }
        public int idp { set; get; }
        public int star { set; get; }

        public string imagefb { set; get; }
        //public List<string> ImageFb { get; set; }
        public List<string> images { get; set; }

    }
}