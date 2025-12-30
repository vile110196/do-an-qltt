
USE PHONGKHAM_DA_LIEU;
GO

ALTER DATABASE [PHONGKHAM_DA_LIEU] SET COMPATIBILITY_LEVEL = 170;
ALTER DATABASE [PHONGKHAM_DA_LIEU] SET AUTO_CLOSE ON;
ALTER DATABASE [PHONGKHAM_DA_LIEU] SET RECOVERY SIMPLE;
ALTER DATABASE [PHONGKHAM_DA_LIEU] SET QUERY_STORE = ON;
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE NguoiDung(
    MaNguoiDung NVARCHAR(50) NOT NULL,
    TenNguoiDung NVARCHAR(MAX),
    NgaySinh DATETIME,
    GioiTinh NVARCHAR(10),
    DienThoai NVARCHAR(10),
    Email NVARCHAR(255),
    MatKhau NVARCHAR(MAX),
    An BIT,
    AnhDaiDien NVARCHAR(MAX),
    TongTien DECIMAL(18,2),
    Diem INT,
    NgayDangKy DATETIME

);

CREATE TABLE DanhMuc(
    MaDanhMuc INT IDENTITY PRIMARY KEY,
    TenDanhMuc NVARCHAR(MAX),
    An BIT,
    Meta NVARCHAR(MAX),
    NgayCapNhat DATETIME
);


CREATE TABLE ThuongHieu(
    MaThuongHieu INT IDENTITY PRIMARY KEY,
    TenThuongHieu NVARCHAR(MAX),
    An BIT,
    Meta NVARCHAR(MAX)
);


CREATE TABLE SanPham(
    MaSanPham INT IDENTITY PRIMARY KEY,
    TenSanPham NVARCHAR(MAX),
    MaDanhMuc INT,
    GiaMoi NVARCHAR(MAX) NOT NULL,
    GiaCu NVARCHAR(MAX) NOT NULL,
    MoTa NVARCHAR(MAX) NOT NULL,
    An BIT NOT NULL,
    TrangThai NVARCHAR(MAX) NOT NULL,
    Anh NVARCHAR(MAX),
    NgayCapNhat DATETIME,
    MaThuongHieu INT,
    Meta NVARCHAR(MAX),
    TinhTrang NVARCHAR(MAX),
    DanhGia NVARCHAR(MAX),
    DanhSachAnh NVARCHAR(MAX),
    XuatXu NVARCHAR(100) NULL
);
ALTER TABLE SanPham 
ADD CONSTRAINT DF_SanPham_XuatXu DEFAULT N'Viet Nam' FOR XuatXu;

CREATE TABLE GioHang(
    MaGioHang INT IDENTITY PRIMARY KEY,
    MaNguoiDung NVARCHAR(50),
    MaSanPham INT,
    SoLuong INT
);

CREATE TABLE YeuThich(
    MaYeuThich INT IDENTITY PRIMARY KEY,
    MaNguoiDung NVARCHAR(50),
    MaSanPham INT
);


CREATE TABLE MaGiamGia(
    Ma INT IDENTITY PRIMARY KEY,
    MaVoucher NVARCHAR(50),
    TenVoucher NVARCHAR(MAX),
    GiaTri NVARCHAR(MAX),
    SoLuong INT,
    DaSuDung INT,
    TuNgay NVARCHAR(MAX),
    DenNgay NVARCHAR(MAX),
    An BIT
);


CREATE TABLE HoaDon(
    MaHoaDon INT IDENTITY PRIMARY KEY,
    MaSanPham INT,
    SoLuong INT,
    TongTien NVARCHAR(MAX),
    DonGia NVARCHAR(MAX),
    MaDonHang NVARCHAR(MAX),
    MaNguoiDung NVARCHAR(50),
    GhiChu NVARCHAR(MAX),
    TrangThai NVARCHAR(MAX),
    DaDanhGia BIT,
    NgayMua DATETIME,
    MaVoucher NVARCHAR(50),
    LyDoHuy NVARCHAR(MAX),
    NgayHoanThanh DATETIME,
    NgoaiLe NVARCHAR(MAX),
    DiaChi NVARCHAR(MAX)
);


CREATE TABLE DanhGia(
    MaDanhGia INT IDENTITY PRIMARY KEY,
    MaDonHang NVARCHAR(MAX),
    NoiDung NVARCHAR(MAX),
    NgayDanhGia DATETIME,
    An BIT,
    MaNguoiDung NVARCHAR(50),
    MaSanPham INT,
    SoSao INT,
    AnhDanhGia NVARCHAR(MAX)
);

