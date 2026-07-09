local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ExtraKeysEnum = require(ParentParent.Enums.ExtraKeysEnum)
local TouchControlsEnum = require(ParentParent.Enums.TouchControlsEnum)

require(script.Parent.ConfigTypes)

local FFlagEnableConsoleExpControls = require(ParentParentParent.SharedFlags).FFlagEnableConsoleExpControls
local t1 = {
	CharacterMovement = {
		layoutOrder = 1,
		label = "CoreScripts.InGameMenu.Controls.CharacterMovementTitle",
		id = "CharacterMovement"
	},
	Accessories = {
		layoutOrder = 2,
		label = "CoreScripts.InGameMenu.Controls.AccessoriesTitle",
		id = "Accessories"
	},
	Misc = {
		layoutOrder = 3,
		label = "CoreScripts.InGameMenu.Controls.MiscellaneousTitle",
		id = "Misc"
	},
	CameraMovement = {
		layoutOrder = 4,
		label = "CoreScripts.InGameMenu.Controls.CameraMovementTitle",
		id = "CameraMovement"
	},
	MenuItems = {
		layoutOrder = 5,
		label = "CoreScripts.InGameMenu.Controls.MenuItemsTitle",
		id = "MenuItems"
	}
}
local t2 = {
	MoveForward = {
		label = "CoreScripts.InGameMenu.Controls.MoveForward",
		keyboardInput = {
			layoutOrder = 1,
			input = {
				{ Enum.KeyCode.W },
				{ Enum.KeyCode.Up }
			},
			group = t1.CharacterMovement
		}
	},
	MoveBackward = {
		label = "CoreScripts.InGameMenu.Controls.MoveBackward",
		keyboardInput = {
			layoutOrder = 2,
			input = {
				{ Enum.KeyCode.S },
				{ Enum.KeyCode.Down }
			},
			group = t1.CharacterMovement
		}
	},
	MoveLeft = {
		label = "CoreScripts.InGameMenu.Controls.MoveLeft",
		keyboardInput = {
			layoutOrder = 3,
			input = {
				{ Enum.KeyCode.A },
				{ Enum.KeyCode.Left }
			},
			group = t1.CharacterMovement
		}
	},
	MoveRight = {
		label = "CoreScripts.InGameMenu.Controls.MoveRight",
		keyboardInput = {
			layoutOrder = 4,
			input = {
				{ Enum.KeyCode.D },
				{ Enum.KeyCode.Right }
			},
			group = t1.CharacterMovement
		}
	},
	Move = {
		label = "CoreScripts.InGameMenu.Controls.MoveGamepad",
		gamepadInput = {
			input = { Enum.KeyCode.Thumbstick1 }
		},
		touchInput = {
			thumbstickInput = { TouchControlsEnum.BottomLeftRotate },
			tapToMoveInput = { TouchControlsEnum.BottomLeftTap }
		}
	},
	Jump = {
		label = "CoreScripts.InGameMenu.Controls.Jump",
		keyboardInput = {
			layoutOrder = 5,
			input = {{ Enum.KeyCode.Space }},
			group = t1.CharacterMovement
		},
		gamepadInput = {
			input = { Enum.KeyCode.ButtonA }
		},
		touchInput = {
			thumbstickInput = { TouchControlsEnum.BottomRight },
			tapToMoveInput = { TouchControlsEnum.BottomRight }
		}
	},
	EquipUnequipTool = {
		label = "CoreScripts.InGameMenu.Controls.EquipUnequipTools",
		keyboardInput = {
			layoutOrder = 1,
			input = {{ ExtraKeysEnum.NumSequence }},
			group = t1.Accessories
		},
		touchInput = {
			thumbstickInput = { TouchControlsEnum.BottomMid },
			tapToMoveInput = { TouchControlsEnum.BottomMid }
		}
	},
	DropTool = {
		label = "CoreScripts.InGameMenu.Controls.DropTool",
		keyboardInput = {
			layoutOrder = 2,
			input = {{ Enum.KeyCode.Backspace }},
			group = t1.Accessories
		}
	},
	UseTool = {
		label = "CoreScripts.InGameMenu.Controls.UseTool",
		keyboardInput = {
			layoutOrder = 3,
			input = {{ Enum.KeyCode.MouseLeftButton }},
			group = t1.Accessories
		},
		gamepadInput = {
			xboxInput = { Enum.KeyCode.ButtonR2 },
			playstationInput = { Enum.KeyCode.ButtonR2 }
		},
		touchInput = {
			thumbstickInput = { TouchControlsEnum.TopMidTap },
			tapToMoveInput = { TouchControlsEnum.TopRightTap }
		}
	},
	SwitchTool = {
		label = "CoreScripts.InGameMenu.Controls.SwitchToolGamepad",
		gamepadInput = {
			xboxInput = {
				Enum.KeyCode.ButtonL1,
				Enum.KeyCode.ButtonR1
			},
			playstationInput = {
				Enum.KeyCode.ButtonL1,
				Enum.KeyCode.ButtonR1
			}
		}
	},
	UISelectionToggle = {
		label = "CoreScripts.InGameMenu.Controls.GameMenuToggleGamepad",
		keyboardInput = {
			layoutOrder = 1,
			input = {{ Enum.KeyCode.BackSlash }},
			group = t1.Misc
		}
	},
	Screenshot = {
		label = "CoreScripts.InGameMenu.Controls.Screenshot",
		keyboardInput = {
			layoutOrder = 2,
			macInput = {{
				Enum.KeyCode.RightAlt,
				Enum.KeyCode.One
			}},
			winInput = {{
				Enum.KeyCode.LeftAlt,
				Enum.KeyCode.One
			}},
			group = t1.Misc
		}
	},
	RecordVideo = {
		label = "CoreScripts.InGameMenu.Controls.RecordVideo",
		keyboardInput = {
			layoutOrder = 3,
			winInput = {{ Enum.KeyCode.F12 }},
			group = t1.Misc
		}
	},
	DevConsole = {
		label = "CoreScripts.InGameMenu.Controls.DevConsole",
		keyboardInput = {
			layoutOrder = 4,
			macInput = {
				{ Enum.KeyCode.F9 },
				{
					ExtraKeysEnum.Fn,
					Enum.KeyCode.F9
				}
			},
			winInput = {{ Enum.KeyCode.F9 }},
			group = t1.Misc
		}
	},
	Mouselock = {
		label = "CoreScripts.InGameMenu.Controls.MouseLock",
		keyboardInput = {
			layoutOrder = 5,
			input = {{ Enum.KeyCode.LeftShift }},
			group = t1.Misc
		}
	},
	GraphicsLevel = {
		label = "CoreScripts.InGameMenu.Controls.GraphicsLevel",
		keyboardInput = {
			layoutOrder = 6,
			macInput = {
				{ Enum.KeyCode.F10 },
				{
					ExtraKeysEnum.Fn,
					Enum.KeyCode.F10
				}
			},
			winInput = {{ Enum.KeyCode.F10 }},
			group = t1.Misc
		}
	},
	Fullscreen = {
		label = "CoreScripts.InGameMenu.Controls.ToggleFullscreen",
		keyboardInput = {
			layoutOrder = 7,
			macInput = {{
				Enum.KeyCode.LeftControl,
				Enum.KeyCode.LeftSuper,
				Enum.KeyCode.F
			}},
			winInput = {{ Enum.KeyCode.F11 }},
			group = t1.Misc
		}
	},
	PerfStats = {
		label = "CoreScripts.InGameMenu.Controls.PerformanceStats",
		keyboardInput = {
			layoutOrder = 8,
			macInput = {{
				ExtraKeysEnum.Fn,
				Enum.KeyCode.RightAlt,
				Enum.KeyCode.LeftSuper,
				Enum.KeyCode.F7
			}},
			winInput = {{
				Enum.KeyCode.LeftControl,
				Enum.KeyCode.LeftShift,
				Enum.KeyCode.F7
			}},
			group = t1.Misc
		}
	},
	Rotate = {
		label = "CoreScripts.InGameMenu.Controls.RotateCamera",
		keyboardInput = {
			layoutOrder = 1,
			input = {{ Enum.KeyCode.MouseRightButton }},
			group = t1.CameraMovement
		}
	},
	RotateCamera = {
		label = "CoreScripts.InGameMenu.Controls.RotateCameraGamepad",
		gamepadInput = {
			xboxInput = { Enum.KeyCode.Thumbstick2 },
			playstationInput = { Enum.KeyCode.Thumbstick2 }
		},
		touchInput = {
			thumbstickInput = { TouchControlsEnum.TopRightRotate },
			tapToMoveInput = { TouchControlsEnum.TopMidRotate }
		}
	},
	ZoomInOut = {
		label = "CoreScripts.InGameMenu.Controls.ZoomInOutCamera",
		keyboardInput = {
			layoutOrder = 2,
			input = {{ ExtraKeysEnum.MouseWheel }},
			group = t1.CameraMovement
		},
		touchInput = {
			thumbstickInput = { TouchControlsEnum.TopLeft },
			tapToMoveInput = { TouchControlsEnum.TopLeft }
		}
	},
	ZoomIn = {
		label = "CoreScripts.InGameMenu.Controls.ZoomInCamera",
		keyboardInput = {
			layoutOrder = 3,
			input = {{ Enum.KeyCode.I }},
			group = t1.CameraMovement
		}
	},
	ZoomOut = {
		label = "CoreScripts.InGameMenu.Controls.ZoomOutCamera",
		keyboardInput = {
			layoutOrder = 4,
			input = {{ Enum.KeyCode.O }},
			group = t1.CameraMovement
		}
	},
	CameraZoomGamepad = {
		label = "CoreScripts.InGameMenu.Controls.CameraZoomGamepad",
		gamepadInput = {
			xboxInput = { Enum.KeyCode.ButtonR3 },
			playstationInput = { Enum.KeyCode.ButtonR3 }
		}
	},
	FirstPersonCamera = {
		label = "CoreScripts.InGameMenu.Controls.ToggleCameraView",
		gamepadInput = {
			spatialGamepadInput = { Enum.KeyCode.ButtonR3 }
		}
	},
	RobloxMenu = {
		label = "CoreScripts.InGameMenu.Controls.RobloxMenu",
		keyboardInput = {
			layoutOrder = 1,
			input = {{ Enum.KeyCode.Escape }},
			group = t1.MenuItems
		},
		gamepadInput = {
			xboxInput = { Enum.KeyCode.ButtonStart },
			playstationInput = { Enum.KeyCode.ButtonStart },
			spatialGamepadInput = { Enum.KeyCode.ButtonSelect }
		}
	},
	MenuNavigationGamepad = {
		label = "CoreScripts.InGameMenu.Controls.MenuNavigationGamepad",
		gamepadInput = {
			xboxInput = { ExtraKeysEnum.DPad },
			playstationInput = { ExtraKeysEnum.DPad }
		}
	},
	GameMenuToggleGamepad = {
		label = "CoreScripts.InGameMenu.Controls.GameMenuToggle",
		gamepadInput = {
			playstationInput = { ExtraKeysEnum.TouchPad },
			xboxInput = { Enum.KeyCode.ButtonSelect }
		}
	},
	Backpack = {
		label = "CoreScripts.InGameMenu.Controls.Backpack",
		keyboardInput = {
			layoutOrder = 2,
			input = {{ Enum.KeyCode.Backquote }},
			group = t1.MenuItems
		}
	},
	Playerlist = {
		label = "CoreScripts.InGameMenu.Controls.Playerlist",
		keyboardInput = {
			layoutOrder = 3,
			input = {{ Enum.KeyCode.Tab }},
			group = t1.MenuItems
		}
	},
	Chat = {
		label = "CoreScripts.InGameMenu.Controls.Chat",
		keyboardInput = {
			layoutOrder = 4,
			input = {{ Enum.KeyCode.Slash }},
			group = t1.MenuItems
		},
		gamepadInput = {
			xboxInput = { Enum.KeyCode.ButtonL2 }
		}
	},
	Back = {
		label = "CoreScripts.InGameMenu.Controls.BackGamepad",
		gamepadInput = {
			input = { Enum.KeyCode.ButtonB }
		}
	}
}

if not FFlagEnableConsoleExpControls then
	t2.Chat.gamepadInput = nil
end

return {
	ControlGroups = t1,
	Controls = t2
}
