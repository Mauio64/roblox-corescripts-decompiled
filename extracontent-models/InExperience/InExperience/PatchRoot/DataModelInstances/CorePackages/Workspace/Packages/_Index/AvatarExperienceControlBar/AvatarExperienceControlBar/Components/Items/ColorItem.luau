local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local ColorGradientCircle = require(AvatarExperienceControlBarParent.AvatarExperienceCommon).Components.ColorGradientCircle
local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)
local useHoverBinding = require(AvatarExperienceControlBar.Hooks.useHoverBinding)
local t1 = {
	affordance = Foundation.Enums.StateLayerAffordance.None
}

local function getHoverTransparency(p1) -- line: 17
	if p1 then
		return 0
	end

	return 0.2
end
local function ColorItem(t2: {[any]: any}, p2) -- line: 32
	-- upvalues: useSemanticTokens (copy), useHoverBinding (copy), React (copy), Foundation (copy), t1 (copy), getHoverTransparency (copy), ColorGradientCircle (copy)
	local v14 = useSemanticTokens()
	local v15, v16 = useHoverBinding()
	local v17 = if not t2.size then v14.defaultIconContainerSize else t2.size
	local v18 = if not t2.colorSize then v17 else t2.colorSize

	return React.createElement(Foundation.View, {
		ref = p2,
		LayoutOrder = t2.LayoutOrder,
		stateLayer = t1,
		onStateChanged = if not t2.disabled then v16 else nil,
		onActivated = t2.onActivated,
		AutomaticSize = Enum.AutomaticSize.XY,
		disabled = t2.disabled,
		selection = {
			Selectable = t2.Selectable or false
		}
	}, {
		HoverHandler = React.createElement(Foundation.View, {
			tag = "padding-small radius-circle clip auto-xy",
			Size = UDim2.fromOffset(v17, v17),
			GroupTransparency = v15:map(getHoverTransparency),
			backgroundStyle = v15:map(function(p3) -- line: 51
				-- upvalues: v14 (copy), t2 (copy)
				if p3 then
					return v14.hoverIconBackgroundStyle
				end

				if t2.isActive then
					return v14.activeIconBackgroundStyle
				end

				return {
					Transparency = 1,
					Color3 = v14.hoverIconBackgroundStyle.Color3
				}
			end)
		}, {
			ColorGradientCircle = React.createElement(ColorGradientCircle, {
				Colors = t2.colors,
				Size = UDim2.fromOffset(v18, v18),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		})
	})
end

return React.forwardRef(ColorItem)
