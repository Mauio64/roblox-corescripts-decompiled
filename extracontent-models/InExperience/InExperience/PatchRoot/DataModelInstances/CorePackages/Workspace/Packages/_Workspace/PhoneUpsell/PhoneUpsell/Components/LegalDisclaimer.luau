local parent = script:FindFirstAncestor("PhoneUpsell").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local LinkButton = UIBlox.App.Button.LinkButton
local useStyle = UIBlox.Core.Style.useStyle

return function(props)
	local v = useStyle()

	local baseSize = v.Font.BaseSize
	local relativeSize = v.Font.CaptionHeader.RelativeSize
	local size_150 = v.Tokens.Size.Size_150

	local createElement = React.createElement
	local v2 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = props.LayoutOrder
	}
	local v3 = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v.Tokens.Size.Size_150)
		}),
		LegalTextContainer = 0,
		LegalButtonsContainer = 0
	}
	local legalTextContainer

	if props.showLegalText and props.showLegalTextCheckbox then
		legalTextContainer = React.createElement(
			"Frame",
			{
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, size_150)
				}),
				LegalCheckbox = React.createElement(Checkbox, {
					onActivated = props.setLegalTextChecked,
					isChecked = props.legalTextChecked,
					label = ""
				}),
				LegalText = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = props.legalText,
					TextSize = baseSize * relativeSize,
					TextColor3 = v.Theme.TextDefault.Color,
					TextTransparency = v.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					Size = UDim2.new(1, -(26 + size_150), 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				})
			}
		)
	else
		legalTextContainer = props.showLegalText and React.createElement("TextLabel", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Text = props.legalText,
			TextSize = baseSize * relativeSize,
			TextColor3 = v.Theme.TextDefault.Color,
			TextTransparency = v.Theme.TextDefault.Transparency,
			FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		})
	end

	v3.LegalTextContainer = legalTextContainer

	v3.LegalButtonsContainer = props.showLegalButtons
		and React.createElement(
			"Frame",
			{
				LayoutOrder = 4,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 5)
				}),
				TermsOfUseButton = React.createElement(LinkButton, {
					text = props.termsOfUse,
					onActivated = props.onTermsOfUseClick,
					layoutOrder = 5,
					fontStyle = "CaptionBody"
				}),
				TextButtonDivider = React.createElement("TextLabel", {
					LayoutOrder = 6,
					BackgroundTransparency = 1,
					Text = "-",
					TextSize = baseSize * relativeSize,
					TextColor3 = v.Theme.TextDefault.Color,
					TextTransparency = v.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.XY
				}),
				PrivacyPolicyButton = React.createElement(LinkButton, {
					text = props.privacyPolicy,
					onActivated = props.onPrivacyPolicyClick,
					layoutOrder = 7,
					fontStyle = "CaptionBody"
				})
			}
		)
	return createElement("Frame", v2, v3)
end
