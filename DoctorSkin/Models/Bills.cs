using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Bills
    {
        [Key]
        public int sttbill { set; get; }
        public int idp { set; get; }
        public int quantity { set; get; }
        public string totalbill { set; get; }
        public string totalmoney { set; get; }
        public string idbill { set; get; }
        public string iduser { set; get; }
        public string note { set; get; }
        public string status { set; get; }
        public bool yesfb { set; get; }
        public Nullable<System.DateTime> datebuy { set; get; }
            // Constructor
        public Bills()
        {
            yesfb = false;
        }

        public string idvoucher { set; get; }
        public string whycancel { set; get; }

        public Nullable<System.DateTime> datesuccess { set; get; }

        public string exception { set; get; }

        public string address { set; get; }
    }


}