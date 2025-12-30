using DoctorSkin.Models;
using DoctorSkin.Models.Role;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoctorSkin.Areas.Admin.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        DoctorSkinEntities db = new DoctorSkinEntities();

        [Authorize(Roles = "Admin")]
        public ActionResult Index()
        {
            DateTime today = DateTime.Now;

            //So sánh đơn hàng với ngày hôm qua
            DateTime oneDayAgo = today.AddDays(-1);

            //Lấy đơn hàng của ngày hôm nay
            //loại bỏ giờ phút giây
            var bills = db.Bills.Where(s => DbFunctions.TruncateTime(s.datebuy) == today.Date).GroupBy(s => s.idbill).ToList();
            ViewBag.bills = bills;

            //Lấy đơn hàng của ngày hôm qua
            var compareToday = false;
            var billYesterday = db.Bills.Where(s => DbFunctions.TruncateTime(s.datebuy) == oneDayAgo.Date).GroupBy(s => s.idbill).ToList();
            if (bills.Count > billYesterday.Count)
                compareToday = true;
            ViewBag.compareToday = compareToday;



            decimal revenue = 0;
            foreach (var group in db.Bills.GroupBy(bill => bill.idbill))
            {
                if (group.Any(bill => bill.status == "Thành công"))
                {
                    revenue += group.Sum(bill => decimal.Parse(bill.totalbill));
                }
            }
            ViewBag.revenue = revenue.ToString("C");

            //So sánh doanh thu với tháng trước
            var compareRevenueMonth = false;
            decimal revenueMonthAgo = 0;
            DateTime oneMonthAgo = today.AddMonths(-1);
            foreach (var group in db.Bills.Where(s => DbFunctions.DiffMonths(s.datebuy, today) == 1).GroupBy(bill => bill.idbill).ToList())
            {
                if (group.Any(bill => bill.status == "Thành công"))
                {
                    revenueMonthAgo += group.Sum(bill => decimal.Parse(bill.totalbill));
                }
            }

            if (revenue > revenueMonthAgo)
                compareRevenueMonth = true;
            ViewBag.compareRevenueMonth = compareRevenueMonth;

            //MỨC ĐỘ HÀI LÒNG
            //var starAve = db.Feedbacks.Average(s => s.star);
            //ViewBag.starAve = Math.Round(starAve, 1);

            //KHÁCH HÀNG MỚI KHOẢNG 2 THÁNG TRỞ LẠI
            var compareCunstomer = false;
            var twoMonthsAgo = today.AddMonths(-2);

            var newCustomer2Month = db.Users.Where(u => u.dateregist >= twoMonthsAgo && u.dateregist < today).ToList();
            ViewBag.newCustomer2Month = newCustomer2Month;

            var newCustomerMonthNow = db.Users.Where(s => DbFunctions.TruncateTime(s.dateregist) == today.Date).ToList();
            if (newCustomerMonthNow.Count > newCustomer2Month.Count)
                compareCunstomer = true;
            ViewBag.compareCunstomer = compareCunstomer;

            var billsAll = db.Bills.ToList();
            ViewBag.billsAll = billsAll;

            //Thống kê service
            var service = db.ServicesDetails.ToList();
            ViewBag.service = service;

            //Sản phẩm
            var products = db.Products.ToList();
            ViewBag.products = products;

            //Brand
            var categories = db.Categories.ToList();
            ViewBag.brands = categories;

           
            //Top Service
            var topServices = db.ServicesDetails.OrderByDescending(s => s.amount).Take(5).ToList();
            var topBillByProducts = db.Bills
                            .GroupBy(s => s.idp)
                            .Select(g => new { idp = g.Key, totalQuantity = g.Sum(s => s.quantity) })
                            .OrderByDescending(g => g.totalQuantity)
                            .Take(5)
                            .ToList();

            var topProductIds = topBillByProducts.Select(b => b.idp).ToList();

            var topProducts = db.Products
                .Where(p => topProductIds.Contains(p.idp))
                .ToList();

            ViewBag.topServices = topServices;
            ViewBag.topProducts = topProducts;

            //Câu hỏi
            var questions = db.Questions.ToList();
            var usersIds = db.Users.ToList().Select(s => s.iduser).ToList();
            var users = db.Users.Where(s => usersIds.Contains(s.iduser)).ToList();

            var listQuestions = questions.Select(question =>
            {
                var user = users.FirstOrDefault(s => s.iduser == question.iduser);
                dynamic dynamicObj = new
                {
                    q = question,
                    name = user?.name,
                    ava = user?.ava
                };
                return dynamicObj;
            }).ToList();

            ViewBag.listQuestions = listQuestions;

            return View();
        }
    }
}