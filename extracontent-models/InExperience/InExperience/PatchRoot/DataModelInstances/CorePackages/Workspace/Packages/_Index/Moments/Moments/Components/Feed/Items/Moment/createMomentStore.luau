local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent

require(MomentsParent.MomentsCommon)
require(MomentsParent.MomentsTypes)

local Signals = require(MomentsParent.Signals)
local GetReactionsStore = require(Moments.Stores.GetReactionsStore)
local GetShareCountsStore = require(Moments.Stores.GetShareCountsStore)

require(Moments.Stores.GetReactionsStore.createReactionsStore)
require(Moments.Stores.GetShareCountsStore.createShareCountsStore)

local ReactionAction = require(Moments.Enums.ReactionAction)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createMomentStore(p1, t1: {[any]: any}?) -- line: 157
	-- upvalues: createSignal (copy), GetReactionsStore (copy), GetShareCountsStore (copy), createComputed (copy), ReactionAction (copy)
	local v12 = createSignal(p1)
	local momentId = p1.momentId
	local v14 = t1 or {}
	local v15 = if v14.reactionsStore == nil then GetReactionsStore(false) else v14.reactionsStore
	local v16 = if v14.shareCountsStore == nil then GetShareCountsStore(false) else v14.shareCountsStore
	local v17 = if p1.kind ~= "experience" then nil else p1.commentCount
	local v18, v19 = createSignal(v17)
	local v20, v21 = createSignal(p1.isModerated == true)
	local v22 = v15.getUserReactionForMoment(momentId)
	local v23 = createComputed(function(p2) -- line: 182
		-- upvalues: v22 (copy)
		return v22(p2) ~= nil
	end)
	local v24 = v15.getTotalReactionCountForMoment(momentId)
	local v25 = createComputed(function(p3) -- line: 186
		-- upvalues: v24 (copy)
		local v36 = v24(p3)

		if v36 > 0 then
			return v36
		end

		return nil
	end)
	local v26 = v15.getIndividualReactionCountsForMoment(momentId)
	local v27 = v16.getShareInfo(momentId)
	local v28 = createComputed(function(p4) -- line: 196
		-- upvalues: v27 (copy)
		local shareCount = v27(p4).shareCount

		if shareCount > 0 then
			return shareCount
		end

		return nil
	end)
	local v29, v30 = createSignal(nil)
	local v31 = createComputed(function(p5) -- line: 232
		-- upvalues: v29 (copy)
		return v29(p5) ~= nil
	end)
	local v32, v33 = createSignal(false)

	return {
		getData = v12,
		getReactionCount = v25,
		getIndividualReactionCounts = v26,
		getCommentCount = v18,
		setCommentCount = v19,
		getShareCount = v28,
		setShareCount = function(n1: number?) -- line: 200
			-- upvalues: v27 (copy), v16 (copy), momentId (copy)
			local v40 = v27(false)

			v16.setShareCount(momentId, n1 or 0, v40.hasShared)
		end,
		getSelectedReaction = v22,
		getIsReacted = v23,
		commitReaction = function(p6) -- line: 207
			-- upvalues: v15 (copy), p1 (copy), momentId (copy)
			local v42 = v15.reactToFeedItem({
				entityType = "userCreatedMoment",
				feedItemId = p1.feedItemId or momentId,
				entityId = momentId,
				reactionType = p6,
				feedSessionId = p1.feedSessionId
			})

			if type(v42) == "table" and v42.catch ~= nil then
				v42:catch(function() -- line: 221
				end)
			end
		end,
		clearReaction = function() -- line: 224
			-- upvalues: v15 (copy), ReactionAction (copy), momentId (copy)
			v15.updateReaction({
				action = ReactionAction.Unreact,
				momentId = momentId
			})
		end,
		getIsModerated = v20,
		setIsModerated = v21,
		getIsScrubbing = v31,
		getScrubPosition = v29,
		setScrubPosition = v30,
		getIsReactionPickerOpen = v32,
		setReactionPickerOpen = v33
	}
end

return createMomentStore
