require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/HttpClient")
local eventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon").Analytics.EventNames
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/createCommentsAnalyticsSession")
local getCommentsFailureReason = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/getCommentsFailureReason")

local MomentsComments = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsComments")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsExperimental")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore/createCommentCollectionStore")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentSessionFiltersStore/createCommentSessionFiltersStore")
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsCommentActionsRealtime = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentActionsRealtime")
local FFlagMomentsCommentsCountAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsCountAnalytics")
local fFlagMomentsCommentDeepLinks = SharedFlags.FFlagMomentsCommentDeepLinks

local CommentCollectionTypes = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore/CommentCollectionTypes")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetCommentReactionsStore/createCommentReactionsStore")

local loadStatus = CommentCollectionTypes.LoadStatus

local v5 = { 250, 500 }

local v6 = {
	AuthenticationRequired = true,
	CommentsEndpointDisabled = true,
	ViewerNotEligibleToReact = true
}

local v7 = {
	CommentsDisabledByCreator = true,
	MomentUnavailable = true,
	ViewerNotEligibleToRead = true
}

local v8 = {
	CommentsDisabledByCreator = true,
	MomentNotFound = true,
	MomentNotVisible = true,
	ViewerNotEligibleToRead = true,
	ViewerNotEligibleToWrite = true
}

local v9 = {
	Jan = 1,
	Feb = 2,
	Mar = 3,
	Apr = 4,
	May = 5,
	Jun = 6,
	Jul = 7,
	Aug = 8,
	Sep = 9,
	Oct = 10,
	Nov = 11,
	Dec = 12
}

local function cursorKey(value)
	return value or "<initial>"
end

local function defaultSchedule(p2, callback)
	local thread = task.delay(p2 / 1000, callback)
	return function()
		pcall(task.cancel, thread)
	end
end

local function defaultReadStatusCode(p2, p3)
	if p3 ~= nil then
		return p3
	end

	if p2.response == nil then
		return p2.errorCode
	end

	return p2.response.statusCode
end

local function defaultReadRetryAfter(p2)
	if p2.headers == nil then
		return nil
	end

	return p2.headers["retry-after"] or p2.headers["Retry-After"]
end

local function parseHttpDateMs(value)
	local v10, v11, v12, v13, v14, v15 = string.match(
		value,
		"^%a%a%a, (%d%d) (%a%a%a) (%d%d%d%d) (%d%d):(%d%d):(%d%d) GMT$"
	)
	local v16 = if v11 ~= nil then v9[v11] else nil

	if v10 == nil or v16 == nil or v12 == nil or v13 == nil or v14 == nil or v15 == nil then
		return nil
	end

	local success, result = pcall(
		DateTime.fromUniversalTime,
		tonumber(v12),
		v16,
		tonumber(v10),
		tonumber(v13),
		tonumber(v14),
		(tonumber(v15))
	)

	if success then
		return result.UnixTimestampMillis
	end

	return nil
end

local function retryAfterDelayMs(p2, p3)
	if p2 == nil then
		return 5000
	end

	local v10 = tonumber(p2)
	local v11 = if v10 ~= nil then v10 * 1000 else nil

	if v11 == nil then
		local v12 = parseHttpDateMs(p2)
		v11 = if v12 ~= nil then math.max(0, v12 - p3) else nil
	end

	if v11 == nil or v11 < 0 or v11 > 60000 then
		return 5000
	end

	return v11
end

local function definitePostRejectionCode(p2, p3)
	if p3 == "CommentsUnavailable" then
		return nil
	end

	if p3 ~= nil then
		return p3
	end

	if p2 == nil or p2 == 408 or p2 < 400 or p2 >= 500 then
		return nil
	end

	if p2 == 429 then
		return "RateLimited"
	elseif p2 == 401 then
		return "AuthenticationRequired"
	end

	return "PostRejected"
end

local function selectedEmoteId(p2)
	if p2 == nil or p2.userReaction == nil then
		return nil
	end

	return p2.userReaction.emoteId
end

local function isUncertainStatus(p2)
	local v10 = p2 == nil or p2 == 408 or not (p2 == nil or not (p2 >= 500)) and p2 <= 599
	return v10
end

local function errorCodeFrom(p2)
	local commentsError = MomentsComments.parseCommentsError(p2.error)

	if commentsError == nil then
		return "CommentsUnavailable"
	end

	return commentsError.errorCode
end

local function observeRequest(p2, fn)
	local flag = false
	local v10 = nil

	local function stop()
		if flag then
			return
		end

		flag = true

		if v10 ~= nil then
			v10()
			v10 = nil
		end

		p2.dispose()
	end

	local function settle(p3)
		if flag or p3.status == "pending" then
			return
		end

		flag = true

		if v10 ~= nil then
			v10()
			v10 = nil
		end

		p2.dispose()
		fn(p3)
	end

	local state = p2.state(false)

	if state.status == "pending" then
		v10 = Signals.createEffect(function(p3)
			local state2 = p2.state(p3)

			if not flag then
				if state2.status == "pending" then
					return
				end

				flag = true

				if v10 ~= nil then
					v10()
					v10 = nil
				end

				p2.dispose()
				fn(state2)
			end
		end)

		if flag and v10 ~= nil then
			v10()
			v10 = nil
		end
	elseif not flag and state.status ~= "pending" then
		flag = true

		if v10 ~= nil then
			v10()
			v10 = nil
		end

		p2.dispose()
		fn(state)
	end

	return stop
end

local function rejectReactionMutation(p2, p3, p4, p5): boolean
	return false
end

local function noOp() end

