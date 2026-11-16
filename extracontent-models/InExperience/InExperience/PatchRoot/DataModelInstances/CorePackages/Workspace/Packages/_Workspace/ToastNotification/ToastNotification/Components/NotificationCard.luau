local parent = script.Parent

local parent2 = parent.Parent
local constants = require(parent2.constants)
local dependencies = require(parent2.dependencies)
local context = parent2.context
require(parent2.type)
local NotificationActionsFrame = require(parent.NotificationActionsFrame)
local NotificationContentFrame = require(parent.NotificationContentFrame)
local useNotificationCardData = require(context.useNotificationCardData)
local useNotificationCardState = require(context.useNotificationCardState)

local uiBlox = dependencies.UIBlox

local parent3 = parent2.Parent
local React = require(parent3.React)

local useStyle = uiBlox.Core.Style.useStyle
local interactable = uiBlox.Core.Control.Interactable

local defaultCardPadding = constants.Padding.DefaultCardPadding
local defaultContentPadding = constants.DefaultContentPadding
local defaultCardCornerRadius = constants.DefaultCardCornerRadius

return function(props)
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

	local handleActions = v.handleActions
	local v4 = useNotificationCardState("textBody")
	local v5 = v4 and v4[1]
	return React.createElement(interactable, {
		AutoButtonColor = false,
		BackgroundColor3 = v3.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = backgroundTransparency,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		onStateChanged = function() end,
		Size = UDim2.new(1, 0, 0, 0),
		[React.Event.Activated] = function()
			if handleActions and v5 then
				handleActions(v5)
			end
		end
	}, {
		UICorner = React.createElement("UICorner", { CornerRadius = defaultCardCornerRadius }),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, defaultContentPadding),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v2),
			PaddingLeft = UDim.new(0, v2),
			PaddingRight = UDim.new(0, v2),
			PaddingTop = UDim.new(0, v2)
		}),
		NotificationContentFrame = React.createElement(NotificationContentFrame, {
			showHoldButton = props.showHoldButton,
			shouldAutoFocus = props.shouldAutoFocus,
			holdProgress = props.holdProgress
		}),
		NotificationActionsFrame = React.createElement(NotificationActionsFrame, {
			shouldAutoFocus = props.shouldAutoFocus
		})
	})
end
