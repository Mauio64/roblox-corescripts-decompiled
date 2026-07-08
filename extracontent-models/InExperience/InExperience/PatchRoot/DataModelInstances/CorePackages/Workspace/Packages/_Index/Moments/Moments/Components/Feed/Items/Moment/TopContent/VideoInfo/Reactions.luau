local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local SignalsReact = require(MomentsParent.SignalsReact)
local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local FoundationText = Foundation.Text
local View = Foundation.View
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState
local Reaction = MomentsCommon.Components.Reaction
local ReactionSize = MomentsCommon.Enums.ReactionSize
local MomentContext = require(script.Parent.Parent.Parent.MomentContext)
local ReactionsSheet = require(Moments.Components.ReactionsSheet)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)

local function formatCount(n1: number?) -- line: 46
	if n1 == nil then
		return ""
	end

	if n1 >= 1000000 then
		return string.format("%.1fM", n1 / 1000000)
	end

	if n1 >= 1000 then
		return string.format("%.1fK", n1 / 1000)
	end

	return (tostring(n1))
end
local function Reactions(t1: {[any]: any}) -- line: 58
	-- upvalues: useTokens (copy), MomentContext (copy), React (copy), useSignalBinding (copy), useSignalState (copy), getColorStyleWithTransparency (copy), Reaction (copy), ReactionSize (copy), View (copy), StateLayerAffordance (copy), FoundationText (copy), ReactionsSheet (copy)
	local v22 = useTokens()
	local v23 = MomentContext.useMoment()
	local v24, v25 = React.useState(false)
	local v26 = useSignalBinding(v23.store.getReactionCount)
	local v27 = useSignalState(v23.store.getIndividualReactionCounts)
	local animationRatio = v23.animationRatio
	local v29 = animationRatio:map(function(n2: number) -- line: 71
		-- upvalues: getColorStyleWithTransparency (copy), v22 (copy)
		return getColorStyleWithTransparency(v22.Color.Content.Emphasis, n2)
	end)
	local v30 = React.useCallback(function() -- line: 75
		-- upvalues: v25 (copy)
		v25(true)
	end, {})
	local v31 = React.useCallback(function() -- line: 79
		-- upvalues: v25 (copy)
		v25(false)
	end, {})
	local t2 = {}

	for i = 1, math.min(3, #v27) do
		local v34 = v27[i]

		t2["Reaction" .. i] = React.createElement(Reaction, {
			LayoutOrder = i,
			reactionType = v34.reaction,
			size = ReactionSize.Small,
			imageStyle = v29
		})
	end

	return React.createElement(React.Fragment, nil, {
		ReactionsLine = React.createElement(View, {
			tag = "row align-x-left align-y-center gap-small auto-xy",
			LayoutOrder = t1.LayoutOrder,
			onActivated = v30,
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			Visible = v26:map(function(n3: number?) -- line: 102
				return n3 ~= nil
			end)
		}, {
			Facepile = React.createElement(View, {
				LayoutOrder = 1,
				tag = "row align-x-left align-y-center gap-xxsmall auto-xy"
			}, t2),
			Count = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-medium text-align-x-left text-align-y-center content-default",
				Text = v26:map(function(n4: number?) -- line: 114
					return `{ (if n4 ~= nil then (if not (n4 >= 1000000) then (if not (n4 >= 1000) then tostring(n4) else string.format("%.1fK", n4 / 1000)) else string.format("%.1fM", n4 / 1000000)) else "") } reactions`
				end),
				textStyle = animationRatio:map(function(n5: number) -- line: 117
					-- upvalues: getColorStyleWithTransparency (copy), v22 (copy)
					return getColorStyleWithTransparency(v22.Color.Content.Default, n5)
				end)
			})
		}),
		Modal = if not v24 then nil else React.createElement(ReactionsSheet, {
			reactionCounts = v27,
			onClose = v31
		})
	})
end

return React.memo(Reactions)
