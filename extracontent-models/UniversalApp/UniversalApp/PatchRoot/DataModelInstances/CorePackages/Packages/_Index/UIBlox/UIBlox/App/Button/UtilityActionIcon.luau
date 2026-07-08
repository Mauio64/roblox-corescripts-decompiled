local CoreGui = game:GetService("CoreGui")
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Cryo = require(ParentParentParent.Cryo)
local Foundation = require(ParentParentParent.Foundation)
local Label = require(ParentParent.Core.ImageSet.ImageSetComponent).Label
local useStyle = require(ParentParent.Core.Style.useStyle)

require(ParentParent.App.ImageSet.ImagesTypes)
require(ParentParent.App.Style.StyleTypes)

local withHoverTooltip = require(ParentParent.App.Dialog.TooltipV2.Controllers).withHoverTooltip
local TooltipOrientation = require(ParentParent.App.Dialog.Tooltip.Enum.TooltipOrientation)
local StateLayer = require(ParentParent.Core.Control.StateLayer)
local BadgeVariant = require(ParentParent.App.Indicator.Enum.BadgeVariant)
local migrateBadgeVariant = require(ParentParent.Utility.migrateBadgeVariant)
local StatusIndicator = Foundation.StatusIndicator
local t1 = {
	disableOutset = false,
	onMedia = false,
	badgeVariant = BadgeVariant.Alert,
	tooltipTarget = CoreGui
}

local function UtilityActionIcon(t2: {[any]: any}, p1) -- line: 60
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), withHoverTooltip (copy), TooltipOrientation (copy), StateLayer (copy), Label (copy), StatusIndicator (copy), migrateBadgeVariant (copy)
	local v19 = Cryo.Dictionary.join(t1, t2)
	local anchorPoint = v19.anchorPoint
	local position = v19.position
	local layoutOrder = v19.layoutOrder
	local icon = v19.icon
	local badgeValue = v19.badgeValue
	local badgeVariant = v19.badgeVariant
	local tooltipText = v19.tooltipText
	local tooltipTarget = v19.tooltipTarget
	local disableOutset = v19.disableOutset
	local onMedia = v19.onMedia
	local onActivated = v19.onActivated
	local Tokens = useStyle().Tokens
	local Size_500 = Tokens.Global.Size_500
	local Medium = Tokens.Semantic.Icon.Size.Medium
	local v34 = if not onMedia then Tokens.Semantic.Color.Icon.Emphasis else Tokens.Global.Color.White
	local v35 = if not v19.iconColor then v34 else v19.iconColor
	local v36 = not onMedia and "Standard" or "Darken"
	local vector2 = Vector2.new(0, 1)
	local uDim2 = UDim2.new(0.5, Tokens.Global.Size_25, 0.5, -Tokens.Global.Size_25)
	local v39 = React.useMemo(function() -- line: 86
		-- upvalues: disableOutset (copy), Tokens (copy)
		if disableOutset then
			return nil
		end

		return {
			top = UDim.new(0, Tokens.Global.Size_50),
			right = UDim.new(0, Tokens.Global.Size_50),
			bottom = UDim.new(0, Tokens.Global.Size_50),
			left = UDim.new(0, Tokens.Global.Size_50)
		}
	end, {
		disableOutset,
		Tokens
	})
	local v40 = React.useMemo(function() -- line: 97
		-- upvalues: Size_500 (copy), v39 (copy)
		local uDim = UDim.new(0, Size_500)

		if v39 then
			return (UDim2.new(uDim + v39.left + v39.right, uDim + v39.top + v39.bottom))
		end

		return (UDim2.new(uDim, uDim))
	end, {
		Size_500,
		v39
	})

	return withHoverTooltip({
		bodyText = tooltipText
	}, {
		DisplayOrder = 10,
		disabled = not tooltipText,
		preferredOrientation = TooltipOrientation.Bottom,
		guiTarget = tooltipTarget,
		DEBUG_useTargetDirectly = v19._DEBUG_is_plugin
	}, function(p2, p3) -- line: 112
		-- upvalues: React (copy), v40 (copy), anchorPoint (copy), position (copy), layoutOrder (copy), p1 (copy), onMedia (copy), Size_500 (copy), Tokens (copy), StateLayer (copy), v36 (copy), v39 (copy), onActivated (copy), Label (copy), Medium (copy), icon (copy), v35 (copy), badgeValue (copy), StatusIndicator (copy), uDim2 (copy), vector2 (copy), migrateBadgeVariant (copy), badgeVariant (copy), v19 (copy)
		return React.createElement("Frame", {
			Selectable = false,
			Size = v40,
			AnchorPoint = anchorPoint,
			Position = position,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			[React.Change.AbsoluteSize] = p2,
			[React.Change.AbsolutePosition] = p2,
			ref = p1
		}, {
			Background = if not onMedia then nil else React.createElement("Frame", {
				Selectable = false,
				BorderSizePixel = 0,
				BackgroundTransparency = 0.5,
				ZIndex = 1,
				Size = UDim2.fromOffset(Size_500, Size_500),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = Tokens.Global.Color.Black.Color3
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, Tokens.Semantic.Radius.Circle)
				})
			}),
			StateLayer = React.createElement(StateLayer, {
				zIndex = 2,
				size = UDim2.fromOffset(Size_500, Size_500),
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				cornerRadius = UDim.new(0, Tokens.Semantic.Radius.Circle),
				stateStyle = v36,
				outset = v39,
				onStateChanged = p3,
				onActivated = onActivated
			}),
			Icon = React.createElement(Label, {
				Selectable = false,
				BackgroundTransparency = 1,
				ZIndex = 3,
				Size = UDim2.fromOffset(Medium, Medium),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = icon,
				ImageColor3 = v35.Color3,
				ImageTransparency = v35.Transparency
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, Tokens.Semantic.Radius.Circle)
				}),
				Badge = if not badgeValue then nil else React.createElement(StatusIndicator, {
					Position = uDim2,
					AnchorPoint = vector2,
					value = tonumber(badgeValue),
					variant = migrateBadgeVariant(badgeVariant),
					max = if not tonumber(badgeValue) then nil else 99
				})
			}, v19.children)
		})
	end)
end

return React.forwardRef(UtilityActionIcon)
