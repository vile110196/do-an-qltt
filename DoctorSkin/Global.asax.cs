using DoctorSkin.config;
using DoctorSkin.Controllers;
using DoctorSkin.Mappings;
using Microsoft.AspNet.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Timers;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using Microsoft.AspNet.SignalR;
using Owin;

namespace DoctorSkin
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        private static Timer timer;
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            timer = new Timer(30000); // Chạy mỗi 30 giây
            timer.Elapsed += new ElapsedEventHandler(OnTimer);
            timer.Start();
        }
        protected void Application_End()
        {
            // Dừng tác vụ định kỳ khi ứng dụng kết thúc
            timer.Stop();
            timer.Dispose();
        }

        private void OnTimer(object sender, ElapsedEventArgs e)
        {
            // Gọi phương thức xóa dữ liệu
            var dataCleanupService = new MyJob();
            dataCleanupService.DeleteOldData();
        }

        //protected void Application_Error()
        //{
        //    Exception exception = Server.GetLastError();
        //    Response.Clear();

        //    HttpException httpException = exception as HttpException;
        //    RouteData routeData = new RouteData();

        //    routeData.Values["controller"] = "Error";
        //    routeData.Values["action"] = "Index";

        //    if (httpException != null)
        //    {
        //        routeData.Values["statuscode"] = httpException.GetHttpCode();
        //    }
        //    else
        //    {
        //        routeData.Values["statuscode"] = 500;
        //    }

        //    Server.ClearError();

        //    Response.TrySkipIisCustomErrors = true;

        //    IController errorController = new ErrorController();
        //    errorController.Execute(new RequestContext(
        //        new HttpContextWrapper(Context), routeData));
        //}


    }
}
