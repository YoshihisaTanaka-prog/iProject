function calculate_rest_time(time){
    document.getElementById('hour').innerHTML = time / 3600;
    document.getElementById('minute').innerHTML = (time / 60) % 60;
    document.getElementById('second').innerHTML = time % 60;
}