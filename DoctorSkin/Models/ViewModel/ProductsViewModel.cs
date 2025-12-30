using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Security.RightsManagement;
using System.Web;

namespace DoctorSkin.Models.ViewModel
{
    [Serializable]
    public class ProductsViewModel
    {
        [Key]
        public int idp { set; get; }
        public String namep { set; get; }
                         public String newprice { set; get; }
                         public String oldprice { set; get; }
public int typep{ set; get; }
public String descr { set; get; }
public String statep { set; get; }
public String img { set; get; }
public String cmt { set; get; }
public String nameu { set; get; }
public String  avau { set; get; }
public Nullable<System.DateTime> datefb { set; get; }
    }
}