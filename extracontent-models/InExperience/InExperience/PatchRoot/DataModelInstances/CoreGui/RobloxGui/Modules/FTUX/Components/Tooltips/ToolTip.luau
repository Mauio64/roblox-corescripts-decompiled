local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local React = require(CorePackages.Packages.React)

local function Tooltip(t1: {[any]: any}) -- line: 11
	-- upvalues: withTooltip (copy), TooltipOrientation (copy), React (copy)
	local controllerPart = t1.controllerPart
	local BillboardGui = controllerPart:WaitForChild("BillboardGui")

	return withTooltip({
		bodyText = t1.tooltipText
	}, {
		DisplayOrder = 0,
		triggerPointName = "TriggerPart",
		active = true,
		DEBUG_useTargetDirectly = true,
		preferredOrientation = TooltipOrientation.Bottom,
		guiTarget = BillboardGui
	}, function(p1) -- line: 24
		-- upvalues: React (copy), controllerPart (copy)
		return React.createElement("BillboardGui", {
			AlwaysOnTop = true,
			Active = false,
			Parent = controllerPart,
			Adornee = controllerPart,
			Size = UDim2.new(0.5, 0, 0.5, 0)
		}, {
			TriggerBody = React.createElement("Frame", {
				Transparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.49, 0, 1.02, 0),
				[React.Change.AbsoluteSize] = p1,
				[React.Change.AbsolutePosition] = p1
			})
		})
	end)
end

return Tooltip
