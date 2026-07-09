local Parent = script:FindFirstAncestor("PhoneUpsell").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Checkbox = require(Parent.Foundation).Checkbox
local LinkButton = UIBlox.App.Button.LinkButton
local useStyle = UIBlox.Core.Style.useStyle

return function(p1) -- line: 30
	-- upvalues: useStyle (copy), React (copy), Checkbox (copy), LinkButton (copy)
	local v8 = useStyle()
	local BaseSize = v8.Font.BaseSize
	local RelativeSize = v8.Font.CaptionHeader.RelativeSize
	local Size_150 = v8.Tokens.Size.Size_150

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = p1.LayoutOrder
	}, {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v8.Tokens.Size.Size_150)
		}),
		LegalTextContainer = if not p1.showLegalText or not p1.showLegalTextCheckbox then p1.showLegalText and React.createElement("TextLabel", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			TextWrapped = true,
			Text = p1.legalText,
			TextSize = BaseSize * RelativeSize,
			TextColor3 = v8.Theme.TextDefault.Color,
			TextTransparency = v8.Theme.TextDefault.Transparency,
			Font = v8.Font.Body.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}) else React.createElement("Frame", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, Size_150)
			}),
			LegalCheckbox = React.createElement(Checkbox, {
				label = "",
				onActivated = p1.setLegalTextChecked,
				isChecked = p1.legalTextChecked
			}),
			LegalText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				Text = p1.legalText,
				TextSize = BaseSize * RelativeSize,
				TextColor3 = v8.Theme.TextDefault.Color,
				TextTransparency = v8.Theme.TextDefault.Transparency,
				Font = v8.Font.Body.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, -(26 + Size_150), 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			})
		}),
		LegalButtonsContainer = p1.showLegalButtons and React.createElement("Frame", {
			LayoutOrder = 4,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 5)
			}),
			TermsOfUseButton = React.createElement(LinkButton, {
				layoutOrder = 5,
				fontStyle = "CaptionBody",
				text = p1.termsOfUse,
				onActivated = p1.onTermsOfUseClick
			}),
			TextButtonDivider = React.createElement("TextLabel", {
				LayoutOrder = 6,
				BackgroundTransparency = 1,
				Text = "-",
				TextWrapped = true,
				TextSize = BaseSize * RelativeSize,
				TextColor3 = v8.Theme.TextDefault.Color,
				TextTransparency = v8.Theme.TextDefault.Transparency,
				Font = v8.Font.Body.Font,
				TextXAlignment = Enum.TextXAlignment.Center,
				AutomaticSize = Enum.AutomaticSize.XY
			}),
			PrivacyPolicyButton = React.createElement(LinkButton, {
				layoutOrder = 7,
				fontStyle = "CaptionBody",
				text = p1.privacyPolicy,
				onActivated = p1.onPrivacyPolicyClick
			})
		})
	})
end
