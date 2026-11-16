local UserInputService = game:GetService("UserInputService")

local KeyCode = Enum.KeyCode
local UserInputType = Enum.UserInputType

local controlLayouts = { KEYBOARD = "Keyboard", GAMEPAD = "Gamepad" }

local inputToControlTypeMap = {
	[Enum.UserInputType.MouseButton2] = controlLayouts.KEYBOARD,
	[Enum.UserInputType.MouseButton3] = controlLayouts.KEYBOARD,
	[Enum.UserInputType.MouseWheel] = controlLayouts.KEYBOARD,
	[Enum.UserInputType.MouseMovement] = controlLayouts.KEYBOARD,
	[Enum.UserInputType.Keyboard] = controlLayouts.KEYBOARD,
	[Enum.UserInputType.Gamepad1] = controlLayouts.GAMEPAD,
	[Enum.UserInputType.Gamepad2] = controlLayouts.GAMEPAD,
	[Enum.UserInputType.Gamepad3] = controlLayouts.GAMEPAD,
	[Enum.UserInputType.Gamepad4] = controlLayouts.GAMEPAD,
	[Enum.UserInputType.Gamepad5] = controlLayouts.GAMEPAD,
	[Enum.UserInputType.Gamepad6] = controlLayouts.GAMEPAD,
	[Enum.UserInputType.Gamepad7] = controlLayouts.GAMEPAD,
	[Enum.UserInputType.Gamepad8] = controlLayouts.GAMEPAD
}

local keybinds = {
	{
		title = "CoreScripts.InGameMenu.Controls.CharacterMovementTitle",
		controls = {
			{
				desc = "CoreScripts.InGameMenu.Controls.MoveForward",
				inputs = { KeyCode.Up, KeyCode.W }
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.MoveBackward",
				inputs = { KeyCode.Down, KeyCode.S }
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.MoveLeft",
				inputs = { KeyCode.A }
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.MoveRight",
				inputs = { KeyCode.D }
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.Jump",
				inputs = { KeyCode.Space }
			}
		}
	},
	{
		title = "CoreScripts.InGameMenu.Controls.CameraMovementTitle",
		controls = {
			{
				desc = "CoreScripts.InGameMenu.Controls.RotateCamera",
				inputs = { KeyCode.Left, KeyCode.Right, UserInputType.MouseButton2 }
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.ZoomInOutCamera",
				inputs = { UserInputType.MouseWheel }
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.ZoomInCamera",
				inputs = { KeyCode.I }
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.ZoomOutCamera",
				inputs = { KeyCode.O }
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.MouseLock",
				inputs = { KeyCode.LeftShift }
			}
		}
	},
	{
		title = "CoreScripts.InGameMenu.Controls.AccessoriesTitle",
		controls = {
			{
				desc = "CoreScripts.InGameMenu.Controls.EquipUnequipTools",
				inputs = { KeyCode.One, KeyCode.Two, KeyCode.Three },
				list = true
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.DropTool",
				inputs = { KeyCode.Backspace }
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.UseTool",
				inputs = { UserInputType.MouseButton1 }
			}
		}
	},
	{
		title = "CoreScripts.InGameMenu.Controls.MenuItemsTitle",
		controls = {
			{
				desc = "CoreScripts.InGameMenu.Controls.RobloxMenu",
				inputs = { KeyCode.Escape }
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.Backpack",
				inputs = { KeyCode.Tilde }
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.Playerlist",
				inputs = { KeyCode.Tab }
			},
			{
				desc = "CoreScripts.InGameMenu.Controls.Chat",
				inputs = { KeyCode.Slash }
			}
		}
	}
}

