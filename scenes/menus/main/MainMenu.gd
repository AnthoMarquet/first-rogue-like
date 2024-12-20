extends Control

@onready var quit_dialog = %QuitDialog
@onready var start_button: Button = %StartButton


func _ready():
	ProgressionService.init()
	start_button.grab_focus()


func _on_start_button_pressed():
	print("Start button clicked")
	get_tree().change_scene_to_file("res://scenes/levels/Lobby.tscn")


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/credits/CreditsMenu.tscn")


func _on_quit_button_pressed():
	_ask_to_confirm_quit()


func _on_quit_dialog_confirmed():
	get_tree().quit()


func _ask_to_confirm_quit():
	quit_dialog.pop_in()
