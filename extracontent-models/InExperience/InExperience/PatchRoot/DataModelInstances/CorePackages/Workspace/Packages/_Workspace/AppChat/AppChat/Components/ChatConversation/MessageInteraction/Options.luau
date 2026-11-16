local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local BuilderIcons = require(parent.BuilderIcons)
local Cryo = require(parent.Cryo)
local OptionsEnum = require(script.Parent.OptionsEnum)

local FFlagAppChatEnableMessageContextMenu = require(AppChat.Flags.FFlagAppChatEnableMessageContextMenu)
local SignalsMigrationConfig = require(AppChat.Flags.SignalsMigrationConfig)

local v = {
	LayoutOrder = 1,
	isIncoming = false,
	handleEvent = function(_, _, _) end,
	emitImpressionTelemetryEvent = function() end
}

function Options(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = Foundation.Hooks.useTokens()

	React.useEffect(function()
		union.emitImpressionTelemetryEvent()
	end, {})

	local onActivated = React.useCallback(function()
		union.handleEvent(React.Event.Activated, nil, OptionsEnum.Reply)
	end, { union.handleEvent })

	local onActivated2 = React.useCallback(function()
		union.handleEvent(React.Event.Activated, nil, OptionsEnum.MessageContextMenu)
	end, { union.handleEvent })

	local v3 = {
		Reply = React.createElement(Foundation.IconButton, {
			onActivated = onActivated,
			icon = BuilderIcons.Icon.ArrowThickToRight,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.InputSize.Medium,
			isCircular = true,
			LayoutOrder = union.isIncoming and 1 or -1
		}),
		MessageContextMenu = 0
	}
	local messageContextMenu

	if FFlagAppChatEnableMessageContextMenu then
		messageContextMenu = React.createElement(Foundation.IconButton, {
			onActivated = onActivated2,
			icon = BuilderIcons.Icon.ThreeDotsHorizontal,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.InputSize.Medium,
			isCircular = true,
			LayoutOrder = union.isIncoming and 2 or -2
		})
	end

	v3.MessageContextMenu = messageContextMenu

	if SignalsMigrationConfig.shouldUseViewRecyclerMessageList then
		return React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(),
				LayoutOrder = union.LayoutOrder
			},
			{
				Buttons = React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.new()
				}, Cryo.Dictionary.join(v3, {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, v2.Gap.XXSmall)
					})
				}))
			}
		)
	end

	return React.createElement(
		Foundation.View,
		{ tag = "row auto-xy gap-xxsmall", LayoutOrder = union.LayoutOrder },
		v3
	)
end

return React.memo(Options)
