local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local constants = require(scriptParentParent.constants)
local dependencies = require(scriptParentParent.dependencies)
local context = scriptParentParent.context

require(scriptParentParent.type)

local NotificationActionsFrame = require(scriptParent.NotificationActionsFrame)
local NotificationContentFrame = require(scriptParent.NotificationContentFrame)
local useNotificationCardData = require(context.useNotificationCardData)
local useNotificationCardState = require(context.useNotificationCardState)
local UIBlox = dependencies.UIBlox
local scriptParentParentParent = scriptParentParent.Parent
local React = require(scriptParentParentParent.React)
local useStyle = UIBlox.Core.Style.useStyle
local Interactable = UIBlox.Core.Control.Interactable
local DefaultCardPadding = constants.Padding.DefaultCardPadding
local DefaultContentPadding = constants.DefaultContentPadding
local DefaultCardCornerRadius = constants.DefaultCardCornerRadius

return function(t1: {[any]: any}) -- line: 32
	-- upvalues: useNotificationCardData (copy), constants (copy), DefaultCardPadding (copy), useStyle (copy), useNotificationCardState (copy), React (copy), Interactable (copy), DefaultCardCornerRadius (copy), DefaultContentPadding (copy), NotificationContentFrame (copy), NotificationActionsFrame (copy)
	local v19 = useNotificationCardData()
	local cardSize = v19.cardSize
	local v21 = if not v19.cardTransparency then constants.CardTransparency.Default else v19.cardTransparency
	local v22 = if not cardSize or not cardSize.cardPadding then DefaultCardPadding else cardSize.cardPadding
	local v23 = useStyle()
	local handleActions = v19.handleActions
	local v25 = useNotificationCardState("textBody")
	local v26 = v25 and v25[1]

	return React.createElement(Interactable, {
		AutoButtonColor = false,
		BackgroundColor3 = v23.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = v21,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		onStateChanged = function() -- line: 50
		end,
		Size = UDim2.new(1, 0, 0, 0),
		[React.Event.Activated] = function() -- line: 52
			-- upvalues: handleActions (copy), v26 (copy)
			if handleActions and v26 then
				handleActions(v26)
			end
		end
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = DefaultCardCornerRadius
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, DefaultContentPadding),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v22),
			PaddingLeft = UDim.new(0, v22),
			PaddingRight = UDim.new(0, v22),
			PaddingTop = UDim.new(0, v22)
		}),
		NotificationContentFrame = React.createElement(NotificationContentFrame, {
			showHoldButton = t1.showHoldButton,
			shouldAutoFocus = t1.shouldAutoFocus,
			holdProgress = t1.holdProgress
		}),
		NotificationActionsFrame = React.createElement(NotificationActionsFrame, {
			shouldAutoFocus = t1.shouldAutoFocus
		})
	})
end
