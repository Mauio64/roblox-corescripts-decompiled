local parent = script:FindFirstAncestor("UserList").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local Foundation = require(parent.Foundation)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local View = Foundation.View
local IconButton = Foundation.IconButton

return function(p)
	local v = useSelector(function(p2)
		return p2.TopBar.statusBarHeight
	end)

	local v2 = useTopBarHeight()

	local onActivated = React.useCallback(function()
		p.navigateBack()
	end, { p.navigateBack })

	return React.createElement(View, {
		tag = "bg-surface-100",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 0, 0, v2),
		Active = true,
		BorderSizePixel = 0
	}, {
		LeftNavigationButton = React.createElement(IconButton, {
			Position = UDim2.new(0, 15, 0, v),
			BackgroundTransparency = 1,
			onActivated = onActivated,
			icon = "icons/navigation/close"
		})
	})
end
