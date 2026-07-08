local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle

return function(t1: {[any]: any}) -- line: 12
	-- upvalues: useStyle (copy), React (copy), AppFonts (copy)
	local v6 = useStyle()

	return React.createElement("TextLabel", {
		Text = "12+",
		TextSize = 9,
		BackgroundTransparency = 0,
		LineHeight = 1.25,
		ZIndex = 2,
		AnchorPoint = Vector2.new(0, 1),
		Position = t1.position,
		Font = AppFonts.default:getMedium(),
		TextColor3 = v6.Theme.TextEmphasis.Color,
		BackgroundColor3 = v6.Theme.BackgroundUIContrast.Color,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 2)
		}),
		Shape = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		})
	})
end
