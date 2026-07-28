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
local FFlagMomentsReactToFeedItemV2 = require(Moments.Flags.FFlagMomentsReactToFeedItemV2)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createMomentStore(p1, t1: {[any]: any}?) -- line: 155
	-- upvalues: createSignal (copy), GetReactionsStore (copy), GetShareCountsStore (copy), createComputed (copy), FFlagMomentsReactToFeedItemV2 (copy), ReactionAction (copy)
	local v13 = createSignal(p1)
	local momentId = p1.momentId
	local v15 = t1 or {}
	local v16 = if v15.reactionsStore == nil then GetReactionsStore(false) else v15.reactionsStore
	local v17 = if v15.shareCountsStore == nil then GetShareCountsStore(false) else v15.shareCountsStore
	local v18 = if p1.kind ~= "experience" then nil else p1.commentCount
	local v19, v20 = createSignal(v18)
	local v21, v22 = createSignal(p1.isModerated == true)
	local v23 = v16.getUserReactionForMoment(momentId)
	local v24 = createComputed(function(p2) -- line: 180
		-- upvalues: v23 (copy)
		return v23(p2) ~= nil
	end)
	local v25 = v16.getTotalReactionCountForMoment(momentId)
	local v26 = createComputed(function(p3) -- line: 184
		-- upvalues: v25 (copy)
		local v37 = v25(p3)

		if v37 > 0 then
			return v37
		end

		return nil
	end)
	local v27 = v16.getIndividualReactionCountsForMoment(momentId)
	local v28 = v17.getShareInfo(momentId)
	local v29 = createComputed(function(p4) -- line: 194
		-- upvalues: v28 (copy)
		local shareCount = v28(p4).shareCount

		if shareCount > 0 then
			return shareCount
		end

		return nil
	end)
	local v30, v31 = createSignal(nil)
	local v32 = createComputed(function(p5) -- line: 247
		-- upvalues: v30 (copy)
		return v30(p5) ~= nil
	end)
	local v33, v34 = createSignal(false)

	return {
		getData = v13,
		getReactionCount = v26,
		getIndividualReactionCounts = v27,
		getCommentCount = v19,
		setCommentCount = v20,
		getShareCount = v29,
		setShareCount = function(n1: number?) -- line: 198
			-- upvalues: v28 (copy), v17 (copy), momentId (copy)
			local v41 = v28(false)

			v17.setShareCount(momentId, n1 or 0, v41.hasShared)
		end,
		getSelectedReaction = v23,
		getIsReacted = v24,
		commitReaction = function(p6) -- line: 205
			-- upvalues: v16 (copy), p1 (copy), momentId (copy)
			local v43 = v16.reactToFeedItem({
				entityType = "userCreatedMoment",
				feedItemId = p1.feedItemId or momentId,
				entityId = momentId,
				reactionType = p6,
				feedSessionId = p1.feedSessionId
			})

			if type(v43) == "table" and v43.catch ~= nil then
				v43:catch(function() -- line: 220
				end)
			end
		end,
		clearReaction = function() -- line: 223
			-- upvalues: FFlagMomentsReactToFeedItemV2 (copy), v23 (copy), v16 (copy), p1 (copy), momentId (copy), ReactionAction (copy)
			if FFlagMomentsReactToFeedItemV2 then
				local v44 = v23(false)

				if v44 ~= nil then
					local v45 = v16.removeFeedItemReaction({
						entityType = "userCreatedMoment",
						feedItemId = p1.feedItemId or momentId,
						entityId = momentId,
						reactionType = v44,
						feedSessionId = p1.feedSessionId
					})

					if type(v45) == "table" and v45.catch ~= nil then
						v45:catch(function() -- line: 235
						end)
					end

					return
				end
			end

			v16.updateReaction({
				action = ReactionAction.Unreact,
				momentId = momentId
			})
		end,
		getIsModerated = v21,
		setIsModerated = v22,
		getIsScrubbing = v32,
		getScrubPosition = v30,
		setScrubPosition = v31,
		getIsReactionPickerOpen = v33,
		setReactionPickerOpen = v34
	}
end

return createMomentStore
