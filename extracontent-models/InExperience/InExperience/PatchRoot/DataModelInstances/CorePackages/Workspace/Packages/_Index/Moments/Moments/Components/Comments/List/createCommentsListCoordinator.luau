local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.HttpClient)
local MomentsCommon = require(parent.MomentsCommon)
local EventNames = MomentsCommon.Analytics.EventNames
require(Moments.Components.Comments.createCommentsAnalyticsSession)
local getCommentsFailureReason = require(Moments.Analytics.getCommentsFailureReason)

local MomentsComments = require(parent.DataHydration.MomentsComments)
require(parent.DataHydration.MomentsStoreTypes)
require(parent.MomentsTypes)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)

require(Moments.Components.Comments.GetCommentCollectionStore.createCommentCollectionStore)

require(Moments.Components.Comments.GetCommentSessionFiltersStore.createCommentSessionFiltersStore)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsCommentActionsRealtime = require(Moments.Flags.FFlagMomentsCommentActionsRealtime)
local FFlagMomentsCommentsCountAnalytics = require(Moments.Flags.FFlagMomentsCommentsCountAnalytics)
local FFlagMomentsCommentDeepLinks = SharedFlags.FFlagMomentsCommentDeepLinks

local CommentCollectionTypes = require(Moments.Components.Comments.GetCommentCollectionStore.CommentCollectionTypes)
require(Moments.Stores.GetCommentReactionsStore.createCommentReactionsStore)

local LoadStatus = CommentCollectionTypes.LoadStatus

local v = { 250, 500 }

local v2 = {
	AuthenticationRequired = true,
	CommentsEndpointDisabled = true,
	ViewerNotEligibleToReact = true
}

local v3 = {
	CommentsDisabledByCreator = true,
	MomentUnavailable = true,
	ViewerNotEligibleToRead = true
}

local v4 = {
	CommentsDisabledByCreator = true,
	MomentNotFound = true,
	MomentNotVisible = true,
	ViewerNotEligibleToRead = true,
	ViewerNotEligibleToWrite = true
}

