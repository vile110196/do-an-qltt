using System.Web.Mvc;
using System.Web.Routing;

namespace DoctorSkin.Areas.Admin
{
    public class AdminAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Admin";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                name: "Admin_ServicesDetails",
                url: "admin/{type}/{meta}",
                defaults: new { controller = "ServicesDetails", action = "Index", meta = UrlParameter.Optional },
                constraints: new { type = "dich-vu" },
                namespaces: new[] { "DoctorSkin.Areas.Admin.Controllers" }
            );

            context.MapRoute(
                name: "Admin_default",
                url: "admin/{controller}/{action}/{id}",
                new { controller = "Home", action = "Index", id = UrlParameter.Optional },
                namespaces: new[] { "DoctorSkin.Areas.Admin.Controllers" }
            );
        }
    }
}
