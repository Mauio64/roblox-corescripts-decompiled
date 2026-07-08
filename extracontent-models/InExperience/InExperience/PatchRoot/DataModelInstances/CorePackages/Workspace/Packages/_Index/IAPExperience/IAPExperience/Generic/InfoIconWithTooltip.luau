local CoreGui = game:GetService("CoreGui")
local ParentParent = script.Parent.Parent.Parent
local UIBlox = require(ParentParent.UIBlox)
local Roact = require(ParentParent.Roact)
local withHoverTooltip = UIBlox.App.Dialog.TooltipV2.withHoverTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local Images = UIBlox.App.ImageSet.Images
local Interactable = UIBlox.Core.Control.Interactable
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v10 = Images["icons/actions/info"]

function InfoIconWithTooltip(t1: {[any]: any}) -- line: 22
	-- upvalues: withHoverTooltip (copy), TooltipOrientation (copy), CoreGui (copy), Roact (copy), ImageSetLabel (copy), v10 (copy), Interactable (copy)
	local uDim2 = UDim2.new(0, 18, 0, 18)

	return withHoverTooltip({
		bodyText = t1.text
	}, {
		DisplayOrder = 10,
		delayTime = 0.2,
		triggerPointName = "BonusBannerInfoIcon",
		preferredOrientation = TooltipOrientation.Bottom,
		guiTarget = CoreGui
	}, function(p1, p2) -- line: 32
		-- upvalues: Roact (copy), uDim2 (copy), t1 (copy), ImageSetLabel (copy), v10 (copy), Interactable (copy)
		return Roact.createElement("Frame", {
			Size = uDim2,
			BackgroundTransparency = 1,
			LayoutOrder = t1.layoutOrder,
			AnchorPoint = Vector2.new(1, 0),
			[Roact.Change.AbsolutePosition] = p1,
			[Roact.Change.AbsoluteSize] = p1
		}, {
			TooltipIcon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				ZIndex = 1,
				Size = uDim2,
				Image = v10,
				ImageColor3 = t1.color
			}),
			Hitbox = Roact.createElement(Interactable, {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				onStateChanged = p2,
				[Roact.Event.Activated] = t1.eventActivated,
				ZIndex = 2
			})
		})
	end)
end

return InfoIconWithTooltip
