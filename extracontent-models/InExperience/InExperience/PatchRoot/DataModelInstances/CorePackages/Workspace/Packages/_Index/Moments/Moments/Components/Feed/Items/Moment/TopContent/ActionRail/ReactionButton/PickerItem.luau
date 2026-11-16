local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local usePreferences = Foundation.Hooks.usePreferences

local Reaction = MomentsCommon.Components.Reaction
local ReactionSize = MomentsCommon.Enums.ReactionSize

local v = { frequency = 4, dampingRatio = 0.65 }
local v2 = { frequency = 4, dampingRatio = 1 }

local function PickerItem(props)
	local reducedMotion = usePreferences().reducedMotion
	local ref = React.useRef(nil)

	local onActivated = React.useCallback(function()
		local current = ref.current
		local v3

		if current ~= nil then
			v3 = current.AbsolutePosition + current.AbsoluteSize / 2
		end

		props.onSelect(props.reaction, v3)
	end, { props.onSelect, props.reaction })

	local entry, v3 = ReactOtter.useAnimatedBinding(0)
	local hover, v4 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function()
		if reducedMotion then
			v3(ReactOtter.instant(1))
		else
			local thread = task.delay((props.index - 1) * 0.04, function()
				v3((ReactOtter.spring(1, v)))
			end)
			return function()
				task.cancel(thread)
			end
		end
	end, { props.index, reducedMotion })

	local state, setState = React.useState(false)
	React.useEffect(function()
		local v5 = state and 1 or 0

		if reducedMotion then
			v4(ReactOtter.instant(v5))
		else
			v4((ReactOtter.spring(v5, v2)))
		end
	end, { state, reducedMotion })

	local onStateChanged = React.useCallback(function(p)
		setState(p == ControlState.Hover or p == ControlState.Pressed or p == ControlState.Selected or p == ControlState.SelectedPressed)
	end, {})

	local mapped = React.joinBindings({ entry = entry, hover = hover }):map(function(p)
		return p.entry * (p.hover * 0.1 + 1)
	end)

	local mapped2 = React.joinBindings({ entry = entry, hover = hover }):map(function(p)
		local v5 = (1 - p.entry) * 12 - p.hover * 8
		return UDim2.new(0.5, 0, 0.5, v5)
	end)

	return React.createElement(View, {
		tag = "size-800-800",
		onActivated = onActivated,
		onStateChanged = onStateChanged,
		LayoutOrder = props.index,
		selection = { Selectable = true },
		stateLayer = { affordance = StateLayerAffordance.None },
		ref = ref
	}, {
		Glyph = React.createElement(Reaction, {
			reactionType = props.reaction,
			size = ReactionSize.Medium,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = mapped2,
			scale = mapped
		})
	})
end

return React.memo(PickerItem)
