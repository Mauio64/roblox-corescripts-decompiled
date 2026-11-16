local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)

local v = {
	on = {
		background = Color3.fromRGB(14, 26, 14),
		border = Color3.fromRGB(32, 64, 32),
		text = Color3.fromRGB(130, 220, 130)
	},
	off = {
		background = Color3.fromRGB(18, 18, 18),
		border = Color3.fromRGB(40, 40, 40),
		text = Color3.fromRGB(150, 150, 150)
	}
}

local udim = UDim.new(0, 9)

local udim2 = UDim.new(0, 8)

local function FilterChip(props)
	local on = props.isOn and v.on or v.off
	return Roact.createElement("TextButton", {
		Text = props.name,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 0, 18),
		LayoutOrder = props.layoutOrder,
		Font = Constants.Font.MainWindow,
		TextSize = Constants.DefaultFontSize.MainWindow + -3,
		TextColor3 = on.text,
		BackgroundColor3 = on.background,
		AutoButtonColor = false,
		[Roact.Event.Activated] = props.onActivated
	}, {
		Corner = Roact.createElement("UICorner", { CornerRadius = udim }),
		Stroke = Roact.createElement("UIStroke", { Color = on.border, Thickness = 1 }),
		Padding = Roact.createElement("UIPadding", { PaddingLeft = udim2, PaddingRight = udim2 })
	})
end

return FilterChip
