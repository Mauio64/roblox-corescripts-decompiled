local CoreGui = game:GetService("CoreGui")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local withHoverTooltip = UIBlox.App.Dialog.TooltipV2.withHoverTooltip
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local images = UIBlox.App.ImageSet.Images
local interactable = UIBlox.Core.Control.Interactable
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconsactionsinfo = images["icons/actions/info"]
function LUAUFORGE_MODULE_GLOBALS_aZd_InfoIconWithTooltip(data)
	local udim = UDim2.new(0, 18, 0, 18)
	return withHoverTooltip({ bodyText = data.text }, {
		preferredOrientation = tooltipOrientation.Bottom,
		guiTarget = CoreGui,
		DisplayOrder = 10,
		delayTime = 0.2,
		triggerPointName = "BonusBannerInfoIcon"
	}, function(p2, onStateChanged)
		return Roact.createElement("Frame", {
			Size = udim,
			BackgroundTransparency = 1,
			LayoutOrder = data.layoutOrder,
			AnchorPoint = Vector2.new(1, 0),
			[Roact.Change.AbsolutePosition] = p2,
			[Roact.Change.AbsoluteSize] = p2
		}, {
			TooltipIcon = Roact.createElement(imageSetLabel, {
				Size = udim,
				BackgroundTransparency = 1,
				Image = iconsactionsinfo,
				ImageColor3 = data.color,
				ZIndex = 1
			}),
			Hitbox = Roact.createElement(interactable, {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				onStateChanged = onStateChanged,
				[Roact.Event.Activated] = data.eventActivated,
				ZIndex = 2
			})
		})
	end)
end

return LUAUFORGE_MODULE_GLOBALS_aZd_InfoIconWithTooltip
