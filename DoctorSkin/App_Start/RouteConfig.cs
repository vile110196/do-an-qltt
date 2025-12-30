using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Routing;

namespace DoctorSkin
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(name:"Products", url:"{type}/{meta}",
                new {Controller = "Products",action="Index",meta = UrlParameter.Optional},
                new RouteValueDictionary
                {
                    {"type","san-pham" }
                },
                namespaces: new[] { "DoctorSkin.Controllers"});

            routes.MapRoute(name: "AllProducts", url: "{type}",
                new { Controller = "Products", action = "getAllProduct" },
                new RouteValueDictionary
                {
                    {"type","tat-ca-san-pham" }
                },
                namespaces: new[] { "DoctorSkin.Controllers" });

            routes.MapRoute("BlogByType", "{type}/{meta}",
                new { Controller = "BlogByType", action = "Index", meta = UrlParameter.Optional },
                new RouteValueDictionary
                {
                    {"type","blog" }
                },
                namespaces: new[] { "DoctorSkin.Controllers" });

            routes.MapRoute("BlogDetails", "{type}/{metablog}",
                new { Controller = "Blog", action = "blogDetail", metablog = UrlParameter.Optional },
                 new RouteValueDictionary
                {
                    {"type","bai-viet" }
                },
                namespaces: new[] { "DoctorSkin.Controllers" });

            routes.MapRoute("Doctors", "{type}",
                new { Controller = "Doctors", action = "Index"},
                new RouteValueDictionary
                {
                    {"type","doi-ngu-bac-si" }
                },
                namespaces: new[] { "DoctorSkin.Controllers" });

            routes.MapRoute("Blog", "{type}",
                new { Controller = "Blog", action = "Index"},
                new RouteValueDictionary
                {
                    {"type","kien-thuc" }
                },
                namespaces: new[] { "DoctorSkin.Controllers" });

            routes.MapRoute("ServicesDetails", "{type}/{meta}",
                new { Controller = "ServicesDetails", action = "Index", meta = UrlParameter.Optional },
                new RouteValueDictionary
                {
                    {"type","dich-vu" }
                },
                namespaces: new[] { "DoctorSkin.Controllers" });

            routes.MapRoute(
                 name: "Product Detail",
                 url: "{type}/{metap}/{idp}",
                 new { controller = "Products", action = "Details", idp = UrlParameter.Optional },
                 new RouteValueDictionary
                 {
                     { "type","san-pham" }
                 },
                 namespaces: new[] { "DoctorSkin.Controllers" }
             );

            //Đăng nhập & đăng ký
            routes.MapRoute(
                 name: "Login",
                 url: "{type}",
                 new { controller = "Users", action = "Create", idp = UrlParameter.Optional },
                 new RouteValueDictionary
                 {
                     { "type","dang-nhap" }
                 },
                 namespaces: new[] { "DoctorSkin.Controllers" }
             );

            //ĐƠN HÀNG
            routes.MapRoute(
                 name: "Purchase",
                 url: "{type}",
                 new { controller = "Users", action = "Purchase", idp = UrlParameter.Optional },
                 new RouteValueDictionary
                 {
                     { "type","don-hang" }
                 },
                 namespaces: new[] { "DoctorSkin.Controllers" }
             );

            //VOUCHER
            routes.MapRoute(
                 name: "Vouchers",
                 url: "{type}",
                 new { controller = "Vouchers", action = "Index", idp = UrlParameter.Optional },
                 new RouteValueDictionary
                 {
                     { "type","uu-dai" }
                 },
                 namespaces: new[] { "DoctorSkin.Controllers" }
             );

            
            routes.MapRoute("Carts", "{type}",
                new { Controller = "Carts", action = "Index"},
                new RouteValueDictionary
                {
                    {"type","cart" }
                },
                namespaces: new[] { "DoctorSkin.Controllers" });

            routes.MapRoute("ProductsByBrand", "{type}/{meta}",
                new { Controller = "Products", action = "getProductsByBrand", meta = UrlParameter.Optional },
                new RouteValueDictionary
                {
                    {"type","thuong-hieu" }
                },
                namespaces: new[] { "DoctorSkin.Controllers" });

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional },
                namespaces: new[] { "DoctorSkin.Controllers" }
            );
        }

    }
}
