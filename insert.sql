-- Import Users sheet
IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Users (
        iduser      NVARCHAR(50)    PRIMARY KEY,
        name        NVARCHAR(100),
        birth       DATE,
        gender      NVARCHAR(10),
        address     NVARCHAR(200),
        phone       NVARCHAR(15),
        email       NVARCHAR(100),
        pass        NVARCHAR(100),
        point       INT,
        dateregist  DATE
    );
END;
INSERT INTO dbo.Users
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Users$]'
);
GO

-- Import UserRoles sheet
IF OBJECT_ID(N'dbo.UserRoles', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserRoles (
        stt      INT            PRIMARY KEY,
        email    NVARCHAR(100),
        idrole   INT,
        rolename NVARCHAR(50)
    );
END;
INSERT INTO dbo.UserRoles
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [UserRoles$]'
);
GO

-- Import UserRolesMappings sheet
IF OBJECT_ID(N'dbo.UserRolesMappings', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserRolesMappings (
        stt    INT            PRIMARY KEY,
        email  NVARCHAR(100),
        idrole INT
    );
END;
INSERT INTO dbo.UserRolesMappings
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [UserRolesMappings$]'
);
GO

-- Import RoleMasters sheet
IF OBJECT_ID(N'dbo.RoleMasters', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.RoleMasters (
        id        INT           PRIMARY KEY,
        rollname  NVARCHAR(50)
    );
END;
INSERT INTO dbo.RoleMasters
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [RoleMasters$]'
);
GO

-- Import Categories sheet
IF OBJECT_ID(N'dbo.Categories', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Categories (
        typep  INT           PRIMARY KEY,
        namec  NVARCHAR(100),
        meta   NVARCHAR(100),
        hide   BIT
    );
END;
INSERT INTO dbo.Categories
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Categories$]'
);
GO

-- Import Brands sheet
IF OBJECT_ID(N'dbo.Brands', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Brands (
        idbrand    INT           PRIMARY KEY,
        namebrand  NVARCHAR(100),
        hide       BIT
    );
END;
INSERT INTO dbo.Brands
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Brands$]'
);
GO

-- Import Products sheet
IF OBJECT_ID(N'dbo.Products', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Products (
        idp       INT           PRIMARY KEY,
        namep     NVARCHAR(200),
        newprice  INT,
        oldprice  INT,
        descr     NVARCHAR(1000),
        typep     INT,
        idbrand   INT,
        img       NVARCHAR(255),
        hide      BIT
    );
END;
INSERT INTO dbo.Products
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Products$]'
);
GO

-- Import Vouchers sheet
IF OBJECT_ID(N'dbo.Vouchers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Vouchers (
        stt        INT           PRIMARY KEY,
        idvoucher  NVARCHAR(50),
        namevc     NVARCHAR(100),
        valuevc    INT,
        quantity   INT,
        hide       BIT
    );
END;
INSERT INTO dbo.Vouchers
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Vouchers$]'
);
GO

-- Import Campaigns sheet
IF OBJECT_ID(N'dbo.Campaigns', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Campaigns (
        id_campaign  INT           PRIMARY KEY,
        name         NVARCHAR(100),
        description  NVARCHAR(255),
        start_date   DATE,
        end_date     DATE,
        status       NVARCHAR(50)
    );
END;
INSERT INTO dbo.Campaigns
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Campaigns$]'
);
GO

-- Import CampaignVouchers sheet
IF OBJECT_ID(N'dbo.CampaignVouchers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CampaignVouchers (
        id           INT           PRIMARY KEY,
        campaign_id  INT,
        voucher_id   NVARCHAR(50)
    );
END;
INSERT INTO dbo.CampaignVouchers
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [CampaignVouchers$]'
);
GO

-- Import Bills sheet
IF OBJECT_ID(N'dbo.Bills', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Bills (
        sttbill     INT           PRIMARY KEY,
        iduser      NVARCHAR(50),
        idp         INT,
        totalmoney  INT,
        status      NVARCHAR(50),
        datebuy     DATE,
        idvoucher   NVARCHAR(50)
    );
END;
INSERT INTO dbo.Bills
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Bills$]'
);
GO

-- Import Bought sheet
IF OBJECT_ID(N'dbo.Bought', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Bought (
        stt    INT           PRIMARY KEY,
        iduser NVARCHAR(50),
        idp    INT
    );
END;
INSERT INTO dbo.Bought
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Bought$]'
);
GO

-- Import Carts sheet
IF OBJECT_ID(N'dbo.Carts', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Carts (
        stt       INT           PRIMARY KEY,
        iduser    NVARCHAR(50),
        idp       INT,
        quanlity  INT
    );
END;
INSERT INTO dbo.Carts
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Carts$]'
);
GO

