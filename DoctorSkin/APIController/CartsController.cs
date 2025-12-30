using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using System.Web.ModelBinding;
using System.Windows.Forms;
using DoctorSkin.Models;

namespace DoctorSkin.APIController
{
    public class CartsController : ApiController
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();

        // GET: api/Carts
        public IQueryable<Carts> GetCarts()
        {
            return db.Carts;
        }

        // GET: api/Carts/5
        [ResponseType(typeof(Carts))]
        [Route("api/getCart/{iduser}")]
        public IHttpActionResult GetCarts(String iduser)
        {
            var carts = (from a in db.Carts
                         join b in db.Products on a.idp equals b.idp
                         join c in db.Brands on b.idbrand equals c.idbrand
                         where a.iduser.Equals(iduser) && b.hide == false
                         select new
                         {
                             iduser = a.iduser,
                             idp = a.idp,
                             quanlity = a.quanlity,
                             namep = b.namep,
                             imgp = b.img,
                             pricep = b.newprice,
                             brandp = c.namebrand
                         }).ToList();
            if (carts == null)
            {
                return NotFound();
            }

            return Ok(carts);
        }

        // PUT: api/Carts/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutCarts(int id, Carts carts)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != carts.stt)
            {
                return BadRequest();
            }

            db.Entry(carts).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CartsExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/Carts
        [ResponseType(typeof(Carts))]
        public IHttpActionResult PostCarts(Carts carts)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            Carts check = db.Carts.Where(i => i.idp == carts.idp && i.iduser.Equals(carts.iduser)).FirstOrDefault();
            if(check==null)
            {
                db.Carts.Add(carts);
            }    
            else
            {
                check.quanlity = check.quanlity + 1;
            }    
            db.SaveChanges();

            return CreatedAtRoute("DefaultApi", new { id = carts.stt }, carts);
        }

        // DELETE: api/Carts/5
        [ResponseType(typeof(Carts))]
        public IHttpActionResult DeleteCarts(int idp, string iduser)
        {
            
            Carts carts = db.Carts.Where(i=>i.iduser.Equals(iduser) && i.idp==idp).FirstOrDefault();
            if (carts == null)
            {
                return NotFound();
            }

            db.Carts.Remove(carts);
            db.SaveChanges();

            return Ok(carts);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool CartsExists(int id)
        {
            return db.Carts.Count(e => e.stt == id) > 0;
        }
    }
}