let isPlaying = false;

function initAudio(src) {
	try {
		var sound      = document.createElement('audio');
		sound.id       = 'audio-player';
		sound.src      = src;
		sound.type     = 'audio/mpeg';
		sound.loop     = true;
		document.body.appendChild(sound);
		
		document.addEventListener('visibilitychange', manageAudio);
	} catch(error) {
		console.error('initAudio : ', error);
	}
}

function playAudio() {
	try {
		document.getElementById('audio-player').play().catch(error => console.error(error));
		isPlaying = true;
	} catch(error) {
		console.error('playAudio : ', error);
		isPlaying = false;
	}
}

function pauseAudio() {
	try {
		document.getElementById('audio-player').pause();
	} catch(error) {
		console.error('pauseAudio : ', error);
		isPlaying = false;
	}
}

function resumeAudio() {
	try {
		document.getElementById('audio-player').play().catch(error => console.error(error));
	} catch(error) {
		console.error('resumeAudio : ', error);
		isPlaying = false;
	}
}

function stopAudio() {
	try {
		document.getElementById('audio-player').pause();
		document.getElementById('audio-player').currentTime =0;
		isPlaying = false;
	} catch(error) {
		console.error('stopAudio : ', error);
		isPlaying = false;
	}
}

function manageAudio() {
	try {
		if (isPlaying) {
			if (document.hidden) {
				pauseAudio();
			} else {
				resumeAudio();
			}
		}
	} catch(error) {
		console.error('manageAudio : ', error);
	}
}