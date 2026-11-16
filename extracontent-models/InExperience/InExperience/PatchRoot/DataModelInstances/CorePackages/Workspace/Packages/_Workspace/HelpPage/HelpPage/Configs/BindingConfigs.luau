local parent = script.Parent.Parent
local parent2 = parent.Parent
local ExtraKeysEnum = require(parent.Enums.ExtraKeysEnum)
local TouchControlsEnum = require(parent.Enums.TouchControlsEnum)
require(script.Parent.ConfigTypes)
local SharedFlags = require(parent2.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagHelpPageCCL = require(parent.Flags.FFlagHelpPageCCL)

local controlGroups = {
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
		layoutOrder = FFlagHelpPageCCL and 4 or 3,
		label = "CoreScripts.InGameMenu.Controls.MiscellaneousTitle",
		id = "Misc"
	},
	CameraMovement = {
		layoutOrder = FFlagHelpPageCCL and 3 or 4,
		label = "CoreScripts.InGameMenu.Controls.CameraMovementTitle",
		id = "CameraMovement"
	},
	MenuItems = {
		layoutOrder = 5,
		label = "CoreScripts.InGameMenu.Controls.MenuItemsTitle",
		id = "MenuItems"
	}
}

local controls = {
	MoveForward = {
		label = "CoreScripts.InGameMenu.Controls.MoveForward",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.W },
				{ Enum.KeyCode.Up }
			},
			group = controlGroups.CharacterMovement,
			layoutOrder = 1
		}
	},
	MoveBackward = {
		label = "CoreScripts.InGameMenu.Controls.MoveBackward",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.S },
				{ Enum.KeyCode.Down }
			},
			group = controlGroups.CharacterMovement,
			layoutOrder = 2
		}
	},
	MoveLeft = {
		label = "CoreScripts.InGameMenu.Controls.MoveLeft",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.A },
				{ Enum.KeyCode.Left }
			},
			group = controlGroups.CharacterMovement,
			layoutOrder = 3
		}
	},
	MoveRight = {
		label = "CoreScripts.InGameMenu.Controls.MoveRight",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.D },
				{ Enum.KeyCode.Right }
			},
			group = controlGroups.CharacterMovement,
			layoutOrder = 4
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
			input = {
				{ Enum.KeyCode.Space }
			},
			group = controlGroups.CharacterMovement,
			layoutOrder = 5
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
			input = {
				{ ExtraKeysEnum.NumSequence }
			},
			group = controlGroups.Accessories,
			layoutOrder = 1
		},
		touchInput = {
			thumbstickInput = { TouchControlsEnum.BottomMid },
			tapToMoveInput = { TouchControlsEnum.BottomMid }
		}
	},
	DropTool = {
		label = "CoreScripts.InGameMenu.Controls.DropTool",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.Backspace }
			},
			group = controlGroups.Accessories,
			layoutOrder = 2
		}
	},
	UseTool = {
		label = "CoreScripts.InGameMenu.Controls.UseTool",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.MouseLeftButton }
			},
			group = controlGroups.Accessories,
			layoutOrder = 3
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
			xboxInput = { Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1 },
			playstationInput = { Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1 }
		}
	},
	UISelectionToggle = {
		label = "CoreScripts.InGameMenu.Controls.GameMenuToggleGamepad",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.BackSlash }
			},
			group = controlGroups.Misc,
			layoutOrder = 1
		}
	},
	Screenshot = {
		label = "CoreScripts.InGameMenu.Controls.Screenshot",
		keyboardInput = {
			macInput = {
				{ Enum.KeyCode.RightAlt, Enum.KeyCode.One }
			},
			winInput = {
				{ Enum.KeyCode.LeftAlt, Enum.KeyCode.One }
			},
			group = controlGroups.Misc,
			layoutOrder = 2
		}
	},
	RecordVideo = {
		label = "CoreScripts.InGameMenu.Controls.RecordVideo",
		keyboardInput = {
			winInput = {
				{ Enum.KeyCode.F12 }
			},
			group = controlGroups.Misc,
			layoutOrder = 3
		}
	},
	DevConsole = {
		label = "CoreScripts.InGameMenu.Controls.DevConsole",
		keyboardInput = {
			macInput = {
				{ Enum.KeyCode.F9 },
				{ ExtraKeysEnum.Fn, Enum.KeyCode.F9 }
			},
			winInput = {
				{ Enum.KeyCode.F9 }
			},
			group = controlGroups.Misc,
			layoutOrder = 4
		}
	},
	Mouselock = {
		label = "CoreScripts.InGameMenu.Controls.MouseLock",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.LeftShift }
			},
			group = controlGroups.Misc,
			layoutOrder = 5
		}
	},
	GraphicsLevel = {
		label = "CoreScripts.InGameMenu.Controls.GraphicsLevel",
		keyboardInput = {
			macInput = {
				{ Enum.KeyCode.F10 },
				{ ExtraKeysEnum.Fn, Enum.KeyCode.F10 }
			},
			winInput = {
				{ Enum.KeyCode.F10 }
			},
			group = controlGroups.Misc,
			layoutOrder = 6
		}
	},
	Fullscreen = {
		label = "CoreScripts.InGameMenu.Controls.ToggleFullscreen",
		keyboardInput = {
			macInput = {
				{ Enum.KeyCode.LeftControl, Enum.KeyCode.LeftSuper, Enum.KeyCode.F }
			},
			winInput = {
				{ Enum.KeyCode.F11 }
			},
			group = controlGroups.Misc,
			layoutOrder = 7
		}
	},
	PerfStats = {
		label = "CoreScripts.InGameMenu.Controls.PerformanceStats",
		keyboardInput = {
			macInput = {
				{ ExtraKeysEnum.Fn, Enum.KeyCode.RightAlt, Enum.KeyCode.LeftSuper, Enum.KeyCode.F7 }
			},
			winInput = {
				{ Enum.KeyCode.LeftControl, Enum.KeyCode.LeftShift, Enum.KeyCode.F7 }
			},
			group = controlGroups.Misc,
			layoutOrder = 8
		}
	},
	Rotate = {
		label = "CoreScripts.InGameMenu.Controls.RotateCamera",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.MouseRightButton }
			},
			group = controlGroups.CameraMovement,
			layoutOrder = 1
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
			input = {
				{ ExtraKeysEnum.MouseWheel }
			},
			group = controlGroups.CameraMovement,
			layoutOrder = 2
		},
		touchInput = {
			thumbstickInput = { TouchControlsEnum.TopLeft },
			tapToMoveInput = { TouchControlsEnum.TopLeft }
		}
	},
	ZoomIn = {
		label = "CoreScripts.InGameMenu.Controls.ZoomInCamera",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.I }
			},
			group = controlGroups.CameraMovement,
			layoutOrder = 3
		}
	},
	ZoomOut = {
		label = "CoreScripts.InGameMenu.Controls.ZoomOutCamera",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.O }
			},
			group = controlGroups.CameraMovement,
			layoutOrder = 4
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
			input = {
				{ Enum.KeyCode.Escape }
			},
			group = controlGroups.MenuItems,
			layoutOrder = 1
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
			input = {
				{ Enum.KeyCode.Backquote }
			},
			group = controlGroups.MenuItems,
			layoutOrder = 2
		}
	},
	Playerlist = {
		label = "CoreScripts.InGameMenu.Controls.Playerlist",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.Tab }
			},
			group = controlGroups.MenuItems,
			layoutOrder = 3
		}
	},
	Chat = {
		label = "CoreScripts.InGameMenu.Controls.Chat",
		keyboardInput = {
			input = {
				{ Enum.KeyCode.Slash }
			},
			group = controlGroups.MenuItems,
			layoutOrder = 4
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
	controls.Chat.gamepadInput = nil
end

return { ControlGroups = controlGroups, Controls = controls }
