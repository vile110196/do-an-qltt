using CloudinaryDotNet.Actions;
using CloudinaryDotNet;
using DoctorSkin.Models;
using DoctorSkin.Models.Role;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;

namespace DoctorSkin.Areas.Admin.Controllers
{
    [Authorize]
    [Authorize(Roles = "Admin")]
    public class EmployeesController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();
        DateTime currentDateTime = DateTime.Now;
        // GET: Admin/Employee
        public ActionResult Index(string role)
        {
            switch (role)
            {
                case "Doctor":
                    ViewBag.title = "Bác sĩ";
                    var listEmailRoleDoctor = db.Roles.Where(r => r.rolename == "Doctor").Select(r => r.email);
                    var listDoctor = db.Users.Where(u => listEmailRoleDoctor.Contains(u.email));
                    return View(listDoctor);
                default:
                    ViewBag.title = "Nhân viên";
                    var listEmailRoleAdmin = db.Roles.Where(r => r.rolename == "Admin").Select(r => r.email);
                    var listEmployee = db.Users.Where(u => listEmailRoleAdmin.Contains(u.email));
                    return View(listEmployee);
            }
        }

        [HttpGet]
        public ActionResult getInfo(string iduser)
        {
            var user = db.Users.FirstOrDefault(s => s.iduser == iduser);
            if (user != null)
            {
                return Json(new { code = 0, data = user }, JsonRequestBehavior.AllowGet);
            }
            else
                return Json(new { code = 1, message = "Failed" }, JsonRequestBehavior.AllowGet);
        }


        [HttpPut]
        [ValidateInput(false)]
        public JsonResult disable(string iduser)
        {
            if (string.IsNullOrEmpty(iduser))
            {
                return Json(new { code = 1, message = "Invalid user ID" });
            }

            var user = db.Users.FirstOrDefault(s => s.iduser == iduser);
            if (user != null)
            {
                user.hide = true;

                db.Configuration.ValidateOnSaveEnabled = false;
                db.SaveChanges();
                return Json(new { code = 0, message = "Thành công" });
            }
            else
            {
                return Json(new { code = 1, message = "User not found" });
            }
        }

        public String randomID()
        {
            var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            var stringChars = new char[10];
            var random = new Random();

            for (int i = 0; i < stringChars.Length; i++)
            {
                stringChars[i] = chars[random.Next(chars.Length)];
            }

            var finalString = new String(stringChars);
            return finalString;
        }

        [HttpPost]
        public ActionResult Create(Users users, HttpPostedFileBase file, string role)
        {
            ImageUploadResult uploadResult = null;

            var check = db.Users.FirstOrDefault(s => s.email.Equals(users.email) || s.phone.Equals(users.phone));

            var cloudinary = new Cloudinary(new Account("dnqk5fjla", "149557243487116", "n9moDShH0IrWNmotU4l5EWdhSuI"));

            using (var reader = new BinaryReader(file.InputStream))
            {
                var fileBytes = reader.ReadBytes(file.ContentLength);
                var uploadParams = new ImageUploadParams()
                {
                    File = new FileDescription(file.FileName, new MemoryStream(fileBytes)),
                    PublicId = Guid.NewGuid().ToString(), // Tên public id để lưu hình ảnh trên Cloudinary
                    Folder = "DoctorSkin"
                };
                uploadResult = cloudinary.Upload(uploadParams);
            }

            if (check == null)
            {
                string salt = BCrypt.Net.BCrypt.GenerateSalt();
                string hash = BCrypt.Net.BCrypt.HashPassword(users.password, salt);

                db.Configuration.ValidateOnSaveEnabled = false;

                DateTime currentDateTime = DateTime.Now;

                users.dateregist = DateTime.Parse(currentDateTime.ToString("yyyy-MM-dd HH:mm:ss"));
                users.password = hash;
                users.ava = uploadResult?.SecureUri.ToString();
                users.iduser = randomID();
                users.point = 0;
                db.Users.Add(users);

                //Thêm vào bảng UserRoles
                var roleUser = new UserRoles();
                roleUser.email = users.email;
                roleUser.rolename = role;
                db.Roles.Add(roleUser);

                //Thêm vào bảng Mapping
                var roleMapping = new UserRolesMappings();
                roleMapping.email = users.email;
                roleMapping.idrole = role == "Admin" ? 1 : 3;
                db.UserRolesMappings.Add(roleMapping);


                db.SaveChanges();

                return Json(new { code = 0, message = "Đăng ký thành công" });
            }

            else
                return Json(new { code = 1, message = "Đăng ký không thành công, số điện thoại hoặc Email đã được đăng ký" });
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Edit(Users users, string role)
        {
            var user = db.Users.FirstOrDefault(s => s.iduser == users.iduser);
            if (user == null)
            {
                return RedirectToAction("Index");
            }

            user.name = users.name;
            user.hide = users.hide;
            user.email = users.email;
            user.gender = users.gender;
            user.phone = users.phone;
            user.birth = users.birth;

            //Thêm vào bảng UserRoles
            var roleUser = db.Roles.FirstOrDefault(s => s.email == users.email);
            roleUser.rolename = role;


            //Thêm vào bảng Mapping
            var roleMapping = db.UserRolesMappings.FirstOrDefault(s => s.email == users.email);
            roleMapping.idrole = role == "Admin" ? 1 : 3;


            db.Configuration.ValidateOnSaveEnabled = false;
            db.SaveChanges();
            return Json(new { code = 0, message = "Thành công" });
        }

    }
}