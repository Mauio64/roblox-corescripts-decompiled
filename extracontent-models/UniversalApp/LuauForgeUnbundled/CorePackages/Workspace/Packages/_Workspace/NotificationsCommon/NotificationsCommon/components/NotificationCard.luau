local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/dependencies")
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/components/NotificationContentFrame")
local useStyle = uiBlox.Core.Style.useStyle
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/constants")
local useNotificationCardData = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/context/useNotificationCardData")

local defaultCardPadding = constants.Padding.DefaultCardPadding
local defaultContentPadding = constants.DefaultContentPadding
local defaultCardCornerRadius = constants.DefaultCardCornerRadius

return function(p2)
	local v5 = useNotificationCardData()
	local cardSize = v5.cardSize
	local v6 = if v5.cardTransparency then v5.cardTransparency else constants.CardTransparency.Default
	local v7 = if cardSize and cardSize.cardPadding then cardSize.cardPadding else defaultCardPadding
	local v8 = useStyle()

	return react.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = v8.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = v6,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = p2.layoutOrder
	}, {
		UICorner = react.createElement("UICorner", {
			CornerRadius = defaultCardCornerRadius
		}),
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, defaultContentPadding),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = react.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v7),
			PaddingLeft = UDim.new(0, v7),
			PaddingRight = UDim.new(0, v7),
			PaddingTop = UDim.new(0, v7)
		}),
		NotificationContentFrame = react.createElement(module2)
	})
end
