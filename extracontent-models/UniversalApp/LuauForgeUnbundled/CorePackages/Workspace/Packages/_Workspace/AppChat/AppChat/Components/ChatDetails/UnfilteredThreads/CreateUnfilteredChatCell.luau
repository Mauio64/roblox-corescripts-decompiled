require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatDetailsTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ChatDetailsTelemetryEvents")
local ChatDetailsTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDetailsTelemetryLayer")
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useEffectOnMount

local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Style.useStyle

local FlexIconWithTextCell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/FlexIconWithTextCell")

local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation").Hooks.useTokens

local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")

local v5 = {
	bodyText = "Placeholder body",
	subTitleText = "Placeholder subtitle",
	iconImage = nil,
	cellHeight = 48,
	onActivated = function() end
}

local function CreateUnfilteredChatCell(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()
	local style = joined.style or v6
	local v7 = useTokens()
	local v8 = useIsInExperience()
	local v9 = useTelemetry(ChatDetailsTelemetryLayer.Context)

	useEffectOnMount(function()
		v9.emit(ChatDetailsTelemetryEvents.ChatDetailsCreateUnfilteredChatCellRendered, {})
	end)

	local createElement = React.createElement
	local v11 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = joined.layoutOrder,
		Size = UDim2.fromScale(1, 0)
	}

	local createElement2 = React.createElement
	local v14 = {
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
	local v15 = if v8 then v7.Color.None.Transparency else nil
	v14.BackgroundTransparency = v15
	return createElement("Frame", v11, {
		CreateUnfilteredChatRow = createElement2(FlexIconWithTextCell, v14)
	})
end

return CreateUnfilteredChatCell
