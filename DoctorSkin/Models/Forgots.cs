using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Forgots
    {
        [Key]
        public int stt { set; get; }
        public string email { set; get; }
        public string token { set; get; }
        public string createAt { set; get; }
    }
}