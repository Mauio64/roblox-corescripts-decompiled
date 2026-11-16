local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.MomentsCommon)
require(parent.DataHydration.MomentsStoreTypes)
require(parent.MomentsTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local Signals = require(parent.Signals)

local GetReactionsStore = require(Moments.Stores.GetReactionsStore)
local GetShareCountsStore = require(Moments.Stores.GetShareCountsStore)
require(Moments.Analytics.RecommendationContentType)
require(Moments.Stores.GetReactionsStore.createReactionsStore)
require(Moments.Stores.GetShareCountsStore.createShareCountsStore)
local ReactionAction = require(Moments.Enums.ReactionAction)
local FFlagMomentsReactToFeedItemV2 = require(Moments.Flags.FFlagMomentsReactToFeedItemV2)
local FFlagMomentsHideZeroCommentCount = require(Moments.Flags.FFlagMomentsHideZeroCommentCount)
local MomentsGetMomentsCommentsStore

if SharedFlags.FFlagMomentsComments then
	MomentsGetMomentsCommentsStore = require(parent.DataHydration.MomentsGetMomentsCommentsStore)
else
	MomentsGetMomentsCommentsStore = nil
end

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createMomentStore(data, options)
	local signal = createSignal(data)
	local momentId = data.momentId

	local v = options or {}
	local v2

	if v.reactionsStore == nil then
		v2 = GetReactionsStore(false)
	else
		v2 = v.reactionsStore
	end

	local v3

	if v.shareCountsStore == nil then
		v3 = GetShareCountsStore(false)
	else
		v3 = v.shareCountsStore
	end

	local v4 = data.kind == "experience" or FFlagMomentsRenderAvatarPostsInFeed and data.kind == "avatar"
	local commentCount

	if data.kind == "experience" then
		commentCount = data.commentCount
	elseif FFlagMomentsRenderAvatarPostsInFeed and data.kind == "avatar" then
		commentCount = data.commentCount
	end

	local signal2, setCommentCount = createSignal(commentCount)
	local v5

	if v.commentsStore == nil then
		if MomentsGetMomentsCommentsStore ~= nil then
			v5 = MomentsGetMomentsCommentsStore(false)
		end
	else
		v5 = v.commentsStore
	end

	local feedItemId = data.feedItemId
	local v6

	if v5 == nil or not v4 or feedItemId == nil or feedItemId == "" then
		v6 = signal2
	else
		local data2 = v5.getCachedMomentComments(feedItemId).data
		v6 = createComputed(function(p)
			local v7 = data2(p)

			if v7 == nil or v7.count == nil then
				return signal2(p)
			end

			return v7.count
		end)
	end

	local getCommentCount

	if FFlagMomentsHideZeroCommentCount then
		getCommentCount = createComputed(function(p)
			local v7 = v6(p)
			return if not (v7 == nil or not (v7 > 0)) then v7 else nil
		end)
	else
		getCommentCount = v6
	end

	local signal3, setIsModerated = createSignal(data.isModerated == true)

	local userReactionForMoment = v2.getUserReactionForMoment(momentId)
	local getIsReacted = createComputed(function(p): boolean
		return userReactionForMoment(p) ~= nil
	end)

	local totalReactionCountForMoment = v2.getTotalReactionCountForMoment(momentId)
	local getReactionCount = createComputed(function(p)
		local v7 = totalReactionCountForMoment(p)
		return if v7 > 0 then v7 else nil
	end)

	local individualReactionCountsForMoment = v2.getIndividualReactionCountsForMoment(momentId)

	local shareInfo = v3.getShareInfo(momentId)
	local getShareCount = createComputed(function(p)
		local shareCount = shareInfo(p).shareCount
		return if shareCount > 0 then shareCount else nil
	end)

	local signal4, setScrubPosition = createSignal(nil)
	local getIsScrubbing = createComputed(function(p): boolean
		return signal4(p) ~= nil
	end)

	local signal5, setReactionPickerOpen = createSignal(false)
	return {
		getData = signal,
		getReactionCount = getReactionCount,
		getIndividualReactionCounts = individualReactionCountsForMoment,
		getCommentCount = getCommentCount,
		setCommentCount = setCommentCount,
		getShareCount = getShareCount,
		setShareCount = function(value: number?)
			local v7 = shareInfo(false)
			v3.setShareCount(momentId, value or 0, v7.hasShared)
		end,
		getSelectedReaction = userReactionForMoment,
		getIsReacted = getIsReacted,
		commitReaction = function(reactionType)
			if FFlagMomentsOptimisticProfilePending and data.isPending then
				return
			end

			local reactToFeedItem = v2.reactToFeedItem({
				feedItemId = data.feedItemId or momentId,
				entityType = "userCreatedMoment",
				entityId = momentId,
				reactionType = reactionType,
				feedSessionId = data.feedSessionId
			})

			if type(reactToFeedItem) == "table" and reactToFeedItem.catch ~= nil then
				reactToFeedItem:catch(function() end)
			end
		end,
		clearReaction = function()
			if FFlagMomentsOptimisticProfilePending and data.isPending then
				return
			end

			if FFlagMomentsReactToFeedItemV2 then
				local reactionType = userReactionForMoment(false)

				if reactionType ~= nil then
					local v7 = v2.removeFeedItemReaction({
						feedItemId = data.feedItemId or momentId,
						entityType = "userCreatedMoment",
						entityId = momentId,
						reactionType = reactionType,
						feedSessionId = data.feedSessionId
					})

					if type(v7) == "table" and v7.catch ~= nil then
						v7:catch(function() end)
					end

					return
				end
			end

			v2.updateReaction({ action = ReactionAction.Unreact, momentId = momentId })
		end,
		getIsModerated = signal3,
		setIsModerated = setIsModerated,
		getIsScrubbing = getIsScrubbing,
		getScrubPosition = signal4,
		setScrubPosition = setScrubPosition,
		getIsReactionPickerOpen = signal5,
		setReactionPickerOpen = setReactionPickerOpen
	}
end

return createMomentStore
