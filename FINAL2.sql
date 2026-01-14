
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

USE DOCTORSKIN2
GO

/* =========================================================
   STORED PROCEDURES
   ========================================================= */

-- 1. Đăng ký lịch khám
CREATE PROCEDURE sp_AddBooking
    @name NVARCHAR(MAX),
    @phone NVARCHAR(MAX),
    @email NVARCHAR(MAX),
    @require NVARCHAR(MAX),
    @timebooking DATETIME
AS
BEGIN
    INSERT INTO Bookings(name, phone, email, require, timebooking, completed)
    VALUES (@name, @phone, @email, @require, @timebooking, 0)
END
GO

-- 2. Thêm bệnh nhân sau khi khám
CREATE PROCEDURE sp_AddPatient
    @name NVARCHAR(MAX),
    @gender NVARCHAR(MAX),
    @age INT,
    @phone NVARCHAR(10),
    @diagnose NVARCHAR(MAX),
    @prescription NVARCHAR(MAX),
    @doctor NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Patients
    (name, gender, age, phone, diagnose, prescription, date, doctor)
    VALUES
    (@name, @gender, @age, @phone, @diagnose, @prescription, GETDATE(), @doctor)
END
GO

-- 3. Tạo hóa đơn
CREATE PROCEDURE sp_CreateBill
    @iduser NVARCHAR(50),
    @idp INT,
    @quantity INT,
    @totalmoney NVARCHAR(MAX),
    @address NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Bills
    (iduser, idp, quantity, totalmoney, status, datebuy, address)
    VALUES
    (@iduser, @idp, @quantity, @totalmoney, N'Chờ thanh toán', GETDATE(), @address)
END
GO

-- 4. Thanh toán hóa đơn
CREATE PROCEDURE sp_PayBill
    @sttbill INT
AS
BEGIN
    UPDATE Bills
    SET status = N'Đã thanh toán',
        datesuccess = GETDATE()
    WHERE sttbill = @sttbill
END
GO

-- 5. Them san pham vao gio hang (neu ton tai thi tang so luong)
CREATE PROCEDURE sp_AddToCart
    @iduser NVARCHAR(50),
    @idp INT,
    @quantity INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Carts WHERE iduser = @iduser AND idp = @idp)
        UPDATE Carts
        SET quanlity = ISNULL(quanlity,0) + @quantity
        WHERE iduser = @iduser AND idp = @idp
    ELSE
        INSERT INTO Carts (iduser, idp, quanlity)
        VALUES (@iduser, @idp, @quantity)
END
GO


/* =========================================================
   FUNCTIONS
   ========================================================= */

-- 1. Tính tổng tiền hóa đơn
CREATE FUNCTION fn_TotalBill (@sttbill INT)
RETURNS INT
AS
BEGIN
    DECLARE @total INT
    SELECT @total = quantity * CAST(totalmoney AS INT)
    FROM Bills
    WHERE sttbill = @sttbill
    RETURN ISNULL(@total,0)
END
GO

-- 2. Kiểm tra người dùng có phải bác sĩ không
CREATE FUNCTION fn_IsDoctor (@email NVARCHAR(MAX))
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0
    IF EXISTS (
        SELECT 1
        FROM UserRoles
        WHERE email = @email AND rolename = 'Doctor'
    )
        SET @result = 1
    RETURN @result
END
GO

