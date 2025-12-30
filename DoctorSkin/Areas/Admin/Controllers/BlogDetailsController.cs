using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Mvc;
using DoctorSkin.config;
using DoctorSkin.Models;

namespace DoctorSkin.Areas.Admin.Controllers
{
    [Authorize]
    [Authorize(Roles = "Admin")]
    public class BlogDetailsController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();
        SlugifyConfig slugify = new SlugifyConfig();
        public ActionResult Index()
        {
            return View(db.BlogDetails.ToList());
        }

        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            BlogDetails blogDetails = db.BlogDetails.Find(id);
            if (blogDetails == null)
            {
                return HttpNotFound();
            }
            return View(blogDetails);
        }

        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [ValidateInput(false)]
        public ActionResult Create([Bind(Include = "idb,idbt,title,shortcontent,date_up,cardimg,hideblog,contentblog,metablog")] BlogDetails blogDetails, HttpPostedFileBase cardimg)
        {
            try
            {
                var path = "";
                var filename = "";
                if (ModelState.IsValid)
                {
                    if (cardimg != null)
                    {
                        //filename = Guid.NewGuid().ToString() + img.FileName;
                        filename = DateTime.Now.ToString("dd-MM-yy-hh-mm-ss-") + cardimg.FileName;
                        path = Path.Combine(Server.MapPath("~/Content/upload/img"), filename);
                        cardimg.SaveAs(path);

                        UploadCloud uploadCloud = new UploadCloud();

                        blogDetails.cardimg = uploadCloud.uploadImage(cardimg);
                    }
                    else
                    {
                        blogDetails.cardimg = "https://media.istockphoto.com/id/1277506610/vector/tiny-dermatologist-examining-dry-face-skin.jpg?s=612x612&w=0&k=20&c=5lglsJPKwTXaJONri4Ev2-g0SZkbPF2dP04T3Q6cSV0=";
                    }


                    blogDetails.hideblog = false;
                    blogDetails.metablog = slugify.slugify(blogDetails.title);

                    DateTime currentDateTime = DateTime.Now;
                    blogDetails.date_up = DateTime.Parse(currentDateTime.ToString("yyyy-MM-dd HH:mm:ss"));

                    db.BlogDetails.Add(blogDetails);
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

            return View(blogDetails);
        }

        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            BlogDetails blogDetails = db.BlogDetails.Find(id);
            if (blogDetails == null)
            {
                return HttpNotFound();
            }
            return View(blogDetails);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [ValidateInput(false)]
        public ActionResult Edit([Bind(Include = "idb,idbt,title,shortcontent,date_up,cardimg,hideblog,contentblog,metablog")] BlogDetails blogDetails, HttpPostedFileBase cardimg)
        {
            var path = "";
            var filename = "";
            var existingBlogDetails = db.BlogDetails.FirstOrDefault(s=>s.idb == blogDetails.idb);

            if (existingBlogDetails != null)
            {
                if (cardimg != null)
                {
                    filename = DateTime.Now.ToString("dd-MM-yy-hh-mm-ss-") + cardimg.FileName;
                    path = Path.Combine(Server.MapPath("~/Content/upload/img"), filename);
                    cardimg.SaveAs(path);

                    UploadCloud uploadCloud = new UploadCloud();

                    existingBlogDetails.cardimg = uploadCloud.uploadImage(cardimg);
                }


                // Cập nhật trường title
                existingBlogDetails.metablog = slugify.slugify(blogDetails.title);
                existingBlogDetails.title = blogDetails.title;
                existingBlogDetails.shortcontent = blogDetails.shortcontent;
                existingBlogDetails.hideblog = blogDetails.hideblog;
                existingBlogDetails.idbt = blogDetails.idbt;
                existingBlogDetails.contentblog = blogDetails.contentblog;

                db.Entry(existingBlogDetails).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(blogDetails);
        }


        [HttpDelete]
        public ActionResult delete(int idb)
        {
            var blog = db.BlogDetails.FirstOrDefault(s => s.idb == idb);
            if (blog != null)
            {
                db.BlogDetails.Remove(blog);
                db.SaveChanges();
                return Json(new { code = 0, message = "Thành công" });
            }
            else
                return Json(new { code = 1, message = "Failed" });
        }

        [HttpPut]
        public ActionResult hideBlog(int idb, bool hideblog)
        {
            var blog = db.BlogDetails.FirstOrDefault(s => s.idb == idb);
            if (blog != null)
            {
                blog.hideblog = hideblog;

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
