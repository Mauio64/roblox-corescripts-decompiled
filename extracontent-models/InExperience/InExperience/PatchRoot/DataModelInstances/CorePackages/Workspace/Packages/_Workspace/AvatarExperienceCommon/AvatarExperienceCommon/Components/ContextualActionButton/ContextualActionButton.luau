local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function getHoverTransparency(p): number
	return if p then 0 else 0.2
end

local function useHoverBinding()
	local v, v2 = React.useBinding(false)

	return v, (React.useCallback(function(p)
		if p == Foundation.Enums.ControlState.Default then
			v2(false)
		elseif p == Foundation.Enums.ControlState.Hover then
			v2(true)
		end
	end, {}))
end

local function ContextualActionButton(props, ref)
	local v = useTokens()

	local v2, onStateChanged = useHoverBinding()

	local v3 = React.useCallback(function(p)
		if p then
			return v.Color.Shift.Shift_200
		end

		if props.isActive then
			return v.Color.Shift.Shift_400
		end

		return { Color3 = v.Color.Shift.Shift_200.Color3, Transparency = 1 }
	end, { props.isActive, v })

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = {
		ref = ref,
		backgroundStyle = v.Color.OverMedia.OverMedia_0,
		LayoutOrder = props.LayoutOrder,
		stateLayer = stateLayer,
		onStateChanged = 0,
		onActivated = 0,
		disabled = 0,
		selection = 0,
		tag = "radius-circle clip auto-xy"
	}

	if props.disabled then
		onStateChanged = nil
	end

	v4.onStateChanged = onStateChanged
	v4.onActivated = props.onActivated
	v4.disabled = props.disabled
	v4.selection = {
		Selectable = props.Selectable or false
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local size

	if props.size then
		size = UDim2.new(props.size, props.size)
	else
		size = UDim2.fromScale(1, 1)
	end

	return createElement(view, v4, {
		HoverHandler = createElement2(view2, {
			Size = size,
			GroupTransparency = props.GroupTransparencyOverwrite or v2:map(getHoverTransparency),
			backgroundStyle = v2:map(v3),
			tag = "padding-small radius-circle clip auto-xy"
		}, {
			Children = React.createElement(React.Fragment, nil, props.children)
		})
	})
end

return React.forwardRef(ContextualActionButton)
