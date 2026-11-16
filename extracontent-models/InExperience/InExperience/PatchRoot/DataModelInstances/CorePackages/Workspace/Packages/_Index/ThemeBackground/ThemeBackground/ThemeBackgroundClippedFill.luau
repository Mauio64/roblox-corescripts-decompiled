local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local ThemeBackgroundFill = require(parent.ThemeBackgroundFill)

local function ThemeBackgroundClippedFill(props)
	local clipRight = props.clipRight
	local overscan = props.overscan

	local v, v2 = React.useBinding(0)
	local ref = React.useRef(nil)

	local v3 = React.useCallback(function()
		local current = ref.current

		if current == nil then
			return
		end

		local value = v:getValue()
		local v3 = current.AbsoluteSize.X + value
		local v4 = math.clamp(current.AbsolutePosition.X + v3 - clipRight, 0, v3)

		if v4 ~= value then
			v2(v4)
		end
	end, { v, clipRight })

	local ref2 = React.useCallback(function(current)
		ref.current = current
		v3()
	end, { v3 })

	React.useLayoutEffect(v3, { v3 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(-overscan, -overscan),
		Size = v:map(function(p: number)
			return UDim2.new(1, overscan * 2 - p, 1, overscan * 2)
		end),
		ZIndex = 0,
		ref = ref2,
		[React.Change.AbsolutePosition] = v3,
		[React.Change.AbsoluteSize] = v3
	}, {
		ThemeBackground = React.createElement(ThemeBackgroundFill, {
			image = props.image,
			baseColor = props.baseColor,
			onPageChanged = props.onPageChanged,
			Size = v:map(function(p: number)
				return UDim2.new(1, p, 1, 0)
			end)
		})
	})
end

return ThemeBackgroundClippedFill
