local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel

local UIBlox = require(CorePackages.Packages.UIBlox)
local checkbox = Foundation.Checkbox

local withStyle = UIBlox.Style.withStyle

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local large = UIBlox.App.Constant.IconSize.Large

return function(data)
	return withStyle(function(props)
		local v5 = props.Font.BaseSize * props.Font.Body.RelativeSize
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
				local v6 = data.MainText[i]

				if typeof(v6) == "table" and data.showConsentCheckbox then
					local image = v6.image
					local content = v6.content
					table.insert(
						children,
						Roact.createElement(
							"Frame",
							{
								AutomaticSize = Enum.AutomaticSize.XY,
								BackgroundTransparency = 1
							},
							{
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
								Label = Roact.createElement(fitTextLabel, {
									Text = content,
									TextColor3 = textColor,
									TextSize = v5,
									TextTransparency = transparency,
									Font = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									LayoutOrder = #children,
									TextWrapped = true,
									RichText = true,
									TextXAlignment = Enum.TextXAlignment.Left,
									Size = UDim2.new(1, -large, 0, 0),
									width = UDim.new(1, -large)
								})
							}
						)
					)
				else
					local createElement = Roact.createElement
					local v8 = {
						Text = v6,
						TextColor3 = textColor,
						TextSize = v5,
						TextTransparency = transparency,
						Font = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = #children,
						TextWrapped = true,
						RichText = data.showConsentCheckbox,
						TextXAlignment = 0,
						Size = 0,
						width = 0
					}
					local v9 = if data.showConsentCheckbox then Enum.TextXAlignment.Left else Enum.TextXAlignment.Center
					v8.TextXAlignment = v9

					v8.Size = UDim2.new(1, 0, 0, 0)
					v8.width = UDim.new(1, 0)
					table.insert(children, createElement(fitTextLabel, v8))
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
				local v7 = {
					BackgroundTransparency = 1,
					LayoutOrder = #children,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 25)
				}

				local createElement2 = Roact.createElement
				local v10 = {
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
				local v11

				if data.hideConsent then
					v11 = Roact.createElement("TextLabel", {
						Text = data.consentText,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextColor3 = textColor,
						TextSize = v5,
						TextTransparency = transparency,
						FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 10,
						TextWrapped = true,
						RichText = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, -10, 0, 0)
					})
				else
					v11 = Roact.createElement("TextButton", {
						Text = data.consentText,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextColor3 = textColor,
						TextSize = v5,
						TextTransparency = transparency,
						FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 10,
						TextWrapped = true,
						RichText = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						[Roact.Event.Activated] = data.consentActivated,
						Size = UDim2.new(1, -10, 0, 0)
					})
				end

				children2.CheckboxContent = v11

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
				local v8 = { createElement2("Frame", v10, children2) }
				table.insert(children, createElement("Frame", v7, v8))
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
