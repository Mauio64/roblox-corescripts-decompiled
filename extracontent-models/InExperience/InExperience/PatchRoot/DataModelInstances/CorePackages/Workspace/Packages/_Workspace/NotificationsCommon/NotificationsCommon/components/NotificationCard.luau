local parent = script.Parent
local parent2 = parent.Parent
local context = parent2.context
local dependencies = require(parent2.dependencies)
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local NotificationContentFrame = require(parent.NotificationContentFrame)
local useStyle = uiBlox.Core.Style.useStyle
local constants = require(parent2.constants)
local useNotificationCardData = require(context.useNotificationCardData)

local defaultCardPadding = constants.Padding.DefaultCardPadding
local defaultContentPadding = constants.DefaultContentPadding
local defaultCardCornerRadius = constants.DefaultCardCornerRadius

return function(p)
	local v = useNotificationCardData()
	local cardSize = v.cardSize
	local backgroundTransparency

	if v.cardTransparency then
		backgroundTransparency = v.cardTransparency
	else
		backgroundTransparency = constants.CardTransparency.Default
	end

	local v2

	if cardSize and cardSize.cardPadding then
		v2 = cardSize.cardPadding
	else
		v2 = defaultCardPadding
	end

	local v3 = useStyle()

	return react.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = v3.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = backgroundTransparency,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = p.layoutOrder
	}, {
		UICorner = react.createElement("UICorner", { CornerRadius = defaultCardCornerRadius }),
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, defaultContentPadding),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = react.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v2),
			PaddingLeft = UDim.new(0, v2),
			PaddingRight = UDim.new(0, v2),
			PaddingTop = UDim.new(0, v2)
		}),
		NotificationContentFrame = react.createElement(NotificationContentFrame)
	})
end
