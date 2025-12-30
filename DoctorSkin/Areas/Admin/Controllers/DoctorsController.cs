using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DoctorSkin.Models;
using DoctorSkin.Models.ViewModel;

namespace DoctorSkin.Areas.Admin.Controllers
{
    [Authorize]
    [Authorize(Roles = "Doctor")]
    public class DoctorsController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();
        DateTime currentTime = DateTime.Now;

        public ActionResult Index()
        {
            return View();
        }

        // GET: Admin/Doctors/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Doctors doctors = db.Doctors.Find(id);
            if (doctors == null)
            {
                return HttpNotFound();
            }
            return View(doctors);
        }

        public ActionResult Create()
        {
            return View();
        }


        [HttpPost]
        public ActionResult prescription(Patients patients)
        {
            if (ModelState.IsValid)
            {
                patients.date =  DateTime.Parse(currentTime.ToString("yyyy-MM-dd HH:mm:ss"));
                patients.doctor = (string)Session["iduser"];
                db.Patients.Add(patients);
                db.SaveChanges();

                int stt = patients.stt;
                List<dynamic> itemList = Newtonsoft.Json.JsonConvert.DeserializeObject<List<dynamic>>(patients.prescription);
                foreach(var i in itemList)
                {
                    if(i.type == 2)
                    {
                        Bills newBill = new Bills();
                        newBill.idbill = stt + "[patients]";
                        newBill.idp = i.id;
                        newBill.quantity = i.soluong;
                        newBill.totalmoney = i.total;
                        newBill.datebuy = patients.date;
                        newBill.datesuccess = patients.date;
                        newBill.totalbill = patients.pay;
                        newBill.status = "Thành công";
                        newBill.exception = "Tạo bởi bác sĩ";

                        db.Bills.Add(newBill);
                    }    

                    if(i.type == 3)
                    {
                        int idValue = int.Parse(i.id);
                        var service = db.ServicesDetails.FirstOrDefault(s => s.id_sd == idValue);
                        service.amount = service.amount + 1;
                        db.SaveChanges();
                    }    
                }
                db.SaveChanges();
                return Json(new { code = 0, message = "Lưu thông tin thành công" });
            }

            // Create a JSON object to store the errors
            var errors = ModelState.Keys
                .SelectMany(key => ModelState[key].Errors.Select(error => new { Field = key, Message = error.ErrorMessage }))
                .ToList();

            // Return the errors as JSON
            return Json(new { code =1, Errors = errors });
        }

        public ActionResult reExamination(string phone)
        {
            var patient = db.Patients.Where(s => s.phone == phone).OrderByDescending(s=>s.date).ToList();
            return View(patient);
        }


        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Doctors doctors = db.Doctors.Find(id);
            if (doctors == null)
            {
                return HttpNotFound();
            }
            return View(doctors);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "iddoc,namedoc,infordoc,ava_doc,hide_doc,date_up_doc")] Doctors doctors)
        {
            if (ModelState.IsValid)
            {
                db.Entry(doctors).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(doctors);
        }

        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Doctors doctors = db.Doctors.Find(id);
            if (doctors == null)
            {
                return HttpNotFound();
            }
            return View(doctors);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Doctors doctors = db.Doctors.Find(id);
            db.Doctors.Remove(doctors);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        public ActionResult listMedicine()
        {
            var products = db.Products.ToList();
            var medicines = db.Medicines.ToList();
            var services = db.ServicesDetails.ToList();

            var productList = products.Select((p, index) => new MedicinesModel
            {
                stt = index + 1,
                id = p.idp,
                type = 2,
                name = p.namep,
                price = p.newprice
            }).ToList();

            var medicineList = medicines.Select((m, index) => new MedicinesModel
            {
                stt = index + 1,
                id = m.id,
                type = 1,
                name = m.name,
                price = m.price
            }).ToList();

            var servicesList = services.Select((m, index) => new MedicinesModel
            {
                stt = index + 1,
                id = m.id_sd,
                type = 3,
                name = m.name_sd,
                price = m.price_sd
            }).ToList();

            var list = productList.Concat(medicineList).Concat(servicesList).ToList();

            return PartialView(list);
        }



    }
}
