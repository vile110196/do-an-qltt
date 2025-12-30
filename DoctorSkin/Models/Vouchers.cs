using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoctorSkin.Models
{
	public class Vouchers
	{
		[Key]
		public int stt { set; get; }
		public string idvoucher { set; get; }
		public string namevc { set; get; }
		public string valuevc { set; get; }
		public int quantity { set; get; }
		public int dasudung { set; get; }
		public string datefrom { set; get; }
		public string dateto { set; get; }
		public bool hidevc { set; get; }

    }
}