using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models.Role
{
    public class RoleMasters
    {
        [Key]
        public int ID { set; get; }
        public string RollName { set; get; }
    }
}