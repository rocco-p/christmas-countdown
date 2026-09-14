let isPlaying = false;

function initAudio(src) {
	try {
		var sound      = document.createElement('audio');
		sound.id       = 'audio-player';
		sound.src      = src;
		sound.type     = 'audio/mpeg';
		sound.loop	   = true;
		document.body.appendChild(sound);
	} catch(error) {
		console.error('initAudio : ', error);
	}
}

function playAudio() {
	try {
		document.getElementById('audio-player').play();
		isPlaying = true;
	} catch(error) {
		console.error('playAudio : ', error);
	}
}

function pauseAudio() {
	try {
		document.getElementById('audio-player').pause();
	} catch(error) {
		console.error('pauseAudio : ', error);
	}
}

function resumeAudio() {
	try {
		document.getElementById('audio-player').play();
		isPlaying = true;
	} catch(error) {
		console.error('resumeAudio : ', error);
	}
}

function stopAudio() {
	try {
		document.getElementById('audio-player').pause();
		document.getElementById('audio-player').currentTime =0;
		isPlaying = false;
	} catch(error) {
		console.error('stopAudio : ', error);
	}
}