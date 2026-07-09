local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Checkbox = require(CorePackages.Packages.Foundation).Checkbox
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Large = UIBlox.App.Constant.IconSize.Large

return function(p1) -- line: 22
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), Large (copy), FitTextLabel (copy), FitChildren (copy), Checkbox (copy)
	return withStyle(function(p2) -- line: 23
		-- upvalues: p1 (copy), Roact (copy), ImageSetLabel (copy), Large (copy), FitTextLabel (copy), FitChildren (copy), Checkbox (copy)
		local BodyFont = p2.Font.Body.Font
		local v14 = p2.Font.BaseSize * p2.Font.Body.RelativeSize
		local TextDefaultTransparency = p2.Theme.TextDefault.Transparency
		local v16 = p1.TextColor or p2.Theme.TextDefault.Color
		local t1 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, p1.MainTextPadding or 0)
			})
		}

		if p1.MainText then
			for i = 1, #p1.MainText do
				local v19 = p1.MainText[i]

				if typeof(v19) == "table" and p1.showConsentCheckbox then
					local image = v19.image
					local content = v19.content

					table.insert(t1, Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.XY
					}, {
						Image = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							Image = image,
							Size = UDim2.fromOffset(Large, Large),
							ScaleType = Enum.ScaleType.Slice
						}),
						Layout = Roact.createElement("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Top,
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 12)
						}),
						Label = Roact.createElement(FitTextLabel, {
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							TextWrapped = true,
							RichText = true,
							Text = content,
							TextColor3 = v16,
							TextSize = v14,
							TextTransparency = TextDefaultTransparency,
							Font = BodyFont,
							LayoutOrder = #t1,
							TextXAlignment = Enum.TextXAlignment.Left,
							Size = UDim2.new(1, -Large, 0, 0),
							fitAxis = FitChildren.FitAxis.Height
						})
					}))
				else
					table.insert(t1, Roact.createElement(FitTextLabel, {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						TextWrapped = true,
						Text = v19,
						TextColor3 = v16,
						TextSize = v14,
						TextTransparency = TextDefaultTransparency,
						Font = BodyFont,
						LayoutOrder = #t1,
						RichText = p1.showConsentCheckbox,
						TextXAlignment = if not p1.showConsentCheckbox then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height
					}))
				end
			end

			if p1.LocalizedOptOutText then
				table.insert(t1, Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = #t1,
					Size = UDim2.new(0, 0, 0, 25),
					AutomaticSize = Enum.AutomaticSize.XY
				}, { Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(not p1.centerCheckbox and 0 or 0.5, 0.5)
				}, {
					Checkbox = Roact.createElement(Checkbox, {
						label = p1.LocalizedOptOutText,
						onActivated = p1.onActivated,
						isChecked = p1.checkboxSelected
					})
				}) }))
			end

			if p1.showConsentCheckbox then
				table.insert(t1, Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = #t1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 25)
				}, { Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(0, 12),
					Size = UDim2.new(1, 0, 0, 50),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Checkbox = not p1.hideConsent and Roact.createElement(Checkbox, {
						label = "",
						onActivated = p1.consentActivated,
						isChecked = p1.consentSelected
					}),
					CheckboxContent = if not p1.hideConsent then Roact.createElement("TextButton", {
						Text = p1.consentText,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextColor3 = v16,
						TextSize = v14,
						TextTransparency = TextDefaultTransparency,
						Font = BodyFont,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 10,
						TextWrapped = true,
						RichText = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						[Roact.Event.Activated] = p1.consentActivated,
						Size = UDim2.new(1, -10, 0, 0)
					}) else Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 10,
						TextWrapped = true,
						RichText = true,
						Text = p1.consentText,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextColor3 = v16,
						TextSize = v14,
						TextTransparency = TextDefaultTransparency,
						Font = BodyFont,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, -10, 0, 0)
					}),
					Layout = Roact.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 10)
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingRight = UDim.new(0, 10)
					})
				}) }))
			end
		end

		return Roact.createElement(FitChildren.FitFrame, {
			BackgroundTransparency = 1,
			LayoutOrder = p1.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			fitAxis = FitChildren.FitAxis.Height
		}, t1)
	end)
end
