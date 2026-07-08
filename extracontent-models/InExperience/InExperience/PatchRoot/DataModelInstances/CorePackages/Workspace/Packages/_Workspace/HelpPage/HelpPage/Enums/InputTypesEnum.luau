local t1 = {
	InputType = {
		KEYBOARD = "KEYBOARD",
		GAMEPAD = "GAMEPAD",
		TOUCH = "TOUCH",
		SPATIAL_GAMEPAD = "SPATIAL_GAMEPAD"
	}
}

table.freeze(t1.InputType)
table.freeze(t1)

return t1
