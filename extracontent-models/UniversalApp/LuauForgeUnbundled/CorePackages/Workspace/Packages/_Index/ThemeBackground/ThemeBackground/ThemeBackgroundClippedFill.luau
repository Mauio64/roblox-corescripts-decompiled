local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ThemeBackground/React")

local ThemeBackgroundFill = require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/ThemeBackgroundFill")

local function ThemeBackgroundClippedFill(props)
	local clipRight = props.clipRight
	local overscan = props.overscan

	local v5, v6 = React.useBinding(0)
	local ref = React.useRef(nil)

	local v7 = React.useCallback(function()
		local current = ref.current

		if current == nil then
			return
		end

		local value = v5:getValue()
		local v8 = current.AbsoluteSize.X + value
		local v9 = math.clamp(current.AbsolutePosition.X + v8 - clipRight, 0, v8)

		if v9 ~= value then
			v6(v9)
		end
	end, { v5, clipRight })

	local v8 = React.useCallback(function(current)
		ref.current = current
		v7()
	end, { v7 })

	React.useLayoutEffect(v7, { v7 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(-overscan, -overscan),
		Size = v5:map(function(p2)
			return UDim2.new(1, overscan * 2 - p2, 1, overscan * 2)
		end),
		ZIndex = 0,
		ref = v8,
		[React.Change.AbsolutePosition] = v7,
		[React.Change.AbsoluteSize] = v7
	}, {
		ThemeBackground = React.createElement(ThemeBackgroundFill, {
			image = props.image,
			baseColor = props.baseColor,
			onPageChanged = props.onPageChanged,
			Size = v5:map(function(p2)
				return UDim2.new(1, p2, 1, 0)
			end)
		})
	})
end

return ThemeBackgroundClippedFill
