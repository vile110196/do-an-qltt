window.onload = function () {
    const signUpButton = document.getElementById('signUp');
    const signInButton = document.getElementById('signIn');
    const container = document.getElementById('container');

    signUpButton.addEventListener('click', () => {
        container.classList.add("right-panel-active");
    });

    signInButton.addEventListener('click', () => {
        container.classList.remove("right-panel-active");
    });

    function checkPass_Repass() {
        $('#registerPassword, #confirm_password').on('keyup', function () {
            if ($('#password').val() != null && $('#confirm_password').val() != null) {
                if ($('#password').val() == $('#confirm_password').val()) {
                    $('#messageMatch').html('Mật khẩu trùng khớp').css('color', 'green');                }
                else {
                    $('#messageMatch').html('Mật khẩu không khớp').css('color', 'red');
                }
            }
        });
    }

    checkPass_Repass()


    $("#register-form").submit(function (event) {
            event.preventDefault();
            event.stopPropagation();
            const data = new FormData($("#register-form")[0])
            console.log($("#register-form")[0]);
            $.ajax({
                type: "POST",
                url: "/users/create",
                data: data,
                contentType: false,
                processData: false,
                success: function (res) {
                    if (res.code === 0) {
                        swal("good job!", "Đăng ký tài khoản thành công. Vui lòng đăng nhập!", "success")
                    } else {
                        console.log(res)
                        $('#messageMatch').html(res.message).css('color', 'red');
                    }
                },
                error: function (err) {
                    console.log(err)
                }
            })
    })

    $("#login-form").submit(function (event) {
        event.preventDefault();
        event.stopPropagation();

        let data = {
            email: $('#email-login').val(),
            phone: $('#email-login').val(),
            password: $('#password-login').val()
        }
        $.ajax({
            type: "POST",
            url: "/users/login",
            data: data,
            contenttype: "application/json",
            processdata: false,
            datatype: "json",
            success: function (res) {
                if (res.code === 0) {
                    swal("Thành công!", "Đăng nhập thành công", "success")
                        .then(() => {
                            window.location.href = "/"
                        })
                } else {
                    swal("Thất bại!", "Sai thông tin đăng nhập", "error")
                }
            },
            error: function (err) {
                console.log(err)
            }
        })
    })

    
}

//LẤY TOKEN QUA MAIL
$("#forgot-form").submit(function (event) {
    event.preventDefault();
    event.stopPropagation();
    const data = new FormData($("#forgot-form")[0])
    console.log($("#forgot-form")[0]);
    $.ajax({
        type: "POST",
        url: "/users/forgot",
        data: data,
        contentType: false,
        processData: false,
        success: function (res) {
            if (res.code === 0) {
                swal("Thành công!", "Vui lòng kiểm tra email của bạn", "success")
            } else {
                swal("Thất bại!", res.message, "error")
            }
        },
        error: function (err) {
            console.log(err)
        }
    })
})

//CẬP NHẬT LẠI PASSWORD
$("#reset-form").submit(function (event) {
    event.preventDefault();
    event.stopPropagation();

    let email = window.location.search.split("=")[1]
    if ($('#password').val() != $('#confirm_password').val()) {
        swal("Fail!", "Mật khẩu nhập lại không trùng khớp", "error")
    }
    else {
        const data = new FormData($("#reset-form")[0])
        $.ajax({
            type: "PUT",
            url: "/users/resetpass",
            data: {
                email: email,
                token: data.get("token"),
                password: data.get("password")
            },
            contenType: "application/json",
            datatype: "json",
            processdata: false,
            success: function (res) {
                if (res.code === 0) {
                    swal("Good job!", res.message, "success")
                        .then(() => {
                            location.href = "/dang-nhap";
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
    }

})