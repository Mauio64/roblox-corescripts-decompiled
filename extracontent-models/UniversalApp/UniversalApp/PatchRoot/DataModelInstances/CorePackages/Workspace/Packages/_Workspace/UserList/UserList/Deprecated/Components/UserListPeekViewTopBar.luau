local Parent = script:FindFirstAncestor("UserList").Parent
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)
local Foundation = require(Parent.Foundation)
local useTopBarHeight = require(Parent.RobloxAppHooks).useTopBarHeight
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local View = Foundation.View
local IconButton = Foundation.IconButton

return function(p1) -- line: 20
	-- upvalues: useSelector (copy), useTopBarHeight (copy), React (copy), View (copy), IconButton (copy)
	local v10 = useSelector(function(p2) -- line: 21
		return p2.TopBar.statusBarHeight
	end)
	local v11 = useTopBarHeight()
	local v12 = React.useCallback(function() -- line: 26
		-- upvalues: p1 (copy)
		p1.navigateBack()
	end, { p1.navigateBack })

	return React.createElement(View, {
		tag = "bg-surface-100",
		Active = true,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 0, 0, v11)
	}, {
		LeftNavigationButton = React.createElement(IconButton, {
			BackgroundTransparency = 1,
			icon = "icons/navigation/close",
			Position = UDim2.new(0, 15, 0, v10),
			onActivated = v12
		})
	})
end
