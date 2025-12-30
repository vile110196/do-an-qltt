$(window).on("load", function () {
    function selectSearch() {
        let urlSearch = window.location.search
        const myOpts = Array.from(document.getElementById('selectSort').options);
        myOpts.map(ele => {
            if (ele.value == urlSearch.split("=")[1])
                ele.setAttribute("selected", true);
        });
    }
    selectSearch()

    function formatMoney() {
        let money = document.querySelectorAll('.money')
        money.forEach(ele => {
            let value = ele.getAttribute('value')
            ele.innerText = Number(value).toLocaleString('vi-VN', { style: 'currency', currency: 'VND' });
        })
    }
    formatMoney()
});

    