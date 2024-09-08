class_name Syncronizer extends Node

const INITIAL_BPM : float = 110

signal beat(beat_time:float)

@export var audio_stream:AudioStreamPlayer
@export var bpm:float = 110

var _bps:float
#var _bps:float = bpm / 60.0

var _last_beat:float = 0

# Called when the node enters the scene tree for the first time.
func start_stage() -> void:
	_bps = 60.0 / bpm
	play_audio_stream()

func play_audio_stream() -> void:
	var delay:float = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	await get_tree().create_timer(delay).timeout
	
	audio_stream.play()
	audio_stream.pitch_scale = bpm/INITIAL_BPM
	var effect : AudioEffectPitchShift = AudioServer.get_bus_effect(0, 0)
	effect.pitch_scale = 1/audio_stream.pitch_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var music_time:float = (audio_stream.get_playback_position() + AudioServer.get_time_to_next_mix() - AudioServer.get_output_latency())
	
	var beat_time:int = int(music_time / _bps)
	
	if beat_time > _last_beat:
		_last_beat = beat_time
		beat.emit(_last_beat)
