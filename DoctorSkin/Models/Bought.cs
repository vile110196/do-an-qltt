using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Bought
    {
        public int sttbought { set; get; }
        public int sttbill { set; get; }
        public String iduser { set; get; }
        public Nullable<System.DateTime> datebuy { set; get; }
        public String status { set; get; }
        public Nullable<System.DateTime> datestatus { set; get; }
        public String yesfb { set; get; }
    }
}