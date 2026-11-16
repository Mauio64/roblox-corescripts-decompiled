local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local Foundation = require(CorePackages.Packages.Foundation)
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local UIBlox = require(CorePackages.Packages.UIBlox)
local checkbox = Foundation.Checkbox

local withStyle = UIBlox.Style.withStyle

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local large = UIBlox.App.Constant.IconSize.Large

return function(data)
	return withStyle(function(props)
		local font = props.Font.Body.Font
		local v6 = props.Font.BaseSize * props.Font.Body.RelativeSize
		local transparency = props.Theme.TextDefault.Transparency
		local textColor = data.TextColor or props.Theme.TextDefault.Color

		local children = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, data.MainTextPadding or 0)
			})
		}

		if data.MainText then
			for i = 1, #data.MainText do
				local v7 = data.MainText[i]

				if typeof(v7) == "table" and data.showConsentCheckbox then
					local image = v7.image
					local content = v7.content

					local createElement = Roact.createElement
					local v9 = {
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1
					}

					local children2 = {
						Image = Roact.createElement(imageSetLabel, {
							Image = image,
							Size = UDim2.fromOffset(large, large),
							BackgroundTransparency = 1,
							ScaleType = Enum.ScaleType.Slice
						}),
						Layout = Roact.createElement("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Top,
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 12)
						}),
						Label = 0
					}

					local createElement2 = Roact.createElement

					local v12 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else font
					local v11 = {
						Text = content,
						TextColor3 = textColor,
						TextSize = v6,
						TextTransparency = transparency,
						Font = v12,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = #children,
						TextWrapped = true,
						RichText = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, -large, 0, 0),
						fitAxis = 0,
						width = 0
					}
					local v13 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
					v11.fitAxis = v13
					local v14 = if foundationFontFaceMigration then UDim.new(1, -large) else nil
					v11.width = v14
					children2.Label = createElement2(v5, v11)
					table.insert(children, createElement("Frame", v9, children2))
				else
					local createElement = Roact.createElement

					local v10 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else font
					local v9 = {
						Text = v7,
						TextColor3 = textColor,
						TextSize = v6,
						TextTransparency = transparency,
						Font = v10,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = #children,
						TextWrapped = true,
						RichText = data.showConsentCheckbox,
						TextXAlignment = 0,
						Size = 0,
						fitAxis = 0,
						width = 0
					}
					local v11 = if data.showConsentCheckbox then Enum.TextXAlignment.Left else Enum.TextXAlignment.Center
					v9.TextXAlignment = v11

					v9.Size = UDim2.new(1, 0, 0, 0)
					local v12 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
					v9.fitAxis = v12
					local v13 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
					v9.width = v13
					table.insert(children, createElement(v5, v9))
				end
			end

			if data.LocalizedOptOutText then
				table.insert(children, Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = #children,
					Size = UDim2.new(0, 0, 0, 25),
					AutomaticSize = Enum.AutomaticSize.XY
				}, { Roact.createElement("Frame", {
						Position = UDim2.fromScale(data.centerCheckbox and 0.5 or 0, 0.5),
						BackgroundTransparency = 1
					}, {
						Checkbox = Roact.createElement(checkbox, {
							label = data.LocalizedOptOutText,
							onActivated = data.onActivated,
							isChecked = data.checkboxSelected
						})
					}) }))
			end

			if data.showConsentCheckbox then
				local createElement = Roact.createElement
				local v8 = {
					BackgroundTransparency = 1,
					LayoutOrder = #children,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 25)
				}

				local createElement2 = Roact.createElement
				local v11 = {
					Position = UDim2.fromOffset(0, 12),
					Size = UDim2.new(1, 0, 0, 50),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y
				}
				local children2 = {
					Checkbox = not data.hideConsent and Roact.createElement(checkbox, {
						label = "",
						onActivated = data.consentActivated,
						isChecked = data.consentSelected
					}),
					CheckboxContent = 0,
					Layout = 0,
					Padding = 0
				}
				local v12

				if data.hideConsent then
					local createElement3 = Roact.createElement
					local v14 = {
						Text = data.consentText,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextColor3 = textColor,
						TextSize = v6,
						TextTransparency = transparency,
						Font = 0,
						FontFace = 0,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 10,
						TextWrapped = true,
						RichText = true,
						TextXAlignment = 0,
						Size = 0
					}

					if foundationFontFaceMigration then
						font = nil
					end

					v14.Font = font

					local v15 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
					v14.FontFace = v15

					v14.TextXAlignment = Enum.TextXAlignment.Left
					v14.Size = UDim2.new(1, -10, 0, 0)
					v12 = createElement3("TextLabel", v14)
				else
					local createElement3 = Roact.createElement
					local consentActivatedsByActivated = {}
					consentActivatedsByActivated.Text = data.consentText
					consentActivatedsByActivated.AutomaticSize = Enum.AutomaticSize.XY
					consentActivatedsByActivated.TextColor3 = textColor
					consentActivatedsByActivated.TextSize = v6
					consentActivatedsByActivated.TextTransparency = transparency

					if foundationFontFaceMigration then
						font = nil
					end

					consentActivatedsByActivated.Font = font

					local v14 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
					consentActivatedsByActivated.FontFace = v14

					consentActivatedsByActivated.BackgroundTransparency = 1
					consentActivatedsByActivated.BorderSizePixel = 0
					consentActivatedsByActivated.LayoutOrder = 10
					consentActivatedsByActivated.TextWrapped = true
					consentActivatedsByActivated.RichText = true
					consentActivatedsByActivated.TextXAlignment = Enum.TextXAlignment.Left
					consentActivatedsByActivated[Roact.Event.Activated] = data.consentActivated
					consentActivatedsByActivated.Size = UDim2.new(1, -10, 0, 0)
					v12 = createElement3("TextButton", consentActivatedsByActivated)
				end

				children2.CheckboxContent = v12

				children2.Layout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 10)
				})

				children2.Padding = Roact.createElement("UIPadding", {
					PaddingRight = UDim.new(0, 10)
				})
				local v9 = { createElement2("Frame", v11, children2) }
				table.insert(children, createElement("Frame", v8, v9))
			end
		end

		return Roact.createElement(
			FitChildren.FitFrame,
			{
				LayoutOrder = data.LayoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BackgroundTransparency = 1
			},
			children
		)
	end)
end
