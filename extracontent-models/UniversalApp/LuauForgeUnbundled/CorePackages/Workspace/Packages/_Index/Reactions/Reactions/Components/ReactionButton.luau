local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/ReactOtter")

local module4 = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/Reaction")
local ReactionSize = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionSize")
require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionType")

local controlState = Foundation.Enums.ControlState
local view = Foundation.View
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens

local vector2 = Vector2.new(0.5, 0.5)

local v5 = { frequency = 4, dampingRatio = 0.65 }

local v6 = { frequency = 4, dampingRatio = 1 }

local function getCenter(p2)
	return p2.AbsolutePosition + p2.AbsoluteSize / 2
end

local function ReactionButton(props)
	local v7 = useTokens()
	local reducedMotion = usePreferences().reducedMotion

	local v8 = React.useMemo(function()
		return {
			radius = UDim.new(0, v7.Radius.Circle),
			offset = v7.Size.Size_150,
			borderWidth = v7.Stroke.Thicker
		}
	end, { v7 })

	local state, setState = React.useState(false)
	local v9 = React.useCallback(function(p2)
		setState(p2 == controlState.Hover)
	end, {})

	local v10 = props.isHovered == true or state
	local v11, v12 = ReactOtter.useAnimatedBinding(0)
	React.useEffect(function()
		local v13 = v10 and 1 or 0

		if reducedMotion then
			v12(ReactOtter.instant(v13))
		else
			v12(ReactOtter.spring(v13, v6))
		end
	end, { v10, reducedMotion })

	local entryDelay = props.entryDelay
	local v13, v14 = ReactOtter.useAnimatedBinding(entryDelay == nil and 1 or 0)
	React.useEffect(function()
		if entryDelay == nil or reducedMotion then
			v14(ReactOtter.instant(1))
			return nil
		end

		local thread = task.delay(entryDelay, function()
			v14(ReactOtter.spring(1, v5))
		end)
		return function()
			task.cancel(thread)
		end
	end, { entryDelay, reducedMotion })

	local joinBindings = React.joinBindings({ entry = v13, hover = v11 })
	local mapped = joinBindings:map(function(p2)
		return UDim2.new(0.5, 0, 0.5, (1 - p2.entry) * 12 - p2.hover * 8)
	end)

	local mapped2 = joinBindings:map(function(p2)
		return p2.entry * (1 + p2.hover * 0.1)
	end)

	local onActivated = props.onActivated
	local v15 = React.useCallback(function(p2)
		onActivated(p2.AbsolutePosition + p2.AbsoluteSize / 2)
	end, { onActivated })

	local createElement = React.createElement
	local v17 = {
		tag = {
			["size-1000-1000 radius-circle"] = true,
			["bg-surface-300"] = props.isActive == true
		},
		onActivated = v15,
		onStateChanged = v9,
		cursor = v8,
		LayoutOrder = props.layoutOrder,
		ref = props.buttonRef,
		testId = props.testId
	}

	local createElement2 = React.createElement
	local v20 = {
		tag = "auto-xy",
		Position = mapped,
		AnchorPoint = vector2,
		ZIndex = 2,
		scale = mapped2,
		testId = 0
	}

	local v21 = if props.testId then `{props.testId}--glyph` else nil
	v20.testId = v21

	local createElement3 = React.createElement
	local v24 = {
		reactionType = props.reactionType,
		size = props.reactionSize or ReactionSize.Small,
		testId = 0
	}
	local v25 = if props.testId then `{props.testId}--reaction` else nil
	v24.testId = v25
	return createElement(view, v17, {
		Glyph = createElement2(view, v20, { Reaction = createElement3(module4, v24) })
	})
end

return React.memo(ReactionButton)
