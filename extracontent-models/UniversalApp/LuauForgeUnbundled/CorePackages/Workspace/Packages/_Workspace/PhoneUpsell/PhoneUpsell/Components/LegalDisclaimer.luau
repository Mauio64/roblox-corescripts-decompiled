local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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
		local createElement2 = React.createElement
		local v11 = {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v12 = {
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
			LegalText = 0
		}

		local createElement3 = React.createElement
		local v14 = {
			BackgroundTransparency = 1,
			Text = props.legalText,
			TextSize = baseSize * relativeSize,
			TextColor3 = v5.Theme.TextDefault.Color,
			TextTransparency = v5.Theme.TextDefault.Transparency,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			Size = 0,
			AutomaticSize = 0
		}
		local v15 = if not foundationFontFaceMigration then v5.Font.Body.Font else nil
		v14.Font = v15

		local v16 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font) else nil
		v14.FontFace = v16

		v14.TextXAlignment = Enum.TextXAlignment.Left

		v14.Size = UDim2.new(1, -(26 + size_150), 0, 0)
		v14.AutomaticSize = Enum.AutomaticSize.Y
		v12.LegalText = createElement3("TextLabel", v14)
		v9 = createElement2("Frame", v11, v12)
	else
		v9 = props.showLegalText

		if v9 then
			local createElement2 = React.createElement
			local v11 = {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Text = props.legalText,
				TextSize = baseSize * relativeSize,
				TextColor3 = v5.Theme.TextDefault.Color,
				TextTransparency = v5.Theme.TextDefault.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0,
				AutomaticSize = 0
			}
			local v12 = if not foundationFontFaceMigration then v5.Font.Body.Font else nil
			v11.Font = v12

			local v13 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font) else nil
			v11.FontFace = v13

			v11.TextXAlignment = Enum.TextXAlignment.Left

			v11.Size = UDim2.new(1, 0, 0, 0)
			v11.AutomaticSize = Enum.AutomaticSize.Y
			v9 = createElement2("TextLabel", v11)
		end
	end

	v8.LegalTextContainer = v9

	local v10 = props.showLegalButtons

	if v10 then
		local createElement2 = React.createElement
		local v12 = {
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
			TermsOfUseButton = React.createElement(linkButton, {
				text = props.termsOfUse,
				onActivated = props.onTermsOfUseClick,
				layoutOrder = 5,
				fontStyle = "CaptionBody"
			}),
			TextButtonDivider = 0,
			PrivacyPolicyButton = 0
		}

		local createElement3 = React.createElement
		local v14 = {
			LayoutOrder = 6,
			BackgroundTransparency = 1,
			Text = "-",
			TextSize = baseSize * relativeSize,
			TextColor3 = v5.Theme.TextDefault.Color,
			TextTransparency = v5.Theme.TextDefault.Transparency,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			AutomaticSize = 0
		}
		local v15 = if not foundationFontFaceMigration then v5.Font.Body.Font else nil
		v14.Font = v15

		local v16 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font) else nil
		v14.FontFace = v16

		v14.TextXAlignment = Enum.TextXAlignment.Center

		v14.AutomaticSize = Enum.AutomaticSize.XY
		children.TextButtonDivider = createElement3("TextLabel", v14)

		children.PrivacyPolicyButton = React.createElement(linkButton, {
			text = props.privacyPolicy,
			onActivated = props.onPrivacyPolicyClick,
			layoutOrder = 7,
			fontStyle = "CaptionBody"
		})
		v10 = createElement2("Frame", v12, children)
	end

	v8.LegalButtonsContainer = v10
	return createElement("Frame", v7, v8)
end
