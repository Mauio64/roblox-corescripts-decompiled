local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")

local view = Foundation.View
local controlState = Foundation.Enums.ControlState
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local usePreferences = Foundation.Hooks.usePreferences

local reaction = MomentsCommon.Components.Reaction
local reactionSize = MomentsCommon.Enums.ReactionSize

local v5 = { frequency = 4, dampingRatio = 0.65 }
local v6 = { frequency = 4, dampingRatio = 1 }

local function PickerItem(props)
	local reducedMotion = usePreferences().reducedMotion
	local ref = React.useRef(nil)

	local v7 = React.useCallback(function()
		local current = ref.current

		local v8 = if current ~= nil then current.AbsolutePosition + current.AbsoluteSize / 2 else nil

		props.onSelect(props.reaction, v8)
	end, { props.onSelect, props.reaction })

	local v8, v9 = ReactOtter.useAnimatedBinding(0)
	local v10, v11 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function()
		if reducedMotion then
			v9(ReactOtter.instant(1))
		else
			local thread = task.delay((props.index - 1) * 0.04, function()
				v9(ReactOtter.spring(1, v5))
			end)
			return function()
				task.cancel(thread)
			end
		end
	end, { props.index, reducedMotion })

	local state, setState = React.useState(false)
	React.useEffect(function()
		local v12 = state and 1 or 0

		if reducedMotion then
			v11(ReactOtter.instant(v12))
		else
			v11(ReactOtter.spring(v12, v6))
		end
	end, { state, reducedMotion })

	local v12 = React.useCallback(function(p2)
		setState(p2 == controlState.Hover or p2 == controlState.Pressed or p2 == controlState.Selected or p2 == controlState.SelectedPressed)
	end, {})

	local mapped = React.joinBindings({ entry = v8, hover = v10 }):map(function(p2)
		return p2.entry * (1 + p2.hover * 0.1)
	end)

	local mapped2 = React.joinBindings({ entry = v8, hover = v10 }):map(function(p2)
		local v13 = (1 - p2.entry) * 12 - p2.hover * 8
		return UDim2.new(0.5, 0, 0.5, v13)
	end)

	return React.createElement(view, {
		tag = "size-800-800",
		onActivated = v7,
		onStateChanged = v12,
		LayoutOrder = props.index,
		selection = { Selectable = true },
		stateLayer = { affordance = stateLayerAffordance.None },
		ref = ref
	}, {
		Glyph = React.createElement(reaction, {
			reactionType = props.reaction,
			size = reactionSize.Medium,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = mapped2,
			scale = mapped
		})
	})
end

return React.memo(PickerItem)
