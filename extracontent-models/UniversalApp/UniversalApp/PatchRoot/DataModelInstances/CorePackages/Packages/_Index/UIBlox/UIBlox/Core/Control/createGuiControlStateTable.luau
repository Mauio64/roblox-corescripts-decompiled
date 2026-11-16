local parent = script.Parent
local parent2 = parent.Parent.Parent

local ControlState = require(parent.Enum.ControlState)
local ControlStateEvent = require(parent.Enum.ControlStateEvent)

local StateTable = require(parent2.StateTable.StateTable)

local function createGuiControlStateTable(callback)
	local new = StateTable.new
	local initialize = ControlState.Initialize
	local v = {
		[ControlState.Initialize] = {
			[ControlStateEvent.Idle] = { nextState = ControlState.Default },
			[ControlStateEvent.Enabled] = { nextState = ControlState.Default },
			[ControlStateEvent.Disabled] = { nextState = ControlState.Disabled }
		}
	}

	local default = ControlState.Default
	v[default] = {
		[ControlStateEvent.PrimaryPressed] = { nextState = ControlState.Pressed },
		[ControlStateEvent.PointerHover] = { nextState = ControlState.Hover },
		[ControlStateEvent.SelectionGained] = { nextState = ControlState.Selected },
		[ControlStateEvent.Disabled] = { nextState = ControlState.Disabled }
	}

	local hover = ControlState.Hover
	v[hover] = {
		[ControlStateEvent.SelectionGained] = { nextState = ControlState.Selected },
		[ControlStateEvent.PrimaryPressed] = { nextState = ControlState.Pressed },
		[ControlStateEvent.PointerHoverEnd] = { nextState = ControlState.Default },
		[ControlStateEvent.Disabled] = { nextState = ControlState.Disabled }
	}

	local pressed = ControlState.Pressed
	v[pressed] = {
		[ControlStateEvent.SelectionGained] = { nextState = ControlState.SelectedPressed },
		[ControlStateEvent.PrimaryReleasedHover] = { nextState = ControlState.Hover },
		[ControlStateEvent.PrimaryReleased] = { nextState = ControlState.Default },
		[ControlStateEvent.Disabled] = { nextState = ControlState.Disabled }
	}

	local selected = ControlState.Selected
	v[selected] = {
		[ControlStateEvent.SelectionLost] = { nextState = ControlState.Default },
		[ControlStateEvent.PrimaryPressed] = { nextState = ControlState.SelectedPressed },
		[ControlStateEvent.Disabled] = { nextState = ControlState.Disabled }
	}

	local selectedPressed = ControlState.SelectedPressed
	v[selectedPressed] = {
		[ControlStateEvent.SelectionLost] = { nextState = ControlState.Default },
		[ControlStateEvent.PrimaryReleasedHover] = { nextState = ControlState.Selected },
		[ControlStateEvent.PrimaryReleased] = { nextState = ControlState.Selected },
		[ControlStateEvent.Disabled] = { nextState = ControlState.Disabled }
	}

	local disabled = ControlState.Disabled
	v[disabled] = {
		[ControlStateEvent.Enabled] = { nextState = ControlState.Default }
	}
	local guiStateTable = new("GuiStateTable", initialize, {}, v)

	guiStateTable:onStateChange(callback)

	return guiStateTable
end

return createGuiControlStateTable
