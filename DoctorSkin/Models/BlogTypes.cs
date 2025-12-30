using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class BlogTypes
    {
        [Key]
        public int idbt { set; get; }
        public String namebt { set; get; }
        public bool hide { set; get; }
        public String meta { set; get; }
    }
}