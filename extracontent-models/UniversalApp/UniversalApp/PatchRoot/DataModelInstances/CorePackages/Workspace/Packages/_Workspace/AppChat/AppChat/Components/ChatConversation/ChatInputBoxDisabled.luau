local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useCountdownBinding = require(Parent.InterventionShared).Hooks.useCountdownBinding
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local t1 = {
	bodyText = "Chat Disabled",
	defaultCountdownString = "",
	onActivated = function() -- line: 26
	end
}

local function ChatInputBoxDisabled(t2: {[any]: any}) -- line: 29
	-- upvalues: Cryo (copy), t1 (copy), Foundation (copy), useCountdownBinding (copy), React (copy), Interactable (copy), ImageSetLabel (copy), Images (copy)
	local v13 = Cryo.Dictionary.union(t1, t2)
	local v14 = Foundation.Hooks.useTokens()
	local v15 = useCountdownBinding(v13.endTimestamp, v13.defaultCountdownString)

	return React.createElement(Interactable, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[React.Event.Activated] = v13.onActivated
	}, {
		uiListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v14.Gap.Small),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		disabledText = React.createElement(Foundation.Text, {
			BackgroundTransparency = 1,
			TextWrapped = false,
			tag = "fill",
			LayoutOrder = 1,
			Size = UDim2.new(0, 0, 1, 0),
			Text = v13.bodyText,
			Font = v13.font,
			TextSize = v13.contentSize,
			textStyle = v14.Color.System.Alert,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextTruncate = Enum.TextTruncate.AtEnd
		}),
		countdownText = if v13.endTimestamp == nil then nil else React.createElement(Foundation.Text, {
			BackgroundTransparency = 1,
			TextWrapped = false,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			Text = v15,
			Font = v13.font,
			TextSize = v13.contentSize,
			textStyle = v14.Color.Content.Emphasis,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Top
		}),
		icon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(0, v13.contentSize, 0, v13.contentSize),
			ImageColor3 = v14.Color.System.Alert.Color3,
			ImageTransparency = v14.Color.System.Alert.Transparency,
			Image = Images["icons/status/error_large"]
		})
	})
end

return ChatInputBoxDisabled
