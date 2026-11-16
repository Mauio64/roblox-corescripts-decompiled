local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local DataHydration = require(parent.DataHydration)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Reactions = require(parent.Reactions)

require(SduiSharedContent.Stores.ContentReactionsStoreTypes)
local AddReactionButton = require(SduiSharedContent.Components.AddReactionButton)
local useOptimisticReactions = require(SduiSharedContent.Components.useOptimisticReactions)

local getLocalPlayerUserId = DataHydration.DataHydrationUtils.getLocalPlayerUserId

local View = Foundation.View

local function findReaction(p, items)
	local reactionType = p.reactionType
	local v = nil

	for _, item in items do
		if item.reactionType ~= reactionType then
			continue
		end

		if item.hasUserAppliedReaction then
			return item
		end

		v = v or item
	end

	return v or { emoteId = p.emoteId, reactionType = reactionType, hasUserAppliedReaction = false }
end

local function SduiReactions(props)
	local onReactionActivated = props.onReactionActivated
	local v

	if onReactionActivated == nil or getLocalPlayerUserId() == nil then
		v = false
	else
		v = not props.isDisabled
	end

	local v2, v3 = useOptimisticReactions(props.id, props.reactions, onReactionActivated)

	local v4 = React.useMemo(function()
		local availableByType = {}
		local reactionTypes = {}

		for _, v4 in props.availableReactions or {} do
			local reactionType = v4.reactionType

			if not Reactions.Constants.ReactionIconMappings[reactionType] then
				continue
			end

			availableByType[reactionType] = v4
			table.insert(reactionTypes, reactionType)
		end

		return { reactionTypes = reactionTypes, availableByType = availableByType }
	end, { props.availableReactions })

	local selectedReactions = React.useMemo(function()
		local reactionTypeSet = {}

		for _, v5 in v2 do
			if v5.hasUserAppliedReaction then
				reactionTypeSet[v5.reactionType] = true
			end
		end

		return reactionTypeSet
	end, { v2 })

	local function selectReaction(p)
		v3(findReaction(v4.availableByType[p], v2))
	end

	local count = 0
	local v5 = false
	local children = {}

	for _, v6 in v2 do
		if not Reactions.Constants.ReactionIconMappings[v6.reactionType] then
			continue
		end

		local reactionCount = props.areReactionCountsVisible and (v6.reactionCount or 0) or nil
		count += 1
		v5 = v5 or reactionCount ~= 0
		children[`Reaction_{v6.emoteId}`] = React.createElement(Reactions.ReactionPill, {
			reactionType = v6.reactionType,
			count = reactionCount,
			isSelected = v6.hasUserAppliedReaction,
			onActivated = v and function()
				v3(v6)
			end or nil,
			layoutOrder = count,
			testId = `reaction-{v6.emoteId}`
		})
	end

	if v and #v4.reactionTypes > 0 then
		children.AddReaction = React.createElement(AddReactionButton, {
			layoutOrder = 0,
			reactions = v4.reactionTypes,
			selectedReactions = selectedReactions,
			onReactionSelected = selectReaction
		})
	elseif not v5 then
		return nil
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			testId = "reactions",
			tag = "row wrap align-y-center gap-small size-full-0 auto-y"
		},
		children
	)
end

return SduiReactions
