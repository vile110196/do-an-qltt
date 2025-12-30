using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace DoctorSkin.Models
{
    public class BlogDetails
    {
        [Key]
        public int idb { set; get; }
        public int idbt { set; get; }
        public String title { set; get; }
        public String shortcontent { set; get; }
        public Nullable<System.DateTime> date_up { set; get; }
        public String cardimg { set; get; }

        public bool hideblog { set; get; }

        public string contentblog { set; get; }

        public string metablog { set; get; }
    }
}