local TweenService = game:GetService("TweenService")

local Reactions = script:FindFirstAncestor("Reactions")
local parent = Reactions.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local Reaction = require(Reactions.Components.Reaction)
local ReactionSize = require(Reactions.Enums.ReactionSize)
require(Reactions.Enums.ReactionType)
local abbreviateReactionCount = require(Reactions.Utils.abbreviateReactionCount)

local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local Text = Foundation.Text
local View = Foundation.View
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens

local function easeOut(p: number)
	return TweenService:GetValue(p, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

local function getPopScale(p: number)
	if p < 0.6 then
		return (math.lerp(0.88, 1.08, easeOut(p / 0.6)))
	end

	return (math.lerp(1.08, 1, easeOut((p - 0.6) / 0.4)))
end

local function getPopOpacity(p: number) -- 1 equivalent call inferred from this helper
	if p < 0.6 then
		return (math.lerp(0.55, 1, easeOut(p / 0.6)))
	end

	return 1
end

local function CountText(props)
	local default = useTokens().Color.Content.Default
	local v, v2 = ReactOtter.useAnimatedBinding(props.isAnimated and 0 or 1)

	React.useLayoutEffect(function()
		if props.isAnimated then
			v2((ReactOtter.ease(1, { duration = 0.24 })))
		end
	end, { props.isAnimated })

	local createElement = React.createElement
	local v3 = {
		Text = props.text,
		scale = 0,
		textStyle = 0,
		tag = "auto-xy text-label-small content-default",
		LayoutOrder = 2,
		testId = 0
	}
	local scale

	if props.isAnimated then
		scale = v:map(getPopScale)
	end

	v3.scale = scale
	local textStyle

	if props.isAnimated then
		textStyle = v:map(function(p: number)
			return {
				Color3 = default.Color3,
				Transparency = 1 - (1 - (default.Transparency or 0)) * getPopOpacity(p) -- inferred equivalent call
			}
		end)
	end

	v3.textStyle = textStyle

	v3.testId = props.testId
	return createElement(Text, v3)
end

local function PoppingCount(props)
	local reducedMotion = usePreferences().reducedMotion
	local state, setState = React.useState(0)
	local ref = React.useRef(props.count)

	React.useLayoutEffect(function()
		if ref.current ~= props.count then
			ref.current = props.count
			setState(function(p: number)
				return p + 1
			end)
		end
	end, { props.count })

	return React.createElement(CountText, {
		key = tostring(state),
		text = props.localizeCount(props.count),
		isAnimated = state > 0 and not reducedMotion,
		testId = props.testId
	})
end

local function ReactionPill(props)
	local testId = props.testId or "reaction-pill"
	local count = props.count

	if count == 0 then
		return nil
	end

	local isSelected = props.isSelected == true

	local createElement = React.createElement
	local v = {
		tag = {
			["row align-y-center gap-xsmall auto-xy padding-small stroke-standard radius-circle"] = true,
			["stroke-action-standard bg-shift-300"] = isSelected,
			["stroke-default bg-surface-100"] = not isSelected
		},
		stateLayer = isSelected and { affordance = StateLayerAffordance.None } or nil,
		onActivated = props.onActivated,
		LayoutOrder = props.layoutOrder,
		testId = testId
	}

	local v2 = {
		Reaction = React.createElement(Reaction, {
			reactionType = props.reactionType,
			size = ReactionSize.XSmall,
			LayoutOrder = 1,
			testId = `{testId}--reaction`
		}),
		Count = 0
	}
	local count2

	if count ~= nil then
		count2 = React.createElement(PoppingCount, {
			count = count,
			localizeCount = props.localizeCount or abbreviateReactionCount,
			testId = `{testId}--count`
		})
	end

	v2.Count = count2
	return createElement(View, v, v2)
end

return React.memo(ReactionPill)
