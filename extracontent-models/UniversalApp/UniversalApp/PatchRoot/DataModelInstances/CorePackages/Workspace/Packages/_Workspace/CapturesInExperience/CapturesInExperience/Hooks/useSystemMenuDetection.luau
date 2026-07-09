local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local useEventConnection = require(ParentParent.ReactUtils).useEventConnection
local useState = React.useState

local function useSystemMenuDetection() -- line: 12
	-- upvalues: useState (copy), useEventConnection (copy), GuiService (copy)
	local v7, v8 = useState(false)

	useEventConnection(GuiService.MenuOpened, function() -- line: 15
		-- upvalues: v8 (copy)
		v8(true)
	end)
	useEventConnection(GuiService.MenuClosed, function() -- line: 19
		-- upvalues: v8 (copy)
		v8(false)
	end)

	return v7
end

return useSystemMenuDetection
