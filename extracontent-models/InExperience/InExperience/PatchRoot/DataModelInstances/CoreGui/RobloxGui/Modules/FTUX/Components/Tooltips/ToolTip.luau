local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local React = require(CorePackages.Packages.React)

local function Tooltip(p)
	local controllerPart = p.controllerPart
	local billboardGui = controllerPart:WaitForChild("BillboardGui")

	return withTooltip({ bodyText = p.tooltipText }, {
		preferredOrientation = TooltipOrientation.Bottom,
		guiTarget = billboardGui,
		DisplayOrder = 0,
		triggerPointName = "TriggerPart",
		active = true,
		DEBUG_useTargetDirectly = true
	}, function(p2)
		return React.createElement("BillboardGui", {
			Parent = controllerPart,
			Adornee = controllerPart,
			AlwaysOnTop = true,
			Active = false,
			Size = UDim2.new(0.5, 0, 0.5, 0)
		}, {
			TriggerBody = React.createElement("Frame", {
				Transparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.49, 0, 1.02, 0),
				[React.Change.AbsoluteSize] = p2,
				[React.Change.AbsolutePosition] = p2
			})
		})
	end)
end

return Tooltip
