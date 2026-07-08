local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local React = require(AvatarExperienceCommonParent.React)
local Foundation = require(AvatarExperienceCommonParent.Foundation)
local IXPUtils = require(AvatarExperienceCommonParent.IXPUtils)
local useTokens = Foundation.Hooks.useTokens
local usePulseAnimationBinding = require(AvatarExperienceCommon.Hooks.usePulseAnimationBinding)
local AXEnableAccessoryAdjustmentDuringTryOnIXP = require(AvatarExperienceCommonParent.AvatarExperienceExperiments).AXEnableAccessoryAdjustmentDuringTryOnIXP
local t1 = {
	affordance = Foundation.Enums.StateLayerAffordance.None
}

local function getHoverTransparency(p1) -- line: 18
	if p1 then
		return 0
	end

	return 0.2
end
local function useHoverBinding() -- line: 22
	-- upvalues: React (copy), Foundation (copy)
	local v14, v15 = React.useBinding(false)

	return v14, (React.useCallback(function(p2) -- line: 26
		-- upvalues: Foundation (copy), v15 (copy)
		if p2 == Foundation.Enums.ControlState.Default then
			v15(false)

			return
		end

		if p2 == Foundation.Enums.ControlState.Hover then
			v15(true)
		end
	end, {}))
end
local function ContextualActionButton(t2: {[any]: any}, p3) -- line: 51
	-- upvalues: useTokens (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), IXPUtils (copy), usePulseAnimationBinding (copy), useHoverBinding (copy), React (copy), Foundation (copy), t1 (copy), getHoverTransparency (copy)
	local v18 = useTokens()
	local v19 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else IXPUtils.readTestVariable(AXEnableAccessoryAdjustmentDuringTryOnIXP.EnabledForUser)
	local v20 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else usePulseAnimationBinding(t2.enableFocusAnimation)
	local v21, v22 = useHoverBinding()
	local v23 = React.useCallback(function(p4) -- line: 64
		-- upvalues: v18 (copy), t2 (copy)
		if p4 then
			return v18.Color.Shift.Shift_200
		end

		if t2.isActive then
			return v18.Color.Shift.Shift_400
		end

		return {
			Transparency = 1,
			Color3 = v18.Color.Shift.Shift_200.Color3
		}
	end, {
		t2.isActive,
		v18
	})

	return React.createElement(Foundation.View, {
		tag = "radius-circle clip auto-xy",
		ref = p3,
		backgroundStyle = v18.Color.OverMedia.OverMedia_0,
		LayoutOrder = t2.LayoutOrder,
		stateLayer = t1,
		onStateChanged = if not t2.disabled then v22 else nil,
		onActivated = t2.onActivated,
		disabled = t2.disabled,
		selection = {
			Selectable = t2.Selectable or false
		}
	}, {
		HoverHandler = React.createElement(Foundation.View, {
			tag = "padding-small radius-circle clip auto-xy",
			Size = if not t2.size then UDim2.fromScale(1, 1) else UDim2.new(t2.size, t2.size),
			GroupTransparency = t2.GroupTransparencyOverwrite or v21:map(getHoverTransparency),
			backgroundStyle = v21:map(v23)
		}, {
			Children = React.createElement(React.Fragment, nil, t2.children)
		}),
		UIStroke = if not v19 or not t2.enableFocusAnimation then nil else React.createElement("UIStroke", {
			Color = v18.Color.ActionEmphasis.Background.Color3,
			Thickness = v20 and v20:map(function(p5) -- line: 98
				return p5.thickness
			end),
			Transparency = v20 and v20:map(function(p6) -- line: 101
				return p6.transparency
			end)
		})
	})
end

return React.forwardRef(ContextualActionButton)
