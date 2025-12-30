//using System;
//using System.Collections.Generic;
//using System.Data;
//using System.Data.Entity;
//using System.IO;
//using System.Linq;
//using System.Net;
//using System.Web;
//using System.Web.Mvc;
//using CloudinaryDotNet.Actions;
//using CloudinaryDotNet;
//using DoctorSkin.Models;
//using System.Text;

//namespace DoctorSkin.Controllers
//{
//    public class FeedbacksController : Controller
//    {
//        private DoctorSkinEntities db = new DoctorSkinEntities();

//        [HttpPost]
//        public ActionResult add(Feedbacks fb)
//        {
//            DateTime currentDateTime = DateTime.Now;
//            List<string> imageUrls = new List<string>();


//            var checkBill = db.Bills.FirstOrDefault(s => s.idbill == fb.idbill && s.idp == fb.idp && s.iduser == fb.iduser);

//            if (checkBill == null)
//                return Json(new { code = 1, message = "Kiểm tra lại thông tin" });

//            var cloudinary = new Cloudinary(new Account("dnqk5fjla", "149557243487116", "n9moDShH0IrWNmotU4l5EWdhSuI"));

//            if (fb.images.Count >= 0)
//            {
//                foreach (var i in fb.images)
//                {
//                    //Mã hóa base64
//                    byte[] originalBytes = Encoding.UTF8.GetBytes(i);
//                    string encodedString = Convert.ToBase64String(originalBytes);

//                    //upload base64
//                    byte[] imageBytes = Convert.FromBase64String(encodedString);
//                    var uploadParams = new ImageUploadParams()
//                    {
//                        File = new FileDescription("feedback_" + fb.idbill + "_" + fb.idp.ToString(), new MemoryStream(imageBytes)),
//                        PublicId = Guid.NewGuid().ToString(),
//                        Folder = "DoctorSkin",
//                        Overwrite = true
//                    };

//                    // Upload the image
//                    var uploadResult = cloudinary.Upload(uploadParams);

//                    // Get the public URL of the uploaded image
//                    string imageUrl = uploadResult.SecureUri.ToString();
//                    imageUrls.Add(imageUrl);
//                }
//            }
//            fb.datefb = DateTime.Parse(currentDateTime.ToString("yyyy-MM-dd HH:mm:ss"));
//            fb.hidefb = false;
//            fb.imagefb = String.Join(",", imageUrls);

//            db.Configuration.ValidateOnSaveEnabled = false;

//            //Thêm vào data
//            db.Feedbacks.Add(fb);

//            //Cập nhật yesfb
//            var bill = db.Bills.FirstOrDefault(s => s.idbill == fb.idbill && s.idp == fb.idp && s.iduser == fb.iduser);
//            bill.yesfb = true;

//            db.SaveChanges();

//            return Json(new { code = 0, message = "Đánh giá sản phẩm thành công" });
//        }
//        protected override void Dispose(bool disposing)
//        {
//            if (disposing)
//            {
//                db.Dispose();
//            }
//            base.Dispose(disposing);
//        }
//    }
//}
