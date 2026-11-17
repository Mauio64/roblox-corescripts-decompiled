local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Flags = require(Foundation.Utility.Flags)
local StatusIndicator = require(Foundation.Components.StatusIndicator)
local StatusIndicatorSize = require(Foundation.Enums.StatusIndicatorSize)
local StatusIndicatorVariant = require(Foundation.Enums.StatusIndicatorVariant)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local getStatusIndicatorSize = require(Foundation.Components.StatusIndicator.getStatusIndicatorSize)
local useTokens = require(Foundation.Providers.Style.useTokens)

local vector2 = Vector2.new(0.8885729807284855, 0.1853398044750813)

local function TileIconIndicator(props)
	local v = useTokens()
	local indicator = props.indicator
	local v2 = indicator.value ~= nil
	local size

	if v2 then
		if props.isCompact then
			size = StatusIndicatorSize.Medium
		else
			size = StatusIndicatorSize.Large
		end
	else
		size = StatusIndicatorSize.Small
	end

	local v3

	if v2 and not Flags.FoundationStatusIndicatorDesignUpdate then
		v3 = StatusIndicatorSize.Medium
	else
		v3 = size
	end

	local statusIndicatorSize = getStatusIndicatorSize(v, v3, v2)
	local mask = indicator.mask or v.Color.Surface.Surface_0
	local formatted = `{props.testId}--status-indicator`

	local createElement = React.createElement
	local v4 = {
		tag = "auto-x",
		Size = UDim2.fromOffset(0, statusIndicatorSize),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(vector2.X, statusIndicatorSize / 2, vector2.Y, 0),
		ZIndex = 3
	}
	local indicator2

	if indicator.value == nil then
		indicator2 = React.createElement(StatusIndicator, {
			variant = indicator.variant or StatusIndicatorVariant.Emphasis,
			size = size,
			mask = mask,
			testId = formatted
		})
	else
		indicator2 = React.createElement(StatusIndicator, {
			value = indicator.value,
			max = indicator.max,
			variant = indicator.variant or StatusIndicatorVariant.Emphasis,
			size = size,
			mask = mask,
			testId = formatted
		})
	end

	return createElement(View, v4, { Indicator = indicator2 })
end

return React.memo(TileIconIndicator)
