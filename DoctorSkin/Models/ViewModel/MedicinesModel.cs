using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models.ViewModel
{
    public class MedicinesModel
    {
        [Key]
        public int stt { set; get; }

        public int id { set; get; }
        public int type { set; get; }  //1: medicines, 2: products, 3: Dịch vụ
        public string name { set; get; }
        public string price { set; get; }


    }
}