local CoreGui = game:GetService("CoreGui")

local parent = script.Parent.Parent.Parent
local UIBlox = require(parent.UIBlox)
local Roact = require(parent.Roact)

local withHoverTooltip = UIBlox.App.Dialog.TooltipV2.withHoverTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local Images = UIBlox.App.ImageSet.Images
local Interactable = UIBlox.Core.Control.Interactable
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconsactionsinfo = Images["icons/actions/info"]

function InfoIconWithTooltip(data)
	local udim = UDim2.new(0, 18, 0, 18)
	return withHoverTooltip({ bodyText = data.text }, {
		preferredOrientation = TooltipOrientation.Bottom,
		guiTarget = CoreGui,
		DisplayOrder = 10,
		delayTime = 0.2,
		triggerPointName = "BonusBannerInfoIcon"
	}, function(p, onStateChanged)
		return Roact.createElement("Frame", {
			Size = udim,
			BackgroundTransparency = 1,
			LayoutOrder = data.layoutOrder,
			AnchorPoint = Vector2.new(1, 0),
			[Roact.Change.AbsolutePosition] = p,
			[Roact.Change.AbsoluteSize] = p
		}, {
			TooltipIcon = Roact.createElement(ImageSetLabel, {
				Size = udim,
				BackgroundTransparency = 1,
				Image = iconsactionsinfo,
				ImageColor3 = data.color,
				ZIndex = 1
			}),
			Hitbox = Roact.createElement(Interactable, {
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

return InfoIconWithTooltip