CREATE TABLE TraLoiDanhGia(
    MaTraLoi INT IDENTITY PRIMARY KEY,
    MaDanhGia INT,
    MaNguoiDung NVARCHAR(50),
    NoiDung NVARCHAR(MAX),
    NgayTraLoi DATETIME,
    An BIT,
    NguonTraLoi NVARCHAR(MAX)
);


CREATE TABLE DichVu(
    MaDichVu INT IDENTITY PRIMARY KEY,
    TenDichVu NVARCHAR(MAX),
    MoTa NVARCHAR(MAX),
    An BIT,
    Anh NVARCHAR(MAX),
    Meta NVARCHAR(MAX),
    Slider NVARCHAR(MAX)
);


CREATE TABLE ChiTietDichVu(
    MaChiTiet INT IDENTITY PRIMARY KEY,
    TenChiTiet NVARCHAR(MAX),
    Anh NVARCHAR(MAX),
    An BIT,
    Gia NVARCHAR(MAX),
    MaDichVu INT,
    MoTa NVARCHAR(MAX),
    SoLuong INT
);


CREATE TABLE LoaiBaiViet(
    MaLoai INT PRIMARY KEY,
    TenLoai NVARCHAR(MAX),
    An BIT NOT NULL,
    Meta NVARCHAR(MAX)
);


CREATE TABLE BaiViet(
    MaLoai INT NOT NULL,
    TieuDe NVARCHAR(MAX),
    MoTaNgan NVARCHAR(MAX),
    Anh NVARCHAR(MAX),
    An BIT,
    MaBaiViet INT IDENTITY PRIMARY KEY,
    NgayDang DATETIME,
    NoiDung NVARCHAR(MAX),
    Meta NVARCHAR(MAX)
);

CREATE TABLE BacSi (
    MaBacSi INT IDENTITY PRIMARY KEY,
    TenBacSi NVARCHAR(MAX),
    ThongTin NVARCHAR(MAX),
    AnhDaiDien NVARCHAR(MAX),
    An BIT,
    NgayCapNhat DATETIME,
    MaBacSiCode NVARCHAR(MAX)
);


CREATE TABLE BenhNhan (
    MaBenhNhan INT IDENTITY PRIMARY KEY,
    TenBenhNhan NVARCHAR(MAX),
    GioiTinh NVARCHAR(MAX),
    Tuoi INT,
    DienThoai NVARCHAR(10),
    ChanDoan NVARCHAR(MAX),
    DonThuoc NVARCHAR(MAX),
    ThanhToan NVARCHAR(MAX),
    NgayKham DATETIME,
    BacSi NVARCHAR(MAX),
    NgayTaiKham DATETIME
);


CREATE TABLE DatLich (
    MaDatLich INT IDENTITY PRIMARY KEY,
    TenNguoiDat NVARCHAR(MAX),
    DienThoai NVARCHAR(MAX),
    Email NVARCHAR(MAX),
    YeuCau NVARCHAR(MAX),
    ThoiGianDat DATETIME,
    DaHoanThanh BIT
);


------------------------------------------------------------
-- UNIQUE CONSTRAINTS
------------------------------------------------------------
ALTER TABLE NguoiDung 
ADD CONSTRAINT PK_NguoiDung PRIMARY KEY (MaNguoiDung);

ALTER TABLE NguoiDung 
ADD CONSTRAINT UQ_NguoiDung_Email UNIQUE (Email);

ALTER TABLE MaGiamGia 
ADD CONSTRAINT UQ_MaGiamGia_MaVoucher UNIQUE (MaVoucher);


------------------------------------------------------------
-- FOREIGN KEYS
------------------------------------------------------------
ALTER TABLE SanPham 
ADD CONSTRAINT FK_SanPham_DanhMuc 
FOREIGN KEY (MaDanhMuc) REFERENCES DanhMuc(MaDanhMuc);

ALTER TABLE SanPham 
ADD CONSTRAINT FK_SanPham_ThuongHieu 
FOREIGN KEY (MaThuongHieu) REFERENCES ThuongHieu(MaThuongHieu);

ALTER TABLE GioHang 
ADD CONSTRAINT FK_GioHang_NguoiDung 
FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung);

ALTER TABLE GioHang 
ADD CONSTRAINT FK_GioHang_SanPham 
FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham);

ALTER TABLE YeuThich 
ADD CONSTRAINT FK_YeuThich_NguoiDung 
FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung);

ALTER TABLE YeuThich 
ADD CONSTRAINT FK_YeuThich_SanPham 
FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham);

