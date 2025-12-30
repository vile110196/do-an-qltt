using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DoctorSkin.config;
using DoctorSkin.Models;

namespace DoctorSkin.Areas.Admin.Controllers
{
    [Authorize]
    [Authorize(Roles = "Admin")]
    public class ProductsController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();
        SlugifyConfig slugify = new SlugifyConfig();
        GetImages getImages = new GetImages();
        DateTime currentDateTime = DateTime.Now;

        // GET: Admin/Products
        public ActionResult Index()
        {
            return View(db.Products.ToList());
        }

        // GET: Admin/Products/Details/5
        //public ActionResult Details(int? id)
        //{
        //    if (id == null)
        //    {
        //        return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
        //    }
        //    Products products = db.Products.Find(id);
        //    if (products == null)
        //    {
        //        return HttpNotFound();
        //    }
        //    return View(products);
        //}

        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [ValidateInput(false)]
        public ActionResult Create([Bind(Include = "idp,namep,typep,newprice,oldprice,descr,date_up,hide,statep,img,idbrand,metap,avilability,rated")] Products products, HttpPostedFileBase img)
        {
            try
            {
                var path = "";
                var filename = "";
                if (ModelState.IsValid)
                {
                    if (img != null)
                    {
                        //filename = Guid.NewGuid().ToString() + img.FileName;
                        filename = DateTime.Now.ToString("dd-MM-yy-hh-mm-ss-") + img.FileName;
                        path = Path.Combine(Server.MapPath("~/Content/upload/img"), filename);
                        img.SaveAs(path);

                        UploadCloud uploadCloud = new UploadCloud();

                        products.img = uploadCloud.uploadImage(img);
                    }
                    else
                    {
                        products.img = "https://media.istockphoto.com/id/1277506610/vector/tiny-dermatologist-examining-dry-face-skin.jpg?s=612x612&w=0&k=20&c=5lglsJPKwTXaJONri4Ev2-g0SZkbPF2dP04T3Q6cSV0=";
                    }

                    products.metap = slugify.slugify(products.namep);
                    products.date_up = DateTime.Parse(currentDateTime.ToString("yyyy-MM-dd HH:mm:ss"));
                    products.listimg = string.Join(",", getImages.listImageForProducts(products.descr)); //lấy ảnh đại diện
                    products.hide = false;
                    products.rated = "0";

                    db.Products.Add(products);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }
            catch (DbEntityValidationException e)
            {
                throw e;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return View(products);
        }


        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Products products = db.Products.Find(id);
            if (products == null)
            {
                return HttpNotFound();
            }
            return View(products);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [ValidateInput(false)]
        public ActionResult Edit([Bind(Include = "idp,namep,typep,newprice,oldprice,descr,date_up,hide,statep,img,idbrand,metap,avilability,rated")] Products products, HttpPostedFileBase img)
        {
            var path = "";
            var filename = "";
            var existingProducts = db.Products.FirstOrDefault(s => s.idp == products.idp);

            if (existingProducts != null)
            {
                if (img != null)
                {
                    filename = DateTime.Now.ToString("dd-MM-yy-hh-mm-ss-") + img.FileName;
                    path = Path.Combine(Server.MapPath("~/Content/upload/img"), filename);
                    img.SaveAs(path);

                    UploadCloud uploadCloud = new UploadCloud();

                    existingProducts.img = uploadCloud.uploadImage(img);
                }


                // Cập nhật trường title
                existingProducts.metap = slugify.slugify(products.namep);
                existingProducts.typep = products.typep;
                existingProducts.newprice = products.oldprice; //cập nhật giá mới
                existingProducts.newprice = products.newprice; //cập nhật giá mới
                existingProducts.hide = products.hide;
                existingProducts.statep = products.statep;
                existingProducts.idbrand = products.idbrand;
                existingProducts.avilability = products.avilability;
                existingProducts.descr = products.descr;
                existingProducts.listimg = string.Join(",", getImages.listImageForProducts(products.descr)); //lấy ảnh đại diện

                db.Entry(existingProducts).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(products);
        }

        [HttpPut]
        public ActionResult hideProduct(int idp)
        {
            var pr = db.Products.FirstOrDefault(s => s.idp == idp);
            if (pr != null)
            {
                pr.hide = true;
                //db.Products.Remove(pr);
                db.SaveChanges();
                return Json(new { code = 0, message = "Thành công" });
            }
            else
                return Json(new { code = 1, message = "Failed" });
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
