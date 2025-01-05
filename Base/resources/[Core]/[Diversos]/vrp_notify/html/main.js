$(function() {
    window.addEventListener("message", function (event) {
        var _ = event.data;

        var audioPlayer = new Howl({ src: ["assets/demo.ogg"] });
        audioPlayer.volume(1);
        audioPlayer.play();

        var notificationDuration = 5000; // Duração da notificação em milissegundos
        var notifyDiv = $("<div class='notify'><div class='notify-titulo'><img class='icon' src='assets/sucesso.png'></div><div class='notify-type'>Sucesso</div><div class='notify-text'>" + _.NotifyString + "</div><div class='tempbar'></div></div>").appendTo("#container").hide().fadeIn(750);

        // Define a largura do tempbar e anima a sua diminuição
        notifyDiv.find('.tempbar').css('width', '100%').animate({ width: '0%' }, notificationDuration, function() {
            $(this).parent().fadeOut(750, function() {
                $(this).remove(); // Remove a notificação após o tempo
            });
        });

        // Seleciona o ícone e título corretos baseados no tipo de notificação
        switch (_.NotifyType) {
            case "sucesso":
                notifyDiv.find('.icon').attr('src', 'assets/sucesso.png');
                notifyDiv.find('.notify-type').text('Sucesso');
                notifyDiv.find('.tempbar').css('background-color', '#4caf50'); // Verde
                break;
            case "negado":
                notifyDiv.find('.icon').attr('src', 'assets/negado.png');
                notifyDiv.find('.notify-type').text('Negado');
                notifyDiv.find('.tempbar').css('background-color', '#ff0000'); // Vermelho
                break;
            case "rr":
                notifyDiv.find('.icon').remove(); // Se não precisar de ícone
                notifyDiv.find('.notify-type').text('Adrenum Sistema');
                notifyDiv.find('.tempbar').css('background-color', '#673AB7'); // Cor personalizada
                break;
            case "anuncio":
                notifyDiv.find('.icon').remove(); // Se não precisar de ícone
                notifyDiv.find('.notify-type').text('Equipe Adrenum');
                notifyDiv.find('.tempbar').css('background-color', '#9c27b0'); // Cor personalizada
                break;
            case "aviso":
                notifyDiv.find('.icon').attr('src', 'assets/aviso.png');
                notifyDiv.find('.notify-type').text('Aviso');
                notifyDiv.find('.tempbar').css('background-color', '#d6bb03'); // Amarelo
                break;
            case "importante":
                notifyDiv.find('.icon').attr('src', 'assets/importante.png');
                notifyDiv.find('.notify-type').text('Importante');
                notifyDiv.find('.tempbar').css('background-color', '#2196F3'); // Azul
                break;
            default:
                break;
        }
    });
});
