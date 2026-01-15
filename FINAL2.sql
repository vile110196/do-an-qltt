USE DOCTORSKIN2;
GO

SET NOCOUNT ON;
GO

------------------------------------------------------------
-- DROP (đúng thứ tự để khỏi vướng FK)
------------------------------------------------------------
IF OBJECT_ID('dbo.Campaign_Vouchers','U') IS NOT NULL DROP TABLE dbo.Campaign_Vouchers;
IF OBJECT_ID('dbo.Campaigns','U') IS NOT NULL DROP TABLE dbo.Campaigns;


IF OBJECT_ID('dbo.Wishlists','U') IS NOT NULL DROP TABLE dbo.Wishlists;
IF OBJECT_ID('dbo.Carts','U') IS NOT NULL DROP TABLE dbo.Carts;

IF OBJECT_ID('dbo.Bought','U') IS NOT NULL DROP TABLE dbo.Bought;
IF OBJECT_ID('dbo.Bills','U') IS NOT NULL DROP TABLE dbo.Bills;

IF OBJECT_ID('dbo.Products','U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Brands','U') IS NOT NULL DROP TABLE dbo.Brands;
IF OBJECT_ID('dbo.Categories','U') IS NOT NULL DROP TABLE dbo.Categories;

IF OBJECT_ID('dbo.BlogDetails','U') IS NOT NULL DROP TABLE dbo.BlogDetails;
IF OBJECT_ID('dbo.BlogTypes','U') IS NOT NULL DROP TABLE dbo.BlogTypes;

IF OBJECT_ID('dbo.Banners','U') IS NOT NULL DROP TABLE dbo.Banners;
IF OBJECT_ID('dbo.Medias','U') IS NOT NULL DROP TABLE dbo.Medias;

IF OBJECT_ID('dbo.ServicesDetails','U') IS NOT NULL DROP TABLE dbo.ServicesDetails;
IF OBJECT_ID('dbo.Services','U') IS NOT NULL DROP TABLE dbo.Services;

IF OBJECT_ID('dbo.Bookings','U') IS NOT NULL DROP TABLE dbo.Bookings;
IF OBJECT_ID('dbo.Patients','U') IS NOT NULL DROP TABLE dbo.Patients;
IF OBJECT_ID('dbo.Doctors','U') IS NOT NULL DROP TABLE dbo.Doctors;
IF OBJECT_ID('dbo.Medicines','U') IS NOT NULL DROP TABLE dbo.Medicines;

IF OBJECT_ID('dbo.Forgots','U') IS NOT NULL DROP TABLE dbo.Forgots;
IF OBJECT_ID('dbo.Questions','U') IS NOT NULL DROP TABLE dbo.Questions;

IF OBJECT_ID('dbo.UserRolesMappings','U') IS NOT NULL DROP TABLE dbo.UserRolesMappings;
IF OBJECT_ID('dbo.UserRoles','U') IS NOT NULL DROP TABLE dbo.UserRoles;
IF OBJECT_ID('dbo.RoleMasters','U') IS NOT NULL DROP TABLE dbo.RoleMasters;
IF OBJECT_ID('dbo.Users','U') IS NOT NULL DROP TABLE dbo.Users;

IF OBJECT_ID('dbo.Vouchers','U') IS NOT NULL DROP TABLE dbo.Vouchers;
GO

------------------------------------------------------------
-- CREATE TABLES (schema đồng bộ với backend)
------------------------------------------------------------

-- Users: backend cần cột [pass]
CREATE TABLE dbo.Users(
    iduser      NVARCHAR(50) NOT NULL PRIMARY KEY,
    name        NVARCHAR(255) NULL,
    birth       DATETIME NULL,
    gender      NVARCHAR(20) NULL,
    address     NVARCHAR(500) NULL,
    phone       NVARCHAR(20) NULL,
    email       NVARCHAR(255) NULL,
    [pass]      NVARCHAR(255) NULL,
    point       INT NULL,
    dateregist  DATETIME NULL
);
GO

CREATE TABLE dbo.RoleMasters(
    id       INT NOT NULL PRIMARY KEY,
    rollname NVARCHAR(100) NULL
);
GO

-- UserRoles: backend cần email + idrole + rolename
CREATE TABLE dbo.UserRoles(
    stt      INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    email    NVARCHAR(255) NULL,
    idrole   INT NULL,
    rolename NVARCHAR(100) NULL
);
GO

CREATE TABLE dbo.UserRolesMappings(
    stt    INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    email  NVARCHAR(255) NULL,
    idrole INT NULL
);
GO

CREATE TABLE dbo.Categories(
    typep INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    namec NVARCHAR(255) NULL,
    meta  NVARCHAR(255) NULL,
    hide  BIT NULL
);
GO

CREATE TABLE dbo.Brands(
    idbrand   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    namebrand NVARCHAR(255) NULL,
    hide      BIT NULL
);
GO

