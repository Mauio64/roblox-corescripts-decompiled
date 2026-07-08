local Foundation = script:FindFirstAncestor("Foundation")
local scriptParent = script.Parent
local ControlState = require(Foundation.Enums.ControlState)

require(Foundation.Enums.ControlStateEvent)
require(scriptParent.StateTable.StateTable)

return {
	Initialize = {
		Idle = {
			nextState = ControlState.Default
		},
		Enabled = {
			nextState = ControlState.Default
		},
		Disabled = {
			nextState = ControlState.Disabled
		}
	},
	Default = {
		PrimaryPressed = {
			nextState = ControlState.Pressed
		},
		PointerHover = {
			nextState = ControlState.Hover
		},
		SelectionGained = {
			nextState = ControlState.Selected
		},
		Disabled = {
			nextState = ControlState.Disabled
		}
	},
	Hover = {
		SelectionGained = {
			nextState = ControlState.Selected
		},
		PrimaryPressed = {
			nextState = ControlState.Pressed
		},
		PointerHoverEnd = {
			nextState = ControlState.Default
		},
		Disabled = {
			nextState = ControlState.Disabled
		}
	},
	Pressed = {
		SelectionGained = {
			nextState = ControlState.SelectedPressed
		},
		PrimaryReleasedHover = {
			nextState = ControlState.Hover
		},
		PrimaryReleased = {
			nextState = ControlState.Default
		},
		Disabled = {
			nextState = ControlState.Disabled
		}
	},
	Selected = {
		SelectionLost = {
			nextState = ControlState.Default
		},
		PrimaryPressed = {
			nextState = ControlState.SelectedPressed
		},
		Disabled = {
			nextState = ControlState.Disabled
		}
	},
	SelectedPressed = {
		SelectionLost = {
			nextState = ControlState.Default
		},
		PrimaryReleasedHover = {
			nextState = ControlState.Selected
		},
		PrimaryReleased = {
			nextState = ControlState.Selected
		},
		Disabled = {
			nextState = ControlState.Disabled
		}
	},
	Disabled = {
		Enabled = {
			nextState = ControlState.Default
		}
	}
}
