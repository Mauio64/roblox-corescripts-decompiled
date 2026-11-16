local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local FFlagMomentsUseSharedReactions = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsUseSharedReactions")

local text = Foundation.Text
local view = Foundation.View
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState

local v5 = if FFlagMomentsUseSharedReactions then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Reactions/Reaction") else MomentsCommon.Components.Reaction
local reactionSize = MomentsCommon.Enums.ReactionSize

local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local ReactionsSheet = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/ReactionsSheet")
local getColorStyleWithTransparency = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getColorStyleWithTransparency")

local function formatCount(p2)
	if p2 == nil then
		return ""
	end

	if p2 >= 1000000 then
		return string.format("%.1fM", p2 / 1000000)
	end

	if p2 >= 1000 then
		return string.format("%.1fK", p2 / 1000)
	end

	return (tostring(p2))
end

local function Reactions(p2)
	local v6 = useTokens()
	local v7 = MomentContext.useMoment()

	local state, setState = React.useState(false)

	local v8 = useSignalBinding(v7.store.getReactionCount)

	local v9 = useSignalState(v7.store.getIndividualReactionCounts)
	local animationRatio = v7.animationRatio

	local mapped = animationRatio:map(function(p3)
		return getColorStyleWithTransparency(v6.Color.Content.Emphasis, p3)
	end)

	local v10 = React.useCallback(function()
		setState(true)
	end, {})

	local v11 = React.useCallback(function()
		setState(false)
	end, {})

	local children = {}

	for i = 1, math.min(3, #v9) do
		local v12 = v9[i]
		children["Reaction" .. i] = React.createElement(v5, {
			LayoutOrder = i,
			reactionType = v12.reaction,
			size = reactionSize.Small,
			imageStyle = mapped
		})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v13 = {
		ReactionsLine = React.createElement(view, {
			LayoutOrder = p2.LayoutOrder,
			tag = "row align-x-left align-y-center gap-small auto-xy",
			onActivated = v10,
			stateLayer = { affordance = stateLayerAffordance.None },
			Visible = v8:map(function(p3): boolean
				return p3 ~= nil
			end)
		}, {
			Facepile = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "row align-x-left align-y-center gap-xxsmall auto-xy"
				},
				children
			),
			Count = React.createElement(text, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-medium text-align-x-left text-align-y-center content-default",
				Text = v8:map(function(p3)
					local v15

					if p3 == nil then
						v15 = ""
					elseif p3 >= 1000000 then
						v15 = string.format("%.1fM", p3 / 1000000)
					else
						v15 = if p3 >= 1000 then string.format("%.1fK", p3 / 1000) else tostring(p3)
					end

					return `{v15} reactions`
				end),
				textStyle = animationRatio:map(function(p3)
					return getColorStyleWithTransparency(v6.Color.Content.Default, p3)
				end)
			})
		}),
		Modal = 0
	}

	local v14 = if state then React.createElement(ReactionsSheet, {
		reactionCounts = v9,
		onClose = v11
	}) else nil
	v13.Modal = v14
	return createElement(fragment, nil, v13)
end

return React.memo(Reactions)
