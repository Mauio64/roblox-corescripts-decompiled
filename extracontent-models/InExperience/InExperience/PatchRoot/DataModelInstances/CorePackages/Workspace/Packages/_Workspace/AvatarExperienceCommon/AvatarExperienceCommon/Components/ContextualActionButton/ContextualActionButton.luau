local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	affordance = Foundation.Enums.StateLayerAffordance.None
}

local function getHoverTransparency(p1) -- line: 13
	if p1 then
		return 0
	end

	return 0.2
end
local function useHoverBinding() -- line: 17
	-- upvalues: React (copy), Foundation (copy)
	local v10, v11 = React.useBinding(false)

	return v10, (React.useCallback(function(p2) -- line: 21
		-- upvalues: Foundation (copy), v11 (copy)
		if p2 == Foundation.Enums.ControlState.Default then
			v11(false)

			return
		end

		if p2 == Foundation.Enums.ControlState.Hover then
			v11(true)
		end
	end, {}))
end
local function ContextualActionButton(t2: {[any]: any}, p3) -- line: 45
	-- upvalues: useTokens (copy), useHoverBinding (copy), React (copy), Foundation (copy), t1 (copy), getHoverTransparency (copy)
	local v14 = useTokens()
	local v15, v16 = useHoverBinding()
	local v17 = React.useCallback(function(p4) -- line: 50
		-- upvalues: v14 (copy), t2 (copy)
		if p4 then
			return v14.Color.Shift.Shift_200
		end

		if t2.isActive then
			return v14.Color.Shift.Shift_400
		end

		return {
			Transparency = 1,
			Color3 = v14.Color.Shift.Shift_200.Color3
		}
	end, {
		t2.isActive,
		v14
	})

	return React.createElement(Foundation.View, {
		tag = "radius-circle clip auto-xy",
		ref = p3,
		backgroundStyle = v14.Color.OverMedia.OverMedia_0,
		LayoutOrder = t2.LayoutOrder,
		stateLayer = t1,
		onStateChanged = if not t2.disabled then v16 else nil,
		onActivated = t2.onActivated,
		disabled = t2.disabled,
		selection = {
			Selectable = t2.Selectable or false
		}
	}, {
		HoverHandler = React.createElement(Foundation.View, {
			tag = "padding-small radius-circle clip auto-xy",
			Size = if not t2.size then UDim2.fromScale(1, 1) else UDim2.new(t2.size, t2.size),
			GroupTransparency = t2.GroupTransparencyOverwrite or v15:map(getHoverTransparency),
			backgroundStyle = v15:map(v17)
		}, {
			Children = React.createElement(React.Fragment, nil, t2.children)
		})
	})
end

return React.forwardRef(ContextualActionButton)
