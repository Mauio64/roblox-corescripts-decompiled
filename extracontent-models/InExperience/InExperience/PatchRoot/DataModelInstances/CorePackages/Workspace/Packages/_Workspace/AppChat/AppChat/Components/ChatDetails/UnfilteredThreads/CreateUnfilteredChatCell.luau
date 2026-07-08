local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatDetailsTelemetryEvents = require(AppChat.Components.ChatDetails.ChatDetailsTelemetryEvents)
local ChatDetailsTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDetailsTelemetryLayer)
local useEffectOnMount = require(AppChatParent.RoactUtils).Hooks.useEffectOnMount
local useStyle = require(AppChatParent.UIBlox).Core.Style.useStyle
local FlexIconWithTextCell = require(AppChat.Components.Cells.FlexIconWithTextCell)
local useTokens = require(AppChatParent.Foundation).Hooks.useTokens
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local t1 = {
	bodyText = "Placeholder body",
	subTitleText = "Placeholder subtitle",
	iconImage = nil,
	cellHeight = 48,
	onActivated = function() -- line: 39
	end
}

local function CreateUnfilteredChatCell(t2: {[any]: any}) -- line: 44
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useTokens (copy), useIsInExperience (copy), useTelemetry (copy), ChatDetailsTelemetryLayer (copy), useEffectOnMount (copy), ChatDetailsTelemetryEvents (copy), React (copy), FlexIconWithTextCell (copy)
	local v16 = Cryo.Dictionary.join(t1, t2)
	local v17 = useStyle()
	local v18 = v16.style or v17
	local v19 = useTokens()
	local v20 = useIsInExperience()
	local v21 = useTelemetry(ChatDetailsTelemetryLayer.Context)

	useEffectOnMount(function() -- line: 52
		-- upvalues: v21 (copy), ChatDetailsTelemetryEvents (copy)
		v21.emit(ChatDetailsTelemetryEvents.ChatDetailsCreateUnfilteredChatCellRendered, {})
	end)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = v16.layoutOrder,
		Size = UDim2.fromScale(1, 0)
	}, {
		CreateUnfilteredChatRow = React.createElement(FlexIconWithTextCell, {
			showDivider = false,
			LayoutOrder = v16.layoutOrder,
			onActivated = v16.onActivated,
			primaryIcon = v16.iconImage,
			Size = UDim2.new(1, 0, 0, v16.cellHeight),
			style = v18,
			Text = v16.bodyText,
			SubTitleText = v16.subTitleText,
			isDisabled = v16.isLoading,
			BackgroundTransparency = if not v20 then nil else v19.Color.None.Transparency
		})
	})
end

return CreateUnfilteredChatCell
