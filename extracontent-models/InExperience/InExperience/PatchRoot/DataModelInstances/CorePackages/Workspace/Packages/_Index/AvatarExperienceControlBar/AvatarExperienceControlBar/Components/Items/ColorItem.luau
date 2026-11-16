local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local ColorGradientCircle = AvatarExperienceCommon.Components.ColorGradientCircle

local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)
local useHoverBinding = require(AvatarExperienceControlBar.Hooks.useHoverBinding)

local stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function getHoverTransparency(p): number
	return if p then 0 else 0.2
end

local function ColorItem(props, ref)
	local v = useSemanticTokens()
	local v2, onStateChanged = useHoverBinding()
	local v3

	if props.size then
		v3 = props.size
	else
		v3 = v.defaultIconContainerSize
	end

	local v4 = if props.colorSize then props.colorSize else v3

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		ref = ref,
		LayoutOrder = props.LayoutOrder,
		stateLayer = stateLayer,
		onStateChanged = 0,
		onActivated = 0,
		AutomaticSize = 0,
		disabled = 0,
		selection = 0
	}

	if props.disabled then
		onStateChanged = nil
	end

	v5.onStateChanged = onStateChanged
	v5.onActivated = props.onActivated
	v5.AutomaticSize = Enum.AutomaticSize.XY
	v5.disabled = props.disabled
	v5.selection = {
		Selectable = props.Selectable or false
	}
	return createElement(view, v5, {
		HoverHandler = React.createElement(Foundation.View, {
			Size = UDim2.fromOffset(v3, v3),
			GroupTransparency = v2:map(getHoverTransparency),
			backgroundStyle = v2:map(function(p)
				if p then
					return v.hoverIconBackgroundStyle
				end

				if props.isActive then
					return v.activeIconBackgroundStyle
				end

				return { Color3 = v.hoverIconBackgroundStyle.Color3, Transparency = 1 }
			end),
			tag = "padding-small radius-circle clip auto-xy"
		}, {
			ColorGradientCircle = React.createElement(ColorGradientCircle, {
				Colors = props.colors,
				Size = UDim2.fromOffset(v4, v4),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		})
	})
end

return React.forwardRef(ColorItem)
