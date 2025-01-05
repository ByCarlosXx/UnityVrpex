let actionContainer = $("body");
var type;
var imgDiret;
var fuel;
var body;
var engine;
var carselect = "nil" 
var pickedvehs = [];


$(document).ready(function(){
	window.addEventListener("message",function(event){
		let item = event.data;
        imgDiret = event.data.imgDiret;
		fuel = event.data.fuel;
		body = event.data.body;
		engine = event.data.engine;
        type = event.data.type;
        pickedvehs = [];

		switch(event.data.action){
			case "OpenTablet":
				updatewine_garagem(event.data);
				actionContainer.fadeIn(1000);
			break;

			case "CloseTablet":
				actionContainer.fadeOut(1000);
			break;
			
			case 'updateGarages':
                updateGarages(event.data);
            break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			actionContainer.fadeOut(1000);
			$.post("http://wine_garagem/close");
		}
	};
});
/* --------------------------------------------------- */
const updatewine_garagem = (data) => {
	const nameList = data.vehicles.sort((a, b) => (a.name > b.name) ? 1 : -1);
	//  data.vehicles.sort((a,b) => (a.name2 > b.name2) ? 1: -1);
	$("#displayHud").html(`
		<section class="list">
		${nameList.map((item) => (`
				<div class="item vehicle" data-name="${item.name}" ${item.id !== undefined ? "data-id=" + item.id : ''}>
						<div class="item-photo" style="
							-webkit-mask-image: linear-gradient(to left, transparent 25%, black 100%);
							background-image: url(${imgDiret}/${item.name}.png);
						">
						<div class="name-veh">
							<small>veiculo</small>
							<span>${item.vname}</span>
						</div>
						</div>
						<div class="item-info">
							<div class="column">
								<img src="./files/engine.png">
								<span>motor</span>
								<small>${engine}%</small>
							</div>
							<div class="column">
								<img src="./files/body.png">
								<span>lataria</span>
								<small>${body}%</small>
							</div>
							<div class="column">
								<img src="./files/fuel.png">
								<span>gasolina</span>
								<small>${fuel}%</small>
							</div>
						</div>
					</div>
			`)).join("")}
		</section>
		<footer>
			<strong><b>INFORMAÇÕES</b></strong>
			<p>Deixe suas dividas em dia <br>
				para evitar transtornos na garagem!</p>
		</footer>
		<div class="btns">
			<button id="spawnVehicle">
				<span>retirar</span>
				<small>veiculo selecionado</small>
			</button>
		</div>
	`);
}
/* --------------------------------------------------- */
$(document).on("click",".vehicle",function(){
	let $el = $(this);
	let isActive = $el.hasClass("active");
	$(".vehicle").removeClass("active");
	if(!isActive) $el.addClass("active");
});

$(document).on('click', '.section_content_item', function () {
	let $el = $('.section_content_item:hover');
    if(type == "work"){
	    $('.section_content_item').removeClass('active');
    }


	if ($el.attr('data-id')) {carselect = $el.attr('data-id')} else {carselect = $el.attr('data-name')};
})

$(document).on('click','.section_content_item',function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	if ($el.attr('data-id')) {carname = $el.attr('data-id')} else {carname = $el.attr('data-name')};

    // let carname = $el.attr('data-name');
	if(!isActive){
        $el.addClass('active');
        pickedvehs.push(carname);
    } else {
        $el.removeClass('active');
        const index = pickedvehs.indexOf(carname);
        if (index > -1) {
            pickedvehs.splice(index, 1);
        }
    }
});
/* --------------------------------------------------- */
$(document).on("click","#spawnVehicle",debounce(function(){
	let $el = $(".vehicle.active").attr("data-name");
	if(type == "work"){
		if($el){
			$.post("http://wine_garagem/SpawnVeh",JSON.stringify({ name: $el }));
		}
		}else {
			
       		$.post('http://wine_garagem/SelectCars', JSON.stringify({ vehicles: $el }));
		}
}));
/* --------------------------------------------------- */
$(document).on("click","#storeVehicle",function(){
	$.post("http://wine_garagem/deleteVehicles");
});
/* ----------DEBOUNCE---------- */
function debounce(func,immediate){
	var timeout
	return function(){
		var context = this,args = arguments
		var later = function(){
			timeout = null
			if (!immediate) func.apply(context,args)
		}
		var callNow = immediate && !timeout
		clearTimeout(timeout)
		timeout = setTimeout(later,500)
		if (callNow) func.apply(context,args)
	}
}