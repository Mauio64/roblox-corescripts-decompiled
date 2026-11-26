local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DataHydration")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Reactions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Reactions")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Stores/ContentReactionsStoreTypes")
local AddReactionButton = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/AddReactionButton")
local useOptimisticReactions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/useOptimisticReactions")

local getLocalPlayerUserId = DataHydration.DataHydrationUtils.getLocalPlayerUserId

local view = Foundation.View

local function findReaction(p2, items)
	local reactionType = p2.reactionType
	local v5 = nil

	for k, item in items do
		if item.reactionType ~= reactionType then
			continue
		end

		if item.hasUserAppliedReaction then
			return item
		end

		v5 = v5 or item
	end

	if v5 then
		return v5
	end

	return {
		emoteId = p2.emoteId,
		reactionType = reactionType,
		hasUserAppliedReaction = false
	}
end

local function SduiReactions(props)
	local onReactionActivated = props.onReactionActivated
	local v5 = not (onReactionActivated == nil or getLocalPlayerUserId() == nil) and not props.isDisabled

	local v6, v7 = useOptimisticReactions(props.id, props.reactions, onReactionActivated)

	local v8 = React.useMemo(function()
		local v9 = {}
		local reactionTypes = {}

		for k, v10 in props.availableReactions or {} do
			local reactionType = v10.reactionType

			if not Reactions.Constants.ReactionIconMappings[reactionType] then
				continue
			end

			v9[reactionType] = v10
			table.insert(reactionTypes, reactionType)
		end

		return { reactionTypes = reactionTypes, availableByType = v9 }
	end, { props.availableReactions })

	local v9 = React.useMemo(function()
		local reactionTypeSet = {}

		for k, v10 in v6 do
			if v10.hasUserAppliedReaction then
				reactionTypeSet[v10.reactionType] = true
			end
		end

		return reactionTypeSet
	end, { v6 })

	local function selectReaction(p2)
		v7(findReaction(v8.availableByType[p2], v6))
	end

	local count = 0
	local v10 = false
	local children = {}

	for k, v11 in v6 do
		if not Reactions.Constants.ReactionIconMappings[v11.reactionType] then
			continue
		end

		local reactionCount = props.areReactionCountsVisible and (v11.reactionCount or 0) or nil
		count += 1
		v10 = v10 or reactionCount ~= 0
		children[`Reaction_{v11.emoteId}`] = React.createElement(Reactions.ReactionPill, {
			reactionType = v11.reactionType,
			count = reactionCount,
			isSelected = v11.hasUserAppliedReaction,
			onActivated = v5 and function()
				v7(v11)
			end or nil,
			layoutOrder = count,
			testId = `reaction-{v11.emoteId}`
		})
	end

	if v5 and #v8.reactionTypes > 0 then
		children.AddReaction = React.createElement(AddReactionButton, {
			layoutOrder = 0,
			reactions = v8.reactionTypes,
			selectedReactions = v9,
			onReactionSelected = selectReaction
		})
	elseif not v10 then
		return nil
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			testId = "reactions",
			tag = "row wrap align-y-center gap-small size-full-0 auto-y"
		},
		children
	)
end

return SduiReactions
