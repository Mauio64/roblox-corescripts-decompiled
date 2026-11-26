local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local function WidgetListSpacer(p2)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, p2.height)
	})
end

return WidgetListSpacer