CREATE TABLE dbo.Products(
    idp      INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    namep    NVARCHAR(255) NULL,
    newprice NVARCHAR(50) NULL,
    oldprice NVARCHAR(50) NULL,
    descr    NVARCHAR(MAX) NULL,
    typep    INT NULL,
    idbrand  INT NULL,
    img      NVARCHAR(MAX) NULL,
    hide     BIT NULL
);
GO

-- Vouchers: backend dùng stt, idvoucher, namevc, valuevc (int), quantity, hide
CREATE TABLE dbo.Vouchers(
    stt      INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    idvoucher NVARCHAR(50) NOT NULL,
    namevc   NVARCHAR(255) NULL,
    valuevc  INT NULL,
    quantity INT NULL,
    hide     BIT NULL
);
GO

-- Campaigns + mapping
CREATE TABLE dbo.Campaigns(
    id_campaign INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name        NVARCHAR(255) NULL,
    description NVARCHAR(MAX) NULL,
    start_date  DATETIME NULL,
    end_date    DATETIME NULL,
    status      NVARCHAR(50) NULL
);
GO

CREATE TABLE dbo.Campaign_Vouchers(
    id          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    campaign_id INT NOT NULL,
    voucher_id  NVARCHAR(50) NOT NULL
);
GO

-- Bills: backend dùng sttbill,iduser,idp,totalmoney,status,datebuy,idvoucher
CREATE TABLE dbo.Bills(
    sttbill    INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    iduser     NVARCHAR(50) NOT NULL,
    idp        INT NULL,
    totalmoney NVARCHAR(50) NULL,
    status     NVARCHAR(50) NULL,
    datebuy    DATETIME NULL,
    idvoucher  NVARCHAR(50) NULL
);
GO

CREATE TABLE dbo.Bought(
    stt   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    iduser NVARCHAR(50) NULL,
    idp   INT NULL
);
GO

-- Carts: sửa IDENTITY để khỏi lỗi stt NULL
CREATE TABLE dbo.Carts(
    stt      INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    iduser   NVARCHAR(50) NULL,
    idp      INT NULL,
    quanlity INT NULL
);
GO

CREATE TABLE dbo.Wishlists(
    stt INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    iduser NVARCHAR(50) NOT NULL,
    idp INT NULL
);
GO



CREATE TABLE dbo.Services(
    id_dt INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name_dt NVARCHAR(255) NULL,
    desc_dt NVARCHAR(MAX) NULL,
    img_dt NVARCHAR(MAX) NULL
);
GO

CREATE TABLE dbo.ServicesDetails(
    id_sd INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_dt INT NULL,
    name_sd NVARCHAR(255) NULL,
    price_sd NVARCHAR(50) NULL
);
GO

CREATE TABLE dbo.BlogTypes(
    idbt INT NOT NULL PRIMARY KEY,
    namebt NVARCHAR(255) NULL
);
GO

CREATE TABLE dbo.BlogDetails(
    idb INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    idbt INT NULL,
    title NVARCHAR(255) NULL,
    contentblog NVARCHAR(MAX) NULL,
    meta NVARCHAR(255) NULL,
    img NVARCHAR(MAX) NULL,
    hide BIT NULL
);
GO

CREATE TABLE dbo.Banners(
    stt INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    link NVARCHAR(MAX) NULL,
    homepage BIT NULL,
    servicepage BIT NULL,
    blogpage BIT NULL,
    productpage BIT NULL
);
GO

CREATE TABLE dbo.Medias(
    stt INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    link NVARCHAR(MAX) NULL
);
GO

CREATE TABLE dbo.Bookings(
    stt INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(255) NULL,
    phone NVARCHAR(20) NULL,
    timebooking DATETIME NULL,
    require NVARCHAR(MAX) NULL
);
GO

CREATE TABLE dbo.Patients(
    stt INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(255) NULL,
    phone NVARCHAR(20) NULL,
    address NVARCHAR(500) NULL,
    diagnose NVARCHAR(MAX) NULL,
    prescription NVARCHAR(MAX) NULL,
    doctor NVARCHAR(255) NULL,
    date DATETIME NULL,
    date_re DATETIME NULL
);
GO

CREATE TABLE dbo.Doctors(
    stt INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    namedoc NVARCHAR(255) NULL,
    iddoc NVARCHAR(50) NULL,
    infordoc NVARCHAR(MAX) NULL
);
GO

CREATE TABLE dbo.Medicines(
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(255) NULL,
    price NVARCHAR(50) NULL,
    uses NVARCHAR(MAX) NULL,
    hide BIT NULL
);
GO

CREATE TABLE dbo.Forgots(
    stt INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    email NVARCHAR(255) NULL,
    token NVARCHAR(255) NULL,
    time NVARCHAR(50) NULL
);
GO

