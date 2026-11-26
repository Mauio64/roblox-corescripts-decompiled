local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useCountdownBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InterventionShared").Hooks.useCountdownBinding

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local interactable = UIBlox.Core.Control.Interactable

local v5 = {
	bodyText = "Chat Disabled",
	defaultCountdownString = "",
	onActivated = function() end,
	contentVerticalAlignment = Enum.VerticalAlignment.Top
}

local function ChatInputBoxDisabled(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = Foundation.Hooks.useTokens()
	local v7 = useCountdownBinding(union.endTimestamp, union.defaultCountdownString)
	local v8

	if union.contentVerticalAlignment == Enum.VerticalAlignment.Center then
		v8 = Enum.TextYAlignment.Center
	elseif union.contentVerticalAlignment == Enum.VerticalAlignment.Bottom then
		v8 = Enum.TextYAlignment.Bottom
	else
		v8 = Enum.TextYAlignment.Top
	end

	local createElement = React.createElement
	local onActivatedsByActivated = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[React.Event.Activated] = union.onActivated,
		ref = union.navigationTargetRef
	}
	local v10 = {
		uiListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v6.Gap.Small),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = union.contentVerticalAlignment,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		disabledText = React.createElement(Foundation.Text, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 1, 0),
			Text = union.bodyText,
			fontStyle = Cryo.Dictionary.join(v6.Typography.BodyLarge, {
				FontSize = union.contentSize
			}),
			TextSize = union.contentSize,
			textStyle = v6.Color.System.Alert,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = v8,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.AtEnd,
			tag = "fill",
			LayoutOrder = 1
		}),
		countdownText = 0,
		icon = 0
	}

	local v11 = if union.endTimestamp ~= nil then React.createElement(Foundation.Text, {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0),
		Text = v7,
		fontStyle = Cryo.Dictionary.join(v6.Typography.BodyLarge, {
			FontSize = union.contentSize
		}),
		TextSize = union.contentSize,
		textStyle = v6.Color.Content.Emphasis,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = v8,
		TextWrapped = false,
		LayoutOrder = 2
	}) else nil
	v10.countdownText = v11

	v10.icon = React.createElement(imageSetLabel, {
		Size = UDim2.new(0, union.contentSize, 0, union.contentSize),
		BackgroundTransparency = 1,
		ImageColor3 = v6.Color.System.Alert.Color3,
		ImageTransparency = v6.Color.System.Alert.Transparency,
		Image = images["icons/status/error_large"],
		LayoutOrder = 3
	})
	return createElement(interactable, onActivatedsByActivated, v10)
end

return ChatInputBoxDisabled
