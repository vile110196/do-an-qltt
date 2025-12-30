using DoctorSkin.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace DoctorSkin.Dao
{
    public class DbHelper : DbContext
    {
        public DbHelper() : base("name=myDatabase")
        {
            Database.SetInitializer<DbHelper>(new CreateDatabaseIfNotExists<DbHelper>());
        }
        public DbSet<Products> Products { set; get; }
        public DbSet<BlogDetails> BlogDetail { set; get; }
        public DbSet<Categories> Category { set; get; }
    }
}