local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation

return (React.forwardRef(function(p1, p2) -- line: 9
	-- upvalues: withTooltip (copy), CoreGui (copy), TooltipOrientation (copy), React (copy)
	return withTooltip({
		ref = p2,
		headerText = p1.headerText,
		bodyText = p1.bodyText
	}, {
		DisplayOrder = 10,
		active = p1.shouldShowTooltip,
		guiTarget = CoreGui,
		preferredOrientation = TooltipOrientation.Bottom
	}, function(p3) -- line: 20
		-- upvalues: React (copy)
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = p3,
			[React.Change.AbsolutePosition] = p3
		})
	end)
end))
