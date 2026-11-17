local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(parent.BuilderIcons)
require(Foundation.Enums.ControlState)
local Icon = require(Foundation.Components.Icon)
local TileIconIndicator = require(script.Parent.TileIconIndicator)
local View = require(Foundation.Components.View)
local blendColors = require(Foundation.Utility.blendColors)
local getStateLayerStyle = require(Foundation.Components.Interactable.getStateLayerStyle)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function TileIconMedia(props)
	local v = useTokens()
	local size_600 = v.Size.Size_600
	local size_1000 = v.Size.Size_1000

	local size_1200 = v.Size.Size_1200

	local v2, v3 = React.useBinding(0)
	local state, setState = React.useState(false)
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v3(p.AbsoluteSize.X)
		setState(p.AbsoluteSize.X <= size_1200)
	end, { size_1200 })

	local createElement = React.createElement
	local backgroundStyle

	if props.controlState then
		backgroundStyle = props.controlState:map(function(p)
			return blendColors(v.Color.Shift.Shift_200, getStateLayerStyle(v, nil, p))
		end)
	else
		backgroundStyle = v.Color.Shift.Shift_200
	end

	local v4 = {
		tag = "size-full-full radius-circle",
		backgroundStyle = backgroundStyle,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		testId = `{props.testId}--circle`
	}
	local v5 = {
		Icon = React.createElement(Icon, {
			name = props.icon,
			variant = props.iconVariant,
			size = v2:map(function(p: number)
				return (math.clamp(math.round(p * 0.4), size_600, size_1000))
			end),
			style = v.Color.Content.Emphasis,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			testId = `{props.testId}--icon`
		}),
		Indicator = 0
	}
	local indicator

	if props.indicator then
		indicator = React.createElement(TileIconIndicator, {
			indicator = props.indicator,
			isCompact = state,
			testId = props.testId
		})
	end

	v5.Indicator = indicator
	return createElement(View, v4, v5)
end

return React.memo(TileIconMedia)
