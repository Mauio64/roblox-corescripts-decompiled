local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/BuilderIcons")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local OptionsEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/OptionsEnum")

local FFlagAppChatEnableMessageContextMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEnableMessageContextMenu")
local SignalsMigrationConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/SignalsMigrationConfig")

local v5 = {
	LayoutOrder = 1,
	isIncoming = false,
	handleEvent = function(p2, p3, p4) end,
	emitImpressionTelemetryEvent = function() end
}

function LUAUFORGE_MODULE_GLOBALS_hnd_Options(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = Foundation.Hooks.useTokens()

	React.useEffect(function()
		union.emitImpressionTelemetryEvent()
	end, {})

	local v7 = React.useCallback(function()
		union.handleEvent(React.Event.Activated, nil, OptionsEnum.Reply)
	end, { union.handleEvent })

	local v8 = React.useCallback(function()
		union.handleEvent(React.Event.Activated, nil, OptionsEnum.MessageContextMenu)
	end, { union.handleEvent })

	local v9 = {
		Reply = React.createElement(Foundation.IconButton, {
			onActivated = v7,
			icon = BuilderIcons.Icon.ArrowThickToRight,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.InputSize.Medium,
			isCircular = true,
			LayoutOrder = union.isIncoming and 1 or -1
		}),
		MessageContextMenu = 0
	}

	local v10 = if FFlagAppChatEnableMessageContextMenu then React.createElement(Foundation.IconButton, {
		onActivated = v8,
		icon = BuilderIcons.Icon.ThreeDotsHorizontal,
		variant = Foundation.Enums.ButtonVariant.Standard,
		size = Foundation.Enums.InputSize.Medium,
		isCircular = true,
		LayoutOrder = union.isIncoming and 2 or -2
	}) else nil
	v9.MessageContextMenu = v10

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
				}, Cryo.Dictionary.join(v9, {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, v6.Gap.XXSmall)
					})
				}))
			}
		)
	end

	return React.createElement(
		Foundation.View,
		{ tag = "row auto-xy gap-xxsmall", LayoutOrder = union.LayoutOrder },
		v9
	)
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hnd_Options)