local v = {
	title = "CoreScripts.InGameMenu.Controls.MiscellaneousTitle",
	controls = {
		{
			desc = "CoreScripts.InGameMenu.Controls.GameMenuToggleGamepad",
			inputs = { KeyCode.BackSlash }
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.Screenshot",
			inputs = {
				{ KeyCode.LeftSuper, KeyCode.LeftShift, KeyCode.Three }
			}
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.DevConsole",
			inputs = {
				{ KeyCode.LeftMeta, KeyCode.F9 },
				KeyCode.F9
			}
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.GraphicsLevelUp",
			inputs = {
				{ KeyCode.LeftMeta, KeyCode.F10 },
				KeyCode.F10
			}
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.GraphicsLevelDown",
			inputs = {
				{ KeyCode.LeftMeta, KeyCode.LeftShift, KeyCode.F10 },
				{ KeyCode.LeftShift, KeyCode.F10 }
			}
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.ToggleFullscreen",
			inputs = {
				{ KeyCode.LeftControl, KeyCode.LeftSuper, KeyCode.F }
			}
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.PerformanceStats",
			inputs = {
				{ KeyCode.LeftMeta, KeyCode.LeftAlt, KeyCode.LeftSuper, KeyCode.F7 }
			}
		}
	}
}

local v2 = {
	title = "CoreScripts.InGameMenu.Controls.MiscellaneousTitle",
	controls = {
		{
			desc = "CoreScripts.InGameMenu.Controls.GameMenuToggleGamepad",
			inputs = { KeyCode.BackSlash }
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.Screenshot",
			inputs = { KeyCode.Print }
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.RecordVideo",
			inputs = { KeyCode.F12 }
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.DevConsole",
			inputs = { KeyCode.F9 }
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.GraphicsLevelUp",
			inputs = { KeyCode.F10 }
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.GraphicsLevelDown",
			inputs = {
				{ KeyCode.LeftShift, KeyCode.F10 }
			}
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.ToggleFullscreen",
			inputs = { KeyCode.F11 }
		},
		{
			desc = "CoreScripts.InGameMenu.Controls.PerformanceStats",
			inputs = {
				{ KeyCode.LeftControl, KeyCode.LeftShift, KeyCode.F7 }
			}
		}
	}
}

if UserInputService:GetPlatform() == Enum.Platform.OSX then
	table.insert(keybinds, v)
else
	table.insert(keybinds, v2)
end

return {
	ControlLayouts = controlLayouts,
	keybinds = keybinds,
	inputToControlTypeMap = inputToControlTypeMap,
	gamepadLabels = {
		left = {
			"CoreScripts.InGameMenu.Controls.SwitchToolGamepad",
			"CoreScripts.InGameMenu.Controls.GameMenuToggleGamepad",
			"CoreScripts.InGameMenu.Controls.MoveGamepad",
			"CoreScripts.InGameMenu.Controls.MenuNavigationGamepad"
		},
		right = {
			"CoreScripts.InGameMenu.Controls.UseTool",
			"CoreScripts.InGameMenu.Controls.RobloxMenu",
			"CoreScripts.InGameMenu.Controls.BackGamepad",
			"CoreScripts.InGameMenu.Controls.Jump"
		},
		camera = {
			"CoreScripts.InGameMenu.Controls.RotateCameraGamepad",
			"CoreScripts.InGameMenu.Controls.CameraZoomGamepad"
		}
	},
	questGamepadLabels = {
		{
			labelKey = "ResetCameraLabel",
			xPosition = -0.015,
			yPosition = 0.335,
			xAlignment = Enum.TextXAlignment.Right,
			width = 0.17
		},
		{
			labelKey = "MenuLabel",
			xPosition = -0.015,
			yPosition = 0.397,
			xAlignment = Enum.TextXAlignment.Right,
			width = 0.17
		},
		{
			labelKey = "SelectItemLabel",
			xPosition = 0.442,
			yPosition = 0.621,
			xAlignment = Enum.TextXAlignment.Center,
			width = 0.09
		},
		{
			labelKey = "BackExitLabel",
			xPosition = 0.818,
			yPosition = 0.287,
			xAlignment = Enum.TextXAlignment.Left,
			width = 0.17
		},
		{
			labelKey = "FirstPersonCameraLabel",
			xPosition = 0.818,
			yPosition = 0.342,
			xAlignment = Enum.TextXAlignment.Left,
			width = 0.17
		},
		{
			labelKey = "JumpSelectLabel",
			xPosition = 0.818,
			yPosition = 0.413,
			xAlignment = Enum.TextXAlignment.Left,
			width = 0.17
		}
	}
}
