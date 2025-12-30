using System.Web.Http;
using WebActivatorEx;
using DoctorSkin;
using Swashbuckle.Application;

[assembly: PreApplicationStartMethod(typeof(SwaggerConfig), "Register")]

namespace DoctorSkin
{
    public class SwaggerConfig
    {
        public static void Register()
        {
            var thisAssembly = typeof(SwaggerConfig).Assembly;

            GlobalConfiguration.Configuration
                .EnableSwagger(c => c.SingleApiVersion("v1","ASP.NET API"))
                .EnableSwaggerUi();
        }
    }
}
