local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local useEventConnection = ReactUtils.useEventConnection
local useState = React.useState

local function useSystemMenuDetection()
	local state, setState = useState(false)

	useEventConnection(GuiService.MenuOpened, function()
		setState(true)
	end)

	useEventConnection(GuiService.MenuClosed, function()
		setState(false)
	end)

	return state
end

return useSystemMenuDetection
