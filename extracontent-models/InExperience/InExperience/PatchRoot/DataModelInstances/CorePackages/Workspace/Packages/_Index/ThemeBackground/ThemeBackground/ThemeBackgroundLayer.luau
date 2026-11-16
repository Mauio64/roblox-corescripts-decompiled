local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local GetThemeBackgroundStore = require(parent.Stores.GetThemeBackgroundStore)
local ThemeBackgroundFill = require(parent.ThemeBackgroundFill)
local ThemeBackgroundClippedFill = require(parent.ThemeBackgroundClippedFill)

local function ThemeBackgroundLayer(props)
	local themeBackgroundStore = GetThemeBackgroundStore(false)
	local image = props.image
	local baseColor = props.baseColor

	React.useLayoutEffect(function()
		themeBackgroundStore.setThemeBackground(image and { image = image, baseColor = baseColor } or nil)
		return function()
			themeBackgroundStore.setThemeBackground(nil)
		end
	end, { themeBackgroundStore, image, baseColor })

	local onPageChanged = React.useCallback(function(p)
		if p then
			themeBackgroundStore.setGeometry({
				position = p.AbsolutePosition,
				size = p.AbsoluteSize
			})
		end
	end, { themeBackgroundStore })

	local overscan = props.overscan or 0
	local clipRight = props.clipRight
	local createElement = React.createElement
	local fragment = React.Fragment
	local themeBackgroundClip

	if image and clipRight ~= nil then
		themeBackgroundClip = React.createElement(ThemeBackgroundClippedFill, {
			image = image,
			baseColor = baseColor,
			onPageChanged = onPageChanged,
			overscan = overscan,
			clipRight = clipRight
		})
	end

	local themeBackground

	if image and clipRight == nil then
		themeBackground = React.createElement(ThemeBackgroundFill, {
			image = image,
			baseColor = baseColor,
			onPageChanged = onPageChanged,
			Position = UDim2.fromOffset(-overscan, -overscan),
			Size = UDim2.new(1, overscan * 2, 1, overscan * 2)
		})
	end

	return createElement(fragment, nil, {
		ThemeBackgroundClip = themeBackgroundClip,
		ThemeBackground = themeBackground,
		Content = React.createElement(React.Fragment, nil, props.children)
	})
end

return ThemeBackgroundLayer