CREATE TABLE dbo.Questions(
    stt INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    iduser NVARCHAR(50) NULL,
    question NVARCHAR(MAX) NULL,
    repquestion NVARCHAR(MAX) NULL
);
GO

------------------------------------------------------------
-- UNIQUE / INDEX
------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_Vouchers_Code' AND object_id = OBJECT_ID('dbo.Vouchers'))
    ALTER TABLE dbo.Vouchers ADD CONSTRAINT UQ_Vouchers_Code UNIQUE (idvoucher);
GO

------------------------------------------------------------
-- FOREIGN KEYS (IF NOT EXISTS pattern)
------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Product_Category')
    ALTER TABLE dbo.Products ADD CONSTRAINT FK_Product_Category FOREIGN KEY(typep) REFERENCES dbo.Categories(typep);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Product_Brand')
    ALTER TABLE dbo.Products ADD CONSTRAINT FK_Product_Brand FOREIGN KEY(idbrand) REFERENCES dbo.Brands(idbrand);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Cart_User')
    ALTER TABLE dbo.Carts ADD CONSTRAINT FK_Cart_User FOREIGN KEY(iduser) REFERENCES dbo.Users(iduser);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Cart_Product')
    ALTER TABLE dbo.Carts ADD CONSTRAINT FK_Cart_Product FOREIGN KEY(idp) REFERENCES dbo.Products(idp);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Wishlist_User')
    ALTER TABLE dbo.Wishlists ADD CONSTRAINT FK_Wishlist_User FOREIGN KEY(iduser) REFERENCES dbo.Users(iduser);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Wishlist_Product')
    ALTER TABLE dbo.Wishlists ADD CONSTRAINT FK_Wishlist_Product FOREIGN KEY(idp) REFERENCES dbo.Products(idp);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Bills_User')
    ALTER TABLE dbo.Bills ADD CONSTRAINT FK_Bills_User FOREIGN KEY(iduser) REFERENCES dbo.Users(iduser);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Bills_Product')
    ALTER TABLE dbo.Bills ADD CONSTRAINT FK_Bills_Product FOREIGN KEY(idp) REFERENCES dbo.Products(idp);




IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_ServiceDetail_Service')
    ALTER TABLE dbo.ServicesDetails ADD CONSTRAINT FK_ServiceDetail_Service FOREIGN KEY(id_dt) REFERENCES dbo.Services(id_dt);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_CampaignVouchers_Campaign')
    ALTER TABLE dbo.Campaign_Vouchers ADD CONSTRAINT FK_CampaignVouchers_Campaign FOREIGN KEY(campaign_id) REFERENCES dbo.Campaigns(id_campaign);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_CampaignVouchers_Voucher')
    ALTER TABLE dbo.Campaign_Vouchers ADD CONSTRAINT FK_CampaignVouchers_Voucher FOREIGN KEY(voucher_id) REFERENCES dbo.Vouchers(idvoucher);
GO

