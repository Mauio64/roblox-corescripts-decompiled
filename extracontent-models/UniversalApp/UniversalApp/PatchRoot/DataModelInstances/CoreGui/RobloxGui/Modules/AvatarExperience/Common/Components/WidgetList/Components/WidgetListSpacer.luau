local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local function WidgetListSpacer(t1: {[any]: any}) -- line: 9
	-- upvalues: React (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, t1.height)
	})
end

return WidgetListSpacer
