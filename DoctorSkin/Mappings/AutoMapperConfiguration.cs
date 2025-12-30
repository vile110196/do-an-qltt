using AutoMapper;
using DoctorSkin.Models;
using DoctorSkin.Models.ViewModel;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DoctorSkin.Mappings
{
    public class AutoMapperConfiguration:Profile
    {
        public AutoMapperConfiguration()
        {
            //CreateMap<Products, ProductsViewModel>();
        }
    }
}