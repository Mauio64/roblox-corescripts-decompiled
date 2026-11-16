local Reactions = script:FindFirstAncestor("Reactions")
local parent = Reactions.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local Reaction = require(Reactions.Components.Reaction)
local ReactionSize = require(Reactions.Enums.ReactionSize)
require(Reactions.Enums.ReactionType)

local ControlState = Foundation.Enums.ControlState
local View = Foundation.View
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens

local vector2 = Vector2.new(0.5, 0.5)

local v = { frequency = 4, dampingRatio = 0.65 }

local v2 = { frequency = 4, dampingRatio = 1 }

local function getCenter(p) -- 1 equivalent call inferred from this helper
	return p.AbsolutePosition + p.AbsoluteSize / 2
end

local function ReactionButton(props)
	local v3 = useTokens()
	local reducedMotion = usePreferences().reducedMotion

	local cursor = React.useMemo(function()
		return {
			radius = UDim.new(0, v3.Radius.Circle),
			offset = v3.Size.Size_150,
			borderWidth = v3.Stroke.Thicker
		}
	end, { v3 })

	local state, setState = React.useState(false)
	local onStateChanged = React.useCallback(function(p)
		setState(p == ControlState.Hover)
	end, {})

	local v4 = props.isHovered == true or state
	local hover, v5 = ReactOtter.useAnimatedBinding(0)
	React.useEffect(function()
		local v6 = v4 and 1 or 0

		if reducedMotion then
			v5((ReactOtter.instant(v6)))
		else
			v5((ReactOtter.spring(v6, v2)))
		end
	end, { v4, reducedMotion })

	local entryDelay = props.entryDelay
	local entry, v6 = ReactOtter.useAnimatedBinding(entryDelay == nil and 1 or 0)
	React.useEffect(function()
		if entryDelay == nil or reducedMotion then
			v6((ReactOtter.instant(1)))
			return nil
		end

		local thread = task.delay(entryDelay, function()
			v6((ReactOtter.spring(1, v)))
		end)
		return function()
			task.cancel(thread)
		end
	end, { entryDelay, reducedMotion })

	local joinBindings = React.joinBindings({ entry = entry, hover = hover })
	local mapped = joinBindings:map(function(p)
		return UDim2.new(0.5, 0, 0.5, (1 - p.entry) * 12 - p.hover * 8)
	end)

	local mapped2 = joinBindings:map(function(p)
		return p.entry * (p.hover * 0.1 + 1)
	end)

	local onActivated = props.onActivated
	local onActivated2 = React.useCallback(function(p)
		onActivated(getCenter(p)) -- inferred equivalent call
	end, { onActivated })

	local createElement = React.createElement
	local v7 = {
		tag = {
			["size-1000-1000 radius-circle"] = true,
			["bg-surface-300"] = props.isActive == true
		},
		onActivated = onActivated2,
		onStateChanged = onStateChanged,
		cursor = cursor,
		LayoutOrder = props.layoutOrder,
		ref = props.buttonRef,
		testId = props.testId
	}

	local createElement2 = React.createElement
	local v8 = {
		tag = "auto-xy",
		Position = mapped,
		AnchorPoint = vector2,
		ZIndex = 2,
		scale = mapped2,
		testId = 0
	}
	local testId

	if props.testId then
		testId = `{props.testId}--glyph`
	end

	v8.testId = testId

	local createElement3 = React.createElement
	local v9 = {
		reactionType = props.reactionType,
		size = props.reactionSize or ReactionSize.Small,
		testId = 0
	}
	local testId2

	if props.testId then
		testId2 = `{props.testId}--reaction`
	end

	v9.testId = testId2
	return createElement(View, v7, {
		Glyph = createElement2(View, v8, { Reaction = createElement3(Reaction, v9) })
	})
end

return React.memo(ReactionButton)
