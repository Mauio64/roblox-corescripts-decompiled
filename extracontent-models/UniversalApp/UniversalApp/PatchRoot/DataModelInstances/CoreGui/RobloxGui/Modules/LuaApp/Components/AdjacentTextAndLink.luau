local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Common = Modules.Common
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local Roact = require(Common.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Core.Style.withStyle
local LinkButton = UIBlox.App.Button.LinkButton
local FitChildren = require(Modules.LuaApp.FitChildren)

return function(p1) -- line: 15
	-- upvalues: withStyle (copy), Text (copy), Roact (copy), FitChildren (copy), LinkButton (copy)
	return withStyle(function(p2) -- line: 16
		-- upvalues: p1 (copy), Text (copy), Roact (copy), FitChildren (copy), LinkButton (copy)
		local spacing = p1.spacing
		local v13 = p1.LayoutOrder or 1
		local p1AnchorPoint = p1.AnchorPoint
		local textLabelText = p1.textLabelText
		local textLabelColor = p1.textLabelColor
		local p1TextTransparency = p1.TextTransparency
		local v18 = p1.fontStyle or "CaptionBody"
		local v19 = p2.Font[v18]
		local v20 = p1.buttonSize or UDim2.fromScale(0, 1)
		local linkColorStyle = p1.linkColorStyle
		local linkText = p1.linkText
		local onActivated = p1.onActivated
		local textButtonEnabled = p1.textButtonEnabled

		if textButtonEnabled == nil then
			textButtonEnabled = true
		end

		local v25 = v19.RelativeSize * p2.Font.BaseSize
		local v26 = Text.GetTextWidth(textLabelText or "", v19.Font, v25)
		local v27 = spacing or Text.GetTextWidth(" ", v19.Font, v25)

		return Roact.createElement(FitChildren.FitFrame, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(0, v25),
			AnchorPoint = p1AnchorPoint,
			LayoutOrder = v13,
			fitAxis = FitChildren.FitAxis.Width
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v27),
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			TextLabel = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				TextSize = v25,
				Font = v19.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(0, v26, 1, 0),
				Text = textLabelText,
				TextTransparency = p1TextTransparency,
				TextColor3 = textLabelColor
			}),
			LinkButton = Roact.createElement(LinkButton, {
				layoutOrder = 2,
				fontStyle = v18,
				size = v20,
				text = linkText,
				colorStyleDefault = linkColorStyle,
				colorStyleHover = linkColorStyle,
				isDisabled = not textButtonEnabled,
				onActivated = onActivated
			})
		})
	end)
end
