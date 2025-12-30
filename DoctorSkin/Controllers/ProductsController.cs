using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using AutoMapper;
using DoctorSkin.Models;
using DoctorSkin.Models.ViewModel;
using PagedList;

namespace DoctorSkin.Controllers
{
    public class ProductsController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();

        public ActionResult Index(string meta)
        {
            ViewBag.meta = meta;
            ViewBag.title =  (from t in db.Categories where t.meta == meta select t.namec).FirstOrDefault();
            var v = from t in db.Categories where t.meta == meta select t;
            return View(v.FirstOrDefault());
        }

        public ActionResult getCat()
        {
            var v = from t in db.Categories where t.hide == false select t;
            return PartialView(v.ToList());
        }

        //// GET: Products/Details/5
        public ActionResult Details(int? idp)
        {
            if (idp == null)
           {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
           }
            //Models.Products products = db.Products.Find(id);
            var pr = from a in db.Products where a.hide == false && a.idp==idp select a;
            ViewBag.countfb = db.Feedbacks.Count();
            if (pr == null)
            {
                return HttpNotFound();
            }
            return View(pr.FirstOrDefault());
        }

        public ActionResult getAllProduct()
        { 
            return View();
        }

        [HttpGet]
        public ActionResult getAllProductView(string sortOrder, int? page)
        {
            var v = (from t in db.Products where t.hide == false select t).ToList();
            switch (sortOrder)
            {
                case "new":
                    v = v.OrderByDescending(p => p.date_up).ToList();
                    break;
                case "price_desc":
                    v = v.OrderByDescending(p => p.newprice).ToList();
                    break;
                default:
                    v = v.OrderBy(p => p.newprice).ToList();
                    break;
            }
            int pageSize = 21;
            int pageNumber = (page ?? 1);
            return PartialView(v.ToPagedList(pageNumber, pageSize));
        }

        //Chia sản phẩn theo brand
        public ActionResult getProductsByBrand(string meta)
        {
            ViewBag.meta = meta;
            ViewBag.title = (from t in db.Brands where t.meta == meta select t.meta).FirstOrDefault();
            var v = from t in db.Brands where t.meta == meta select t;
            return View(v.FirstOrDefault());
        }
    }
}
