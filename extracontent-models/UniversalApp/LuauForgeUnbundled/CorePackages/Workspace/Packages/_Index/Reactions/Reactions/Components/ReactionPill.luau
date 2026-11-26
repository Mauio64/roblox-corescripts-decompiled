local TweenService = game:GetService("TweenService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/ReactOtter")

local module4 = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/Reaction")
local ReactionSize = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionSize")
require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionType")
local abbreviateReactionCount = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Utils/abbreviateReactionCount")

local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local text = Foundation.Text
local view = Foundation.View
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens

local function easeOut(p2)
	return TweenService:GetValue(p2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

local function getPopScale(p2)
	if p2 < 0.6 then
		return (math.lerp(0.88, 1.08, easeOut(p2 / 0.6)))
	end

	return (math.lerp(1.08, 1, easeOut((p2 - 0.6) / 0.4)))
end

local function getPopOpacity(p2)
	if p2 < 0.6 then
		return (math.lerp(0.55, 1, easeOut(p2 / 0.6)))
	end

	return 1
end

local function CountText(props)
	local default = useTokens().Color.Content.Default
	local v5, v6 = ReactOtter.useAnimatedBinding(props.isAnimated and 0 or 1)

	React.useLayoutEffect(function()
		if props.isAnimated then
			v6(ReactOtter.ease(1, { duration = 0.24 }))
		end
	end, { props.isAnimated })

	local createElement = React.createElement
	local v8 = {
		Text = props.text,
		scale = 0,
		textStyle = 0,
		tag = "auto-xy text-label-small content-default",
		LayoutOrder = 2,
		testId = 0
	}
	local v9 = if props.isAnimated then v5:map(getPopScale) else nil
	v8.scale = v9
	local v10

	if props.isAnimated then
		v10 = v5:map(function(p2)
			return {
				Color3 = default.Color3,
				Transparency = 1 - (1 - (default.Transparency or 0)) * (not (p2 < 0.6) and 1 or math.lerp(0.55, 1, easeOut(p2 / 0.6)))
			}
		end)
	end

	v8.textStyle = v10

	v8.testId = props.testId
	return createElement(text, v8)
end

local function PoppingCount(props)
	local reducedMotion = usePreferences().reducedMotion
	local state, setState = React.useState(0)
	local ref = React.useRef(props.count)

	React.useLayoutEffect(function()
		if ref.current ~= props.count then
			ref.current = props.count
			setState(function(p2)
				return p2 + 1
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
	local v6 = {
		tag = {
			["row align-y-center gap-xsmall auto-xy padding-small stroke-standard radius-circle"] = true,
			["stroke-action-standard bg-shift-300"] = isSelected,
			["stroke-default bg-surface-100"] = not isSelected
		},
		stateLayer = isSelected and { affordance = stateLayerAffordance.None } or nil,
		onActivated = props.onActivated,
		LayoutOrder = props.layoutOrder,
		testId = testId
	}

	local v7 = {
		Reaction = React.createElement(module4, {
			reactionType = props.reactionType,
			size = ReactionSize.XSmall,
			LayoutOrder = 1,
			testId = `{testId}--reaction`
		}),
		Count = 0
	}

	local v8 = if count ~= nil then React.createElement(PoppingCount, {
		count = count,
		localizeCount = props.localizeCount or abbreviateReactionCount,
		testId = `{testId}--count`
	}) else nil
	v7.Count = v8
	return createElement(view, v6, v7)
end

return React.memo(ReactionPill)
