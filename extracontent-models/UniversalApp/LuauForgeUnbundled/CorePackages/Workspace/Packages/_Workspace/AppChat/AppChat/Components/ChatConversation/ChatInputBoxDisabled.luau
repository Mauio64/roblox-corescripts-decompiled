local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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
	local children = {
		uiListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v6.Gap.Small),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = union.contentVerticalAlignment,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		disabledText = 0,
		countdownText = 0,
		icon = 0
	}

	local createElement2 = React.createElement
	local text = Foundation.Text
	local v10 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		Text = union.bodyText,
		Font = 0,
		fontStyle = 0,
		TextSize = 0,
		textStyle = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextWrapped = false,
		TextTruncate = 0,
		tag = "fill",
		LayoutOrder = 1
	}
	local v11 = if not foundationFontFaceMigration then union.font else nil
	v10.Font = v11

	local v12 = if foundationFontFaceMigration then Cryo.Dictionary.join(v6.Typography.BodyLarge, {
		FontSize = union.contentSize
	}) else nil
	v10.fontStyle = v12

	v10.TextSize = union.contentSize
	v10.textStyle = v6.Color.System.Alert
	v10.TextXAlignment = Enum.TextXAlignment.Left
	v10.TextYAlignment = v8

	v10.TextTruncate = Enum.TextTruncate.AtEnd
	children.disabledText = createElement2(text, v10)
	local v13

	if union.endTimestamp ~= nil then
		local createElement3 = React.createElement
		local text2 = Foundation.Text
		local v14 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			Text = v7,
			Font = 0,
			fontStyle = 0,
			TextSize = 0,
			textStyle = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextWrapped = false,
			LayoutOrder = 2
		}

		local v15 = if not foundationFontFaceMigration then union.font else nil
		v14.Font = v15

		local v16 = if foundationFontFaceMigration then Cryo.Dictionary.join(v6.Typography.BodyLarge, {
			FontSize = union.contentSize
		}) else nil
		v14.fontStyle = v16

		v14.TextSize = union.contentSize
		v14.textStyle = v6.Color.Content.Emphasis
		v14.TextXAlignment = Enum.TextXAlignment.Center
		v14.TextYAlignment = v8
		v13 = createElement3(text2, v14)
	end

	children.countdownText = v13

	children.icon = React.createElement(imageSetLabel, {
		Size = UDim2.new(0, union.contentSize, 0, union.contentSize),
		BackgroundTransparency = 1,
		ImageColor3 = v6.Color.System.Alert.Color3,
		ImageTransparency = v6.Color.System.Alert.Transparency,
		Image = images["icons/status/error_large"],
		LayoutOrder = 3
	})
	return createElement(interactable, onActivatedsByActivated, children)
end

return ChatInputBoxDisabled
