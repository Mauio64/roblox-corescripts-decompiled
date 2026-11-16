local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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
	local text3 = useCountdownBinding(union.endTimestamp, union.defaultCountdownString)
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
	local children = {
		uiListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v2.Gap.Small),
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
	local v3 = {
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
	local font

	if not FoundationFontFaceMigration then
		font = union.font
	end

	v3.Font = font
	local fontStyle

	if FoundationFontFaceMigration then
		fontStyle = Cryo.Dictionary.join(v2.Typography.BodyLarge, { FontSize = union.contentSize })
	end

	v3.fontStyle = fontStyle

	v3.TextSize = union.contentSize
	v3.textStyle = v2.Color.System.Alert
	v3.TextXAlignment = Enum.TextXAlignment.Left
	v3.TextYAlignment = textYAlignment

	v3.TextTruncate = Enum.TextTruncate.AtEnd
	children.disabledText = createElement2(text, v3)
	local countdownText

	if union.endTimestamp ~= nil then
		local createElement3 = React.createElement
		local text2 = Foundation.Text
		local v4 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			Text = text3,
			Font = 0,
			fontStyle = 0,
			TextSize = 0,
			textStyle = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextWrapped = false,
			LayoutOrder = 2
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = union.font
		end

		v4.Font = font2
		local fontStyle2

		if FoundationFontFaceMigration then
			fontStyle2 = Cryo.Dictionary.join(v2.Typography.BodyLarge, {
				FontSize = union.contentSize
			})
		end

		v4.fontStyle = fontStyle2

		v4.TextSize = union.contentSize
		v4.textStyle = v2.Color.Content.Emphasis
		v4.TextXAlignment = Enum.TextXAlignment.Center
		v4.TextYAlignment = textYAlignment
		countdownText = createElement3(text2, v4)
	end

	children.countdownText = countdownText

	children.icon = React.createElement(ImageSetLabel, {
		Size = UDim2.new(0, union.contentSize, 0, union.contentSize),
		BackgroundTransparency = 1,
		ImageColor3 = v2.Color.System.Alert.Color3,
		ImageTransparency = v2.Color.System.Alert.Transparency,
		Image = Images["icons/status/error_large"],
		LayoutOrder = 3
	})
	return createElement(Interactable, onActivatedsByActivated, children)
end

return ChatInputBoxDisabled
