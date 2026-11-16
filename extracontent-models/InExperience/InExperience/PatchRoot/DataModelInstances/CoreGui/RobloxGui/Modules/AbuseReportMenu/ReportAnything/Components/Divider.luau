local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)

local withStyle = UIBlox.Core.Style.withStyle

local function Divider(p)
	return withStyle(function(p2)
		return React.createElement(
			"Frame",
			Cryo.Dictionary.join({ Size = UDim2.new(1, 0, 0, 1) }, p, {
				BorderSizePixel = 0,
				BackgroundColor3 = p2.Theme.Divider.Color,
				BackgroundTransparency = p2.Theme.Divider.Transparency
			})
		)
	end)
end

return Divider
