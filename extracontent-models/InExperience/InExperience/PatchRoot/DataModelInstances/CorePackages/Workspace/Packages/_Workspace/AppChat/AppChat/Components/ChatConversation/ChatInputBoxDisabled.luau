local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local InterventionShared = require(parent.InterventionShared)
local useCountdownBinding = InterventionShared.Hooks.useCountdownBinding

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable

local v = {
	bodyText = "Chat Disabled",
	defaultCountdownString = "",
	onActivated = function() end,
	contentVerticalAlignment = Enum.VerticalAlignment.Top
}

local function ChatInputBoxDisabled(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = Foundation.Hooks.useTokens()
	local text = useCountdownBinding(union.endTimestamp, union.defaultCountdownString)
	local textYAlignment

	if union.contentVerticalAlignment == Enum.VerticalAlignment.Center then
		textYAlignment = Enum.TextYAlignment.Center
	elseif union.contentVerticalAlignment == Enum.VerticalAlignment.Bottom then
		textYAlignment = Enum.TextYAlignment.Bottom
	else
		textYAlignment = Enum.TextYAlignment.Top
	end

	local createElement = React.createElement
	local onActivatedsByActivated = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[React.Event.Activated] = union.onActivated,
		ref = union.navigationTargetRef
	}
	local v3 = {
		uiListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v2.Gap.Small),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = union.contentVerticalAlignment,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		disabledText = React.createElement(Foundation.Text, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 1, 0),
			Text = union.bodyText,
			fontStyle = Cryo.Dictionary.join(v2.Typography.BodyLarge, {
				FontSize = union.contentSize
			}),
			TextSize = union.contentSize,
			textStyle = v2.Color.System.Alert,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = textYAlignment,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.AtEnd,
			tag = "fill",
			LayoutOrder = 1
		}),
		countdownText = 0,
		icon = 0
	}
	local countdownText

	if union.endTimestamp ~= nil then
		countdownText = React.createElement(Foundation.Text, {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			Text = text,
			fontStyle = Cryo.Dictionary.join(v2.Typography.BodyLarge, {
				FontSize = union.contentSize
			}),
			TextSize = union.contentSize,
			textStyle = v2.Color.Content.Emphasis,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = textYAlignment,
			TextWrapped = false,
			LayoutOrder = 2
		})
	end

	v3.countdownText = countdownText

	v3.icon = React.createElement(ImageSetLabel, {
		Size = UDim2.new(0, union.contentSize, 0, union.contentSize),
		BackgroundTransparency = 1,
		ImageColor3 = v2.Color.System.Alert.Color3,
		ImageTransparency = v2.Color.System.Alert.Transparency,
		Image = Images["icons/status/error_large"],
		LayoutOrder = 3
	})
	return createElement(Interactable, onActivatedsByActivated, v3)
end

return ChatInputBoxDisabled
