local ParentParent = script.Parent.Parent.Parent
local ReactUtils = require(ParentParent.ReactUtils)
local GuiService = game:GetService("GuiService")
local React = require(ParentParent.React)
local useEventConnection = ReactUtils.useEventConnection

return function() -- line: 11
	-- upvalues: React (copy), GuiService (copy), useEventConnection (copy)
	local v6, v7 = React.useState(GuiService.TopbarInset)

	useEventConnection(GuiService:GetPropertyChangedSignal("TopbarInset"), function() -- line: 14
		-- upvalues: v7 (copy), GuiService (copy)
		v7(GuiService.TopbarInset)
	end)

	return v6
end
