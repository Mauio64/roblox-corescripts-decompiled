local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Constants)
local HighlightHeight = Constants.TabRowFormatting.HighlightHeight
local FrameHeight = Constants.TabRowFormatting.FrameHeight

local function TabRowButton(p1) -- line: 10
	-- upvalues: Constants (copy), Roact (copy), FrameHeight (copy), HighlightHeight (copy)
	local index = p1.index
	local name = p1.name
	local textWidth = p1.textWidth
	local padding = p1.padding
	local isSelected = p1.isSelected
	local layoutOrder = p1.layoutOrder
	local onTabButtonClicked = p1.onTabButtonClicked
	local v15 = textWidth + padding
	local UnselectedTextTransparency = Constants.TabRowFormatting.UnselectedTextTransparency

	if isSelected then
		UnselectedTextTransparency = Constants.TabRowFormatting.SelectedTextTransparency
	end

	return Roact.createElement("TextButton", {
		Text = name,
		TextSize = Constants.DefaultFontSize.TabBar,
		Font = Constants.Font.TabBar,
		TextScaled = false,
		TextTransparency = UnselectedTextTransparency,
		Size = UDim2.new(0, v15, 0, FrameHeight),
		AutoButtonColor = false,
		TextColor3 = Constants.Color.Text,
		BackgroundColor3 = Constants.Color.UnselectedGray,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		[Roact.Event.Activated] = function(_) -- line: 38
			-- upvalues: onTabButtonClicked (copy), index (copy)
			onTabButtonClicked(index)
		end
	}, {
		BlueHighlight = isSelected and Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, -HighlightHeight),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = Constants.Color.HighlightBlue
		})
	})
end

return TabRowButton
