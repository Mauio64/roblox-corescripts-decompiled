local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local _ = {
	LEFT = 22,
	TOP = 5,
	BOTTOM = 5
}

return function(p1) -- line: 17
	-- upvalues: withStyle (copy), Roact (copy)
	local maxSize = p1.maxSize
	local layoutOrder = p1.layoutOrder
	local text = p1.text

	return withStyle(function(p2) -- line: 22
		-- upvalues: Roact (copy), layoutOrder (copy), maxSize (copy), text (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, 32)
		}, {
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = maxSize
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 22),
				PaddingTop = UDim.new(0, 5),
				PaddingBottom = UDim.new(0, 5)
			}),
			Text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Font = p2.Font.Header2.Font,
				TextSize = p2.Font.BaseSize * p2.Font.Header2.RelativeSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = p2.Theme.TextDefault.Color,
				TextTransparency = p2.Theme.TextDefault.Transparency,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Text = text
			})
		})
	end)
end
