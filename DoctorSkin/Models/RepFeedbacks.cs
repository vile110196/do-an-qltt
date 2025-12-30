using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class RepFeedbacks
    {
        [Key]
        public int sttrep { set; get; }
        public int sttfb { set; get; }
        public String iduser { set; get; }
        public String cmt_rep { set; get; }
        public Nullable<System.DateTime> date_rep { set; get; }
        public bool hide_rep { set; get; }
        public String from_rep { set; get; }
    }
}