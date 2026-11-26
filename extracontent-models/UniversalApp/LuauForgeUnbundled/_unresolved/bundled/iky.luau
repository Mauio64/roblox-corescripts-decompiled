local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/bundled/dzD")
local module2 = require("@luauforge/bundled/igI")

return function(p2)
	local screenSize = p2.screenSize
	local theme = useStyle().Theme
	local globalGuiInset = p2.globalGuiInset
	local v5 = module2()
	local udim = UDim2.fromOffset(0, globalGuiInset.top)
	local udim2 = UDim2.fromOffset(screenSize.X, screenSize.Y - globalGuiInset.top - v5)

	return React.createElement(
		"ScreenGui",
		{
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = module.DisplayOrder.AntiAddictionPrompt,
			IgnoreGuiInset = true
		},
		{
			OverlayFrame = React.createElement("ImageButton", {
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 1, 0),
				ImageTransparency = 1,
				BackgroundColor3 = theme.Overlay.Color,
				BackgroundTransparency = theme.Overlay.Transparency,
				BorderSizePixel = 0,
				Selectable = false
			}, {
				Overlay = React.createElement(
					"Frame",
					{
						Position = udim,
						Size = udim2,
						BorderSizePixel = 0,
						BackgroundTransparency = 1
					},
					{
						Content = React.createElement(loading, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							size = iconSize.Large
						})
					}
				)
			})
		}
	)
end
