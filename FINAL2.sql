
USE DOCTORSKIN2

/****** Object:  Table [dbo].[Wishlists] */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Wishlists]') AND type in (N'U'))
DROP TABLE [dbo].[Wishlists]
GO
/****** Object:  Table [dbo].[Vouchers]    */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vouchers]') AND type in (N'U'))
DROP TABLE [dbo].[Vouchers]
GO
/****** Object:  Table [dbo].[Users]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
DROP TABLE [dbo].[Users]
GO
/****** Object:  Table [dbo].[UserRolesMappings]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserRolesMappings]') AND type in (N'U'))
DROP TABLE [dbo].[UserRolesMappings]
GO
/****** Object:  Table [dbo].[UserRoles]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserRoles]') AND type in (N'U'))
DROP TABLE [dbo].[UserRoles]
GO
/****** Object:  Table [dbo].[ServicesDetails]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServicesDetails]') AND type in (N'U'))
DROP TABLE [dbo].[ServicesDetails]
GO
/****** Object:  Table [dbo].[Services]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Services]') AND type in (N'U'))
DROP TABLE [dbo].[Services]
GO
/****** Object:  Table [dbo].[RoleMasters]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RoleMasters]') AND type in (N'U'))
DROP TABLE [dbo].[RoleMasters]
GO
/****** Object:  Table [dbo].[RepFeedbacks]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RepFeedbacks]') AND type in (N'U'))
DROP TABLE [dbo].[RepFeedbacks]
GO
/****** Object:  Table [dbo].[Questions]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Questions]') AND type in (N'U'))
DROP TABLE [dbo].[Questions]
GO
/****** Object:  Table [dbo].[Products]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Products]') AND type in (N'U'))
DROP TABLE [dbo].[Products]
GO
/****** Object:  Table [dbo].[Patients]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Patients]') AND type in (N'U'))
DROP TABLE [dbo].[Patients]
GO
/****** Object:  Table [dbo].[Medicines]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Medicines]') AND type in (N'U'))
DROP TABLE [dbo].[Medicines]
GO
/****** Object:  Table [dbo].[Medias]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Medias]') AND type in (N'U'))
DROP TABLE [dbo].[Medias]
GO
/****** Object:  Table [dbo].[Forgots]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Forgots]') AND type in (N'U'))
DROP TABLE [dbo].[Forgots]
GO
/****** Object:  Table [dbo].[Feedbacks]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Feedbacks]') AND type in (N'U'))
DROP TABLE [dbo].[Feedbacks]
GO
/****** Object:  Table [dbo].[Doctors]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Doctors]') AND type in (N'U'))
DROP TABLE [dbo].[Doctors]
GO
/****** Object:  Table [dbo].[Categories]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categories]') AND type in (N'U'))
DROP TABLE [dbo].[Categories]
GO
/****** Object:  Table [dbo].[Carts]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Carts]') AND type in (N'U'))
DROP TABLE [dbo].[Carts]
GO
/****** Object:  Table [dbo].[Brands]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Brands]') AND type in (N'U'))
DROP TABLE [dbo].[Brands]
--GO
/****** Object:  Table [dbo].[Bought]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bought]') AND type in (N'U'))
DROP TABLE [dbo].[Bought]
GO
/****** Object:  Table [dbo].[Bookings]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bookings]') AND type in (N'U'))
DROP TABLE [dbo].[Bookings]
GO
/****** Object:  Table [dbo].[BlogTypes]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlogTypes]') AND type in (N'U'))
DROP TABLE [dbo].[BlogTypes]
GO
/****** Object:  Table [dbo].[BlogDetails]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlogDetails]') AND type in (N'U'))
DROP TABLE [dbo].[BlogDetails]
GO

/****** Object:  Table [dbo].[Bills]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bills]') AND type in (N'U'))
DROP TABLE [dbo].[Bills]
GO
/****** Object:  Table [dbo].[Banners]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Banners]') AND type in (N'U'))
DROP TABLE [dbo].[Banners]
GO
/****** Object:  Table [dbo].[Banners]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Banners](
	[stt] [int] IDENTITY(1,1) NOT NULL,
	[link] [nvarchar](max) NULL,
	[homepage] [bit] NULL,
	[servicepage] [bit] NULL,
	[blogpage] [bit] NULL,
	[productpage] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bills]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bills](
	[sttbill] [int] IDENTITY(1,1) NOT NULL,
	[idp] [int] NULL,
	[quantity] [int] NULL,
	[totalbill] [nvarchar](max) NULL,
	[totalmoney] [nvarchar](max) NULL,
	[idbill] [nvarchar](max) NULL,
	[iduser] [nvarchar](50) NOT NULL,
	[note] [nvarchar](max) NULL,
	[status] [nvarchar](max) NULL,
	[yesfb] [bit] NULL,
	[datebuy] [datetime] NULL,
	[idvoucher] [nvarchar](max) NULL,
	[whycancel] [nvarchar](max) NULL,
	[datesuccess] [datetime] NULL,
	[exception] [nvarchar](max) NULL,
	[address] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[BlogDetails]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlogDetails](
	[idbt] [int] NOT NULL,
	[title] [nvarchar](max) NOT NULL,
	[shortcontent] [nvarchar](max) NULL,
	[cardimg] [nvarchar](max) NULL,
	[hideblog] [bit] NULL,
	[idb] [int] IDENTITY(1,1) NOT NULL,
	[date_up] [datetime] NULL,
	[contentblog] [nvarchar](max) NULL,
	[metablog] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BlogTypes]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlogTypes](
	[idbt] [int] NOT NULL,
	[namebt] [nvarchar](max) NOT NULL,
	[hide] [bit] NOT NULL,
	[meta] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bookings]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bookings](
	[stt] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](max) NULL,
	[phone] [nvarchar](max) NULL,
	[email] [nvarchar](max) NULL,
	[require] [nvarchar](max) NULL,
	[timebooking] [datetime] NULL,
	[completed] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bought]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bought](
	[iduser] [nvarchar](max) NULL,
	[datebuy] [datetime] NULL,
	[status] [nvarchar](max) NULL,
	[datestatus] [datetime] NULL,
	[sttbill] [int] NULL,
	[sttbought] [int] IDENTITY(1,1) NOT NULL,
	[yesfb] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Brands]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brands](
	[idbrand] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[namebrand] [nvarchar](max) NULL,
	[hidebrand] [bit] NULL,
	[meta] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Carts]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Carts](
	[stt] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[iduser] [nvarchar](50) NULL,
	[idp] [int] NULL,
	[quanlity] [int] NULL
)
/****** Object:  Table [dbo].[Categories]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[typep] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[namec] [nvarchar](max) NULL,
	[hide] [bit] NULL,
	[meta] [nvarchar](max) NULL,
	[date_up] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doctors]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctors](
	[stt] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[namedoc] [nvarchar](max) NULL,
	[infordoc] [nvarchar](max) NULL,
	[ava_doc] [nvarchar](max) NULL,
	[hide_doc] [bit] NULL,
	[date_up_doc] [datetime] NULL,
	[iddoc] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feedbacks]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feedbacks](
	[sttfb] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[idbill] [nvarchar](max) NULL,
	[cmt] [nvarchar](max) NULL,
	[datefb] [datetime] NULL,
	[hidefb] [bit] NULL,
	[iduser] [nvarchar](50) NOT NULL,
	[idp] [int] NULL,
	[star] [int] NULL,
	[imagefb] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Forgots]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forgots](
	[stt] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[email] [nvarchar](max) NULL,
	[token] [nvarchar](max) NULL,
	[createAt] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Medias]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medias](
	[idmedia] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[hrefmedia] [nvarchar](max) NULL,
	[imgmedia] [nvarchar](max) NULL,
	[hidemedia] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Medicines]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medicines](
	[id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[name] [nvarchar](max) NULL,
	[price] [nvarchar](max) NULL,
	[uses] [nvarchar](max) NULL,
	[hide] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patients]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patients](
	[stt] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[name] [nvarchar](max) NULL,
	[gender] [nvarchar](max) NULL,
	[age] [int] NULL,
	[phone] [nvarchar](10) NULL,
	[diagnose] [nvarchar](max) NULL,
	[prescription] [nvarchar](max) NULL,
	[pay] [nvarchar](max) NULL,
	[date] [datetime] NULL,
	[doctor] [nvarchar](max) NULL,
	[date_re] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[idp] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[namep] [nvarchar](max) NULL,
	[typep] [int] NULL,
	[newprice] [nvarchar](max) NOT NULL,
	[oldprice] [nvarchar](max) NOT NULL,
	[descr] [nvarchar](max) NOT NULL,
	[hide] [bit] NOT NULL,
	[statep] [nvarchar](max) NOT NULL,
	[img] [nvarchar](max) NULL,
	[date_up] [datetime] NULL,
	[idbrand] [int] NULL,
	[metap] [nvarchar](max) NULL,
	[avilability] [nvarchar](max) NULL,
	[rated] [nvarchar](max) NULL,
	[listimg] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Questions]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questions](
	[stt] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[iduser] [nvarchar](max) NULL,
	[question] [nvarchar](max) NULL,
	[rep] [bit] NULL,
	[datequestion] [datetime] NULL,
	[repquestion] [nvarchar](max) NULL,
	[daterep] [nvarchar](max) NULL,
	[iduserrep] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RepFeedbacks]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RepFeedbacks](
	[sttrep] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[sttfb] [int] NULL,
	[iduser] [nvarchar](max) NULL,
	[cmt_rep] [nvarchar](max) NULL,
	[date_rep] [datetime] NULL,
	[hide_rep] [bit] NULL,
	[from_rep] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleMasters]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleMasters](
	[ID] [int] PRIMARY KEY NOT NULL,
	[RollName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Services]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Services](
	[name_dt] [nvarchar](max) NULL,
	[desc_dt] [nvarchar](max) NULL,
	[hide_dt] [bit] NULL,
	[img_dt] [nvarchar](max) NULL,
	[id_dt] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[meta] [nvarchar](max) NULL,
	[slider_dt] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServicesDetails]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServicesDetails](
	[id_sd] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[name_sd] [nvarchar](max) NULL,
	[img_sd] [nvarchar](max) NULL,
	[hide_sd] [bit] NULL,
	[price_sd] [nvarchar](max) NULL,
	[id_dt] [int] NULL,
	[desc_de] [nvarchar](max) NULL,
	[amount] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoles]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[stt] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[email] [nvarchar](max) NULL,
	[rolename] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRolesMappings]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRolesMappings](
	[stt] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[email] [nvarchar](max) NULL,
	[idrole] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[iduser] [nvarchar](50) PRIMARY KEY NOT NULL,
	[name] [nvarchar](max) NULL,
	[birth] [datetime] NULL,
	[gender] [nvarchar](10) NULL,
	[phone] [nvarchar](10) NULL,
	[email] [nvarchar](max) NULL,
	[password] [nvarchar](max) NULL,
	[hide] [bit] NULL,
	[ava] [nvarchar](max) NULL,
	[total] [int] NULL,
	[point] [int] NULL,
	[dateregist] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vouchers]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vouchers](
	[idvoucher] [nvarchar](50) NULL,
	[namevc] [nvarchar](max) NULL,
	[valuevc] [nvarchar](max) NULL,
	[quantity] [int] NULL,
	[dasudung] [int] NULL,
	[datefrom] [nvarchar](max) NULL,
	[dateto] [nvarchar](max) NULL,
	[hidevc] [bit] NULL,
	[stt] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Wishlists]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wishlists](
	[stt_wl] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[iduser] [nvarchar](50) NOT NULL,
	[idp] [int] NULL
)
GO


------------------------------------------------------------
-- UNIQUE CONSTRAINTS
------------------------------------------------------------
ALTER TABLE Users ADD CONSTRAINT PK_Users PRIMARY KEY(iduser);

ALTER TABLE Vouchers ADD CONSTRAINT UQ_Voucher_Code UNIQUE(idvoucher);

------------------------------------------------------------
-- FOREIGN KEYS
------------------------------------------------------------
ALTER TABLE Products 
ADD CONSTRAINT FK_Product_Category FOREIGN KEY(typep) REFERENCES Categories(typep);

ALTER TABLE Products 
ADD CONSTRAINT FK_Product_Brand FOREIGN KEY(idbrand) REFERENCES Brands(idbrand);

ALTER TABLE Carts 
ADD CONSTRAINT FK_Cart_User FOREIGN KEY(iduser) REFERENCES Users(iduser);

ALTER TABLE Carts 
ADD CONSTRAINT FK_Cart_Product FOREIGN KEY(idp) REFERENCES Products(idp);

ALTER TABLE Wishlists 
ADD CONSTRAINT FK_Wishlist_User FOREIGN KEY(iduser) REFERENCES Users(iduser);

ALTER TABLE Wishlists 
ADD CONSTRAINT FK_Wishlist_Product FOREIGN KEY(idp) REFERENCES Products(idp);

ALTER TABLE Bills 
ADD CONSTRAINT FK_Bills_User FOREIGN KEY(iduser) REFERENCES Users(iduser);

ALTER TABLE Bills
ADD CONSTRAINT FK_Bills_Product FOREIGN KEY(idp) REFERENCES Products(idp);

ALTER TABLE Feedbacks
ADD CONSTRAINT FK_Fb_User FOREIGN KEY(iduser) REFERENCES Users(iduser);

ALTER TABLE Feedbacks
ADD CONSTRAINT FK_Fb_Product FOREIGN KEY(idp) REFERENCES Products(idp);

ALTER TABLE RepFeedbacks
ADD CONSTRAINT FK_RepFb_Feedback FOREIGN KEY(sttfb) REFERENCES Feedbacks(sttfb);

ALTER TABLE ServicesDetails
ADD CONSTRAINT FK_ServiceDetail_Service FOREIGN KEY(id_dt) REFERENCES Services(id_dt);

Go