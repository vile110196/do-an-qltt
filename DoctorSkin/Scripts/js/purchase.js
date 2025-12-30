function convertJsonDate(jsonDate) {
    let date = new Date(parseInt(jsonDate.substr(6)));
    return date.toLocaleDateString() +"  "+ date.toLocaleTimeString();
}

function xemdanhgia(text) {
    let arr = text.split(",")
    console.log("ok2")
    $.ajax({
        type: "GET",
        url: "/users/getFeedbackByIdProduct",
        data: {
            iduser: arr[0],
            idbill: Number(arr[1]),
            idp: Number(arr[2])

        },
        contenttype: "application/json",
        processdata: false,
        datatype: "json",
        success: function (res) {
            console.log(res.data)
            let listStar = $('.list-star')
            let htmlStar = '';
            for (let i = 0; i < res.data.star; i++) {
                htmlStar += `<i class="fa fa-star" aria-hidden="true"></i>`;
            }
            listStar.html(htmlStar);
            $('.content-fb').text(res.data.cmt)
            $('.date-fb').text(convertJsonDate(res.data.datefb))

            let listimg = $('.list-imgfb')
            let arrImg = res.data.imagefb.split(',')
            if (arrImg[0]=='')
                listimg.css("display", "none")
            else
                listimg.css("display", "flex")
            let html =''
            for (let i = 0; i < arrImg.length; i++) {
                html += `<div style="width:20%;height:100px;margin-right:6px">
                                <img style="width:100%;height:100%;object-fit:cover" src="${arrImg[i]}">
                            </div>`;
            }
            listimg.html(html);
        },
        error: function (err) {
            console.log(err)
        }
    })
}

