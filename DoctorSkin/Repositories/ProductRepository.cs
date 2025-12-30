using DoctorSkin.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace DoctorSkin.Repositories
{
    public class ProductRepository
    {
        private readonly DoctorSkinEntities db = new DoctorSkinEntities();

        public async Task<List<Products>> GetAllProductAsync()
        {
            var productsAll = await db.Products.AsQueryable().AsNoTracking().ToListAsync();
            return productsAll;
        }
    }
}