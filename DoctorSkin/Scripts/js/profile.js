$(document).ready(function () {
    let iduser = null;
    const nameuser = document.querySelector('#nameuser');
    if (nameuser.hasAttribute('data-id')) {
        iduser = nameuser.dataset.id;
    }

    let url = window.location.pathname
    const myOpts = Array.from(document.querySelectorAll('.choose'));
    myOpts.map(ele => {
        console.log(ele.childNodes[1].getAttribute('href'))
        if (ele.childNodes[1].getAttribute('href') == url)
            ele.classList.add('active');
    });

    $("#profile-form").submit(function (event) {
        event.preventDefault();
        event.stopPropagation();
        const data = new FormData($("#profile-form")[0])
        $.ajax({
            type: "PUT",
            url: "/users/edit",
            data: {
                iduser: iduser,
                name: data.get("name"),
                phone: data.get("phone"),
                birth: data.get("birth"),
                gender: data.get("gender")
            },
            contenType: "application/json",
            datatype: "json",
            processdata: false,
            success: function (res) {
                if (res.code === 0) {
                    swal("Good job!", res.message, "success")
                        .then(() => {

                        })
                } else {
                    console.log(res.data)
                    swal("Fail!", res.message, "error")
                }
            },
            error: function (err) {
                console.log(err)
            }
        })

        console.log("ok")
    })
});
