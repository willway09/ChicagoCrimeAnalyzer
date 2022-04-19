let runClock = true;

function startClock(time) {
	if(time == 0) {
		runClock = true;
	} else if(!runClock) {
		console.log("Ending");
		runClock = true;
		return;
	}

	secStr = "" + time % 60;
	if(secStr.length == 1) {
		secStr = "0" + secStr;
	}

	minStr = "" + Math.floor(time / 60);
	if(minStr.length == 1) {
		minStr = "0" + minStr;
	}

	document.getElementById("clock").innerHTML = `${minStr}:${secStr}`
	setTimeout(() => {startClock(time + 1)}, 1000);
}

function stopClock() {
	console.log("Stopping");
	runClock = false;
}