local function createCommentsListCoordinator(data)
	local collectionStore = data.collectionStore
	local commentsStore = data.commentsStore

	local reactionStore = data.reactionStore
	local catalogStore = data.catalogStore
	local fetchPage = data.fetchPage or MomentsComments.fetchMomentComments
	local fetchComment = data.fetchComment or MomentsComments.fetchMomentComment
	local postComment = data.postComment or MomentsComments.postMomentComment
	local putReaction = data.putReaction or MomentsComments.putMomentCommentReaction
	local deleteReaction = data.deleteReaction or MomentsComments.deleteMomentCommentReaction
	local deleteComment = data.deleteComment or MomentsComments.deleteMomentComment
	local sessionFilters = data.sessionFilters
	local nowMs = data.nowMs or function()
		return DateTime.now().UnixTimestampMillis
	end

	local schedule = data.schedule or defaultSchedule
	local readStatusCode = data.readStatusCode or defaultReadStatusCode
	local readRetryAfter = data.readRetryAfter or defaultReadRetryAfter
	local reactionDebounceMs = data.reactionDebounceMs or 500
	local v10 = nil
	local v11 = nil
	local v12 = {}
	local v13 = {}
	local v14 = {}
	local v15 = {}
	local v16 = nil
	local signal, v17 = Signals.createSignal(0)
	local v18 = nil
	local v19 = commentsStore.getOwnerGeneration(false)
	local flag = false
	local v20 = nil
	local v21 = nil

	local function cancelActivePage(state)
		local activePageRequest = state.activePageRequest
		state.activePageRequest = nil

		if activePageRequest ~= nil then
			activePageRequest.cancel()
		end

		local activePinnedRequest = state.activePinnedRequest
		state.activePinnedRequest = nil

		if activePinnedRequest ~= nil then
			state.hasRequestedPinnedComment = false
			activePinnedRequest.cancel()
		end
	end

	local function getSession(p2, p3)
		local v22 = v10

		if
			flag
			or v22 == nil
			or v22.feedItemId ~= p2
			or v22.sessionId ~= p3
			or v22.ownerGeneration ~= commentsStore.getOwnerGeneration(false)
			or v22.refCount == 0
		then
			return nil
		end

		return v22
	end

	local function isCurrentRequestSession(data2, p2, p3, p4)
		local v22 = not flag

		if v22 then
			if
				v10 == data2
				and data2.feedItemId == p2
				and data2.sessionId == p3
				and data2.ownerGeneration == p4
			then
				v22 = commentsStore.getOwnerGeneration(false) == p4
			else
				v22 = false
			end
		end

		return v22
	end

	local function cancelIntentExpiry(p2)
		local v22 = v14[p2]
		v14[p2] = nil

		if v22 ~= nil then
			v22()
		end
	end

	local function scheduleIntentExpiry(p2, p3)
		local v22 = v14[p2]
		v14[p2] = nil

		if v22 ~= nil then
			v22()
		end

		v14[p2] = schedule(10000, function()
			v14[p2] = nil

			if reactionStore.expireIntent(p2, p3) then
				v15[p2] = nil
			end
		end)
	end

	local function cancelReactionRequest(p2)
		local v22 = v12[p2]
		v12[p2] = nil

		if v22 == nil then
			return
		end

		if v22.cancelRequest ~= nil then
			v22.cancelRequest()
			v22.cancelRequest = nil
		end

		if v22.cancelRetry ~= nil then
			v22.cancelRetry()
			v22.cancelRetry = nil
		end

		if v22.cancelDebounce ~= nil then
			v22.cancelDebounce()
			v22.cancelDebounce = nil
		end
	end

	local function hardResetReaction(p2, p3, p4, p5)
		cancelReactionRequest(p3)
		local v22 = v14[p3]
		v14[p3] = nil

		if v22 ~= nil then
			v22()
		end

		v15[p3] = nil
		reactionStore.clearComment(p3)

		if p4 ~= nil then
			reactionStore.setCommentRestriction(p2, p3, p4, p5)
		end
	end

	local function clearReactionState()
		local v22 = {}

		for k in v12 do
			table.insert(v22, k)
		end

		for k, v23 in v22 do
			cancelReactionRequest(v23)
		end

		local v23 = {}

		for k in v14 do
			table.insert(v23, k)
		end

		for k, v24 in v23 do
			local v25 = v14[v24]
			v14[v24] = nil

			if v25 ~= nil then
				v25()
			end
		end

		if v16 ~= nil then
			v16()
			v16 = nil
		end

		table.clear(v15)
		reactionStore.clear()
	end

	local function clearReactionsForFeed(p2, p3)
		local v22 = {}

		for k, v23 in v15 do
			if v23 == p2 then
				table.insert(v22, k)
			end
		end

		for k, v23 in v22 do
			cancelReactionRequest(v23)
			local v24 = v14[v23]
			v14[v23] = nil

			if v24 ~= nil then
				v24()
			end

			v15[v23] = nil
		end

		reactionStore.clearFeed(p2)
		reactionStore.setFeedRestriction(p2, p3)
	end

	local function setReactionCooldown(p2)
		local v22 = nowMs()

		local cooldownUntilMs = reactionStore.getCooldownUntilMs(false)
		local v23

		if p2 == nil then
			v23 = 5000
		else
			local v24 = tonumber(p2)
			local v25 = if v24 ~= nil then v24 * 1000 else nil

			if v25 == nil then
				local v26 = parseHttpDateMs(p2)
				v25 = if v26 ~= nil then math.max(0, v26 - v22) else nil
			end

			v23 = (v25 == nil or v25 < 0 or v25 > 60000) and 5000 or v25
		end

		local v24 = math.max(cooldownUntilMs, v22 + v23)

		reactionStore.setCooldownUntilMs(v24)

		if v16 ~= nil then
			v16()
		end

		v16 = schedule(math.max(0, v24 - v22), function()
			v16 = nil

			if reactionStore.getCooldownUntilMs(false) == v24 then
				reactionStore.setCooldownUntilMs(0)
			end
		end)
	end

	local function clearPostCooldown()
		if v18 ~= nil then
			v18()
			v18 = nil
		end

		v17(0)
	end

	local function setPostCooldown(p2)
		local v22 = nowMs()

		local v23 = signal(false)
		local v24

		if p2 == nil then
			v24 = 5000
		else
			local v25 = tonumber(p2)
			local v26 = if v25 ~= nil then v25 * 1000 else nil

			if v26 == nil then
				local v27 = parseHttpDateMs(p2)
				v26 = if v27 ~= nil then math.max(0, v27 - v22) else nil
			end

			v24 = (v26 == nil or v26 < 0 or v26 > 60000) and 5000 or v26
		end

		local v25 = math.max(v23, v22 + v24)
		v17(v25)

		if v18 ~= nil then
			v18()
		end

		v18 = schedule(math.max(0, v25 - v22), function()
			v18 = nil

			if signal(false) == v25 then
				v17(0)
			end
		end)
	end

	local function isPostCoolingDown(): boolean
		local v22 = signal(false)

		if v22 == 0 then
			return false
		end

		if nowMs() < v22 then
			return true
		end

		if v18 ~= nil then
			v18()
			v18 = nil
		end

		v17(0)

		return false
	end

	local function markFeedUnavailable(p2, p3)
		local v22 = v10

		if
			v22 == nil
			or v22.feedItemId ~= p2
			or v22.ownerGeneration ~= commentsStore.getOwnerGeneration(false)
		then
			return
		end

		local activePageRequest = v22.activePageRequest
		v22.activePageRequest = nil

		if activePageRequest ~= nil then
			activePageRequest.cancel()
		end

		local activePinnedRequest = v22.activePinnedRequest
		v22.activePinnedRequest = nil

		if activePinnedRequest ~= nil then
			v22.hasRequestedPinnedComment = false
			activePinnedRequest.cancel()
		end

		local v23 = collectionStore.getState(p2)(false).initialLoadStatus == loadStatus.Success
			and "more"
			or "initial"
		collectionStore.failLoad(p2, v23, p3)
	end

	local function getOpenAnalyticsSession(p2)
		local v22 = v10

		if data.getAnalyticsSession == nil or v22 == nil or v22.feedItemId ~= p2 then
			return nil
		end

		return data.getAnalyticsSession(p2, v22.sessionId)
	end

	local function logReactionRequest(p2, p3, p4, failureReason)
		local analyticsSession = p2.analyticsSession

		if analyticsSession == nil then
			return
		end

		local v22 = {
			status = p4,
			action = p3 == "PUT" and "add" or "remove"
		}

		if failureReason ~= nil then
			v22.failureReason = failureReason
		end

		analyticsSession.logRealtimeEvent("MomentsCommentReaction", v22)
	end

	local function commitProjectedReaction(data2)
		local intent = reactionStore.getIntent(data2.commentId, false)

		if intent == nil or intent.generation ~= data2.generation then
			return false
		end

		local data3 = commentsStore.getCachedComment(data2.commentId).data(false)

		if data3 == nil then
			return reactionStore.markLocallyConfirmed(data2.commentId, data2.generation)
		end

		local reactions = reactionStore.getProjection(
			data2.feedItemId,
			data2.commentId,
			data3.reactions,
			false
		).reactions

		if reactions == nil then
			return reactionStore.markLocallyConfirmed(data2.commentId, data2.generation)
		end

		local clone = table.clone(data3)
		clone.reactions = reactions
		local v22 = false
		SignalsExperimental.batch(function()
			commentsStore.upsertComments({ clone }, data2.ownerGeneration)
			v22 = reactionStore.confirmAndRebase(data2.commentId, data2.generation, reactions)
		end)
		return v22
	end

	local function retainUncertainUntilExpiry(state)
		v12[state.commentId] = nil
		state.cancelRetry = nil
		reactionStore.markUncertain(state.commentId, state.generation)
		local commentId = state.commentId
		local generation = state.generation
		local v22 = v14[commentId]
		v14[commentId] = nil

		if v22 ~= nil then
			v22()
		end

		v14[commentId] = schedule(10000, function()
			v14[commentId] = nil

			if reactionStore.expireIntent(commentId, generation) then
				v15[commentId] = nil
			end
		end)
	end

	local function rollbackReaction(data2, p2)
		local commentId = data2.commentId
		local v22 = v14[commentId]
		v14[commentId] = nil

		if v22 ~= nil then
			v22()
		end

		if not reactionStore.rollback(data2.commentId, data2.generation, p2) then
			return
		end

		local intent = reactionStore.getIntent(data2.commentId, false)

		if intent == nil or intent.status ~= "LocallyConfirmed" then
			v15[data2.commentId] = nil

			return
		end

		v15[data2.commentId] = data2.feedItemId
		local commentId2 = data2.commentId
		local generation = intent.generation
		local v23 = v14[commentId2]
		v14[commentId2] = nil

		if v23 ~= nil then
			v23()
		end

		v14[commentId2] = schedule(10000, function()
			v14[commentId2] = nil

			if reactionStore.expireIntent(commentId2, generation) then
				v15[commentId2] = nil
			end
		end)
	end

	local function applyTerminalFailure(data2, p2, p3)
		if p3 == "MomentUnavailable" then
			clearReactionsForFeed(data2.feedItemId, "MomentUnavailable")
			markFeedUnavailable(data2.feedItemId, "MomentUnavailable")
		elseif v6[p3] then
			clearReactionState()
			reactionStore.setGlobalRestriction(p3)
		elseif v8[p3] then
			clearReactionsForFeed(data2.feedItemId, p3)
		elseif p3 == "CommentNotFound" or p2 == 404 then
			local feedItemId = data2.feedItemId
			local commentId = data2.commentId
			local generation = data2.generation
			cancelReactionRequest(commentId)
			local v22 = v14[commentId]
			v14[commentId] = nil

			if v22 ~= nil then
				v22()
			end

			v15[commentId] = nil
			reactionStore.clearComment(commentId)

			if p3 ~= nil then
				reactionStore.setCommentRestriction(feedItemId, commentId, p3, generation)
			end
		else
			rollbackReaction(data2, p3)
		end
	end

	local function fn(state)
		if
			flag
			or v12[state.commentId] ~= state
			or commentsStore.getOwnerGeneration(false) ~= state.ownerGeneration
			or reactionStore.getIntent(state.commentId, false) == nil
		then
			return
		end

		if state.syncIsUncertain or state.desiredEmoteId ~= state.syncedEmoteId then
			local v22 = nowMs()
			local cooldownUntilMs = reactionStore.getCooldownUntilMs(false)

			if v22 < cooldownUntilMs then
				reactionStore.markUncertain(state.commentId, state.generation)
				local v23 = cooldownUntilMs - v22

				if v22 - state.startedAtMs + v23 <= 2000 then
					state.cancelRetry = schedule(v23, function()
						state.cancelRetry = nil
						fn(state)
					end)
					return
				end

				v12[state.commentId] = nil
				state.cancelRetry = nil
				reactionStore.markUncertain(state.commentId, state.generation)
				local commentId = state.commentId
				local generation = state.generation
				local v24 = v14[commentId]
				v14[commentId] = nil

				if v24 ~= nil then
					v24()
				end

				v14[commentId] = schedule(10000, function()
					v14[commentId] = nil

					if reactionStore.expireIntent(commentId, generation) then
						v15[commentId] = nil
					end
				end)
			else
				if cooldownUntilMs > 0 then
					reactionStore.setCooldownUntilMs(0)
				end

				if state.attemptGeneration ~= state.generation then
					state.attemptGeneration = state.generation
					state.attempt = 0
					state.startedAtMs = v22
				end

				if state.attempt > 0 and v22 - state.startedAtMs > 2000 then
					v12[state.commentId] = nil
					state.cancelRetry = nil
					reactionStore.markUncertain(state.commentId, state.generation)
					local commentId = state.commentId
					local generation = state.generation
					local v23 = v14[commentId]
					v14[commentId] = nil

					if v23 ~= nil then
						v23()
					end

					v14[commentId] = schedule(10000, function()
						v14[commentId] = nil

						if reactionStore.expireIntent(commentId, generation) then
							v15[commentId] = nil
						end
					end)
				else
					state.attempt += 1

					if not reactionStore.markPending(state.commentId, state.generation) then
						v12[state.commentId] = nil
						return
					end

					state.readyToCommit = false
					local generation = state.generation
					local desiredEmoteId = state.desiredEmoteId
					local verb = state.verb
					local statusCode = nil
					local v23 = nil
					local v24 = {
						[429] = { function(p2)
								statusCode = p2.statusCode
								v23 = readRetryAfter(p2)
							end }
					}

					local v25 = if verb == "PUT" then putReaction else deleteReaction
					local v26 = v25(state.feedItemId, state.commentId, state.emoteId, data.network, v24)

					if FFlagMomentsCommentActionsRealtime then
						local analyticsSession = state.analyticsSession

						if analyticsSession ~= nil then
							local v27 = {
								status = "attempted",
								action = verb == "PUT" and "add" or "remove"
							}

							analyticsSession.logRealtimeEvent("MomentsCommentReaction", v27)
						end
					end

					state.cancelRequest = observeRequest(v26, function(p2)
						if
							flag
							or v12[state.commentId] ~= state
							or commentsStore.getOwnerGeneration(false) ~= state.ownerGeneration
						then
							return
						end

						state.cancelRequest = nil

						if FFlagMomentsCommentActionsRealtime and p2.status == "succeeded" then
							local v27 = verb
							local analyticsSession = state.analyticsSession

							if analyticsSession ~= nil then
								local v28 = {
									status = "succeeded",
									action = v27 == "PUT" and "add" or "remove"
								}

								analyticsSession.logRealtimeEvent("MomentsCommentReaction", v28)
							end
						end

						if p2.status == "succeeded" then
							state.syncedEmoteId = desiredEmoteId
							state.syncIsUncertain = false

							if state.generation == generation then
								v12[state.commentId] = nil

								if commitProjectedReaction(state) then
									local commentId = state.commentId
									local v27 = generation
									local v28 = v14[commentId]
									v14[commentId] = nil

									if v28 ~= nil then
										v28()
									end

									v14[commentId] = schedule(10000, function()
										v14[commentId] = nil

										if reactionStore.expireIntent(commentId, v27) then
											v15[commentId] = nil
										end
									end)
								end
							elseif state.desiredEmoteId == state.syncedEmoteId then
								v12[state.commentId] = nil

								if commitProjectedReaction(state) then
									local commentId = state.commentId
									local generation2 = state.generation
									local v27 = v14[commentId]
									v14[commentId] = nil

									if v27 ~= nil then
										v27()
									end

									v14[commentId] = schedule(10000, function()
										v14[commentId] = nil

										if reactionStore.expireIntent(commentId, generation2) then
											v15[commentId] = nil
										end
									end)
								end
							elseif state.readyToCommit then
								fn(state)
							end
						else
							local v27 = readStatusCode(p2, statusCode)
							local commentsError = MomentsComments.parseCommentsError(p2.error)
							local v28 = commentsError == nil and "CommentsUnavailable"
								or commentsError.errorCode

							if FFlagMomentsCommentActionsRealtime then
								local v30 = verb
								local v31 = getCommentsFailureReason(v28, v27)
								local analyticsSession = state.analyticsSession

								if analyticsSession ~= nil then
									local v32 = {
										status = "failed",
										action = v30 == "PUT" and "add" or "remove"
									}

									if v31 ~= nil then
										v32.failureReason = v31
									end

									analyticsSession.logRealtimeEvent("MomentsCommentReaction", v32)
								end
							end

							if v27 == 429 then
								v12[state.commentId] = nil
								rollbackReaction(state, nil)
								setReactionCooldown(v23)
							else
								local v29 = v27 == nil
									or v27 == 408
									or not (v27 == nil or not (v27 >= 500)) and v27 <= 599

								if v29 then
									state.syncIsUncertain = true

									if state.generation == generation then
										reactionStore.markUncertain(state.commentId, generation)
										local v30 = v5[state.attempt]

										if
											state.attempt <= 2
											and v30 ~= nil
											and nowMs() - state.startedAtMs + v30 <= 2000
										then
											state.cancelRetry = schedule(v30, function()
												state.cancelRetry = nil

												if
													v12[state.commentId] == state
													and commentsStore.getOwnerGeneration(false) == state.ownerGeneration
												then
													fn(state)
												end
											end)
											return
										end

										local v31 = state
										v12[v31.commentId] = nil
										v31.cancelRetry = nil
										reactionStore.markUncertain(v31.commentId, v31.generation)
										local commentId = v31.commentId
										local generation2 = v31.generation
										local v32 = v14[commentId]
										v14[commentId] = nil

										if v32 ~= nil then
											v32()
										end

										v14[commentId] = schedule(10000, function()
											v14[commentId] = nil

											if reactionStore.expireIntent(commentId, generation2) then
												v15[commentId] = nil
											end
										end)
									elseif state.readyToCommit then
										fn(state)
									end
								else
									v12[state.commentId] = nil
									applyTerminalFailure(state, v27, v28)
								end
							end
						end
					end)
				end
			end
		else
			v12[state.commentId] = nil
			rollbackReaction(state, nil)
		end
	end

	local function scheduleReactionCommit(state)
		if state.cancelDebounce ~= nil then
			state.cancelDebounce()
			state.cancelDebounce = nil
		end

		state.readyToCommit = false

		if not (reactionDebounceMs <= 0) then
			state.cancelDebounce = schedule(reactionDebounceMs, function()
				state.cancelDebounce = nil

				if flag or v12[state.commentId] ~= state then
					return
				end

				state.readyToCommit = true

				if state.cancelRequest == nil and state.cancelRetry == nil then
					fn(state)
				end
			end)
			return
		end

		state.readyToCommit = true

		if state.cancelRequest == nil and state.cancelRetry == nil then
			fn(state)
		end
	end

	local function beginReactionMutation(p2, p3, p4, p5, desiredEmoteId, verb, p6): boolean
		if flag or reactionStore.getRestriction(p2, p3, false) ~= nil then
			return false
		end

		local v22 = nowMs()
		local cooldownUntilMs = reactionStore.getCooldownUntilMs(false)

		if v22 < cooldownUntilMs then
			return false
		end

		if cooldownUntilMs > 0 then
			reactionStore.setCooldownUntilMs(0)
		end

		local v23 = v14[p3]
		v14[p3] = nil

		if v23 ~= nil then
			v23()
		end

		local v24 = reactionStore.beginIntent(p2, p3, p5, desiredEmoteId)
		local v25 = v12[p3]

		if v25 == nil then
			v25 = {
				feedItemId = p2,
				commentId = p3,
				emoteId = p4,
				verb = verb,
				generation = v24,
				ownerGeneration = commentsStore.getOwnerGeneration(false),
				attempt = 0,
				startedAtMs = v22,
				attemptGeneration = v24,
				desiredEmoteId = desiredEmoteId,
				syncedEmoteId = p6,
				syncIsUncertain = false,
				readyToCommit = false,
				cancelRequest = nil,
				cancelRetry = nil,
				cancelDebounce = nil
			}

			v12[p3] = v25
		else
			v25.verb = verb
			v25.generation = v24
			v25.desiredEmoteId = desiredEmoteId

			if v25.cancelRetry ~= nil then
				v25.cancelRetry()
				v25.cancelRetry = nil
				v25.syncIsUncertain = true
			end
		end

		if FFlagMomentsCommentActionsRealtime then
			local v26 = v10
			local v27 = if data.getAnalyticsSession ~= nil and v26 ~= nil and v26.feedItemId == p2 then data.getAnalyticsSession(p2, v26.sessionId) else nil

			v25.analyticsSession = v27
		end

		v15[p3] = p2
		scheduleReactionCommit(v25)
		return true
	end

	local function ensureReactionPresent(p2, p3, p4, p5)
		if p5 == nil then
			return false
		end

		local reactions = reactionStore.getProjection(p2, p3, p5, false).reactions

		if reactions == nil then
			return false
		end

		local v22

		if not (reactions == nil or reactions.userReaction == nil) then
			v22 = reactions.userReaction.emoteId
		end

		if v22 == nil then
			return beginReactionMutation(p2, p3, p4, p5, p4, "PUT", nil)
		end

		return false
	end

	local function ensureReactionAbsent(p2, p3, p4, p5)
		if p5 == nil then
			return false
		end

		local reactions = reactionStore.getProjection(p2, p3, p5, false).reactions

		if reactions == nil then
			return false
		end

		local v22

		if not (reactions == nil or reactions.userReaction == nil) then
			v22 = reactions.userReaction.emoteId
		end

		if v22 == p4 then
			return beginReactionMutation(p2, p3, p4, p5, nil, "DELETE", p4)
		end

		return false
	end

	local fn2

	local function failInvalidContinuation(p2)
		local v22 = collectionStore.getState(p2)(false)

		if #v22.orderedCommentIds > 0 or v22.pendingSubmission ~= nil then
			collectionStore.failLoad(p2, "more", "CommentsUnavailable")
		else
			collectionStore.failLoad(p2, "initial", "CommentsUnavailable")
		end
	end

	local function continueAfterMerge(p2, p3, result, shouldContinuePaging)
		if not result.hasMore then
			return
		end

		local v22 = v10

		if
			flag
			or v22 == nil
			or v22.feedItemId ~= p2
			or v22.sessionId ~= p3
			or v22.ownerGeneration ~= commentsStore.getOwnerGeneration(false)
			or v22.refCount == 0
		then
			v22 = nil
		end

		if v22 == nil then
			return
		end

		local nextCursor = result.nextCursor

		if nextCursor == nil or v22.requestedCursors[nextCursor or "<initial>"] == true then
			failInvalidContinuation(p2)
		elseif shouldContinuePaging then
			fn2(p2, p3, "more", nextCursor)
		end
	end

	local function commentsForUpsert(list, p2)
		local clones = table.create(#list)

		for k, clone in list do
			local intent = reactionStore.getIntent(clone.commentId, false)
			local v22

			if clone.reactions == nil or intent == nil then
				v22 = false
			else
				local reactions = clone.reactions
				v22 = (if reactions ~= nil and reactions.userReaction ~= nil then reactions.userReaction.emoteId else nil) == intent.desiredEmoteId
			end

			if intent ~= nil and p2 < intent.generation and not v22 then
				local data2 = commentsStore.getCachedComment(clone.commentId).data(false)

				if data2 ~= nil then
					clone = table.clone(clone)
					clone.reactions = data2.reactions
				end
			end

			table.insert(clones, clone)
		end

		return clones
	end

	local function requestPinnedComment(state, p2, p3)
		if state.hasRequestedPinnedComment or data.getPinnedCommentId == nil then
			return
		end

		state.hasRequestedPinnedComment = true
		local pinnedCommentId = data.getPinnedCommentId(p2, p3)

		if pinnedCommentId == nil or pinnedCommentId == "" then
			return
		end

		local ownerGeneration = commentsStore.getOwnerGeneration(false)
		local generation = reactionStore.getGeneration(false)
		local v22 = fetchComment(p2, pinnedCommentId, data.network)
		local v23 = {
			cancel = function() end
		}

		state.activePinnedRequest = v23
		v23.cancel = observeRequest(v22, function(p4)
			local v24 = state
			local v25 = p2
			local v26 = p3
			local v27 = ownerGeneration
			local v28 = not flag

			if v28 then
				if
					v10 == v24
					and v24.feedItemId == v25
					and v24.sessionId == v26
					and v24.ownerGeneration == v27
				then
					v28 = commentsStore.getOwnerGeneration(false) == v27
				else
					v28 = false
				end
			end

			if not v28 or state.activePinnedRequest ~= v23 then
				return
			end

			state.activePinnedRequest = nil
			local result = if p4.status == "succeeded" then p4.result else nil

			if
				result == nil
				or result.commentId ~= pinnedCommentId
				or result.feedItemId ~= p2
				or result.status ~= "Active"
			then
				return
			end

			local userId = if result.author ~= nil then result.author.userId else nil

			if
				sessionFilters ~= nil
				and (sessionFilters.isCommentSessionHidden(pinnedCommentId) or userId ~= nil and sessionFilters.isAuthorRecentlyBlocked(userId))
			then
				return
			end

			commentsStore.upsertComments(commentsForUpsert({ result }, generation), ownerGeneration)

			if reactionStore.reconcile(p2, pinnedCommentId, result.reactions, generation) then
				cancelReactionRequest(pinnedCommentId)
				local v29 = pinnedCommentId
				local v30 = v14[v29]
				v14[v29] = nil

				if v30 ~= nil then
					v30()
				end

				v15[pinnedCommentId] = nil
			end

			collectionStore.setPinnedComment(p2, pinnedCommentId)
		end)
	end

	fn2 = function(p2, p3, p4, value): boolean
		local v22 = v10

		if
			flag
			or v22 == nil
			or v22.feedItemId ~= p2
			or v22.sessionId ~= p3
			or v22.ownerGeneration ~= commentsStore.getOwnerGeneration(false)
			or v22.refCount == 0
		then
			v22 = nil
		end

		if v22 == nil or v22.activePageRequest ~= nil then
			return false
		end

		local ownerGeneration = commentsStore.getOwnerGeneration(false)
		local v23 = not fFlagMomentsComments and 0 or reactionStore.getGeneration(false)

		if p4 == "more" then
			if value == nil or v22.requestedCursors[value or "<initial>"] == true then
				failInvalidContinuation(p2)
				return false
			end

			v22.requestedCursors[value or "<initial>"] = true
		end

		if p4 == "initial" then
			collectionStore.beginInitialLoad(p2)
		else
			collectionStore.beginLoadMore(p2)
		end

		local v24 = p4 == "more" and "pagination" or v22.initialLoadType
		local v25

		if fFlagMomentsComments and data.getAnalyticsSession ~= nil then
			v25 = data.getAnalyticsSession(p2, p3)

			if v25 ~= nil then
				v25.logEvent(eventNames.MomentCommentsListLoadAttempted, {
					loadType = v24
				})
			end
		else
			v25 = nil
		end

		local v26 = fetchPage({ feedItemId = p2, cursor = value, sort = "newest" }, data.network)

		local v27 = {
			cancel = function() end
		}

		v22.activePageRequest = v27

		v27.cancel = observeRequest(v26, function(data2)
			local v28 = v22
			local v29 = p2
			local v30 = p3
			local v31 = ownerGeneration
			local v32 = not flag

			if v32 then
				if
					v10 == v28
					and v28.feedItemId == v29
					and v28.sessionId == v30
					and v28.ownerGeneration == v31
				then
					v32 = commentsStore.getOwnerGeneration(false) == v31
				else
					v32 = false
				end
			end

			if not v32 or v22.activePageRequest ~= v27 then
				return
			end

			v22.activePageRequest = nil

			if fFlagMomentsComments and v25 ~= nil then
				if data2.status == "succeeded" and data2.result ~= nil then
					local v33 = { loadType = v24 }

					if FFlagMomentsCommentsCountAnalytics then
						v33.loadedCommentCount = tostring(#data2.result.comments)
					end

					v25.logEvent(eventNames.MomentCommentsListLoadSucceeded, v33)
				else
					local logEvent = v25.logEvent
					local momentCommentsListLoadFailed = eventNames.MomentCommentsListLoadFailed
					local v33 = { loadType = v24, failureReason = 0 }
					local commentsError = MomentsComments.parseCommentsError(data2.error)
					v33.failureReason = getCommentsFailureReason(
						commentsError == nil and "CommentsUnavailable" or commentsError.errorCode,
						readStatusCode(data2, nil)
					)
					logEvent(momentCommentsListLoadFailed, v33)
				end
			end

			if data2.status == "succeeded" and data2.result ~= nil then
				if fFlagMomentsComments then
					commentsStore.upsertComments(
						commentsForUpsert(data2.result.comments, v23),
						ownerGeneration
					)

					for k, comment in data2.result.comments do
						if not reactionStore.reconcile(p2, comment.commentId, comment.reactions, v23) then
							continue
						end

						cancelReactionRequest(comment.commentId)
						local commentId = comment.commentId
						local v33 = v14[commentId]
						v14[commentId] = nil

						if v33 ~= nil then
							v33()
						end

						v15[comment.commentId] = nil
					end
				else
					commentsStore.upsertComments(data2.result.comments, ownerGeneration)
				end

				local v33 = if p4 == "initial" then collectionStore.completeInitialLoad(p2, data2.result) else collectionStore.completeLoadMore(p2, data2.result)
				continueAfterMerge(p2, p3, data2.result, v33.shouldContinuePaging)
			else
				local commentsError = MomentsComments.parseCommentsError(data2.error)
				local v33 = commentsError == nil and "CommentsUnavailable" or commentsError.errorCode

				if fFlagMomentsComments and v33 == "MomentUnavailable" then
					clearReactionsForFeed(p2, "MomentUnavailable")
				end

				if p4 == "more" and v33 == "InvalidCursor" then
					if fFlagMomentsComments then
						v22.initialLoadType = "refresh"
					end

					collectionStore.resetListSession(p2)
					table.clear(v22.requestedCursors)
					fn2(p2, p3, "initial", nil)
				else
					if p4 == "more" and value ~= nil then
						v22.requestedCursors[value or "<initial>"] = nil
					end

					collectionStore.failLoad(p2, p4, v33)
				end
			end
		end)
		local v28 = not flag

		if v28 then
			if
				v10 == v22
				and v22.feedItemId == p2
				and v22.sessionId == p3
				and v22.ownerGeneration == ownerGeneration
			then
				v28 = commentsStore.getOwnerGeneration(false) == ownerGeneration
			else
				v28 = false
			end
		end

		if v28 then
			if fFlagMomentsCommentDeepLinks and p4 == "initial" then
				requestPinnedComment(v22, p2, p3)
			end

			return true
		end

		if v22.activePageRequest == v27 then
			v22.activePageRequest = nil
		end

		v27.cancel()
		return false
	end

	local function revokeViewerWrite(p2, ownerGeneration)
		local data2 = commentsStore.getCachedMomentComments(p2).data(false)

		if data2 == nil then
			markFeedUnavailable(p2, "ViewerNotEligibleToWrite")
			return
		end

		local clone = table.clone(data2)
		clone.viewerCanWrite = false
		commentsStore.upsertMomentComments({ [p2] = clone }, ownerGeneration)
	end

	local function incrementMomentCommentCount(p2, ownerGeneration)
		local data2 = commentsStore.getCachedMomentComments(p2).data(false)

		if data2 == nil or data2.count == nil or data2.countIsCapped == true then
			return
		end

		local clone = table.clone(data2)
		clone.count = data2.count + 1
		commentsStore.upsertMomentComments({ [p2] = clone }, ownerGeneration)
	end

	local function startPendingPost(data2, p2, p3, pendingSubmission, p4): boolean
		if v11 ~= nil then
			return false
		end

		local ownerGeneration = commentsStore.getOwnerGeneration(false)
		local statusCode = nil
		local v22 = nil

		local v23 = fFlagMomentsComments and {
			[429] = { function(p5)
					statusCode = p5.statusCode
					v22 = readRetryAfter(p5)
				end }
		} or nil

		local v24 = v21

		if fFlagMomentsComments and v24 ~= nil then
			v24.logEvent(eventNames.MomentCommentPostAttempted)
		end

		local v25 = postComment(
			p2,
			{
				text = pendingSubmission.text,
				clientRequestId = pendingSubmission.clientRequestId
			},
			data.network,
			v23
		)
		local v26 = {
			analyticsSession = v24,
			clientRequestId = pendingSubmission.clientRequestId,
			feedItemId = p2,
			sessionId = p3,
			ownerGeneration = ownerGeneration,
			cancel = function() end
		}

		v11 = v26
		v26.cancel = observeRequest(v25, function(data3)
			if
				v11 == v26
				and v26.feedItemId == p2
				and v26.sessionId == p3
				and v26.ownerGeneration == ownerGeneration
			then
				local v27 = data2
				local v28 = p2
				local v29 = p3
				local v30 = ownerGeneration
				local v31 = not flag

				if v31 then
					if
						v10 == v27
						and v27.feedItemId == v28
						and v27.sessionId == v29
						and v27.ownerGeneration == v30
					then
						v31 = commentsStore.getOwnerGeneration(false) == v30
					else
						v31 = false
					end
				end

				if v31 then
					v11 = nil

					local pendingSubmission2 = collectionStore.getPendingSubmission(p2)

					if
						pendingSubmission2 == nil
						or pendingSubmission2.clientRequestId ~= v26.clientRequestId
					then
						return
					end

					if data3.status == "succeeded" and data3.result ~= nil then
						commentsStore.upsertComments({ data3.result }, ownerGeneration)
						collectionStore.resolvePendingSubmission(p2, data3.result)
						incrementMomentCommentCount(p2, ownerGeneration)

						if fFlagMomentsComments and v24 ~= nil then
							v24.logEvent(eventNames.MomentCommentPostResult, {
								outcome = "success",
								commentId = data3.result.commentId
							})
						end

						if fFlagMomentsComments then
							local v32 = v20
							v20 = nil

							if v32 ~= nil then
								v32(data3.result.text)
							end
						end
					elseif fFlagMomentsComments then
						local v32 = readStatusCode(data3, statusCode)
						local commentsError = MomentsComments.parseCommentsError(data3.error)

						local v33 = if commentsError ~= nil then commentsError.errorCode else nil

						if v33 == "CommentsUnavailable" then
							v33 = nil
						elseif v33 == nil then
							v33 = v32 ~= nil
								and v32 ~= 408
								and not (v32 < 400 or v32 >= 500)
								and (v32 == 429 and "RateLimited" or v32 == 401 and "AuthenticationRequired" or "PostRejected")
								or nil
						end

						if p4 and v33 ~= nil and (v32 == 429 or commentsError == nil) then
							v33 = nil
						end

						if v32 == 429 then
							setPostCooldown(v22)
						end

						if v24 ~= nil then
							local logEvent = v24.logEvent
							local momentCommentPostResult = eventNames.MomentCommentPostResult
							local v34 = {
								outcome = v33 == nil and "unknown" or "rejected",
								failureReason = 0
							}

							local v36 = if commentsError ~= nil then commentsError.errorCode else nil
							v34.failureReason = getCommentsFailureReason(v36, v32)
							logEvent(momentCommentPostResult, v34)
						end

						if v33 == nil then
							collectionStore.markPendingOutcomeUnknown(p2)
						else
							collectionStore.rejectPendingSubmission(p2, v33)

							if v7[v33] then
								markFeedUnavailable(p2, v33)
							elseif v33 == "ViewerNotEligibleToWrite" then
								revokeViewerWrite(p2, ownerGeneration)
							end
						end
					else
						local commentsError = MomentsComments.parseCommentsError(data3.error)

						if
							commentsError == nil
							or commentsError.errorCode ~= "TextFilterRejected"
							and commentsError.errorCode ~= "RateLimited"
						then
							collectionStore.markPendingOutcomeUnknown(p2)
						else
							collectionStore.rejectPendingSubmission(p2, commentsError.errorCode)

							if fFlagMomentsComments then
								v20 = nil
							end
						end
					end
				end
			end
		end)
		local v27 = not flag

		if v27 then
			if
				v10 == data2
				and data2.feedItemId == p2
				and data2.sessionId == p3
				and data2.ownerGeneration == ownerGeneration
			then
				v27 = commentsStore.getOwnerGeneration(false) == ownerGeneration
			else
				v27 = false
			end
		end

		if v27 then
			return true
		end

		if v11 == v26 then
			v11 = nil
		end

		v26.cancel()
		return false
	end

	local function submitComment(p2, p3, p4)
		local v22 = v10

		if
			flag
			or v22 == nil
			or v22.feedItemId ~= p2
			or v22.sessionId ~= p3
			or v22.ownerGeneration ~= commentsStore.getOwnerGeneration(false)
			or v22.refCount == 0
		then
			v22 = nil
		end

		if v22 == nil or v11 ~= nil or collectionStore.getPendingSubmission(p2) ~= nil then
			return false
		end

		if fFlagMomentsComments then
			local v23 = signal(false)
			local flag2

			if v23 == 0 then
				flag2 = false
			elseif nowMs() < v23 then
				flag2 = true
			else
				if v18 ~= nil then
					v18()
					v18 = nil
				end

				v17(0)
				flag2 = false
			end

			if flag2 then
				return false
			end
		end

		local v23 = collectionStore.beginPendingSubmission(p2, p4)
		local pendingSubmission = collectionStore.getPendingSubmission(p2)

		if pendingSubmission == nil or pendingSubmission.clientRequestId ~= v23 then
			return false
		end

		if fFlagMomentsComments and data.getAnalyticsSession ~= nil then
			v21 = data.getAnalyticsSession(p2, p3)
		end

		if fFlagMomentsComments and data.getCommentPostedCallback ~= nil then
			v20 = data.getCommentPostedCallback(p2, p3)
		end

		return startPendingPost(v22, p2, p3, pendingSubmission)
	end

	local function retryPendingSubmission(p2, p3)
		local v22 = v10

		if
			flag
			or v22 == nil
			or v22.feedItemId ~= p2
			or v22.sessionId ~= p3
			or v22.ownerGeneration ~= commentsStore.getOwnerGeneration(false)
			or v22.refCount == 0
		then
			v22 = nil
		end

		if v22 == nil or v11 ~= nil then
			return false
		end

		local pendingSubmission = collectionStore.getPendingSubmission(p2)

		if pendingSubmission == nil or pendingSubmission.status ~= "OutcomeUnknown" then
			return false
		end

		if fFlagMomentsComments then
			local v23 = signal(false)
			local flag2

			if v23 == 0 then
				flag2 = false
			elseif nowMs() < v23 then
				flag2 = true
			else
				if v18 ~= nil then
					v18()
					v18 = nil
				end

				v17(0)
				flag2 = false
			end

			if flag2 then
				return false
			end
		end

		collectionStore.markPendingSending(p2)
		local pendingSubmission2 = collectionStore.getPendingSubmission(p2)

		if
			pendingSubmission2 == nil
			or pendingSubmission2.clientRequestId ~= pendingSubmission.clientRequestId
		then
			return false
		end

		return startPendingPost(v22, p2, p3, pendingSubmission2, true)
	end

	local function editPendingSubmission(p2, p3): boolean
		local v22 = v10

		if
			flag
			or v22 == nil
			or v22.feedItemId ~= p2
			or v22.sessionId ~= p3
			or v22.ownerGeneration ~= commentsStore.getOwnerGeneration(false)
			or v22.refCount == 0
		then
			v22 = nil
		end

		if v22 == nil or v11 ~= nil then
			return false
		end

		local pendingSubmission = collectionStore.getPendingSubmission(p2)

		if pendingSubmission == nil or pendingSubmission.status ~= "OutcomeUnknown" then
			return false
		end

		collectionStore.rejectPendingSubmission(p2, "SubmissionOutcomeUnknown")
		return true
	end

	local function decrementMomentCommentCount(p2, p3)
		local data2 = commentsStore.getCachedMomentComments(p2).data(false)

		if data2 == nil or data2.count == nil or data2.countIsCapped == true or data2.count <= 0 then
			return
		end

		local clone = table.clone(data2)
		clone.count = data2.count - 1
		commentsStore.upsertMomentComments({ [p2] = clone }, p3)
	end

	local function removeDeletedComment(p2, p3, ownerGeneration)
		if sessionFilters ~= nil then
			sessionFilters.hideCommentForSession(p3)
		end

		local v22 = collectionStore.getState(p2)(false)

		if
			table.find(v22.orderedCommentIds, p3) ~= nil
			or table.find(v22.stickyPostedCommentIds, p3) ~= nil
		then
			collectionStore.removeCommentId(p2, p3)
		end

		if fFlagMomentsComments then
			cancelReactionRequest(p3)
			local v23 = v14[p3]
			v14[p3] = nil

			if v23 ~= nil then
				v23()
			end

			v15[p3] = nil
			reactionStore.clearComment(p3)
		end

		decrementMomentCommentCount(p2, ownerGeneration)
	end

	local function deleteComment2(p2, p3, callback, callback2): boolean
		if flag or v13[p3] ~= nil then
			return false
		end

		local ownerGeneration = commentsStore.getOwnerGeneration(false)
		local v22 = nil

		if fFlagMomentsComments and data.getCommentDeletedCallback ~= nil then
			local v23 = v10

			if v23 ~= nil and v23.feedItemId == p2 then
				v22 = data.getCommentDeletedCallback(p2, v23.sessionId)
			end
		end

		local v23

		if FFlagMomentsCommentActionsRealtime then
			local v24 = v10

			if data.getAnalyticsSession == nil or v24 == nil or v24.feedItemId ~= p2 then
				v23 = nil
			else
				v23 = data.getAnalyticsSession(p2, v24.sessionId)
			end
		else
			v23 = nil
		end

		local v24 = deleteComment(p2, p3, data.network)

		if FFlagMomentsCommentActionsRealtime and v23 ~= nil then
			v23.logRealtimeEvent("MomentsCommentDelete", { status = "attempted" })
		end

		local v25 = {
			cancel = function() end
		}

		v13[p3] = v25
		v25.cancel = observeRequest(v24, function(p4)
			if v13[p3] ~= v25 then
				return
			end

			v13[p3] = nil

			if flag or commentsStore.getOwnerGeneration(false) ~= ownerGeneration then
				return
			end

			local commentsError = MomentsComments.parseCommentsError(p4.error)
			local v26

			if readStatusCode(p4, nil) == 404 then
				v26 = true
			else
				v26 = not (commentsError == nil) and commentsError.errorCode == "CommentNotFound"
			end

			if FFlagMomentsCommentActionsRealtime and v23 ~= nil then
				if p4.status == "succeeded" then
					v23.logRealtimeEvent("MomentsCommentDelete", {
						status = "succeeded"
					})
				elseif v26 then
					v23.logRealtimeEvent("MomentsCommentDelete", {
						status = "already_deleted"
					})
				else
					local logRealtimeEvent = v23.logRealtimeEvent
					local commentsError2 = MomentsComments.parseCommentsError(p4.error)
					logRealtimeEvent("MomentsCommentDelete", {
						status = "failed",
						failureReason = getCommentsFailureReason(
							commentsError2 == nil and "CommentsUnavailable" or commentsError2.errorCode,
							readStatusCode(p4, nil)
						)
					})
				end
			end

			if p4.status == "succeeded" or v26 then
				removeDeletedComment(p2, p3, ownerGeneration)

				if fFlagMomentsComments and p4.status == "succeeded" and callback2 ~= nil then
					callback2()
				end
			elseif callback ~= nil then
				callback()
			end

			if fFlagMomentsComments and p4.status == "succeeded" and v22 ~= nil then
				v22()
			end
		end)
		return true
	end

	local function cancelActiveDeletes()
		local v22 = v13
		v13 = {}

		for k, v23 in v22 do
			v23.cancel()
		end
	end

	local function cancelActivePost(p2)
		local v22 = v11
		v11 = nil

		if v22 == nil then
			return
		end

		if
			fFlagMomentsComments
			and v22.analyticsSession ~= nil
			and v22.ownerGeneration == commentsStore.getOwnerGeneration(false)
		then
			v22.analyticsSession.logEvent(eventNames.MomentCommentPostResult, {
				outcome = "cancelled",
				failureReason = "cancelled"
			})
		end

		v22.cancel()

		if p2 then
			local pendingSubmission = collectionStore.getPendingSubmission(v22.feedItemId)

			if pendingSubmission ~= nil and pendingSubmission.clientRequestId == v22.clientRequestId then
				collectionStore.markPendingOutcomeUnknown(v22.feedItemId)
			end
		end
	end

	local function retireActiveSession(p2)
		if fFlagMomentsComments and not p2 then
			v20 = nil
		end

		local v22 = v10
		v10 = nil

		if v22 ~= nil then
			local activePageRequest = v22.activePageRequest
			v22.activePageRequest = nil

			if activePageRequest ~= nil then
				activePageRequest.cancel()
			end

			local activePinnedRequest = v22.activePinnedRequest
			v22.activePinnedRequest = nil

			if activePinnedRequest ~= nil then
				v22.hasRequestedPinnedComment = false
				activePinnedRequest.cancel()
			end
		end

		cancelActivePost(p2)

		if fFlagMomentsComments and not p2 then
			v21 = nil
		end
	end

	local function acquireSession(p2, p3)
		if flag then
			return function() end
		end

		if fFlagMomentsComments and catalogStore ~= nil and catalogStore.getAndFetchEmojiSets ~= nil then
			catalogStore.getAndFetchEmojiSets()
		end

		local ownerGeneration = commentsStore.getOwnerGeneration(false)
		local v22 = v10

		if
			v22 == nil
			or v22.feedItemId ~= p2
			or v22.sessionId ~= p3
			or v22.ownerGeneration ~= ownerGeneration
		then
			local v23 = not (v22 == nil or v22.feedItemId ~= p2) and v22.ownerGeneration == ownerGeneration

			if fFlagMomentsComments and not v23 then
				v20 = nil
			end

			local v24 = v10
			v10 = nil

			if v24 ~= nil then
				local activePageRequest = v24.activePageRequest
				v24.activePageRequest = nil

				if activePageRequest ~= nil then
					activePageRequest.cancel()
				end

				local activePinnedRequest = v24.activePinnedRequest
				v24.activePinnedRequest = nil

				if activePinnedRequest ~= nil then
					v24.hasRequestedPinnedComment = false
					activePinnedRequest.cancel()
				end
			end

			cancelActivePost(v23)

			if fFlagMomentsComments and not v23 then
				v21 = nil
			end

			collectionStore.selectFeed(p2, ownerGeneration)
			v22 = {
				feedItemId = p2,
				sessionId = p3,
				ownerGeneration = ownerGeneration,
				refCount = 0,
				activePageRequest = nil,
				activePinnedRequest = nil,
				hasRequestedPinnedComment = false,
				requestedCursors = {},
				initialLoadType = "initial"
			}

			v10 = v22
			collectionStore.beginListSession(p2)
		elseif v22.refCount == 0 then
			collectionStore.resetListSession(p2)
		end

		v22.refCount += 1

		local flag2 = false
		return function()
			if flag2 then
				return
			end

			flag2 = true
			local v23 = v10

			if v23 == nil or v23 ~= v22 then
				return
			end

			v23.refCount = math.max(0, v23.refCount - 1)

			if v23.refCount == 0 then
				local activePageRequest = v23.activePageRequest
				v23.activePageRequest = nil

				if activePageRequest ~= nil then
					activePageRequest.cancel()
				end

				local activePinnedRequest = v23.activePinnedRequest
				v23.activePinnedRequest = nil

				if activePinnedRequest ~= nil then
					v23.hasRequestedPinnedComment = false
					activePinnedRequest.cancel()
				end
			end
		end
	end

	local function ensureInitialLoad(p2, p3)
		local v22 = v10

		if
			flag
			or v22 == nil
			or v22.feedItemId ~= p2
			or v22.sessionId ~= p3
			or v22.ownerGeneration ~= commentsStore.getOwnerGeneration(false)
			or v22.refCount == 0
		then
			v22 = nil
		end

		if v22 == nil then
			return false
		end

		local v23 = collectionStore.getState(p2)(false)

		if v23.initialLoadStatus == loadStatus.Idle and v23.loadMoreStatus ~= loadStatus.Loading then
			return fn2(p2, p3, "initial", nil)
		end

		return false
	end

	local function loadMore(p2, sessionId)
		local v22 = collectionStore.getState(p2)(false)

		if
			v22.hasMore == true
			and v22.initialLoadStatus ~= loadStatus.Loading
			and v22.loadMoreStatus ~= loadStatus.Loading
			and v22.loadMoreStatus ~= loadStatus.Failed
		then
			return fn2(p2, sessionId, "more", v22.nextCursor)
		end

		return false
	end

	local function retryInitial(p2, p3)
		local v22 = v10

		if
			flag
			or v22 == nil
			or v22.feedItemId ~= p2
			or v22.sessionId ~= p3
			or v22.ownerGeneration ~= commentsStore.getOwnerGeneration(false)
			or v22.refCount == 0
		then
			v22 = nil
		end

		if v22 == nil then
			return false
		end

		if
			fFlagMomentsComments
			and collectionStore.getState(p2)(false).initialLoadStatus == loadStatus.Success
		then
			v22.initialLoadType = "refresh"
		end

		local activePageRequest = v22.activePageRequest
		v22.activePageRequest = nil

		if activePageRequest ~= nil then
			activePageRequest.cancel()
		end

		local activePinnedRequest = v22.activePinnedRequest
		v22.activePinnedRequest = nil

		if activePinnedRequest ~= nil then
			v22.hasRequestedPinnedComment = false
			activePinnedRequest.cancel()
		end

		table.clear(v22.requestedCursors)
		collectionStore.resetListSession(p2)
		return ensureInitialLoad(p2, p3)
	end

	local function retryLoadMore(p2, p3)
		local v22 = v10

		if
			flag
			or v22 == nil
			or v22.feedItemId ~= p2
			or v22.sessionId ~= p3
			or v22.ownerGeneration ~= commentsStore.getOwnerGeneration(false)
			or v22.refCount == 0
		then
			v22 = nil
		end

		if v22 == nil then
			return false
		end

		local v23 = collectionStore.getState(p2)(false)

		if
			v23.hasMore ~= true
			or v23.initialLoadStatus == loadStatus.Loading
			or v23.loadMoreStatus == loadStatus.Loading
		then
			return false
		end

		if v23.nextCursor == nil or v22.requestedCursors[v23.nextCursor or "<initial>"] == true then
			return retryInitial(p2, p3)
		end

		return fn2(p2, p3, "more", v23.nextCursor)
	end

	local function resolveCommentAuthor(p2)
		local data2 = commentsStore.getCachedComment(p2).data(false)

		if data2 == nil or data2.author == nil then
			return nil
		end

		return data2.author.userId
	end

	local function containsCommentByAuthor(items, p2): boolean
		for k, item in items do
			local data2 = commentsStore.getCachedComment(item).data(false)
			local v22 = if not (data2 == nil or data2.author == nil) then data2.author.userId else nil

			if v22 == p2 then
				return true
			end
		end

		return false
	end

	local function hideCommentsByAuthor(p2, p3)
		if flag then
			return
		end

		if sessionFilters ~= nil then
			sessionFilters.markAuthorRecentlyBlocked(p3)
		end

		local v22 = collectionStore.getState(p2)(false)
		local flag2 = true
		local flag3

		for k, orderedCommentId in v22.orderedCommentIds do
			local data2 = commentsStore.getCachedComment(orderedCommentId).data(false)
			local v23 = if not (data2 == nil or data2.author == nil) then data2.author.userId else nil

			if v23 == p3 then
				flag3 = true
				flag2 = false
				break
			end
		end

		if flag2 then
			flag3 = false
		end

		local v23

		if flag3 then
			collectionStore.removeCommentIdsByAuthor(p2, p3, resolveCommentAuthor)

			v23 = v10

			if v23 ~= nil and #collectionStore.getState(p2)(false).orderedCommentIds == 0 then
				loadMore(p2, v23.sessionId)
			end
		else
			local flag4 = true
			local flag5

			for k, stickyPostedCommentId in v22.stickyPostedCommentIds do
				local data2 = commentsStore.getCachedComment(stickyPostedCommentId).data(false)
				local v24 = if not (data2 == nil or data2.author == nil) then data2.author.userId else nil

				if v24 == p3 then
					flag5 = true
					flag4 = false
					break
				end
			end

			if flag4 then
				flag5 = false
			end

			if flag5 then
				collectionStore.removeCommentIdsByAuthor(p2, p3, resolveCommentAuthor)

				v23 = v10

				if v23 ~= nil and #collectionStore.getState(p2)(false).orderedCommentIds == 0 then
					loadMore(p2, v23.sessionId)
				end
			elseif v22.pinnedCommentId ~= nil then
				local pinnedCommentId = v22.pinnedCommentId
				local data2 = commentsStore.getCachedComment(pinnedCommentId).data(false)
				local v24 = if not (data2 == nil or data2.author == nil) then data2.author.userId else nil

				if v24 == p3 then
					collectionStore.removeCommentIdsByAuthor(p2, p3, resolveCommentAuthor)

					v23 = v10

					if v23 ~= nil and #collectionStore.getState(p2)(false).orderedCommentIds == 0 then
						loadMore(p2, v23.sessionId)
					end
				end
			end
		end
	end

	local function restoreCommentsByAuthor(p2, p3)
		if flag then
			return
		end

		if sessionFilters ~= nil then
			if not sessionFilters.isAuthorRecentlyBlocked(p3) then
				return
			end

			sessionFilters.unmarkAuthorRecentlyBlocked(p3)
		end

		local v22 = v10

		if v22 ~= nil then
			retryInitial(p2, v22.sessionId)
		end
	end

	local effect = Signals.createEffect(function(p2)
		local ownerGeneration = commentsStore.getOwnerGeneration(p2)

		if ownerGeneration == v19 then
			return
		end

		v19 = ownerGeneration

		if fFlagMomentsComments then
			v20 = nil
		end

		local v22 = v10
		v10 = nil

		if v22 ~= nil then
			local activePageRequest = v22.activePageRequest
			v22.activePageRequest = nil

			if activePageRequest ~= nil then
				activePageRequest.cancel()
			end

			local activePinnedRequest = v22.activePinnedRequest
			v22.activePinnedRequest = nil

			if activePinnedRequest ~= nil then
				v22.hasRequestedPinnedComment = false
				activePinnedRequest.cancel()
			end
		end

		local v23 = v11
		v11 = nil

		if v23 ~= nil then
			if
				fFlagMomentsComments
				and v23.analyticsSession ~= nil
				and v23.ownerGeneration == commentsStore.getOwnerGeneration(false)
			then
				v23.analyticsSession.logEvent(eventNames.MomentCommentPostResult, {
					outcome = "cancelled",
					failureReason = "cancelled"
				})
			end

			v23.cancel()
		end

		if fFlagMomentsComments then
			v21 = nil
		end

		local v24 = v13
		v13 = {}

		for k, v25 in v24 do
			v25.cancel()
		end

		if fFlagMomentsComments then
			clearReactionState()
		end

		if fFlagMomentsComments then
			if v18 ~= nil then
				v18()
				v18 = nil
			end

			v17(0)
		end

		collectionStore.clear()
	end)

	local function dispose()
		if flag then
			return
		end

		flag = true
		effect()

		if fFlagMomentsComments then
			v20 = nil
		end

		local v22 = v10
		v10 = nil

		if v22 ~= nil then
			local activePageRequest = v22.activePageRequest
			v22.activePageRequest = nil

			if activePageRequest ~= nil then
				activePageRequest.cancel()
			end

			local activePinnedRequest = v22.activePinnedRequest
			v22.activePinnedRequest = nil

			if activePinnedRequest ~= nil then
				v22.hasRequestedPinnedComment = false
				activePinnedRequest.cancel()
			end
		end

		local v23 = v11
		v11 = nil

		if v23 ~= nil then
			if
				fFlagMomentsComments
				and v23.analyticsSession ~= nil
				and v23.ownerGeneration == commentsStore.getOwnerGeneration(false)
			then
				v23.analyticsSession.logEvent(eventNames.MomentCommentPostResult, {
					outcome = "cancelled",
					failureReason = "cancelled"
				})
			end

			v23.cancel()
		end

		if fFlagMomentsComments then
			v21 = nil
		end

		local v24 = v13
		v13 = {}

		for k, v25 in v24 do
			v25.cancel()
		end

		if fFlagMomentsComments then
			clearReactionState()
		end

		if fFlagMomentsComments then
			if v18 ~= nil then
				v18()
				v18 = nil
			end

			v17(0)
		end

		collectionStore.clear()
	end

	local commentsListCoordinator = {
		acquireSession = acquireSession,
		ensureInitialLoad = ensureInitialLoad,
		loadMore = loadMore,
		retryInitial = retryInitial,
		retryLoadMore = retryLoadMore,
		submitComment = submitComment,
		retryPendingSubmission = retryPendingSubmission,
		editPendingSubmission = editPendingSubmission,
		getPostCooldownUntilMs = signal,
		ensureReactionPresent = nil,
		ensureReactionAbsent = nil,
		clearReactionState = nil,
		deleteComment = nil,
		hideCommentsByAuthor = nil,
		restoreCommentsByAuthor = nil,
		dispose = nil
	}

	if not fFlagMomentsComments then
		ensureReactionPresent = rejectReactionMutation
	end

	commentsListCoordinator.ensureReactionPresent = ensureReactionPresent

	if not fFlagMomentsComments then
		ensureReactionAbsent = rejectReactionMutation
	end

	commentsListCoordinator.ensureReactionAbsent = ensureReactionAbsent
	commentsListCoordinator.clearReactionState = if fFlagMomentsComments then clearReactionState else noOp
	commentsListCoordinator.deleteComment = deleteComment2
	commentsListCoordinator.hideCommentsByAuthor = hideCommentsByAuthor
	commentsListCoordinator.restoreCommentsByAuthor = restoreCommentsByAuthor
	commentsListCoordinator.dispose = dispose
	return commentsListCoordinator
end

return createCommentsListCoordinator
