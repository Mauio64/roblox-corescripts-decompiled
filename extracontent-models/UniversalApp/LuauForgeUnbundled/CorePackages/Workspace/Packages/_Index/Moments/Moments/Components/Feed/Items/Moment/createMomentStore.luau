require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local GetReactionsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetReactionsStore")
local GetShareCountsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetShareCountsStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/RecommendationContentType")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetReactionsStore/createReactionsStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetShareCountsStore/createShareCountsStore")
local ReactionAction = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/ReactionAction")
local FFlagMomentsReactToFeedItemV2 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsReactToFeedItemV2")
local FFlagMomentsHideZeroCommentCount = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsHideZeroCommentCount")

local v5 = if SharedFlags.FFlagMomentsComments then require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsCommentsStore") else nil

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createMomentStore(data, options)
	local signal = createSignal(data)
	local momentId = data.momentId

	local v6 = options or {}
	local v7 = if v6.reactionsStore == nil then GetReactionsStore(false) else v6.reactionsStore
	local v8 = if v6.shareCountsStore == nil then GetShareCountsStore(false) else v6.shareCountsStore

	local v9 = data.kind == "experience" or fFlagMomentsRenderAvatarPostsInFeed and data.kind == "avatar"
	local commentCount

	if data.kind == "experience" then
		commentCount = data.commentCount
	elseif fFlagMomentsRenderAvatarPostsInFeed and data.kind == "avatar" then
		commentCount = data.commentCount
	end

	local signal2, v10 = createSignal(commentCount)
	local v11

	if v6.commentsStore == nil then
		if v5 ~= nil then
			v11 = v5(false)
		end
	else
		v11 = v6.commentsStore
	end

	local feedItemId = data.feedItemId
	local v12

	if v11 == nil or not v9 or feedItemId == nil or feedItemId == "" then
		v12 = signal2
	else
		local data2 = v11.getCachedMomentComments(feedItemId).data
		v12 = createComputed(function(p2)
			local v13 = data2(p2)

			if v13 == nil or v13.count == nil then
				return signal2(p2)
			end

			return v13.count
		end)
	end

	local v13

	if FFlagMomentsHideZeroCommentCount then
		v13 = createComputed(function(p2)
			local v14 = v12(p2)

			if v14 == nil or not (v14 > 0) then
				return nil
			end

			return v14
		end)
	else
		v13 = v12
	end

	local signal3, v14 = createSignal(data.isModerated == true)

	local userReactionForMoment = v7.getUserReactionForMoment(momentId)
	local computed = createComputed(function(p2): boolean
		return userReactionForMoment(p2) ~= nil
	end)

	local totalReactionCountForMoment = v7.getTotalReactionCountForMoment(momentId)
	local computed2 = createComputed(function(p2)
		local v15 = totalReactionCountForMoment(p2)

		if v15 > 0 then
			return v15
		end

		return nil
	end)

	local individualReactionCountsForMoment = v7.getIndividualReactionCountsForMoment(momentId)

	local shareInfo = v8.getShareInfo(momentId)
	local computed3 = createComputed(function(p2)
		local shareCount = shareInfo(p2).shareCount

		if shareCount > 0 then
			return shareCount
		end

		return nil
	end)

	local signal4, v15 = createSignal(nil)
	local computed4 = createComputed(function(p2): boolean
		return signal4(p2) ~= nil
	end)

	local signal5, v16 = createSignal(false)
	return {
		getData = signal,
		getReactionCount = computed2,
		getIndividualReactionCounts = individualReactionCountsForMoment,
		getCommentCount = v13,
		setCommentCount = v10,
		getShareCount = computed3,
		setShareCount = function(value)
			local v17 = shareInfo(false)
			v8.setShareCount(momentId, value or 0, v17.hasShared)
		end,
		getSelectedReaction = userReactionForMoment,
		getIsReacted = computed,
		commitReaction = function(p2)
			if fFlagMomentsOptimisticProfilePending and data.isPending then
				return
			end

			local reactToFeedItem = v7.reactToFeedItem({
				feedItemId = data.feedItemId or momentId,
				entityType = "userCreatedMoment",
				entityId = momentId,
				reactionType = p2,
				feedSessionId = data.feedSessionId
			})

			if type(reactToFeedItem) == "table" and reactToFeedItem.catch ~= nil then
				reactToFeedItem:catch(function() end)
			end
		end,
		clearReaction = function()
			if fFlagMomentsOptimisticProfilePending and data.isPending then
				return
			end

			if FFlagMomentsReactToFeedItemV2 then
				local v15 = userReactionForMoment(false)

				if v15 ~= nil then
					local v16 = v7.removeFeedItemReaction({
						feedItemId = data.feedItemId or momentId,
						entityType = "userCreatedMoment",
						entityId = momentId,
						reactionType = v15,
						feedSessionId = data.feedSessionId
					})

					if type(v16) == "table" and v16.catch ~= nil then
						v16:catch(function() end)
					end

					return
				end
			end

			v7.updateReaction({ action = ReactionAction.Unreact, momentId = momentId })
		end,
		getIsModerated = signal3,
		setIsModerated = v14,
		getIsScrubbing = computed4,
		getScrubPosition = signal4,
		setScrubPosition = v15,
		getIsReactionPickerOpen = signal5,
		setReactionPickerOpen = v16
	}
end

return createMomentStore