local v5 = {
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

local function cursorKey(value: string?) -- 5 equivalent calls inferred from this helper
	return value or "<initial>"
end

local function defaultSchedule(p: number, callback)
	local thread = task.delay(p / 1000, callback)
	return function()
		pcall(task.cancel, thread)
	end
end

local function defaultReadStatusCode(p, p2: number?)
	if p2 ~= nil then
		return p2
	end

	if p.response == nil then
		return p.errorCode
	end

	return p.response.statusCode
end

local function defaultReadRetryAfter(p)
	if p.headers == nil then
		return nil
	end

	return p.headers["retry-after"] or p.headers["Retry-After"]
end

local function parseHttpDateMs(value: string)
	local v6, v7, v8, v9, v10, v11 = string.match(
		value,
		"^%a%a%a, (%d%d) (%a%a%a) (%d%d%d%d) (%d%d):(%d%d):(%d%d) GMT$"
	)
	local v12

	if v7 ~= nil then
		v12 = v5[v7]
	end

	if v6 == nil or v12 == nil or v8 == nil or v9 == nil or v10 == nil or v11 == nil then
		return nil
	end

	local success, result = pcall(
		DateTime.fromUniversalTime,
		tonumber(v8),
		v12,
		tonumber(v6),
		tonumber(v9),
		tonumber(v10),
		(tonumber(v11))
	)

	return if success then result.UnixTimestampMillis else nil
end

local function retryAfterDelayMs(p: string?, p2: number) -- 2 equivalent calls inferred from this helper
	if p == nil then
		return 5000
	end

	local v6 = tonumber(p)
	local v7

	if v6 ~= nil then
		v7 = v6 * 1000
	end

	if v7 == nil then
		local v8 = parseHttpDateMs(p)

		if v8 == nil then
			v7 = nil
		else
			v7 = math.max(0, v8 - p2)
		end
	end

	return if v7 == nil or v7 < 0 or v7 > 60000 then 5000 else v7
end

local function definitePostRejectionCode(p: number?, errorCode: string?) -- 1 equivalent call inferred from this helper
	if errorCode == "CommentsUnavailable" then
		return nil
	end

	if errorCode ~= nil then
		return errorCode
	end

	if p == nil or p == 408 or p < 400 or p >= 500 then
		return nil
	end

	if p == 429 then
		return "RateLimited"
	elseif p == 401 then
		return "AuthenticationRequired"
	end

	return "PostRejected"
end

local function selectedEmoteId(reactions) -- 3 equivalent calls inferred from this helper
	if reactions == nil or reactions.userReaction == nil then
		return nil
	end

	return reactions.userReaction.emoteId
end

local function isUncertainStatus(p: number?): boolean -- 1 equivalent call inferred from this helper
	if p == nil or p == 408 then
		return true
	elseif p == nil or not (p >= 500) then
		return false
	else
		return p <= 599
	end
end

local function errorCodeFrom(p) -- 3 equivalent calls inferred from this helper
	local commentsError = MomentsComments.parseCommentsError(p.error)

	if commentsError == nil then
		return "CommentsUnavailable"
	end

	return commentsError.errorCode
end

local function observeRequest(p, fn)
	local flag = false
	local v6 = nil

	local function stop()
		if flag then
			return
		end

		flag = true

		if v6 ~= nil then
			v6()
			v6 = nil
		end

		p.dispose()
	end

	local function settle(state) -- 1 equivalent call inferred from this helper
		if flag or state.status == "pending" then
			return
		end

		flag = true

		if v6 ~= nil then
			v6()
			v6 = nil
		end

		p.dispose()
		fn(state)
	end

	local state = p.state(false)

	if state.status == "pending" then
		v6 = Signals.createEffect(function(p2)
			local state2 = p.state(p2)

			if not flag then
				if state2.status == "pending" then
					return
				end

				flag = true

				if v6 ~= nil then
					v6()
					v6 = nil
				end

				p.dispose()
				fn(state2)
			end
		end)

		if flag and v6 ~= nil then
			v6()
			v6 = nil
		end
	else
		settle(state) -- inferred equivalent call
	end

	return stop
end

local function rejectReactionMutation(_: string, _: string, _: string, _): boolean
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
	local v6 = nil
	local v7 = nil
	local v8 = {}
	local v9 = {}
	local v10 = {}
	local v11 = {}
	local v12 = nil
	local signal, v13 = Signals.createSignal(0)
	local v14 = nil
	local v15 = commentsStore.getOwnerGeneration(false)
	local flag = false
	local v16 = nil
	local v17 = nil

	local function cancelActivePage(state) -- 4 equivalent calls inferred from this helper
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

	local function getSession(p: string, p2: number) -- 8 equivalent calls inferred from this helper
		local v18 = v6

		if
			flag
			or v18 == nil
			or v18.feedItemId ~= p
			or v18.sessionId ~= p2
			or v18.ownerGeneration ~= commentsStore.getOwnerGeneration(false)
			or v18.refCount == 0
		then
			return nil
		end

		return v18
	end

	local function isCurrentRequestSession(data2, p: string, p2: number, ownerGeneration: number) -- 5 equivalent calls inferred from this helper
		local v18 = not flag

		if v18 then
			if
				v6 == data2
				and data2.feedItemId == p
				and data2.sessionId == p2
				and data2.ownerGeneration == ownerGeneration
			then
				return commentsStore.getOwnerGeneration(false) == ownerGeneration
			end

			return false
		end

		return v18
	end

	local function cancelIntentExpiry(p: string) -- 9 equivalent calls inferred from this helper
		local v18 = v10[p]
		v10[p] = nil

		if v18 ~= nil then
			v18()
		end
	end

	local function scheduleIntentExpiry(commentId: string, generation: number) -- 4 equivalent calls inferred from this helper
		cancelIntentExpiry(commentId) -- inferred equivalent call
		v10[commentId] = schedule(10000, function()
			v10[commentId] = nil

			if reactionStore.expireIntent(commentId, generation) then
				v11[commentId] = nil
			end
		end)
	end

	local function cancelReactionRequest(p: string)
		local v18 = v8[p]
		v8[p] = nil

		if v18 == nil then
			return
		end

		if v18.cancelRequest ~= nil then
			v18.cancelRequest()
			v18.cancelRequest = nil
		end

		if v18.cancelRetry ~= nil then
			v18.cancelRetry()
			v18.cancelRetry = nil
		end

		if v18.cancelDebounce ~= nil then
			v18.cancelDebounce()
			v18.cancelDebounce = nil
		end
	end

	local function hardResetReaction(feedItemId: string, commentId: string, p: string?, generation: number) -- 1 equivalent call inferred from this helper
		cancelReactionRequest(commentId)
		cancelIntentExpiry(commentId) -- inferred equivalent call
		v11[commentId] = nil
		reactionStore.clearComment(commentId)

		if p ~= nil then
			reactionStore.setCommentRestriction(feedItemId, commentId, p, generation)
		end
	end

	local function clearReactionState()
		local v18 = {}

		for k in v8 do
			table.insert(v18, k)
		end

		for _, v19 in v18 do
			cancelReactionRequest(v19)
		end

		local v19 = {}

		for k in v10 do
			table.insert(v19, k)
		end

		for _, v20 in v19 do
			cancelIntentExpiry(v20) -- inferred equivalent call
		end

		if v12 ~= nil then
			v12()
			v12 = nil
		end

		table.clear(v11)
		reactionStore.clear()
	end

	local function clearReactionsForFeed(p: string, p2: string?)
		local v18 = {}

		for k, v19 in v11 do
			if v19 == p then
				table.insert(v18, k)
			end
		end

		for _, v19 in v18 do
			cancelReactionRequest(v19)
			cancelIntentExpiry(v19) -- inferred equivalent call
			v11[v19] = nil
		end

		reactionStore.clearFeed(p)
		reactionStore.setFeedRestriction(p, p2)
	end

	local function setReactionCooldown(p: string?)
		local v18 = nowMs()

		local cooldownUntilMs = reactionStore.getCooldownUntilMs(false)
		local v19 = math.max(cooldownUntilMs, v18 + retryAfterDelayMs(p, v18)) -- inferred equivalent call

		reactionStore.setCooldownUntilMs(v19)

		if v12 ~= nil then
			v12()
		end

		v12 = schedule(math.max(0, v19 - v18), function()
			v12 = nil

			if reactionStore.getCooldownUntilMs(false) == v19 then
				reactionStore.setCooldownUntilMs(0)
			end
		end)
	end

	local function clearPostCooldown() -- 3 equivalent calls inferred from this helper
		if v14 ~= nil then
			v14()
			v14 = nil
		end

		v13(0)
	end

	local function setPostCooldown(p: string?)
		local v18 = nowMs()

		local v19 = signal(false)
		local v20 = math.max(v19, v18 + retryAfterDelayMs(p, v18)) -- inferred equivalent call
		v13(v20)

		if v14 ~= nil then
			v14()
		end

		v14 = schedule(math.max(0, v20 - v18), function()
			v14 = nil

			if signal(false) == v20 then
				v13(0)
			end
		end)
	end

	local function isPostCoolingDown(): boolean -- 2 equivalent calls inferred from this helper
		local v18 = signal(false)

		if v18 == 0 then
			return false
		end

		if nowMs() < v18 then
			return true
		end

		clearPostCooldown() -- inferred equivalent call
		return false
	end

	local function markFeedUnavailable(p: string, p2: string)
		local v18 = v6

		if v18 == nil or v18.feedItemId ~= p or v18.ownerGeneration ~= commentsStore.getOwnerGeneration(false) then
			return
		end

		cancelActivePage(v18) -- inferred equivalent call
		local v19 = collectionStore.getState(p)(false).initialLoadStatus == LoadStatus.Success and "more" or "initial"
		collectionStore.failLoad(p, v19, p2)
	end

	local function getOpenAnalyticsSession(p: string) -- 2 equivalent calls inferred from this helper
		local v18 = v6

		if data.getAnalyticsSession == nil or v18 == nil or v18.feedItemId ~= p then
			return nil
		end

		return data.getAnalyticsSession(p, v18.sessionId)
	end

	local function logReactionRequest(state, verb: string, status: string, failureReason: string?) -- 1 equivalent call inferred from this helper
		local analyticsSession = state.analyticsSession

		if analyticsSession == nil then
			return
		end

		local v18 = {
			status = status,
			action = verb == "PUT" and "add" or "remove"
		}

		if failureReason ~= nil then
			v18.failureReason = failureReason
		end

		analyticsSession.logRealtimeEvent("MomentsCommentReaction", v18)
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

		local reactions = reactionStore.getProjection(data2.feedItemId, data2.commentId, data3.reactions, false).reactions

		if reactions == nil then
			return reactionStore.markLocallyConfirmed(data2.commentId, data2.generation)
		end

		local clone = table.clone(data3)
		clone.reactions = reactions
		local v18 = false
		SignalsExperimental.batch(function()
			commentsStore.upsertComments({ clone }, data2.ownerGeneration)
			v18 = reactionStore.confirmAndRebase(data2.commentId, data2.generation, reactions)
		end)
		return v18
	end

	local function retainUncertainUntilExpiry(state) -- 3 equivalent calls inferred from this helper
		v8[state.commentId] = nil
		state.cancelRetry = nil
		reactionStore.markUncertain(state.commentId, state.generation)
		scheduleIntentExpiry(state.commentId, state.generation) -- inferred equivalent call
	end

	local function rollbackReaction(data2, p: string?)
		cancelIntentExpiry(data2.commentId) -- inferred equivalent call

		if not reactionStore.rollback(data2.commentId, data2.generation, p) then
			return
		end

		local intent = reactionStore.getIntent(data2.commentId, false)

		if intent == nil or intent.status ~= "LocallyConfirmed" then
			v11[data2.commentId] = nil

			return
		end

		v11[data2.commentId] = data2.feedItemId
		scheduleIntentExpiry(data2.commentId, intent.generation) -- inferred equivalent call
	end

	local function applyTerminalFailure(data2, p: number?, p2: string)
		if p2 == "MomentUnavailable" then
			clearReactionsForFeed(data2.feedItemId, "MomentUnavailable")
			markFeedUnavailable(data2.feedItemId, "MomentUnavailable")
		elseif v2[p2] then
			clearReactionState()
			reactionStore.setGlobalRestriction(p2)
		elseif v4[p2] then
			clearReactionsForFeed(data2.feedItemId, p2)
		elseif p2 == "CommentNotFound" or p == 404 then
			hardResetReaction(data2.feedItemId, data2.commentId, p2, data2.generation) -- inferred equivalent call
		else
			rollbackReaction(data2, p2)
		end
	end

	local function fn(state)
		if
			flag
			or v8[state.commentId] ~= state
			or commentsStore.getOwnerGeneration(false) ~= state.ownerGeneration
			or reactionStore.getIntent(state.commentId, false) == nil
		then
			return
		end

		if state.syncIsUncertain or state.desiredEmoteId ~= state.syncedEmoteId then
			local startedAtMs = nowMs()
			local cooldownUntilMs = reactionStore.getCooldownUntilMs(false)

			if startedAtMs < cooldownUntilMs then
				reactionStore.markUncertain(state.commentId, state.generation)
				local v18 = cooldownUntilMs - startedAtMs

				if startedAtMs - state.startedAtMs + v18 <= 2000 then
					state.cancelRetry = schedule(v18, function()
						state.cancelRetry = nil
						fn(state)
					end)
					return
				end

				retainUncertainUntilExpiry(state) -- inferred equivalent call
			else
				if cooldownUntilMs > 0 then
					reactionStore.setCooldownUntilMs(0)
				end

				if state.attemptGeneration ~= state.generation then
					state.attemptGeneration = state.generation
					state.attempt = 0
					state.startedAtMs = startedAtMs
				end

				if state.attempt > 0 and startedAtMs - state.startedAtMs > 2000 then
					retainUncertainUntilExpiry(state) -- inferred equivalent call
				else
					state.attempt += 1

					if not reactionStore.markPending(state.commentId, state.generation) then
						v8[state.commentId] = nil
						return
					end

					state.readyToCommit = false
					local generation = state.generation
					local desiredEmoteId = state.desiredEmoteId
					local verb = state.verb
					local statusCode = nil
					local v18 = nil
					local v19 = {
						[429] = { function(p)
								statusCode = p.statusCode
								v18 = readRetryAfter(p)
							end }
					}
					local v20

					if verb == "PUT" then
						v20 = putReaction
					else
						v20 = deleteReaction
					end

					local v21 = v20(state.feedItemId, state.commentId, state.emoteId, data.network, v19)

					if FFlagMomentsCommentActionsRealtime then
						local analyticsSession = state.analyticsSession

						if analyticsSession ~= nil then
							local v22 = {
								status = "attempted",
								action = verb == "PUT" and "add" or "remove"
							}

							analyticsSession.logRealtimeEvent("MomentsCommentReaction", v22)
						end
					end

					state.cancelRequest = observeRequest(v21, function(p)
						if
							flag
							or v8[state.commentId] ~= state
							or commentsStore.getOwnerGeneration(false) ~= state.ownerGeneration
						then
							return
						end

						state.cancelRequest = nil

						if FFlagMomentsCommentActionsRealtime and p.status == "succeeded" then
							local analyticsSession = state.analyticsSession

							if analyticsSession ~= nil then
								local v22 = {
									status = "succeeded",
									action = verb == "PUT" and "add" or "remove"
								}

								analyticsSession.logRealtimeEvent("MomentsCommentReaction", v22)
							end
						end

						if p.status == "succeeded" then
							state.syncedEmoteId = desiredEmoteId
							state.syncIsUncertain = false

							if state.generation == generation then
								v8[state.commentId] = nil

								if commitProjectedReaction(state) then
									scheduleIntentExpiry(state.commentId, generation) -- inferred equivalent call
								end
							elseif state.desiredEmoteId == state.syncedEmoteId then
								v8[state.commentId] = nil

								if commitProjectedReaction(state) then
									scheduleIntentExpiry(state.commentId, state.generation) -- inferred equivalent call
								end
							elseif state.readyToCommit then
								fn(state)
							end
						else
							local v22 = readStatusCode(p, statusCode)
							local commentsError = MomentsComments.parseCommentsError(p.error)
							local v23 = commentsError == nil and "CommentsUnavailable" or commentsError.errorCode

							if FFlagMomentsCommentActionsRealtime then
								logReactionRequest(state, verb, "failed", getCommentsFailureReason(v23, v22)) -- inferred equivalent call
							end

							if v22 == 429 then
								v8[state.commentId] = nil
								rollbackReaction(state, nil)
								setReactionCooldown(v18)
							elseif isUncertainStatus(v22) then -- inferred equivalent call
								state.syncIsUncertain = true

								if state.generation == generation then
									reactionStore.markUncertain(state.commentId, generation)
									local v24 = v[state.attempt]

									if
										state.attempt <= 2
										and v24 ~= nil
										and nowMs() - state.startedAtMs + v24 <= 2000
									then
										state.cancelRetry = schedule(v24, function()
											state.cancelRetry = nil

											if
												v8[state.commentId] == state
												and commentsStore.getOwnerGeneration(false) == state.ownerGeneration
											then
												fn(state)
											end
										end)
										return
									end

									retainUncertainUntilExpiry(state) -- inferred equivalent call
								elseif state.readyToCommit then
									fn(state)
								end
							else
								v8[state.commentId] = nil
								applyTerminalFailure(state, v22, v23)
							end
						end
					end)
				end
			end
		else
			v8[state.commentId] = nil
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

				if flag or v8[state.commentId] ~= state then
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

	local function beginReactionMutation(feedItemId: string, commentId: string, emoteId: string, p, desiredEmoteId: string?, verb: string, syncedEmoteId: string?): boolean
		if flag or reactionStore.getRestriction(feedItemId, commentId, false) ~= nil then
			return false
		end

		local startedAtMs = nowMs()
		local cooldownUntilMs = reactionStore.getCooldownUntilMs(false)

		if startedAtMs < cooldownUntilMs then
			return false
		end

		if cooldownUntilMs > 0 then
			reactionStore.setCooldownUntilMs(0)
		end

		cancelIntentExpiry(commentId) -- inferred equivalent call
		local v18 = reactionStore.beginIntent(feedItemId, commentId, p, desiredEmoteId)
		local v19 = v8[commentId]

		if v19 == nil then
			v19 = {
				feedItemId = feedItemId,
				commentId = commentId,
				emoteId = emoteId,
				verb = verb,
				generation = v18,
				ownerGeneration = commentsStore.getOwnerGeneration(false),
				attempt = 0,
				startedAtMs = startedAtMs,
				attemptGeneration = v18,
				desiredEmoteId = desiredEmoteId,
				syncedEmoteId = syncedEmoteId,
				syncIsUncertain = false,
				readyToCommit = false,
				cancelRequest = nil,
				cancelRetry = nil,
				cancelDebounce = nil
			}

			v8[commentId] = v19
		else
			v19.verb = verb
			v19.generation = v18
			v19.desiredEmoteId = desiredEmoteId

			if v19.cancelRetry ~= nil then
				v19.cancelRetry()
				v19.cancelRetry = nil
				v19.syncIsUncertain = true
			end
		end

		if FFlagMomentsCommentActionsRealtime then
			v19.analyticsSession = getOpenAnalyticsSession(feedItemId) -- inferred equivalent call
		end

		v11[commentId] = feedItemId
		scheduleReactionCommit(v19)
		return true
	end

	local function ensureReactionPresent(feedItemId: string, commentId: string, p: string, p2)
		if p2 == nil then
			return false
		end

		local reactions = reactionStore.getProjection(feedItemId, commentId, p2, false).reactions

		if reactions ~= nil and selectedEmoteId(reactions) == nil then -- inferred equivalent call
			return beginReactionMutation(feedItemId, commentId, p, p2, p, "PUT", nil)
		end

		return false
	end

	local function ensureReactionAbsent(feedItemId: string, commentId: string, p: string, p2)
		if p2 == nil then
			return false
		end

		local reactions = reactionStore.getProjection(feedItemId, commentId, p2, false).reactions

		if reactions ~= nil and selectedEmoteId(reactions) == p then -- inferred equivalent call
			return beginReactionMutation(feedItemId, commentId, p, p2, nil, "DELETE", p)
		end

		return false
	end

	local fn2

	local function failInvalidContinuation(p: string)
		local v18 = collectionStore.getState(p)(false)

		if #v18.orderedCommentIds > 0 or v18.pendingSubmission ~= nil then
			collectionStore.failLoad(p, "more", "CommentsUnavailable")
		else
			collectionStore.failLoad(p, "initial", "CommentsUnavailable")
		end
	end

	local function continueAfterMerge(p: string, p2: number, result, shouldContinuePaging: boolean)
		if not result.hasMore then
			return
		end

		local session = getSession(p, p2) -- inferred equivalent call

		if session == nil then
			return
		end

		local nextCursor = result.nextCursor

		if nextCursor == nil or session.requestedCursors[cursorKey(nextCursor)] == true then -- inferred equivalent call
			failInvalidContinuation(p)
		elseif shouldContinuePaging then
			fn2(p, p2, "more", nextCursor)
		end
	end

	local function commentsForUpsert(list, p: number)
		local clones = table.create(#list)

		for _, clone in list do
			local intent = reactionStore.getIntent(clone.commentId, false)
			local v18

			if clone.reactions == nil or intent == nil then
				v18 = false
			else
				v18 = selectedEmoteId(clone.reactions) == intent.desiredEmoteId -- inferred equivalent call
			end

			if intent ~= nil and p < intent.generation and not v18 then
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

	local function requestPinnedComment(session, p: string, p2: number)
		if session.hasRequestedPinnedComment or data.getPinnedCommentId == nil then
			return
		end

		session.hasRequestedPinnedComment = true
		local pinnedCommentId = data.getPinnedCommentId(p, p2)

		if pinnedCommentId == nil or pinnedCommentId == "" then
			return
		end

		local ownerGeneration = commentsStore.getOwnerGeneration(false)
		local generation = reactionStore.getGeneration(false)
		local v18 = fetchComment(p, pinnedCommentId, data.network)
		local activePinnedRequest = {
			cancel = function() end
		}

		session.activePinnedRequest = activePinnedRequest
		activePinnedRequest.cancel = observeRequest(v18, function(p3)
			if
				not isCurrentRequestSession(session, p, p2, ownerGeneration) -- inferred equivalent call
				or session.activePinnedRequest ~= activePinnedRequest
			then
				return
			end

			session.activePinnedRequest = nil
			local result

			if p3.status == "succeeded" then
				result = p3.result
			end

			if
				result == nil
				or result.commentId ~= pinnedCommentId
				or result.feedItemId ~= p
				or result.status ~= "Active"
			then
				return
			end

			local userId

			if result.author ~= nil then
				userId = result.author.userId
			end

			if
				sessionFilters ~= nil
				and (sessionFilters.isCommentSessionHidden(pinnedCommentId) or userId ~= nil and sessionFilters.isAuthorRecentlyBlocked(userId))
			then
				return
			end

			commentsStore.upsertComments(commentsForUpsert({ result }, generation), ownerGeneration)

			if reactionStore.reconcile(p, pinnedCommentId, result.reactions, generation) then
				cancelReactionRequest(pinnedCommentId)
				cancelIntentExpiry(pinnedCommentId) -- inferred equivalent call
				v11[pinnedCommentId] = nil
			end

			collectionStore.setPinnedComment(p, pinnedCommentId)
		end)
	end

	fn2 = function(feedItemId: string, p: number, p2: string, cursor: string?): boolean
		local session = getSession(feedItemId, p) -- inferred equivalent call

		if session == nil or session.activePageRequest ~= nil then
			return false
		end

		local ownerGeneration = commentsStore.getOwnerGeneration(false)
		local v18 = not FFlagMomentsComments and 0 or reactionStore.getGeneration(false)

		if p2 == "more" then
			if cursor == nil or session.requestedCursors[cursorKey(cursor)] == true then -- inferred equivalent call
				failInvalidContinuation(feedItemId)
				return false
			end

			session.requestedCursors[cursorKey(cursor)] = true -- inferred equivalent call
		end

		if p2 == "initial" then
			collectionStore.beginInitialLoad(feedItemId)
		else
			collectionStore.beginLoadMore(feedItemId)
		end

		local loadType = p2 == "more" and "pagination" or session.initialLoadType
		local v19

		if FFlagMomentsComments and data.getAnalyticsSession ~= nil then
			v19 = data.getAnalyticsSession(feedItemId, p)

			if v19 ~= nil then
				v19.logEvent(EventNames.MomentCommentsListLoadAttempted, { loadType = loadType })
			end
		else
			v19 = nil
		end

		local v20 = fetchPage({ feedItemId = feedItemId, cursor = cursor, sort = "newest" }, data.network)

		local activePageRequest = {
			cancel = function() end
		}

		session.activePageRequest = activePageRequest

		activePageRequest.cancel = observeRequest(v20, function(p3)
			if
				not isCurrentRequestSession(session, feedItemId, p, ownerGeneration) -- inferred equivalent call
				or session.activePageRequest ~= activePageRequest
			then
				return
			end

			session.activePageRequest = nil

			if FFlagMomentsComments and v19 ~= nil then
				if p3.status == "succeeded" and p3.result ~= nil then
					local v21 = { loadType = loadType }

					if FFlagMomentsCommentsCountAnalytics then
						v21.loadedCommentCount = tostring(#p3.result.comments)
					end

					v19.logEvent(EventNames.MomentCommentsListLoadSucceeded, v21)
				else
					v19.logEvent(EventNames.MomentCommentsListLoadFailed, {
						loadType = loadType,
						failureReason = getCommentsFailureReason(errorCodeFrom(p3), readStatusCode(p3, nil)) -- inferred equivalent call
					})
				end
			end

			if p3.status == "succeeded" and p3.result ~= nil then
				if FFlagMomentsComments then
					commentsStore.upsertComments(commentsForUpsert(p3.result.comments, v18), ownerGeneration)

					for _, comment in p3.result.comments do
						if not reactionStore.reconcile(feedItemId, comment.commentId, comment.reactions, v18) then
							continue
						end

						cancelReactionRequest(comment.commentId)
						cancelIntentExpiry(comment.commentId) -- inferred equivalent call
						v11[comment.commentId] = nil
					end
				else
					commentsStore.upsertComments(p3.result.comments, ownerGeneration)
				end

				local v21

				if p2 == "initial" then
					v21 = collectionStore.completeInitialLoad(feedItemId, p3.result)
				else
					v21 = collectionStore.completeLoadMore(feedItemId, p3.result)
				end

				continueAfterMerge(feedItemId, p, p3.result, v21.shouldContinuePaging)
			else
				local v21 = errorCodeFrom(p3) -- inferred equivalent call

				if FFlagMomentsComments and v21 == "MomentUnavailable" then
					clearReactionsForFeed(feedItemId, "MomentUnavailable")
				end

				if p2 == "more" and v21 == "InvalidCursor" then
					if FFlagMomentsComments then
						session.initialLoadType = "refresh"
					end

					collectionStore.resetListSession(feedItemId)
					table.clear(session.requestedCursors)
					fn2(feedItemId, p, "initial", nil)
				else
					if p2 == "more" and cursor ~= nil then
						session.requestedCursors[cursorKey(cursor)] = nil -- inferred equivalent call
					end

					collectionStore.failLoad(feedItemId, p2, v21)
				end
			end
		end)

		if isCurrentRequestSession(session, feedItemId, p, ownerGeneration) then -- inferred equivalent call
			if FFlagMomentsCommentDeepLinks and p2 == "initial" then
				requestPinnedComment(session, feedItemId, p)
			end

			return true
		end

		if session.activePageRequest == activePageRequest then
			session.activePageRequest = nil
		end

		activePageRequest.cancel()
		return false
	end

	local function revokeViewerWrite(p: string, ownerGeneration: number)
		local data2 = commentsStore.getCachedMomentComments(p).data(false)

		if data2 == nil then
			markFeedUnavailable(p, "ViewerNotEligibleToWrite")
			return
		end

		local clone = table.clone(data2)
		clone.viewerCanWrite = false
		commentsStore.upsertMomentComments({ [p] = clone }, ownerGeneration)
	end

	local function incrementMomentCommentCount(p: string, ownerGeneration: number)
		local data2 = commentsStore.getCachedMomentComments(p).data(false)

		if data2 == nil or data2.count == nil or data2.countIsCapped == true then
			return
		end

		local clone = table.clone(data2)
		clone.count = data2.count + 1
		commentsStore.upsertMomentComments({ [p] = clone }, ownerGeneration)
	end

	local function startPendingPost(session, feedItemId: string, sessionId: number, pendingSubmission, flag2: boolean?): boolean
		if v7 ~= nil then
			return false
		end

		local ownerGeneration = commentsStore.getOwnerGeneration(false)
		local statusCode = nil
		local v18 = nil

		local v19 = FFlagMomentsComments and {
			[429] = { function(p)
					statusCode = p.statusCode
					v18 = readRetryAfter(p)
				end }
		} or nil

		local analyticsSession = v17

		if FFlagMomentsComments and analyticsSession ~= nil then
			analyticsSession.logEvent(EventNames.MomentCommentPostAttempted)
		end

		local v20 = postComment(
			feedItemId,
			{ text = pendingSubmission.text, clientRequestId = pendingSubmission.clientRequestId },
			data.network,
			v19
		)
		local v21 = {
			analyticsSession = analyticsSession,
			clientRequestId = pendingSubmission.clientRequestId,
			feedItemId = feedItemId,
			sessionId = sessionId,
			ownerGeneration = ownerGeneration,
			cancel = function() end
		}

		v7 = v21
		v21.cancel = observeRequest(v20, function(data2)
			if
				v7 == v21
				and v21.feedItemId == feedItemId
				and v21.sessionId == sessionId
				and v21.ownerGeneration == ownerGeneration
				and isCurrentRequestSession(session, feedItemId, sessionId, ownerGeneration) -- inferred equivalent call
			then
				v7 = nil

				local pendingSubmission2 = collectionStore.getPendingSubmission(feedItemId)

				if pendingSubmission2 == nil or pendingSubmission2.clientRequestId ~= v21.clientRequestId then
					return
				end

				if data2.status == "succeeded" and data2.result ~= nil then
					commentsStore.upsertComments({ data2.result }, ownerGeneration)
					collectionStore.resolvePendingSubmission(feedItemId, data2.result)
					incrementMomentCommentCount(feedItemId, ownerGeneration)

					if FFlagMomentsComments and analyticsSession ~= nil then
						analyticsSession.logEvent(EventNames.MomentCommentPostResult, {
							outcome = "success",
							commentId = data2.result.commentId
						})
					end

					if FFlagMomentsComments then
						local v22 = v16
						v16 = nil

						if v22 ~= nil then
							v22(data2.result.text)
						end
					end
				elseif FFlagMomentsComments then
					local v22 = readStatusCode(data2, statusCode)
					local commentsError = MomentsComments.parseCommentsError(data2.error)
					local errorCode

					if commentsError ~= nil then
						errorCode = commentsError.errorCode
					end

					errorCode = definitePostRejectionCode(v22, errorCode) -- inferred equivalent call

					if flag2 and errorCode ~= nil and (v22 == 429 or commentsError == nil) then
						errorCode = nil
					end

					if v22 == 429 then
						setPostCooldown(v18)
					end

					if analyticsSession ~= nil then
						local logEvent = analyticsSession.logEvent
						local momentCommentPostResult = EventNames.MomentCommentPostResult
						local v23 = {
							outcome = errorCode == nil and "unknown" or "rejected",
							failureReason = 0
						}
						local v24

						if commentsError ~= nil then
							v24 = commentsError.errorCode
						end

						v23.failureReason = getCommentsFailureReason(v24, v22)
						logEvent(momentCommentPostResult, v23)
					end

					if errorCode == nil then
						collectionStore.markPendingOutcomeUnknown(feedItemId)
					else
						collectionStore.rejectPendingSubmission(feedItemId, errorCode)

						if v3[errorCode] then
							markFeedUnavailable(feedItemId, errorCode)
						elseif errorCode == "ViewerNotEligibleToWrite" then
							revokeViewerWrite(feedItemId, ownerGeneration)
						end
					end
				else
					local commentsError = MomentsComments.parseCommentsError(data2.error)

					if
						commentsError == nil
						or commentsError.errorCode ~= "TextFilterRejected" and commentsError.errorCode ~= "RateLimited"
					then
						collectionStore.markPendingOutcomeUnknown(feedItemId)
					else
						collectionStore.rejectPendingSubmission(feedItemId, commentsError.errorCode)

						if FFlagMomentsComments then
							v16 = nil
						end
					end
				end
			end
		end)

		if isCurrentRequestSession(session, feedItemId, sessionId, ownerGeneration) then -- inferred equivalent call
			return true
		end

		if v7 == v21 then
			v7 = nil
		end

		v21.cancel()
		return false
	end

	local function submitComment(p: string, p2: number, p3: string)
		local session = getSession(p, p2) -- inferred equivalent call

		if
			session == nil
			or v7 ~= nil
			or collectionStore.getPendingSubmission(p) ~= nil
			or FFlagMomentsComments and isPostCoolingDown() -- inferred equivalent call
		then
			return false
		end

		local v18 = collectionStore.beginPendingSubmission(p, p3)
		local pendingSubmission = collectionStore.getPendingSubmission(p)

		if pendingSubmission == nil or pendingSubmission.clientRequestId ~= v18 then
			return false
		end

		if FFlagMomentsComments and data.getAnalyticsSession ~= nil then
			v17 = data.getAnalyticsSession(p, p2)
		end

		if FFlagMomentsComments and data.getCommentPostedCallback ~= nil then
			v16 = data.getCommentPostedCallback(p, p2)
		end

		return startPendingPost(session, p, p2, pendingSubmission)
	end

	local function retryPendingSubmission(feedItemId: string, sessionId: number)
		local session = getSession(feedItemId, sessionId) -- inferred equivalent call

		if session == nil or v7 ~= nil then
			return false
		end

		local pendingSubmission = collectionStore.getPendingSubmission(feedItemId)

		if
			pendingSubmission == nil
			or pendingSubmission.status ~= "OutcomeUnknown"
			or FFlagMomentsComments and isPostCoolingDown() -- inferred equivalent call
		then
			return false
		end

		collectionStore.markPendingSending(feedItemId)
		local pendingSubmission2 = collectionStore.getPendingSubmission(feedItemId)

		if pendingSubmission2 == nil or pendingSubmission2.clientRequestId ~= pendingSubmission.clientRequestId then
			return false
		end

		return startPendingPost(session, feedItemId, sessionId, pendingSubmission2, true)
	end

	local function editPendingSubmission(p: string, p2: number): boolean
		if getSession(p, p2) == nil or v7 ~= nil then -- inferred equivalent call
			return false
		end

		local pendingSubmission = collectionStore.getPendingSubmission(p)

		if pendingSubmission == nil or pendingSubmission.status ~= "OutcomeUnknown" then
			return false
		end

		collectionStore.rejectPendingSubmission(p, "SubmissionOutcomeUnknown")
		return true
	end

	local function decrementMomentCommentCount(p: string, p2: number)
		local data2 = commentsStore.getCachedMomentComments(p).data(false)

		if data2 == nil or data2.count == nil or data2.countIsCapped == true or data2.count <= 0 then
			return
		end

		local clone = table.clone(data2)
		clone.count = data2.count - 1
		commentsStore.upsertMomentComments({ [p] = clone }, p2)
	end

	local function removeDeletedComment(p: string, p2: string, ownerGeneration: number)
		if sessionFilters ~= nil then
			sessionFilters.hideCommentForSession(p2)
		end

		local v18 = collectionStore.getState(p)(false)

		if table.find(v18.orderedCommentIds, p2) ~= nil or table.find(v18.stickyPostedCommentIds, p2) ~= nil then
			collectionStore.removeCommentId(p, p2)
		end

		if FFlagMomentsComments then
			cancelReactionRequest(p2)
			cancelIntentExpiry(p2) -- inferred equivalent call
			v11[p2] = nil
			reactionStore.clearComment(p2)
		end

		decrementMomentCommentCount(p, ownerGeneration)
	end

	local function deleteComment2(p: string, p2: string, callback, callback2): boolean
		if flag or v9[p2] ~= nil then
			return false
		end

		local ownerGeneration = commentsStore.getOwnerGeneration(false)
		local v18 = nil

		if FFlagMomentsComments and data.getCommentDeletedCallback ~= nil then
			local v19 = v6

			if v19 ~= nil and v19.feedItemId == p then
				v18 = data.getCommentDeletedCallback(p, v19.sessionId)
			end
		end

		local v19

		if FFlagMomentsCommentActionsRealtime then
			v19 = getOpenAnalyticsSession(p) -- inferred equivalent call
		else
			v19 = nil
		end

		local v20 = deleteComment(p, p2, data.network)

		if FFlagMomentsCommentActionsRealtime and v19 ~= nil then
			v19.logRealtimeEvent("MomentsCommentDelete", { status = "attempted" })
		end

		local v21 = {
			cancel = function() end
		}

		v9[p2] = v21
		v21.cancel = observeRequest(v20, function(p3)
			if v9[p2] ~= v21 then
				return
			end

			v9[p2] = nil

			if flag or commentsStore.getOwnerGeneration(false) ~= ownerGeneration then
				return
			end

			local commentsError = MomentsComments.parseCommentsError(p3.error)
			local v22

			if readStatusCode(p3, nil) == 404 then
				v22 = true
			elseif commentsError == nil then
				v22 = false
			else
				v22 = commentsError.errorCode == "CommentNotFound"
			end

			if FFlagMomentsCommentActionsRealtime and v19 ~= nil then
				if p3.status == "succeeded" then
					v19.logRealtimeEvent("MomentsCommentDelete", { status = "succeeded" })
				elseif v22 then
					v19.logRealtimeEvent("MomentsCommentDelete", { status = "already_deleted" })
				else
					v19.logRealtimeEvent("MomentsCommentDelete", {
						status = "failed",
						failureReason = getCommentsFailureReason(errorCodeFrom(p3), readStatusCode(p3, nil)) -- inferred equivalent call
					})
				end
			end

			if p3.status == "succeeded" or v22 then
				removeDeletedComment(p, p2, ownerGeneration)

				if FFlagMomentsComments and p3.status == "succeeded" and callback2 ~= nil then
					callback2()
				end
			elseif callback ~= nil then
				callback()
			end

			if FFlagMomentsComments and p3.status == "succeeded" and v18 ~= nil then
				v18()
			end
		end)
		return true
	end

	local function cancelActiveDeletes() -- 2 equivalent calls inferred from this helper
		local v18 = v9
		v9 = {}

		for _, v19 in v18 do
			v19.cancel()
		end
	end

	local function cancelActivePost(flag2: boolean)
		local v18 = v7
		v7 = nil

		if v18 == nil then
			return
		end

		if
			FFlagMomentsComments
			and v18.analyticsSession ~= nil
			and v18.ownerGeneration == commentsStore.getOwnerGeneration(false)
		then
			v18.analyticsSession.logEvent(EventNames.MomentCommentPostResult, {
				outcome = "cancelled",
				failureReason = "cancelled"
			})
		end

		v18.cancel()

		if flag2 then
			local pendingSubmission = collectionStore.getPendingSubmission(v18.feedItemId)

			if pendingSubmission ~= nil and pendingSubmission.clientRequestId == v18.clientRequestId then
				collectionStore.markPendingOutcomeUnknown(v18.feedItemId)
			end
		end
	end

	local function retireActiveSession(flag2: boolean) -- 3 equivalent calls inferred from this helper
		if FFlagMomentsComments and not flag2 then
			v16 = nil
		end

		local v18 = v6
		v6 = nil

		if v18 ~= nil then
			cancelActivePage(v18) -- inferred equivalent call
		end

		cancelActivePost(flag2)

		if FFlagMomentsComments and not flag2 then
			v17 = nil
		end
	end

	local function acquireSession(feedItemId: string, sessionId: number)
		if flag then
			return function() end
		end

		if FFlagMomentsComments and catalogStore ~= nil and catalogStore.getAndFetchEmojiSets ~= nil then
			catalogStore.getAndFetchEmojiSets()
		end

		local ownerGeneration = commentsStore.getOwnerGeneration(false)
		local v18 = v6

		if
			v18 == nil
			or v18.feedItemId ~= feedItemId
			or v18.sessionId ~= sessionId
			or v18.ownerGeneration ~= ownerGeneration
		then
			retireActiveSession(v18 ~= nil and v18.feedItemId == feedItemId and v18.ownerGeneration == ownerGeneration) -- inferred equivalent call

			collectionStore.selectFeed(feedItemId, ownerGeneration)
			v18 = {
				feedItemId = feedItemId,
				sessionId = sessionId,
				ownerGeneration = ownerGeneration,
				refCount = 0,
				activePageRequest = nil,
				activePinnedRequest = nil,
				hasRequestedPinnedComment = false,
				requestedCursors = {},
				initialLoadType = "initial"
			}

			v6 = v18
			collectionStore.beginListSession(feedItemId)
		elseif v18.refCount == 0 then
			collectionStore.resetListSession(feedItemId)
		end

		v18.refCount += 1

		local flag2 = false
		return function()
			if flag2 then
				return
			end

			flag2 = true
			local v19 = v6

			if v19 == nil or v19 ~= v18 then
				return
			end

			v19.refCount = math.max(0, v19.refCount - 1)

			if v19.refCount == 0 then
				cancelActivePage(v19) -- inferred equivalent call
			end
		end
	end

	local function ensureInitialLoad(p: string, p2: number)
		if getSession(p, p2) == nil then -- inferred equivalent call
			return false
		end

		local v18 = collectionStore.getState(p)(false)

		if v18.initialLoadStatus == LoadStatus.Idle and v18.loadMoreStatus ~= LoadStatus.Loading then
			return fn2(p, p2, "initial", nil)
		end

		return false
	end

	local function loadMore(p: string, sessionId: number)
		local v18 = collectionStore.getState(p)(false)

		if
			v18.hasMore == true
			and v18.initialLoadStatus ~= LoadStatus.Loading
			and v18.loadMoreStatus ~= LoadStatus.Loading
			and v18.loadMoreStatus ~= LoadStatus.Failed
		then
			return fn2(p, sessionId, "more", v18.nextCursor)
		end

		return false
	end

	local function retryInitial(p: string, p2: number)
		local session = getSession(p, p2) -- inferred equivalent call

		if session == nil then
			return false
		end

		if FFlagMomentsComments and collectionStore.getState(p)(false).initialLoadStatus == LoadStatus.Success then
			session.initialLoadType = "refresh"
		end

		cancelActivePage(session) -- inferred equivalent call
		table.clear(session.requestedCursors)
		collectionStore.resetListSession(p)
		return ensureInitialLoad(p, p2)
	end

	local function retryLoadMore(p: string, p2: number)
		local session = getSession(p, p2) -- inferred equivalent call

		if session == nil then
			return false
		end

		local v18 = collectionStore.getState(p)(false)

		if
			v18.hasMore ~= true
			or v18.initialLoadStatus == LoadStatus.Loading
			or v18.loadMoreStatus == LoadStatus.Loading
		then
			return false
		end

		if v18.nextCursor == nil or session.requestedCursors[cursorKey(v18.nextCursor)] == true then -- inferred equivalent call
			return retryInitial(p, p2)
		end

		return fn2(p, p2, "more", v18.nextCursor)
	end

	local function resolveCommentAuthor(p: string) -- 2 equivalent calls inferred from this helper
		local data2 = commentsStore.getCachedComment(p).data(false)

		if data2 == nil or data2.author == nil then
			return nil
		end

		return data2.author.userId
	end

	local function containsCommentByAuthor(items, p: string): boolean -- 2 equivalent calls inferred from this helper
		for _, item in items do
			if resolveCommentAuthor(item) == p then -- inferred equivalent call
				return true
			end
		end

		return false
	end

	local function hideCommentsByAuthor(p: string, p2: string)
		if flag then
			return
		end

		if sessionFilters ~= nil then
			sessionFilters.markAuthorRecentlyBlocked(p2)
		end

		local v18 = collectionStore.getState(p)(false)

		local v19 = containsCommentByAuthor(v18.orderedCommentIds, p2) -- inferred equivalent call
		local v20

		if v19 then
			collectionStore.removeCommentIdsByAuthor(p, p2, resolveCommentAuthor)

			v20 = v6

			if v20 ~= nil and #collectionStore.getState(p)(false).orderedCommentIds == 0 then
				loadMore(p, v20.sessionId)
			end
		elseif containsCommentByAuthor(v18.stickyPostedCommentIds, p2) then -- inferred equivalent call
			collectionStore.removeCommentIdsByAuthor(p, p2, resolveCommentAuthor)

			v20 = v6

			if v20 ~= nil and #collectionStore.getState(p)(false).orderedCommentIds == 0 then
				loadMore(p, v20.sessionId)
			end
		elseif v18.pinnedCommentId ~= nil and resolveCommentAuthor(v18.pinnedCommentId) == p2 then -- inferred equivalent call
			collectionStore.removeCommentIdsByAuthor(p, p2, resolveCommentAuthor)

			v20 = v6

			if v20 ~= nil and #collectionStore.getState(p)(false).orderedCommentIds == 0 then
				loadMore(p, v20.sessionId)
			end
		end
	end

	local function restoreCommentsByAuthor(p: string, p2: string)
		if flag then
			return
		end

		if sessionFilters ~= nil then
			if not sessionFilters.isAuthorRecentlyBlocked(p2) then
				return
			end

			sessionFilters.unmarkAuthorRecentlyBlocked(p2)
		end

		local v18 = v6

		if v18 ~= nil then
			retryInitial(p, v18.sessionId)
		end
	end

	local effect = Signals.createEffect(function(p)
		local ownerGeneration = commentsStore.getOwnerGeneration(p)

		if ownerGeneration == v15 then
			return
		end

		v15 = ownerGeneration
		retireActiveSession(false) -- inferred equivalent call
		cancelActiveDeletes() -- inferred equivalent call

		if FFlagMomentsComments then
			clearReactionState()
		end

		if FFlagMomentsComments then
			clearPostCooldown() -- inferred equivalent call
		end

		collectionStore.clear()
	end)

	local function dispose()
		if flag then
			return
		end

		flag = true
		effect()
		retireActiveSession(false) -- inferred equivalent call
		cancelActiveDeletes() -- inferred equivalent call

		if FFlagMomentsComments then
			clearReactionState()
		end

		if FFlagMomentsComments then
			clearPostCooldown() -- inferred equivalent call
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

	if not FFlagMomentsComments then
		ensureReactionPresent = rejectReactionMutation
	end

	commentsListCoordinator.ensureReactionPresent = ensureReactionPresent

	if not FFlagMomentsComments then
		ensureReactionAbsent = rejectReactionMutation
	end

	commentsListCoordinator.ensureReactionAbsent = ensureReactionAbsent
	local clearReactionState2

	if FFlagMomentsComments then
		clearReactionState2 = clearReactionState
	else
		clearReactionState2 = noOp
	end

	commentsListCoordinator.clearReactionState = clearReactionState2
	commentsListCoordinator.deleteComment = deleteComment2
	commentsListCoordinator.hideCommentsByAuthor = hideCommentsByAuthor
	commentsListCoordinator.restoreCommentsByAuthor = restoreCommentsByAuthor
	commentsListCoordinator.dispose = dispose
	return commentsListCoordinator
end

return createCommentsListCoordinator
