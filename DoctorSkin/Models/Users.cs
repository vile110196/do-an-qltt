using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
    public class Users
    {
        [Key]
        public String iduser { set; get; }

        [Required]
        [StringLength(50, MinimumLength = 3)]
        public String name { set; get; }

        [Required]
        public Nullable<System.DateTime> birth { set; get; }

        [Required]
        public String gender { set; get; }

        [Required]
        [StringLength(10, MinimumLength = 10)]
        public String phone { set; get; }

        [Required]
        [RegularExpression(@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}")]
        public string email { set; get; }

        //[RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,15}$")]
        public string password { get; set; }

        [NotMapped] //không ánh xạ vào data
        [Compare("password", ErrorMessage = "Mật khẩu không khớp.")]
        public string ConfirmPassword { get; set; }

        public bool hide { set; get; }

        [Required]
        public string ava { set; get; }

        public int total { set; get; }

        public int point { set; get; }

        public Nullable<System.DateTime> dateregist { set; get; }


    }
}