ALTER TABLE HoaDon 
ADD CONSTRAINT FK_HoaDon_NguoiDung 
FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung);

ALTER TABLE HoaDon 
ADD CONSTRAINT FK_HoaDon_SanPham 
FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham);

ALTER TABLE DanhGia 
ADD CONSTRAINT FK_DanhGia_NguoiDung 
FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung);

ALTER TABLE DanhGia 
ADD CONSTRAINT FK_DanhGia_SanPham 
FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham);

ALTER TABLE TraLoiDanhGia 
ADD CONSTRAINT FK_TraLoiDanhGia_DanhGia 
FOREIGN KEY (MaDanhGia) REFERENCES DanhGia(MaDanhGia);

ALTER TABLE BaiViet 
ADD CONSTRAINT FK_BaiViet_LoaiBaiViet 
FOREIGN KEY (MaLoai) REFERENCES LoaiBaiViet(MaLoai);

ALTER TABLE ChiTietDichVu 
ADD CONSTRAINT FK_ChiTietDichVu_DichVu 
FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu);
GO

------------------------------------------------------------
-- STORED PROCEDURES
------------------------------------------------------------

CREATE PROCEDURE sp_ThemNguoiDung
(
    @MaNguoiDung NVARCHAR(50),
    @TenNguoiDung NVARCHAR(255),
    @NgaySinh DATETIME = NULL,
    @GioiTinh NVARCHAR(10) = NULL,
    @DienThoai NVARCHAR(10) = NULL,
    @Email NVARCHAR(255) = NULL,
    @MatKhau NVARCHAR(MAX),
    @AnhDaiDien NVARCHAR(MAX) = NULL
)
AS
BEGIN
    INSERT INTO NguoiDung
    (
        MaNguoiDung,
        TenNguoiDung,
        NgaySinh,
        GioiTinh,
        DienThoai,
        Email,
        MatKhau,
        An,
        AnhDaiDien,
        NgayDangKy,
        TongTien,
        Diem
    )
    VALUES
    (
        @MaNguoiDung,
        @TenNguoiDung,
        @NgaySinh,
        @GioiTinh,
        @DienThoai,
        @Email,
        @MatKhau,
        0,
        @AnhDaiDien,
        GETDATE(),
        0,
        0
    )
END
GO

------------------------------------------------------------
-- FUNCTION
------------------------------------------------------------

CREATE FUNCTION fn_TinhTuoi (@NgaySinh DATETIME)
RETURNS INT
AS
BEGIN
    DECLARE @Tuoi INT;
    SELECT @Tuoi = DATEDIFF(YEAR, @NgaySinh, GETDATE());
    RETURN @Tuoi;
END
GO

------------------------------------------------------------
-- TRIGGER
------------------------------------------------------------
CREATE TRIGGER trg_TinhTongTienHoaDon
ON HoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE hd
    SET hd.TongTien =
        TRY_CONVERT(DECIMAL(18,2), hd.SoLuong)
        * TRY_CONVERT(DECIMAL(18,2), hd.DonGia)
    FROM HoaDon hd
    INNER JOIN inserted i
        ON hd.MaHoaDon = i.MaHoaDon;
END
GO

------------------------------------------------------------
-- TRIGGER
------------------------------------------------------------

------------------------------------------------------------
-- PROCEDURE
------------------------------------------------------------

CREATE PROCEDURE sp_CapNhatTongTienNguoiDung
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @MaNguoiDung NVARCHAR(50),
        @TongTien DECIMAL(18,2);

    -- Cursor duyệt từng người dùng có trong HoaDon
    DECLARE curNguoiDung CURSOR FOR
        SELECT DISTINCT MaNguoiDung
        FROM HoaDon
        WHERE MaNguoiDung IS NOT NULL;

    OPEN curNguoiDung;

    FETCH NEXT FROM curNguoiDung INTO @MaNguoiDung;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Tính tổng tiền người dùng đã mua
        SELECT @TongTien = SUM(TRY_CONVERT(DECIMAL(18,2), TongTien))
        FROM HoaDon
        WHERE MaNguoiDung = @MaNguoiDung;

        -- Cập nhật vào bảng NguoiDung
        UPDATE NguoiDung
        SET TongTien = @TongTien
        WHERE MaNguoiDung = @MaNguoiDung;

        FETCH NEXT FROM curNguoiDung INTO @MaNguoiDung;
    END

    CLOSE curNguoiDung;
    DEALLOCATE curNguoiDung;
END
GO

