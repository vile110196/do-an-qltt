

$('.chatboxdiv').click(function () {

    if (document.querySelector('.chat-content-div-main').style.display == 'none')
        $('.chat-content-div-main').css('display', 'block')
    else if (document.querySelector('.chat-content-div-main').style.display != 'none')
        $('.chat-content-div-main').css('display', 'none')

})

let emojiList = document.getElementById('emojiList')
fetch('https://emoji-api.com/emojis?access_key=ed1f72e4e3197cb77b57114001402d3ccae7b78a')
    .then(res => res.json())
    .then(data => loadEmo(data.slice(0, 90)))

function loadEmo(data) {
    // console.log(data)
    data.forEach(emo => {
        let li = document.createElement('li')
        li.setAttribute('emoji-name', emo.slug)
        li.classList.add("item-emo")
        li.textContent = emo.character;
        emojiList.appendChild(li)

    })

    let inputquestion = document.getElementById('inputquestion')
    let item_emo = document.querySelectorAll('.item-emo')
    item_emo.forEach(ele => {
        ele.onclick = function () {
            console.log(ele.innerText)
            inputquestion.value = inputquestion.value + ele.innerText
            document.querySelector('.emojiListdiv').style.display = 'none'
        }
    })
}

document.querySelector('.fa-smile-o').onclick = function () {
    let emojiListdiv = document.querySelector('.emojiListdiv')
    if (emojiListdiv.style.display == 'none')
        emojiListdiv.style.display = 'block'
    else
        emojiListdiv.style.display = 'none'
}

function closemess() {
    $('.chat-content-div-main').css('display', 'none')
}

function clicktosend(uid) {
    console.log(uid)
    let data = {
        iduser: uid,
        question: $('#inputquestion').val()
    }
    console.log(data)
    $.ajax({
        type: "POST",
        url: "/users/addQuestion",
        data: JSON.stringify(data),
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        },
        success: function (res) {
            console.log(res)
            if (res.code == 0) {
                let send = document.createElement("p");
                send.classList.add('mess-send')
                let textsend = document.createTextNode($('#inputquestion').val());
                send.appendChild(textsend);
                document.querySelector('.main-message').appendChild(send)
                $('#inputquestion').val('')

                setTimeout(function () {
                    let to = document.createElement("p");
                    to.classList.add('mess-to')
                    let textto = document.createTextNode('Nhân viên chúng tôi sẽ phản hồi cho quý khách trong thời gian sớm nhất!');
                    to.appendChild(textto);
                    document.querySelector('.main-message').appendChild(to)
                }, 1500)
            }
        },
        error: function (e) {
            console.log("lỗi")
        }
    });
}