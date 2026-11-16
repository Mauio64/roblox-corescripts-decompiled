local v = { Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.ButtonA }

return {
	enter = v,
	exit = { Enum.KeyCode.Backspace, Enum.KeyCode.ButtonB },
	stepIncrement = {
		horizontal = { Enum.KeyCode.Right, Enum.KeyCode.DPadRight },
		vertical = { Enum.KeyCode.Up, Enum.KeyCode.DPadUp }
	},
	stepDecrement = {
		horizontal = { Enum.KeyCode.Left, Enum.KeyCode.DPadLeft },
		vertical = { Enum.KeyCode.Down, Enum.KeyCode.DPadDown }
	},
	thumbSwitch = v,
	coarseIncrement = { Enum.KeyCode.ButtonR1 },
	coarseDecrement = { Enum.KeyCode.ButtonL1 },
	analogStep = { Enum.KeyCode.Thumbstick1 },
	thumbstickDeadzone = 0.8
}
