local parent = script.Parent.Parent

local ControlState = require(parent.Core.Control.Enum.ControlState)
require(parent.App.Style.StyleTypes)

return function(p, data)
	if p == ControlState.Initialize then
		return data.Initialize
	end

	if p == ControlState.Default then
		return data.Default
	end

	if p == ControlState.Pressed then
		return data.Pressed
	end

	if p == ControlState.Hover then
		return data.Hover
	end

	if p == ControlState.Selected then
		return data.Selected
	end

	if p == ControlState.SelectedPressed then
		return data.SelectedPressed
	end

	return if p == ControlState.Disabled then data.Disabled else nil
end
