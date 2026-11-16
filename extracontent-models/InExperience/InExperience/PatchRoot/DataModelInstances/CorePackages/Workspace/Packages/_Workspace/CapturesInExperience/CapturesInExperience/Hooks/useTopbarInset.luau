local parent = script.Parent.Parent.Parent
local ReactUtils = require(parent.ReactUtils)

local GuiService = game:GetService("GuiService")

local React = require(parent.React)

local useEventConnection = ReactUtils.useEventConnection

return function()
	local state, setState = React.useState(GuiService.TopbarInset)

	useEventConnection(GuiService:GetPropertyChangedSignal("TopbarInset"), function()
		setState(GuiService.TopbarInset)
	end)

	return state
end
