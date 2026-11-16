local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatDetailsTelemetryEvents = require(AppChat.Components.ChatDetails.ChatDetailsTelemetryEvents)
local ChatDetailsTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDetailsTelemetryLayer)
local RoactUtils = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local FlexIconWithTextCell = require(AppChat.Components.Cells.FlexIconWithTextCell)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local useIsInExperience = require(AppChat.Hooks.useIsInExperience)

local v = {
	bodyText = "Placeholder body",
	subTitleText = "Placeholder subtitle",
	iconImage = nil,
	cellHeight = 48,
	onActivated = function() end
}

local function CreateUnfilteredChatCell(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()
	local style = joined.style or v2
	local v3 = useTokens()
	local v4 = useIsInExperience()
	local v5 = useTelemetry(ChatDetailsTelemetryLayer.Context)

	useEffectOnMount(function()
		v5.emit(ChatDetailsTelemetryEvents.ChatDetailsCreateUnfilteredChatCellRendered, {})
	end)

	local createElement = React.createElement
	local v6 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = joined.layoutOrder,
		Size = UDim2.fromScale(1, 0)
	}

	local createElement2 = React.createElement
	local v7 = {
		LayoutOrder = joined.layoutOrder,
		onActivated = joined.onActivated,
		primaryIcon = joined.iconImage,
		showDivider = false,
		Size = UDim2.new(1, 0, 0, joined.cellHeight),
		style = style,
		Text = joined.bodyText,
		SubTitleText = joined.subTitleText,
		isDisabled = joined.isLoading,
		BackgroundTransparency = 0
	}
	local backgroundTransparency

	if v4 then
		backgroundTransparency = v3.Color.None.Transparency
	end

	v7.BackgroundTransparency = backgroundTransparency
	return createElement("Frame", v6, {
		CreateUnfilteredChatRow = createElement2(FlexIconWithTextCell, v7)
	})
end

return CreateUnfilteredChatCell
