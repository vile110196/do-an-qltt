let numItemCart = document.querySelector('.aa-cart-notify')
let iduser = null;
const nameuser = document.querySelector('#nameuser');
if (nameuser.hasAttribute('data-id')) {
    iduser = nameuser.dataset.id;
}

$(document).ready(function () {
    console.log("ready!");
});

//lấy danh sách giỏ hàng lúc hover
$.ajax({
    type: "GET",
    dataType: "json",
    url: "https://localhost:44307/api/getCart/"+iduser,
    headers: {
        // 'Content-Type': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
    },
    success: function (res) {
        let htmlcart = res.slice(0,4).map(item => {
            return `<li>
              <div><a class="aa-cartbox-img" href="#"><img src="${item.imgp}" alt="img"></a></div>
              <div class="aa-cartbox-info" style="display:flex;justify-content:space-between;width:75%">
                <div><a href="#" style="-webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden; display: -webkit-box;font-size:14px">${item.namep}</a></div>
                <p class="money" style="font-size:14px;color:#ee4d2d" value="${item.pricep}">${item.pricep}</p>
              </div>
             <div> <a class="aa-remove-product" href="#" style="top:0 !important"><span class="fa fa-times"></span></a></div>
            </li>`
        })
        document.querySelector('#list-product-cart').innerHTML = htmlcart.join('')
    },
    error: function (err) {
        console.log("Lỗi Api")
    }
})

//thêm vào giỏ hàng
function addCart(idp)
{
    if (iduser == null) {
        window.location.href = "/dang-nhap"
    }
    else {
        let data = {
            "iduser": iduser,
            "idp": idp,
            "quanlity": 1
        }
        $.ajax({
            type: "POST",
            dataType: "json",
            url: "https://localhost:44307/api/Carts",
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            data: JSON.stringify(data),
            success: function (res) {
                swal({
                    position: 'top-end',
                    icon: 'success',
                    title: 'Thêm sản phẩm thành công',
                    showConfirmButton: false,
                    timer: 1000
                }).then(() => {
                    numItemCart.innerText = Number(numItemCart.innerText) + 1
                })
            },
            error: function (err) {
                console.log("Lỗi Api")
            }
        })
    }
}

//lấy toàn bộ giỏ hàng
function toCart() {
    window.location.href = "/carts";
}
$.ajax({
    type: "GET",
    dataType: "json",
    url: "https://localhost:44307/api/getCart/" + iduser,
    headers: {
        // 'Content-Type': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
    },
    success: function (res) {
        numItemCart.innerText = res.reduce((acc, curr) => acc + curr.quanlity, 0)
        //let htmlcart = res.slice(0, 4).map(item => {
        //    return `<div class="row" id="div-pr-${item.idp}">
        //                <div class="row" style="margin-bottom:15px">
        //                <div class="col-md-4" style="display: flex;justify-content: space-between;">
        //            <div>
        //              <input type="checkbox"></input>
        //            </div>
        //            <div class="" style="padding: 0 8px;">
        //              <a class="aa-cartbox-img" href="#"><img style="width: 100px;height: 100px;object-fit: cover;"
        //                  src="${item.imgp}"
        //                  alt="img"></a>
        //            </div>
        //            <div>
        //              <a href="#" style="-webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; display: -webkit-box;font-size:14px">${item.namep}</a>
        //              <img style="height: 18px;object-fit: contain;"
        //                src="https://cf.shopee.vn/file/vn-50009109-d73bf8c455170812e24c11d1852ca7b4" alt="">
        //            </div>
        //          </div>

        //          <div class="col-md-2">
        //            <div style="opacity: 0.7;">
        //              <div>Thương hiệu:</div>
        //              <div>${item.brandp}</div>
        //            </div>
        //          </div>
        //          <div class="col-md-2">
        //            <div>
        //              <p class="money" value="${item.pricep}">${item.pricep}</p>
        //            </div>
        //          </div>
        //          <div class="col-md-1">
        //            <div>
        //              <input style="width: 100%;" type="number" value="${item.quanlity}"></input>
        //            </div>
        //          </div>
        //          <div class="col-md-2">
        //            <div>
        //              <p class="money" value="${item.pricep * item.quanlity}" style="color: #ee4d2d">${item.pricep * item.quanlity}</p>
        //            </div>
        //          </div>
        //          <div class="col-md-1">
        //            <div>
        //              <a class="aa-remove-product" href="#" style="top:0 !important">
        //                <span class="fa fa-times" onclick="deletePro(${item.idp})"></span></a>
        //            </div>
        //          </div>
        //            </div>
        //            </div>`
        //})
        //document.querySelector('#table-data-cart').innerHTML = htmlcart.join('')
    },
    error: function (err) {
        console.log("Lỗi Api")
    }
})

