local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local useScreenSize = EconomyCommonCoreScriptHooks.useScreenSize
local constants = require(BulkPurchaseApp.constants)

local function FullPagePromptTwoPanelLayout(props)
	local v, v2 = React.useBinding(Vector2.new(0, 0))
	local v3 = useScreenSize()
	local v4 = useDesignTokens()
	local size_300 = v4.Size.Size_300
	local v5

	if v3.X < constants.MOBILE_BREAKPOINT then
		v5 = v3.X < v3.Y
	else
		v5 = false
	end

	local createElement = React.createElement
	local v6 = {
		Size = props.size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder
	}
	local v7 = {
		StartSlot = React.createElement("Frame", {
			Size = v:map(function(vector2: Vector2)
				if v5 then
					return (UDim2.new(1, 0, 1, -(vector2.Y + v4.Size.Size_600)))
				end

				return (UDim2.new(0.5, -size_300, 1, 0))
			end),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}, props.startSlot),
		EndSlot = 0
	}
	local createElement2 = React.createElement
	local size

	if v5 then
		size = UDim2.new(1, 0, 0, 0)
	else
		size = UDim2.new(0.5, -size_300, 0, 0)
	end

	local position

	if v5 then
		position = UDim2.new(0, 0, 1, 0)
	else
		position = UDim2.new(0.5, size_300, 0, 0)
	end

	local anchorPoint

	if v5 then
		anchorPoint = Vector2.new(0, 1)
	else
		anchorPoint = Vector2.new(0, 0)
	end

	v7.EndSlot = createElement2("Frame", {
		Size = size,
		Position = position,
		AnchorPoint = anchorPoint,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		[React.Change.AbsoluteSize] = function(p)
			v2(p.AbsoluteSize)
		end
	}, props.endSlot)
	return createElement("Frame", v6, v7)
end

return FullPagePromptTwoPanelLayout
