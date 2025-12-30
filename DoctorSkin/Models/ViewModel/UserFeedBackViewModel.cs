using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models.ViewModel
{
    public class UserFeedBackViewModel
    {
        [Key]
        public int sttfb { set; get; }
        public string cmt { set; get; }
        public Nullable<System.DateTime> datefb { set; get; }
        public string nameu { set; get; }
        public string avau { set; get; }

        public int staru { set; get; }

        public string listImg { set; get; }
    }
}