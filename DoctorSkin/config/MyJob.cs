using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Configuration;
using Quartz.Impl;
using System.Data.Entity;
using DoctorSkin.Models;
using Quartz;
using System.Threading.Tasks;

namespace DoctorSkin.config
{
    public class MyJob
    {
        public string createAt()
        {
            DateTime now = DateTime.UtcNow;
            long secondsSinceEpoch = (long)(now - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalSeconds;

            string finalString = secondsSinceEpoch.ToString();
            return finalString;
        }

        public void DeleteOldData()
        {
            int now = int.Parse(createAt());
            using (var db = new DoctorSkinEntities())
            {
                var dataToDelete = db.Forgots.ToList()
                    .Where(x =>
                    {
                        int createAt;
                        return int.TryParse(x.createAt, out createAt) && now - createAt < 3;
                    })
                    .ToList();
                db.Forgots.RemoveRange(dataToDelete);
                db.SaveChanges();
            }
        }
    }

}