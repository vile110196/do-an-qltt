using CloudinaryDotNet.Actions;
using CloudinaryDotNet;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace DoctorSkin.config
{
    public class UploadCloud
    {
        public string uploadImage(HttpPostedFileBase file)
        {
            ImageUploadResult uploadResult = null;
            string linkimg = "";

            var cloudinary = new Cloudinary(new Account("dnqk5fjla", "149557243487116", "n9moDShH0IrWNmotU4l5EWdhSuI"));

            using (var reader = new BinaryReader(file.InputStream))
            {
                var fileBytes = reader.ReadBytes(file.ContentLength);
                var uploadParams = new ImageUploadParams()
                {
                    File = new FileDescription(file.FileName, new MemoryStream(fileBytes)),
                    PublicId = Guid.NewGuid().ToString(), // Tên public id để lưu hình ảnh trên Cloudinary
                    Folder = "DoctorSkin"
                };
                uploadResult = cloudinary.Upload(uploadParams);
            }

            linkimg = uploadResult?.SecureUri.ToString();
            return linkimg;
        }
    }
}