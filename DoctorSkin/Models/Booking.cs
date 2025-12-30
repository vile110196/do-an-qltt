using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Booking
    {

        [Key]
        public int stt { set; get; }

        [Required]
        public string name { set; get; }

        [Required]
        [StringLength(10, MinimumLength = 10)]
        public string phone { set; get; }

        [Required]
        [RegularExpression(@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}")]
        public string email { set; get; }
        public string require { set; get; }

        public Nullable<System.DateTime> timebooking { set; get; }

        public Boolean completed { set; get; }
    }
}