-- Import Wishlists sheet
IF OBJECT_ID(N'dbo.Wishlists', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Wishlists (
        stt    INT           PRIMARY KEY,
        iduser NVARCHAR(50),
        idp    INT
    );
END;
INSERT INTO dbo.Wishlists
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Wishlists$]'
);
GO

-- Import Services sheet
IF OBJECT_ID(N'dbo.Services', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Services (
        id_dt   INT           PRIMARY KEY,
        name_dt NVARCHAR(100),
        desc_dt NVARCHAR(500),
        img_dt  NVARCHAR(255)
    );
END;
INSERT INTO dbo.Services
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Services$]'
);
GO

-- Import ServicesDetails sheet
IF OBJECT_ID(N'dbo.ServicesDetails', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ServicesDetails (
        id_sd   INT           PRIMARY KEY,
        id_dt   INT,
        name_sd NVARCHAR(100),
        price_sd INT
    );
END;
INSERT INTO dbo.ServicesDetails
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [ServicesDetails$]'
);
GO

-- Import BlogTypes sheet
IF OBJECT_ID(N'dbo.BlogTypes', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.BlogTypes (
        idbt    INT           PRIMARY KEY,
        namebt  NVARCHAR(100)
    );
END;
INSERT INTO dbo.BlogTypes
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [BlogTypes$]'
);
GO

-- Import BlogDetails sheet
IF OBJECT_ID(N'dbo.BlogDetails', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.BlogDetails (
        idb          INT           PRIMARY KEY,
        idbt         INT,
        title        NVARCHAR(200),
        contentblog  NVARCHAR(MAX),
        meta         NVARCHAR(100),
        img          NVARCHAR(255),
        hide         BIT
    );
END;
INSERT INTO dbo.BlogDetails
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [BlogDetails$]'
);
GO

-- Import Banners sheet
IF OBJECT_ID(N'dbo.Banners', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Banners (
        stt         INT           PRIMARY KEY,
        link        NVARCHAR(255),
        homepage    BIT,
        servicepage BIT,
        blogpage    BIT,
        productpage BIT
    );
END;
INSERT INTO dbo.Banners
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Banners$]'
);
GO

-- Import Medias sheet
IF OBJECT_ID(N'dbo.Medias', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Medias (
        stt  INT           PRIMARY KEY,
        link NVARCHAR(255)
    );
END;
INSERT INTO dbo.Medias
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Medias$]'
);
GO

-- Import Bookings sheet
IF OBJECT_ID(N'dbo.Bookings', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Bookings (
        stt          INT           PRIMARY KEY,
        name         NVARCHAR(100),
        phone        NVARCHAR(15),
        timebooking  DATETIME,
        require      NVARCHAR(500)
    );
END;
INSERT INTO dbo.Bookings
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Bookings$]'
);
GO

-- Import Patients sheet
IF OBJECT_ID(N'dbo.Patients', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Patients (
        stt          INT           PRIMARY KEY,
        name         NVARCHAR(100),
        phone        NVARCHAR(15),
        address      NVARCHAR(200),
        diagnose     NVARCHAR(500),
        prescription NVARCHAR(500),
        doctor       NVARCHAR(100),
        date         DATE,
        date_re      DATE
    );
END;
INSERT INTO dbo.Patients
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Patients$]'
);
GO

-- Import Doctors sheet
IF OBJECT_ID(N'dbo.Doctors', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Doctors (
        stt      INT           PRIMARY KEY,
        namedoc  NVARCHAR(100),
        iddoc    NVARCHAR(50),
        infordoc NVARCHAR(255)
    );
END;
INSERT INTO dbo.Doctors
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Doctors$]'
);
GO

-- Import Medicines sheet
IF OBJECT_ID(N'dbo.Medicines', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Medicines (
        id    INT           PRIMARY KEY,
        name  NVARCHAR(100),
        price INT,
        uses  NVARCHAR(100),
        hide  BIT
    );
END;
INSERT INTO dbo.Medicines
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Medicines$]'
);
GO

-- Import Forgots sheet
IF OBJECT_ID(N'dbo.Forgots', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Forgots (
        stt   INT           PRIMARY KEY,
        email NVARCHAR(100),
        token NVARCHAR(255),
        time  DATETIME
    );
END;
INSERT INTO dbo.Forgots
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Forgots$]'
);
GO

-- Import Questions sheet
IF OBJECT_ID(N'dbo.Questions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Questions (
        stt          INT           PRIMARY KEY,
        iduser       NVARCHAR(50),
        question     NVARCHAR(500),
        repquestion  NVARCHAR(500)
    );
END;
INSERT INTO dbo.Questions
SELECT * 
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0', 
    'Excel 12.0; Database=C:\New folder\DOCTORSKIN2.xlsx; HDR=YES; IMEX=1', 
    'SELECT * FROM [Questions$]'
);
GO
