local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local linkButton = UIBlox.App.Button.LinkButton
local useStyle = UIBlox.Core.Style.useStyle

return function(props)
	local v5 = useStyle()

	local baseSize = v5.Font.BaseSize
	local relativeSize = v5.Font.CaptionHeader.RelativeSize
	local size_150 = v5.Tokens.Size.Size_150

	local createElement = React.createElement
	local v7 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = props.LayoutOrder
	}
	local v8 = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v5.Tokens.Size.Size_150)
		}),
		LegalTextContainer = 0,
		LegalButtonsContainer = 0
	}
	local v9

	if props.showLegalText and props.showLegalTextCheckbox then
		v9 = React.createElement(
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
				LegalCheckbox = React.createElement(checkbox, {
					onActivated = props.setLegalTextChecked,
					isChecked = props.legalTextChecked,
					label = ""
				}),
				LegalText = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = props.legalText,
					TextSize = baseSize * relativeSize,
					TextColor3 = v5.Theme.TextDefault.Color,
					TextTransparency = v5.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					Size = UDim2.new(1, -(26 + size_150), 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				})
			}
		)
	else
		v9 = props.showLegalText and React.createElement("TextLabel", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Text = props.legalText,
			TextSize = baseSize * relativeSize,
			TextColor3 = v5.Theme.TextDefault.Color,
			TextTransparency = v5.Theme.TextDefault.Transparency,
			FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		})
	end

	v8.LegalTextContainer = v9

	v8.LegalButtonsContainer = props.showLegalButtons
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
				TermsOfUseButton = React.createElement(linkButton, {
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
					TextColor3 = v5.Theme.TextDefault.Color,
					TextTransparency = v5.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.XY
				}),
				PrivacyPolicyButton = React.createElement(linkButton, {
					text = props.privacyPolicy,
					onActivated = props.onPrivacyPolicyClick,
					layoutOrder = 7,
					fontStyle = "CaptionBody"
				})
			}
		)
	return createElement("Frame", v7, v8)
end
