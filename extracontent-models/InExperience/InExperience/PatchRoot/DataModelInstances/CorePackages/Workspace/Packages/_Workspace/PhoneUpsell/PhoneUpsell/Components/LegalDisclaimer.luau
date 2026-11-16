local parent = script:FindFirstAncestor("PhoneUpsell").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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
		local createElement2 = React.createElement
		local v4 = {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v5 = {
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
			LegalText = 0
		}

		local createElement3 = React.createElement
		local v6 = {
			BackgroundTransparency = 1,
			Text = props.legalText,
			TextSize = baseSize * relativeSize,
			TextColor3 = v.Theme.TextDefault.Color,
			TextTransparency = v.Theme.TextDefault.Transparency,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			Size = 0,
			AutomaticSize = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = v.Font.Body.Font
		end

		v6.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font)
		end

		v6.FontFace = fontFace

		v6.TextXAlignment = Enum.TextXAlignment.Left

		v6.Size = UDim2.new(1, -(26 + size_150), 0, 0)
		v6.AutomaticSize = Enum.AutomaticSize.Y
		v5.LegalText = createElement3("TextLabel", v6)
		legalTextContainer = createElement2("Frame", v4, v5)
	else
		legalTextContainer = props.showLegalText

		if legalTextContainer then
			local createElement2 = React.createElement
			local v4 = {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Text = props.legalText,
				TextSize = baseSize * relativeSize,
				TextColor3 = v.Theme.TextDefault.Color,
				TextTransparency = v.Theme.TextDefault.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0,
				AutomaticSize = 0
			}
			local font

			if not FoundationFontFaceMigration then
				font = v.Font.Body.Font
			end

			v4.Font = font
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font)
			end

			v4.FontFace = fontFace

			v4.TextXAlignment = Enum.TextXAlignment.Left

			v4.Size = UDim2.new(1, 0, 0, 0)
			v4.AutomaticSize = Enum.AutomaticSize.Y
			legalTextContainer = createElement2("TextLabel", v4)
		end
	end

	v3.LegalTextContainer = legalTextContainer

	local legalButtonsContainer = props.showLegalButtons

	if legalButtonsContainer then
		local createElement2 = React.createElement
		local v4 = {
			LayoutOrder = 4,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local children = {
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
			TextButtonDivider = 0,
			PrivacyPolicyButton = 0
		}

		local createElement3 = React.createElement
		local v5 = {
			LayoutOrder = 6,
			BackgroundTransparency = 1,
			Text = "-",
			TextSize = baseSize * relativeSize,
			TextColor3 = v.Theme.TextDefault.Color,
			TextTransparency = v.Theme.TextDefault.Transparency,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			AutomaticSize = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = v.Font.Body.Font
		end

		v5.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font)
		end

		v5.FontFace = fontFace

		v5.TextXAlignment = Enum.TextXAlignment.Center

		v5.AutomaticSize = Enum.AutomaticSize.XY
		children.TextButtonDivider = createElement3("TextLabel", v5)

		children.PrivacyPolicyButton = React.createElement(LinkButton, {
			text = props.privacyPolicy,
			onActivated = props.onPrivacyPolicyClick,
			layoutOrder = 7,
			fontStyle = "CaptionBody"
		})
		legalButtonsContainer = createElement2("Frame", v4, children)
	end

	v3.LegalButtonsContainer = legalButtonsContainer
	return createElement("Frame", v2, v3)
end