-- 3. Tinh tong so luong san pham trong gio hang
CREATE FUNCTION fn_TotalCartItems (@iduser NVARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @total INT
    SELECT @total = SUM(ISNULL(quanlity,0))
    FROM Carts
    WHERE iduser = @iduser
    RETURN ISNULL(@total,0)
END
GO

-- 4. Tinh tong tien da mua cua khach hang
CREATE FUNCTION fn_UserTotalSpent (@iduser NVARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @total INT
    SELECT @total = SUM(CAST(totalmoney AS INT))
    FROM Bills
    WHERE iduser = @iduser
    RETURN ISNULL(@total,0)
END
GO

-- 5. Tinh diem danh gia trung binh cua san pham
CREATE FUNCTION fn_ProductAvgStar (@idp INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @avgstar DECIMAL(5,2)
    SELECT @avgstar = AVG(CAST(star AS DECIMAL(5,2)))
    FROM Feedbacks
    WHERE idp = @idp
    RETURN ISNULL(@avgstar,0)
END
GO


/* =========================================================
   TRIGGERS
   ========================================================= */

-- 1. Tự động đánh dấu booking đã hoàn thành nếu quá thời gian
CREATE TRIGGER trg_Booking_Expired
ON Bookings
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Bookings
    SET completed = 1
    WHERE timebooking < GETDATE()
END
GO

-- 2. Tự động trừ voucher khi tạo bill
CREATE TRIGGER trg_UseVoucher
ON Bills
AFTER INSERT
AS
BEGIN
    UPDATE Vouchers
    SET quantity = quantity - 1,
        dasudung = ISNULL(dasudung,0) + 1
    FROM Vouchers V
    JOIN inserted i ON V.idvoucher = i.idvoucher
END
GO

-- 3. Cộng điểm người dùng sau khi thanh toán
CREATE TRIGGER trg_AddPointAfterPay
ON Bills
AFTER UPDATE
AS
BEGIN
    UPDATE Users
    SET point = ISNULL(point,0) + 10
    FROM Users U
    JOIN inserted i ON U.iduser = i.iduser
    WHERE i.status = N'Đã thanh toán'
END
GO

-- 4. Không cho feedback khi chưa thanh toán
CREATE TRIGGER trg_BlockFeedback
ON Feedbacks
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Bills b ON i.idbill = b.idbill
        WHERE b.status <> N'Đã thanh toán'
    )
    BEGIN
        RAISERROR(N'Chỉ được đánh giá sau khi thanh toán',16,1)
        RETURN
    END

    INSERT INTO Feedbacks
    SELECT * FROM inserted
END
GO

-- 5. Khong cho voucher co so luong am
CREATE TRIGGER trg_BlockNegativeVoucher
ON Vouchers
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Vouchers WHERE quantity < 0)
    BEGIN
        RAISERROR(N'So luong voucher khong duoc am',16,1)
        ROLLBACK TRANSACTION
    END
END
GO


/* =========================================================
   CURSOR
   ========================================================= */

-- Cursor: danh sách bệnh nhân chưa thanh toán
DECLARE cur_UnpaidPatients CURSOR FOR
SELECT DISTINCT P.name, B.sttbill
FROM Patients P
JOIN Bills B ON P.phone = B.iduser
WHERE B.status <> N'Đã thanh toán'

DECLARE @name NVARCHAR(MAX), @bill INT

OPEN cur_UnpaidPatients
FETCH NEXT FROM cur_UnpaidPatients INTO @name, @bill

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT N'Bệnh nhân: ' + @name + N' | Bill: ' + CAST(@bill AS NVARCHAR)
    FETCH NEXT FROM cur_UnpaidPatients INTO @name, @bill
END

CLOSE cur_UnpaidPatients
DEALLOCATE cur_UnpaidPatients
GO

-- Cursor: danh sach khach hang chi tieu nhieu nhat
DECLARE cur_TopCustomers CURSOR FOR
SELECT TOP 5 U.name, SUM(CAST(B.totalmoney AS INT)) AS total_spent
FROM Users U
JOIN Bills B ON U.iduser = B.iduser
GROUP BY U.name
ORDER BY total_spent DESC

DECLARE @cust_name NVARCHAR(MAX), @cust_total INT

OPEN cur_TopCustomers
FETCH NEXT FROM cur_TopCustomers INTO @cust_name, @cust_total

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT N'Khach hang: ' + @cust_name + N' | Tong: ' + CAST(@cust_total AS NVARCHAR)
    FETCH NEXT FROM cur_TopCustomers INTO @cust_name, @cust_total
END

CLOSE cur_TopCustomers
DEALLOCATE cur_TopCustomers
GO
INSERT INTO staff (name, gender, dob, phone, email, patients_seen, specialization, last_shift, role) VALUES ('Nguyen Anh', 'Male', '1979-03-13', '0920021248', 'staff03@clinic.com', 857, 'Cardiologist', '2023-10-19 16:15:00', 'doctor');
INSERT INTO staff (name, gender, dob, phone, email, patients_seen, specialization, last_shift, role) VALUES ('Tran Minh', 'Female', '1983-07-22', '0968959641', 'staff01@clinic.com', 251, 'Gynecologist', '2024-02-15 09:30:00', 'doctor');
-- (giữ nguyên, đảm bảo có 50 dòng tương tự)
