local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RoactUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")

local useTopBarHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RobloxAppHooks").useTopBarHeight
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local view = Foundation.View
local iconButton = Foundation.IconButton

return function(p2)
	local v5 = useSelector(function(p3)
		return p3.TopBar.statusBarHeight
	end)

	local v6 = useTopBarHeight()

	local v7 = React.useCallback(function()
		p2.navigateBack()
	end, { p2.navigateBack })

	return React.createElement(view, {
		tag = "bg-surface-100",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 0, 0, v6),
		Active = true,
		BorderSizePixel = 0
	}, {
		LeftNavigationButton = React.createElement(iconButton, {
			Position = UDim2.new(0, 15, 0, v5),
			BackgroundTransparency = 1,
			onActivated = v7,
			icon = "icons/navigation/close"
		})
	})
end