------------------------------------------------------------
-- STORED PROCEDURES (đúng table/column)
------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_AddToCart
    @iduser NVARCHAR(50),
    @idp INT,
    @quantity INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.Carts WHERE iduser=@iduser AND idp=@idp)
        UPDATE dbo.Carts
        SET quanlity = ISNULL(quanlity,0) + @quantity
        WHERE iduser=@iduser AND idp=@idp;
    ELSE
        INSERT INTO dbo.Carts(iduser,idp,quanlity)
        VALUES (@iduser,@idp,@quantity);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_CreateBill
    @iduser NVARCHAR(50),
    @idp INT,
    @totalmoney NVARCHAR(50),
    @idvoucher NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Bills(iduser,idp,totalmoney,status,datebuy,idvoucher)
    VALUES (@iduser,@idp,@totalmoney,N'Chờ thanh toán',GETDATE(),@idvoucher);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_PayBill
    @sttbill INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Bills
    SET status = N'Đã thanh toán'
    WHERE sttbill=@sttbill;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_RemoveFromCart
    @iduser NVARCHAR(50),
    @idp INT,
    @quantity INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    IF @quantity IS NULL OR @quantity <= 0
    BEGIN
        RAISERROR(N'Số lượng cần xóa phải > 0', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.Carts WHERE iduser=@iduser AND idp=@idp)
        RETURN;

    UPDATE dbo.Carts
    SET quanlity = ISNULL(quanlity, 0) - @quantity
    WHERE iduser=@iduser AND idp=@idp;

    DELETE FROM dbo.Carts
    WHERE iduser=@iduser AND idp=@idp
      AND ISNULL(quanlity, 0) <= 0;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_CheckoutCart
    @iduser NVARCHAR(50),
    @idvoucher NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE iduser=@iduser)
    BEGIN
        RAISERROR(N'Không tìm thấy user', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.Carts WHERE iduser=@iduser)
    BEGIN
        RAISERROR(N'Giỏ hàng trống', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.Bills(iduser, idp, totalmoney, status, datebuy, idvoucher)
    SELECT
        c.iduser,
        c.idp,
        CONVERT(NVARCHAR(50),
            TRY_CONVERT(DECIMAL(18,2), ISNULL(c.quanlity,0)) * dbo.fn_ProductPrice(c.idp)
        ) AS totalmoney,
        N'Chờ thanh toán' AS status,
        GETDATE() AS datebuy,
        @idvoucher
    FROM dbo.Carts c
    WHERE c.iduser = @iduser;

    DELETE FROM dbo.Carts WHERE iduser = @iduser;
END
GO

------------------------------------------------------------
-- FUNCTIONS
------------------------------------------------------------

CREATE OR ALTER FUNCTION dbo.fn_ProductPrice(@idp INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @p DECIMAL(18,2);

    SELECT @p =
        COALESCE(
            TRY_CONVERT(DECIMAL(18,2), NULLIF(newprice, '')),
            TRY_CONVERT(DECIMAL(18,2), NULLIF(oldprice, '')),
            0
        )
    FROM dbo.Products
    WHERE idp = @idp;

    RETURN ISNULL(@p, 0);
END
GO

CREATE OR ALTER FUNCTION dbo.fn_CalcCartTotal(@iduser NVARCHAR(50))
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @total DECIMAL(18,2);

    SELECT @total =
        SUM(
            TRY_CONVERT(DECIMAL(18,2), ISNULL(c.quanlity, 0)) * dbo.fn_ProductPrice(c.idp)
        )
    FROM dbo.Carts c
    WHERE c.iduser = @iduser;

    RETURN ISNULL(@total, 0);
END
GO

------------------------------------------------------------
-- TRIGGERS (sửa cho đúng logic + tránh update toàn bảng)
------------------------------------------------------------

-- Booking expired: chỉ update booking vừa insert/update
CREATE OR ALTER TRIGGER dbo.trg_Booking_Expired
ON dbo.Bookings
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE b
    SET b.require = b.require,  -- no-op (giữ nguyên)
        b.timebooking = b.timebooking
    FROM dbo.Bookings b
    JOIN inserted i ON i.stt = b.stt
    WHERE b.timebooking < GETDATE();
END
GO

-- Use voucher: trừ quantity khi Bills insert có idvoucher
CREATE OR ALTER TRIGGER dbo.trg_UseVoucher
ON dbo.Bills
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE v
    SET v.quantity = v.quantity - 1
    FROM dbo.Vouchers v
    JOIN inserted i ON i.idvoucher = v.idvoucher
    WHERE i.idvoucher IS NOT NULL
      AND v.quantity IS NOT NULL
      AND v.quantity > 0;
END
GO

-- Add point after pay: chỉ cộng khi status vừa đổi sang Đã thanh toán
CREATE OR ALTER TRIGGER dbo.trg_AddPointAfterPay
ON dbo.Bills
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE u
    SET u.point = ISNULL(u.point,0) + 10
    FROM dbo.Users u
    JOIN inserted i ON i.iduser = u.iduser
    JOIN deleted  d ON d.sttbill = i.sttbill
    WHERE i.status = N'Đã thanh toán'
      AND (d.status IS NULL OR d.status <> N'Đã thanh toán');
END
GO

-- Block negative voucher quantity
CREATE OR ALTER TRIGGER dbo.trg_BlockNegativeVoucher
ON dbo.Vouchers
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.Vouchers WHERE quantity < 0)
    BEGIN
        RAISERROR(N'Số lượng voucher không được âm',16,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO

CREATE OR ALTER TRIGGER dbo.trg_BlockInvalidCartQuantity
ON dbo.Carts
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.quanlity IS NULL OR i.quanlity <= 0
    )
    BEGIN
        RAISERROR(N'Số lượng trong giỏ (quanlity) phải > 0', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_RecalculateAllUserPoints_Cursor
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @iduser NVARCHAR(50);
    DECLARE @paidCount INT;

    DECLARE curUsers CURSOR LOCAL FAST_FORWARD FOR
        SELECT iduser FROM dbo.Users;

    OPEN curUsers;

    FETCH NEXT FROM curUsers INTO @iduser;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @paidCount = COUNT(*)
        FROM dbo.Bills
        WHERE iduser = @iduser
          AND status = N'Đã thanh toán';

        UPDATE dbo.Users
        SET point = ISNULL(@paidCount, 0) * 10
        WHERE iduser = @iduser;

        FETCH NEXT FROM curUsers INTO @iduser;
    END

    CLOSE curUsers;
    DEALLOCATE curUsers;
END
GO

PRINT N'✅ Init DOCTORSKIN2 OK (schema đồng bộ backend).';
GO