//Xoa san pham
function deletePro(idp) {
    
    $.ajax({
        type: "delete",
        url: "https://localhost:44307/api/carts?idp="+idp+"&iduser="+iduser,
        success: function (res) {
            swal({
                position: 'top-end',
                icon: 'success',
                title: 'xóa sản phẩm thành công',
                showconfirmbutton: false,
                timer: 1500
            })
                .then(() => {
                    document.getElementById(`div-pr-${idp}`).remove()
                })
        },
        error: function(err)
        {
            console.log(iduser)
            console.log("lỗi");
        }
    })
}

//xử lý check
function sum(data) {
    return data.reduce((acc, item) => acc + Number(item.dongia) * Number(item.amount), 0);
}

function formatMoney(value) {
    return Number(value).toLocaleString('vi-VN', { style: 'currency', currency: 'VND' });
}

let cart = []
function checkItem() {
    let listItem = document.querySelectorAll('.check-item')
    listItem.forEach(ele => {
        ele.onchange = function (e) {
            if (ele.checked) {
                cart.push({
                    namep: ele.dataset.namep,
                    imgp: ele.dataset.imgp,
                    brandp: ele.dataset.brandp,
                    idp: ele.dataset.idp,
                    dongia: ele.dataset.price,
                    amount: $(`.amount-item-${ele.dataset.idp}`).val()
                })
                console.log(cart)
                $('#total').attr('value', sum(cart))
                $('#total').text(formatMoney(sum(cart)))
                $('.note').text(`Tổng thanh toán ( ${cart.length} sản phẩm)`)
            }
            else {
                cart = cart.filter(item => item.idp !== ele.dataset.idp);
                console.log(cart)
                $('#total').attr('value', sum(cart))
                $('#total').text(formatMoney(sum(cart)))
                $('.note').text(`Tổng thanh toán ( ${cart.length} sản phẩm)`)
            }
        }
    })

    let amountItem = document.querySelectorAll('.amount-item')
    amountItem.forEach(ele => {
        ele.onchange = function (e) {
            ele.setAttribute('value', ele.value)
            let updatecart = cart.map(item => {
                if (item.idp === ele.dataset.idp) {
                    return { ...item, amount: ele.value };
                } else {
                    return item;
                }
            });
            $(`.total-item-${ele.dataset.idp}`).attr('value', ele.value * Number($(`.dongia-${ele.dataset.idp}`).attr('value')))
            $(`.total-item-${ele.dataset.idp}`).text(formatMoney($(`.total-item-${ele.dataset.idp}`).attr('value')))
            $('#total').attr('value', sum(updatecart))
            $('#total').text(formatMoney(sum(updatecart)))
        }
    })
}
checkItem()

//thanh toán
$('#thanhtoan').click(function () {
    localStorage.setItem("dataCart", JSON.stringify(cart))
    window.location.href = "/carts/payment";
})

//ADD & REMOVE WISHLIST
//thêm vào giỏ hàng
function addWishlist(idp) {
    if (iduser == null) {
        window.location.href = "/dang-nhap"
    }
    else {
        let data = {
            "iduser": iduser,
            "idp": idp,
        }

        let heart = document.querySelector(`#heart-${idp}`)
        console.log(heart.getAttribute('value'))
        if (heart.getAttribute('value') == 'false') {
            $.ajax({
                type: "POST",
                dataType: "json",
                url: "https://localhost:44307/wishlists/Add",
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                data: JSON.stringify(data),
                success: function (res) {
                    console.log(res)
                    heart.classList.remove('fa-heart-o')
                    heart.classList.add('fa-heart')
                    heart.style.color = 'red'
                    heart.setAttribute('value', true)
                },
                error: function (err) {
                    console.log("Lỗi Api")
                }
            })
        }
        if (heart.getAttribute('value') == 'true') {
            $.ajax({
                type: "Delete",
                dataType: "json",
                url: "https://localhost:44307/wishlists/remove",
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                data: JSON.stringify(data),
                success: function (res) {
                    console.log(res)
                    heart.classList.remove('fa-heart')
                    heart.classList.add('fa-heart-o')
                    heart.style.color = ''
                    heart.setAttribute('value', false)
                },
                error: function (err) {
                    console.log("Lỗi Api")
                }
            })
        }
        
    }
}

