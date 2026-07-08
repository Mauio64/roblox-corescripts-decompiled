local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ControlState = require(scriptParent.Enum.ControlState)
local ControlStateEvent = require(scriptParent.Enum.ControlStateEvent)
local StateTable = require(ParentParent.StateTable.StateTable)

local function createGuiControlStateTable(p1: ((...any) -> ...any)) -- line: 17
	-- upvalues: StateTable (copy), ControlState (copy), ControlStateEvent (copy)
	local v8 = StateTable.new("GuiStateTable", ControlState.Initialize, {}, {
		[ControlState.Initialize] = {
			[ControlStateEvent.Idle] = {
				nextState = ControlState.Default
			},
			[ControlStateEvent.Enabled] = {
				nextState = ControlState.Default
			},
			[ControlStateEvent.Disabled] = {
				nextState = ControlState.Disabled
			}
		},
		[ControlState.Default] = {
			[ControlStateEvent.PrimaryPressed] = {
				nextState = ControlState.Pressed
			},
			[ControlStateEvent.PointerHover] = {
				nextState = ControlState.Hover
			},
			[ControlStateEvent.SelectionGained] = {
				nextState = ControlState.Selected
			},
			[ControlStateEvent.Disabled] = {
				nextState = ControlState.Disabled
			}
		},
		[ControlState.Hover] = {
			[ControlStateEvent.SelectionGained] = {
				nextState = ControlState.Selected
			},
			[ControlStateEvent.PrimaryPressed] = {
				nextState = ControlState.Pressed
			},
			[ControlStateEvent.PointerHoverEnd] = {
				nextState = ControlState.Default
			},
			[ControlStateEvent.Disabled] = {
				nextState = ControlState.Disabled
			}
		},
		[ControlState.Pressed] = {
			[ControlStateEvent.SelectionGained] = {
				nextState = ControlState.SelectedPressed
			},
			[ControlStateEvent.PrimaryReleasedHover] = {
				nextState = ControlState.Hover
			},
			[ControlStateEvent.PrimaryReleased] = {
				nextState = ControlState.Default
			},
			[ControlStateEvent.Disabled] = {
				nextState = ControlState.Disabled
			}
		},
		[ControlState.Selected] = {
			[ControlStateEvent.SelectionLost] = {
				nextState = ControlState.Default
			},
			[ControlStateEvent.PrimaryPressed] = {
				nextState = ControlState.SelectedPressed
			},
			[ControlStateEvent.Disabled] = {
				nextState = ControlState.Disabled
			}
		},
		[ControlState.SelectedPressed] = {
			[ControlStateEvent.SelectionLost] = {
				nextState = ControlState.Default
			},
			[ControlStateEvent.PrimaryReleasedHover] = {
				nextState = ControlState.Selected
			},
			[ControlStateEvent.PrimaryReleased] = {
				nextState = ControlState.Selected
			},
			[ControlStateEvent.Disabled] = {
				nextState = ControlState.Disabled
			}
		},
		[ControlState.Disabled] = {
			[ControlStateEvent.Enabled] = {
				nextState = ControlState.Default
			}
		}
	})

	v8:onStateChange(p1)

	return v8
end

return createGuiControlStateTable
