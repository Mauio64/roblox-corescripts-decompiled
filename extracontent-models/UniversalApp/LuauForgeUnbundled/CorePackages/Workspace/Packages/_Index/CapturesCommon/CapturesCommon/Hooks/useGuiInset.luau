local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")
local useEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/ReactUtils").useEventConnection

return function()
	local useState = React.useState
	local guiInset, v5 = GuiService:GetGuiInset()
	local state, setState = useState({
		bottom = v5.Y,
		left = guiInset.X,
		right = v5.X,
		top = guiInset.Y
	})

	local function fn()
		local guiInset2, v7 = GuiService:GetGuiInset()
		setState({ bottom = v7.Y, left = guiInset2.X, right = v7.X, top = guiInset2.Y })
	end

	useEventConnection(GuiService.SafeZoneOffsetsChanged, fn)
	useEventConnection(UserInputService:GetPropertyChangedSignal("BottomBarSize"), fn)
	useEventConnection(UserInputService:GetPropertyChangedSignal("RightBarSize"), fn)

	return state
end
