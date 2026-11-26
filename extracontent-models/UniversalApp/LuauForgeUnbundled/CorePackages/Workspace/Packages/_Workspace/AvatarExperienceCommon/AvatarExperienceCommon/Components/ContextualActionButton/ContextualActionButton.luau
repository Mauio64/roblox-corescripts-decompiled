local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local useTokens = Foundation.Hooks.useTokens

local v5 = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function getHoverTransparency(p2): number
	if p2 then
		return 0
	end

	return 0.2
end

local function useHoverBinding()
	local v6, v7 = React.useBinding(false)

	return v6, (React.useCallback(function(p2)
		if p2 == Foundation.Enums.ControlState.Default then
			v7(false)
		elseif p2 == Foundation.Enums.ControlState.Hover then
			v7(true)
		end
	end, {}))
end

local function ContextualActionButton(props, p2)
	local v6 = useTokens()

	local v7, v8 = useHoverBinding()

	local v9 = React.useCallback(function(p3)
		if p3 then
			return v6.Color.Shift.Shift_200
		end

		if props.isActive then
			return v6.Color.Shift.Shift_400
		end

		return { Color3 = v6.Color.Shift.Shift_200.Color3, Transparency = 1 }
	end, { props.isActive, v6 })

	local createElement = React.createElement
	local view = Foundation.View
	local v10 = {
		ref = p2,
		backgroundStyle = v6.Color.OverMedia.OverMedia_0,
		LayoutOrder = props.LayoutOrder,
		stateLayer = v5,
		onStateChanged = 0,
		onActivated = 0,
		disabled = 0,
		selection = 0,
		tag = "radius-circle clip auto-xy"
	}

	if props.disabled then
		v8 = nil
	end

	v10.onStateChanged = v8
	v10.onActivated = props.onActivated
	v10.disabled = props.disabled
	v10.selection = {
		Selectable = props.Selectable or false
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v13 = if props.size then UDim2.new(props.size, props.size) else UDim2.fromScale(1, 1)
	return createElement(view, v10, {
		HoverHandler = createElement2(view2, {
			Size = v13,
			GroupTransparency = props.GroupTransparencyOverwrite or v7:map(getHoverTransparency),
			backgroundStyle = v7:map(v9),
			tag = "padding-small radius-circle clip auto-xy"
		}, {
			Children = React.createElement(React.Fragment, nil, props.children)
		})
	})
end

return React.forwardRef(ContextualActionButton)
