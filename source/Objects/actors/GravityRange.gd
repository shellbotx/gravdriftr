extends Area2D

signal sfx_finished

func _on_sfxRumble_finished():
    emit_signal("sfx_finished")
