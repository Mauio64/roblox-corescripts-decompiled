local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)
local MomentsCommon = require(Parent.MomentsCommon)
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local usePreferences = Foundation.Hooks.usePreferences
local Reaction = MomentsCommon.Components.Reaction
local ReactionSize = MomentsCommon.Enums.ReactionSize
local t1 = {
	frequency = 4,
	dampingRatio = 0.65
}
local t2 = {
	frequency = 4,
	dampingRatio = 1
}

local function PickerItem(t3: {[any]: any}) -- line: 33
	-- upvalues: usePreferences (copy), React (copy), ReactOtter (copy), t1 (copy), t2 (copy), ControlState (copy), View (copy), StateLayerAffordance (copy), Reaction (copy), ReactionSize (copy)
	local reducedMotion = usePreferences().reducedMotion
	local v17 = React.useRef(nil)
	local v18 = React.useCallback(function() -- line: 37
		-- upvalues: v17 (copy), t3 (copy)
		local current = v17.current
		local v29 = nil

		if current ~= nil then
			v29 = current.AbsolutePosition + current.AbsoluteSize / 2
		end

		t3.onSelect(t3.reaction, v29)
	end, {
		t3.onSelect,
		t3.reaction
	})
	local v19, v20 = ReactOtter.useAnimatedBinding(0)
	local v21, v22 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function() -- line: 50
		-- upvalues: reducedMotion (copy), v20 (copy), ReactOtter (copy), t3 (copy), t1 (copy)
		if reducedMotion then
			v20(ReactOtter.instant(1))

			return
		end

		local thread = task.delay((t3.index - 1) * 0.04, function() -- line: 55
			-- upvalues: v20 (copy), ReactOtter (copy), t1 (copy)
			v20((ReactOtter.spring(1, t1)))
		end)

		return function() -- line: 58
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		t3.index,
		reducedMotion
	})

	local v23, v24 = React.useState(false)

	React.useEffect(function() -- line: 65
		-- upvalues: v23 (copy), reducedMotion (copy), v22 (copy), ReactOtter (copy), t2 (copy)
		local v31 = not v23 and 0 or 1

		if reducedMotion then
			v22(ReactOtter.instant(v31))

			return
		end

		v22((ReactOtter.spring(v31, t2)))
	end, {
		v23,
		reducedMotion
	})

	local v25 = React.useCallback(function(p1) -- line: 74
		-- upvalues: v24 (copy), ControlState (copy)
		v24(p1 == ControlState.Hover or (p1 == ControlState.Pressed or (p1 == ControlState.Selected or p1 == ControlState.SelectedPressed)))
	end, {})
	local v26 = React.joinBindings({
		entry = v19,
		hover = v21
	}):map(function(t4: {[any]: any}) -- line: 88
		return t4.entry * (t4.hover * 0.1 + 1)
	end)
	local v27 = React.joinBindings({
		entry = v19,
		hover = v21
	}):map(function(t5: {[any]: any}) -- line: 94
		local v35 = (1 - t5.entry) * 12 - t5.hover * 8

		return UDim2.new(0.5, 0, 0.5, v35)
	end)

	return React.createElement(View, {
		tag = "size-800-800",
		onActivated = v18,
		onStateChanged = v25,
		LayoutOrder = t3.index,
		selection = {
			Selectable = true
		},
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		ref = v17
	}, {
		Glyph = React.createElement(Reaction, {
			reactionType = t3.reaction,
			size = ReactionSize.Medium,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = v27,
			scale = v26
		})
	})
end

return React.memo(PickerItem)
