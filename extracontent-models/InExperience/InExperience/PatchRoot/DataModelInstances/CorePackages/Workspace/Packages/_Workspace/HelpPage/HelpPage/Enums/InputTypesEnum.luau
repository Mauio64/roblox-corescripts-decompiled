local InputTypesEnum = {
	InputType = {
		KEYBOARD = "KEYBOARD",
		GAMEPAD = "GAMEPAD",
		TOUCH = "TOUCH",
		SPATIAL_GAMEPAD = "SPATIAL_GAMEPAD"
	}
}

table.freeze(InputTypesEnum.InputType)
table.freeze(InputTypesEnum)

return InputTypesEnum
