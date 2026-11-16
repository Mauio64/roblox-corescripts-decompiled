local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation

return (React.forwardRef(function(data, ref)
	return withTooltip(
		{ ref = ref, headerText = data.headerText, bodyText = data.bodyText },
		{
			DisplayOrder = 10,
			active = data.shouldShowTooltip,
			guiTarget = CoreGui,
			preferredOrientation = TooltipOrientation.Bottom
		},
		function(p)
			return React.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				[React.Change.AbsoluteSize] = p,
				[React.Change.AbsolutePosition] = p
			})
		end
	)
end))
