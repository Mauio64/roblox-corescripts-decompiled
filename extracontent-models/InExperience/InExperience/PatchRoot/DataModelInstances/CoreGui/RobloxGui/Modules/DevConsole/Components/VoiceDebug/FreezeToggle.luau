local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Parent.Constants)

local udim = UDim.new(0, 6)

local function FreezeToggle(props)
	return Roact.createElement("TextButton", {
		Text = props.frozen and "Frozen" or "Freeze",
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 0, 16),
		LayoutOrder = props.layoutOrder,
		Font = Constants.Font.MainWindow,
		TextSize = Constants.DefaultFontSize.MainWindow + -2,
		TextColor3 = props.frozen and Constants.Color.HighlightBlue or Constants.Color.Text,
		BackgroundColor3 = Constants.Color.UnselectedGray,
		BorderSizePixel = 1,
		BorderColor3 = Constants.Color.Text,
		[Roact.Event.Activated] = props.onToggle
	}, {
		Padding = Roact.createElement("UIPadding", { PaddingLeft = udim, PaddingRight = udim })
	})
end

return FreezeToggle
