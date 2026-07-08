local ParentParent = script.Parent.Parent
local ControlState = require(ParentParent.Core.Control.Enum.ControlState)

require(ParentParent.App.Style.StyleTypes)

return function(p1, p2) -- line: 10
	-- upvalues: ControlState (copy)
	if p1 == ControlState.Initialize then
		return p2.Initialize
	end

	if p1 == ControlState.Default then
		return p2.Default
	end

	if p1 == ControlState.Pressed then
		return p2.Pressed
	end

	if p1 == ControlState.Hover then
		return p2.Hover
	end

	if p1 == ControlState.Selected then
		return p2.Selected
	end

	if p1 == ControlState.SelectedPressed then
		return p2.SelectedPressed
	end

	if p1 == ControlState.Disabled then
		return p2.Disabled
	end

	return nil
end
