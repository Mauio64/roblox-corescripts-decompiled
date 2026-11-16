local CoreGui = game:GetService("CoreGui")

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Cryo = require(parent2.Cryo)
local Foundation = require(parent2.Foundation)

local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)
local Label = ImageSetComponent.Label
local useStyle = require(parent.Core.Style.useStyle)
require(parent.App.ImageSet.ImagesTypes)
require(parent.App.Style.StyleTypes)
local Controllers = require(parent.App.Dialog.TooltipV2.Controllers)
local withHoverTooltip = Controllers.withHoverTooltip
local TooltipOrientation = require(parent.App.Dialog.Tooltip.Enum.TooltipOrientation)
local StateLayer = require(parent.Core.Control.StateLayer)
local BadgeVariant = require(parent.App.Indicator.Enum.BadgeVariant)

local migrateBadgeVariant = require(parent.Utility.migrateBadgeVariant)

local StatusIndicator = Foundation.StatusIndicator

local v = {
	badgeVariant = BadgeVariant.Alert,
	tooltipTarget = CoreGui,
	disableOutset = false,
	onMedia = false
}

local function UtilityActionIcon(p, ref)
	local joined = Cryo.Dictionary.join(v, p)
	local anchorPoint = joined.anchorPoint
	local position = joined.position
	local layoutOrder = joined.layoutOrder
	local icon = joined.icon
	local badgeValue = joined.badgeValue
	local badgeVariant = joined.badgeVariant
	local tooltipText = joined.tooltipText
	local tooltipTarget = joined.tooltipTarget
	local disableOutset = joined.disableOutset
	local onMedia = joined.onMedia
	local onActivated = joined.onActivated

	local tokens = useStyle().Tokens

	local size_1000 = tokens.Size.Size_1000
	local size_900 = tokens.Size.Size_900
	local v2

	if onMedia then
		v2 = tokens.Color.Extended.White.White_100
	else
		v2 = tokens.Color.Content.Emphasis
	end

	if joined.iconColor then
		v2 = joined.iconColor
	end

	local stateStyle = onMedia and "Darken" or "Standard"
	local vector2 = Vector2.new(0, 1)
	local udim = UDim2.new(0.5, tokens.Size.Size_50, 0.5, -tokens.Size.Size_50)

	local outset = React.useMemo(function()
		if disableOutset then
			return nil
		end

		return {
			top = UDim.new(0, tokens.Size.Size_100),
			right = UDim.new(0, tokens.Size.Size_100),
			bottom = UDim.new(0, tokens.Size.Size_100),
			left = UDim.new(0, tokens.Size.Size_100)
		}
	end, { disableOutset, tokens })

	local size = React.useMemo(function()
		local udim2 = UDim.new(0, size_1000)

		if outset then
			return (UDim2.new(udim2 + outset.left + outset.right, udim2 + outset.top + outset.bottom))
		end

		return (UDim2.new(udim2, udim2))
	end, { size_1000, outset })

	return withHoverTooltip({ bodyText = tooltipText }, {
		disabled = not tooltipText,
		preferredOrientation = TooltipOrientation.Bottom,
		guiTarget = tooltipTarget,
		DEBUG_useTargetDirectly = joined._DEBUG_is_plugin,
		DisplayOrder = 10
	}, function(p2, onStateChanged)
		local createElement = React.createElement
		local v3 = {
			Selectable = false,
			Size = size,
			AnchorPoint = anchorPoint,
			Position = position,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			[React.Change.AbsoluteSize] = p2,
			[React.Change.AbsolutePosition] = p2,
			ref = ref
		}
		local background

		if onMedia then
			background = React.createElement("Frame", {
				Selectable = false,
				Size = UDim2.fromOffset(size_1000, size_1000),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BorderSizePixel = 0,
				BackgroundColor3 = tokens.Color.Extended.Black.Black_100.Color3,
				BackgroundTransparency = 0.5,
				ZIndex = 1
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, tokens.Radius.Circle)
				})
			})
		end

		local children = {
			Background = background,
			StateLayer = React.createElement(StateLayer, {
				size = UDim2.fromOffset(size_1000, size_1000),
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				cornerRadius = UDim.new(0, tokens.Radius.Circle),
				zIndex = 2,
				stateStyle = stateStyle,
				outset = outset,
				onStateChanged = onStateChanged,
				onActivated = onActivated
			}),
			Icon = 0
		}

		local createElement2 = React.createElement
		local v4 = {
			Selectable = false,
			Size = UDim2.fromOffset(size_900, size_900),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = icon,
			ImageColor3 = v2.Color3,
			ImageTransparency = v2.Transparency,
			BackgroundTransparency = 1,
			ZIndex = 3
		}

		local v5 = {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, tokens.Radius.Circle)
			}),
			Badge = 0
		}
		local badge

		if badgeValue then
			badge = React.createElement(StatusIndicator, {
				Position = udim,
				AnchorPoint = vector2,
				value = tonumber(badgeValue),
				variant = migrateBadgeVariant(badgeVariant),
				max = tonumber(badgeValue) and 99 or nil
			})
		end

		v5.Badge = badge
		children.Icon = createElement2(Label, v4, v5, joined.children)
		return createElement("Frame", v3, children)
	end)
end

return React.forwardRef(UtilityActionIcon)
