local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/constants")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/dependencies")

require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Components/NotificationActionsFrame")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Components/NotificationContentFrame")
local useNotificationCardData = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/context/useNotificationCardData")
local useNotificationCardState = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/context/useNotificationCardState")

local uiBlox = dependencies.UIBlox

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")

local useStyle = uiBlox.Core.Style.useStyle
local interactable = uiBlox.Core.Control.Interactable

local defaultCardPadding = constants.Padding.DefaultCardPadding
local defaultContentPadding = constants.DefaultContentPadding
local defaultCardCornerRadius = constants.DefaultCardCornerRadius

return function(props)
	local v5 = useNotificationCardData()
	local cardSize = v5.cardSize
	local v6 = if v5.cardTransparency then v5.cardTransparency else constants.CardTransparency.Default
	local v7 = if cardSize and cardSize.cardPadding then cardSize.cardPadding else defaultCardPadding
	local v8 = useStyle()

	local handleActions = v5.handleActions
	local v9 = useNotificationCardState("textBody")
	local v10 = v9 and v9[1]
	return React.createElement(interactable, {
		AutoButtonColor = false,
		BackgroundColor3 = v8.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = v6,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		onStateChanged = function() end,
		Size = UDim2.new(1, 0, 0, 0),
		[React.Event.Activated] = function()
			if handleActions and v10 then
				handleActions(v10)
			end
		end
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = defaultCardCornerRadius
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, defaultContentPadding),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v7),
			PaddingLeft = UDim.new(0, v7),
			PaddingRight = UDim.new(0, v7),
			PaddingTop = UDim.new(0, v7)
		}),
		NotificationContentFrame = React.createElement(module4, {
			showHoldButton = props.showHoldButton,
			shouldAutoFocus = props.shouldAutoFocus,
			holdProgress = props.holdProgress
		}),
		NotificationActionsFrame = React.createElement(module3, {
			shouldAutoFocus = props.shouldAutoFocus
		})
	})
end
