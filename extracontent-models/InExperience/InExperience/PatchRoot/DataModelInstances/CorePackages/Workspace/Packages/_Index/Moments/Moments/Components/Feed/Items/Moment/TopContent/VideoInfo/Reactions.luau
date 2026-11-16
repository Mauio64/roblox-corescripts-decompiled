local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local FFlagMomentsUseSharedReactions = require(Moments.Flags.FFlagMomentsUseSharedReactions)

local Text = Foundation.Text
local View = Foundation.View
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState
local v

if FFlagMomentsUseSharedReactions then
	v = require(parent.Reactions.Reaction)
else
	v = MomentsCommon.Components.Reaction
end

local ReactionSize = MomentsCommon.Enums.ReactionSize

local MomentContext = require(script.Parent.Parent.Parent.MomentContext)
local ReactionsSheet = require(Moments.Components.ReactionsSheet)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)

local function formatCount(p: number?) -- 1 equivalent call inferred from this helper
	if p == nil then
		return ""
	end

	if p >= 1000000 then
		return string.format("%.1fM", p / 1000000)
	end

	if p >= 1000 then
		return string.format("%.1fK", p / 1000)
	end

	return (tostring(p))
end

local function Reactions(p)
	local v2 = useTokens()
	local v3 = MomentContext.useMoment()

	local state, setState = React.useState(false)

	local v4 = useSignalBinding(v3.store.getReactionCount)

	local reactionCounts = useSignalState(v3.store.getIndividualReactionCounts)
	local animationRatio = v3.animationRatio

	local mapped = animationRatio:map(function(p2: number)
		return getColorStyleWithTransparency(v2.Color.Content.Emphasis, p2)
	end)

	local onActivated = React.useCallback(function()
		setState(true)
	end, {})

	local onClose = React.useCallback(function()
		setState(false)
	end, {})

	local children = {}

	for i = 1, math.min(3, #reactionCounts) do
		local v5 = reactionCounts[i]
		children["Reaction" .. i] = React.createElement(v, {
			LayoutOrder = i,
			reactionType = v5.reaction,
			size = ReactionSize.Small,
			imageStyle = mapped
		})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v5 = {
		ReactionsLine = React.createElement(View, {
			LayoutOrder = p.LayoutOrder,
			tag = "row align-x-left align-y-center gap-small auto-xy",
			onActivated = onActivated,
			stateLayer = { affordance = StateLayerAffordance.None },
			Visible = v4:map(function(p2: number?): boolean
				return p2 ~= nil
			end)
		}, {
			Facepile = React.createElement(
				View,
				{ LayoutOrder = 1, tag = "row align-x-left align-y-center gap-xxsmall auto-xy" },
				children
			),
			Count = React.createElement(Text, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-medium text-align-x-left text-align-y-center content-default",
				Text = v4:map(function(p2: number?)
					local v5 = formatCount(p2) -- inferred equivalent call
					return `{v5} reactions`
				end),
				textStyle = animationRatio:map(function(p2: number)
					return getColorStyleWithTransparency(v2.Color.Content.Default, p2)
				end)
			})
		}),
		Modal = 0
	}
	local modal

	if state then
		modal = React.createElement(ReactionsSheet, {
			reactionCounts = reactionCounts,
			onClose = onClose
		})
	end

	v5.Modal = modal
	return createElement(fragment, nil, v5)
end

return React.memo(Reactions)
