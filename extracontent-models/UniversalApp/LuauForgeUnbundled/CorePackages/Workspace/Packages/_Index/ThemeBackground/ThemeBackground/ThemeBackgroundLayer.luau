local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ThemeBackground/React")

local GetThemeBackgroundStore = require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/Stores/GetThemeBackgroundStore")
local ThemeBackgroundFill = require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/ThemeBackgroundFill")
local ThemeBackgroundClippedFill = require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/ThemeBackgroundClippedFill")

local function ThemeBackgroundLayer(props)
	local v5 = GetThemeBackgroundStore(false)
	local image = props.image
	local baseColor = props.baseColor

	React.useLayoutEffect(function()
		v5.setThemeBackground(image and { image = image, baseColor = baseColor } or nil)
		return function()
			v5.setThemeBackground(nil)
		end
	end, { v5, image, baseColor })

	local v6 = React.useCallback(function(p2)
		if p2 then
			v5.setGeometry({ position = p2.AbsolutePosition, size = p2.AbsoluteSize })
		end
	end, { v5 })

	local overscan = props.overscan or 0
	local clipRight = props.clipRight
	local createElement = React.createElement
	local fragment = React.Fragment

	local v9 = if image and clipRight ~= nil then React.createElement(ThemeBackgroundClippedFill, {
		image = image,
		baseColor = baseColor,
		onPageChanged = v6,
		overscan = overscan,
		clipRight = clipRight
	}) else nil

	local v10 = if image and clipRight == nil then React.createElement(ThemeBackgroundFill, {
		image = image,
		baseColor = baseColor,
		onPageChanged = v6,
		Position = UDim2.fromOffset(-overscan, -overscan),
		Size = UDim2.new(1, overscan * 2, 1, overscan * 2)
	}) else nil
	return createElement(fragment, nil, {
		ThemeBackgroundClip = v9,
		ThemeBackground = v10,
		Content = React.createElement(React.Fragment, nil, props.children)
	})
end

return ThemeBackgroundLayer
