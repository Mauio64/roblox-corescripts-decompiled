local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")
local colorGradientCircle = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceCommon").Components.ColorGradientCircle

local useSemanticTokens = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useSemanticTokens")
local useHoverBinding = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useHoverBinding")

local v5 = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function getHoverTransparency(p2): number
	if p2 then
		return 0
	end

	return 0.2
end

local function ColorItem(props, p2)
	local v6 = useSemanticTokens()
	local v7, v8 = useHoverBinding()
	local v9 = if props.size then props.size else v6.defaultIconContainerSize
	local v10 = if props.colorSize then props.colorSize else v9

	local createElement = React.createElement
	local view = Foundation.View
	local v11 = {
		ref = p2,
		LayoutOrder = props.LayoutOrder,
		stateLayer = v5,
		onStateChanged = 0,
		onActivated = 0,
		AutomaticSize = 0,
		disabled = 0,
		selection = 0
	}

	if props.disabled then
		v8 = nil
	end

	v11.onStateChanged = v8
	v11.onActivated = props.onActivated
	v11.AutomaticSize = Enum.AutomaticSize.XY
	v11.disabled = props.disabled
	v11.selection = {
		Selectable = props.Selectable or false
	}
	return createElement(view, v11, {
		HoverHandler = React.createElement(Foundation.View, {
			Size = UDim2.fromOffset(v9, v9),
			GroupTransparency = v7:map(getHoverTransparency),
			backgroundStyle = v7:map(function(p3)
				if p3 then
					return v6.hoverIconBackgroundStyle
				end

				if props.isActive then
					return v6.activeIconBackgroundStyle
				end

				return { Color3 = v6.hoverIconBackgroundStyle.Color3, Transparency = 1 }
			end),
			tag = "padding-small radius-circle clip auto-xy"
		}, {
			ColorGradientCircle = React.createElement(colorGradientCircle, {
				Colors = props.colors,
				Size = UDim2.fromOffset(v10, v10),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		})
	})
end

return React.forwardRef(ColorItem)
