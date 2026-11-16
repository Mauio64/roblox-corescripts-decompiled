local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local CommentCollectionTypes = require(script.Parent.CommentCollectionTypes)
local mergeCommentPage = require(script.Parent.mergeCommentPage)

local createCommentSessionFiltersStore = require(script.Parent.Parent.GetCommentSessionFiltersStore.createCommentSessionFiltersStore)

local LoadStatus = CommentCollectionTypes.LoadStatus
local pendingSentinel = CommentCollectionTypes.pendingSentinel
local createSignal = Signals.createSignal

local function specialOrderedIds(p, options)
	local result = {}
	local set = {}

	if p ~= nil then
		local v = pendingSentinel(p.clientRequestId)
		table.insert(result, v)
		set[v] = true
	end

	for _, v in options or {} do
		if set[v] then
			continue
		end

		table.insert(result, v)
		set[v] = true
	end

	return result
end

local function defaultState(pendingSubmission, options)
	local v = options or {}
	return {
		orderedCommentIds = specialOrderedIds(pendingSubmission, v),
		channelId = nil,
		nextCursor = nil,
		hasMore = false,
		initialLoadStatus = LoadStatus.Idle,
		loadMoreStatus = LoadStatus.Idle,
		errorCode = nil,
		pendingSubmission = pendingSubmission,
		stickyPostedCommentIds = table.clone(v),
		pinnedCommentId = nil,
		submissionError = nil
	}
end

local function createCommentCollectionStore(options)
	local v = options or {}
	local v2

	if v.sessionFilters == nil then
		v2 = createCommentSessionFiltersStore()
	else
		v2 = v.sessionFilters
	end

	local signal, v3 = createSignal(nil)
	local signal2, set2 = createSignal(defaultState())
	local v4 = { get = signal2, set = set2 }

	local v5 = nil
	local flag = false

	local function requireSelectedSlot(p: string) -- 15 equivalent calls inferred from this helper
		assert(not flag, "Comment collection store is disposed")
		assert(signal(false) == p, "Comment feed must be selected before mutation")
		return v4
	end

	local function clear() -- 1 equivalent call inferred from this helper
		if flag then
			return
		end

		v4.set(defaultState())
		v5 = nil
		v3(nil)
		v2.reset()
	end

	local function currentFilters(filters) -- 1 equivalent call inferred from this helper
		if filters == nil then
			return v2.getFilters(false)
		end

		return filters
	end

	local function pendingSentinelFor(p) -- 2 equivalent calls inferred from this helper
		local pendingSubmission = p.pendingSubmission

		if pendingSubmission == nil then
			return nil
		end

		return pendingSentinel(pendingSubmission.clientRequestId)
	end

	local function applyMerge(p: string, data, replace: boolean, filters)
		local v6 = requireSelectedSlot(p) -- inferred equivalent call
		local v7 = v6.get(false)
		local orderedCommentIdSet = {}

		for _, orderedCommentId in v7.orderedCommentIds do
			orderedCommentIdSet[orderedCommentId] = true
		end

		local commentIdSet = {}

		for _, comment in data.comments do
			commentIdSet[comment.commentId] = true
		end

		local stickyPostedCommentIdSet = {}
		local stickyPostedCommentIds = {}

		for _, stickyPostedCommentId in v7.stickyPostedCommentIds do
			if commentIdSet[stickyPostedCommentId] then
				stickyPostedCommentIdSet[stickyPostedCommentId] = true
			else
				table.insert(stickyPostedCommentIds, stickyPostedCommentId)
			end
		end

		local orderedCommentIds = {}

		for _, orderedCommentId in v7.orderedCommentIds do
			if not stickyPostedCommentIdSet[orderedCommentId] then
				table.insert(orderedCommentIds, orderedCommentId)
			end
		end

		local v8 = {
			existingIds = orderedCommentIds,
			pageComments = data.comments,
			filters = 0,
			replace = 0,
			pendingSentinel = 0,
			stickyPostedCommentIds = 0,
			pinnedCommentId = 0,
			visibleIdsBeforeReconciliation = 0,
			hasMore = 0
		}
		filters = currentFilters(filters) -- inferred equivalent call
		v8.filters = filters
		v8.replace = replace
		v8.pendingSentinel = pendingSentinelFor(v7) -- inferred equivalent call
		v8.stickyPostedCommentIds = stickyPostedCommentIds
		v8.pinnedCommentId = v7.pinnedCommentId
		v8.visibleIdsBeforeReconciliation = orderedCommentIdSet
		v8.hasMore = data.hasMore
		local v9 = mergeCommentPage(v8)

		local set = v6.set
		local v10 = {
			orderedCommentIds = v9.orderedCommentIds,
			channelId = data.channelId or v7.channelId,
			nextCursor = data.nextCursor,
			hasMore = data.hasMore,
			initialLoadStatus = 0,
			loadMoreStatus = 0,
			errorCode = nil,
			pendingSubmission = 0,
			stickyPostedCommentIds = 0,
			pinnedCommentId = 0,
			submissionError = 0
		}
		local initialLoadStatus

		if replace then
			initialLoadStatus = LoadStatus.Success
		else
			initialLoadStatus = v7.initialLoadStatus
		end

		v10.initialLoadStatus = initialLoadStatus
		local loadMoreStatus

		if replace then
			loadMoreStatus = LoadStatus.Idle
		else
			loadMoreStatus = LoadStatus.Success
		end

		v10.loadMoreStatus = loadMoreStatus

		v10.pendingSubmission = v7.pendingSubmission
		v10.stickyPostedCommentIds = stickyPostedCommentIds
		v10.pinnedCommentId = v7.pinnedCommentId
		v10.submissionError = v7.submissionError
		set(v10)

		return v9
	end

	local function dropId(orderedCommentIds, p: string) -- 1 equivalent call inferred from this helper
		local result = {}

		for _, item in orderedCommentIds do
			if item ~= p then
				table.insert(result, item)
			end
		end

		return result
	end

	local function replaceId(orderedCommentIds, p: string, commentId: string)
		local set = {}
		local result = {}
		local v6 = false

		for _, item in orderedCommentIds do
			local v7 = if item == p then commentId else item

			if set[v7] then
				continue
			end

			table.insert(result, v7)
			set[v7] = true

			if item == p then
				v6 = true
			end
		end

		if not (v6 or set[commentId]) then
			table.insert(result, 1, commentId)
		end

		return result
	end

	local function moveToFront(stickyPostedCommentIds, commentId: string) -- 1 equivalent call inferred from this helper
		local result = { commentId }

		for _, item in stickyPostedCommentIds do
			if item ~= commentId then
				table.insert(result, item)
			end
		end

		return result
	end

	return {
		getState = function(p: string)
			return function(p2)
				if signal(p2) == p then
					return v4.get(p2)
				end

				return defaultState()
			end
		end,
		selectFeed = function(p: string, p2: number)
			assert(not flag, "Comment collection store is disposed")

			if signal(false) == p and v5 == p2 then
				return
			end

			v4.set(defaultState())
			v5 = p2
			v3(p)
			v2.reset()
		end,
		clear = clear,
		dispose = function()
			if flag then
				return
			end

			clear() -- inferred equivalent call
			flag = true
		end,
		beginListSession = function(p: string)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			v6.set(defaultState(v7.pendingSubmission, v7.stickyPostedCommentIds))
		end,
		resetListSession = function(p: string)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			v6.set({
				orderedCommentIds = specialOrderedIds(v7.pendingSubmission, v7.stickyPostedCommentIds),
				channelId = nil,
				nextCursor = nil,
				hasMore = false,
				initialLoadStatus = LoadStatus.Idle,
				loadMoreStatus = LoadStatus.Idle,
				errorCode = nil,
				pendingSubmission = v7.pendingSubmission,
				stickyPostedCommentIds = v7.stickyPostedCommentIds,
				pinnedCommentId = v7.pinnedCommentId,
				submissionError = v7.submissionError
			})
		end,
		beginInitialLoad = function(p: string)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			v6.set({
				orderedCommentIds = v7.orderedCommentIds,
				channelId = v7.channelId,
				nextCursor = v7.nextCursor,
				hasMore = v7.hasMore,
				initialLoadStatus = LoadStatus.Loading,
				loadMoreStatus = v7.loadMoreStatus,
				errorCode = nil,
				pendingSubmission = v7.pendingSubmission,
				stickyPostedCommentIds = v7.stickyPostedCommentIds,
				pinnedCommentId = v7.pinnedCommentId,
				submissionError = v7.submissionError
			})
		end,
		completeInitialLoad = function(p: string, p2, p3)
			return applyMerge(p, p2, true, p3)
		end,
		beginLoadMore = function(p: string)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			v6.set({
				orderedCommentIds = v7.orderedCommentIds,
				channelId = v7.channelId,
				nextCursor = v7.nextCursor,
				hasMore = v7.hasMore,
				initialLoadStatus = v7.initialLoadStatus,
				loadMoreStatus = LoadStatus.Loading,
				errorCode = v7.errorCode,
				pendingSubmission = v7.pendingSubmission,
				stickyPostedCommentIds = v7.stickyPostedCommentIds,
				pinnedCommentId = v7.pinnedCommentId,
				submissionError = v7.submissionError
			})
		end,
		completeLoadMore = function(p: string, p2, p3)
			return applyMerge(p, p2, false, p3)
		end,
		failLoad = function(p: string, p2: string, errorCode: string)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			local set = v6.set
			local v8 = {
				orderedCommentIds = v7.orderedCommentIds,
				channelId = v7.channelId,
				nextCursor = v7.nextCursor,
				hasMore = v7.hasMore,
				initialLoadStatus = 0,
				loadMoreStatus = 0,
				errorCode = 0,
				pendingSubmission = 0,
				stickyPostedCommentIds = 0,
				pinnedCommentId = 0,
				submissionError = 0
			}
			local initialLoadStatus

			if p2 == "initial" then
				initialLoadStatus = LoadStatus.Failed
			else
				initialLoadStatus = v7.initialLoadStatus
			end

			v8.initialLoadStatus = initialLoadStatus
			local loadMoreStatus

			if p2 == "more" then
				loadMoreStatus = LoadStatus.Failed
			else
				loadMoreStatus = v7.loadMoreStatus
			end

			v8.loadMoreStatus = loadMoreStatus
			v8.errorCode = errorCode
			v8.pendingSubmission = v7.pendingSubmission
			v8.stickyPostedCommentIds = v7.stickyPostedCommentIds
			v8.pinnedCommentId = v7.pinnedCommentId
			v8.submissionError = v7.submissionError
			set(v8)
		end,
		beginPendingSubmission = function(p: string, text: string)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			local pendingSubmission = v7.pendingSubmission

			if pendingSubmission == nil or pendingSubmission.text ~= text then
				local guid = HttpService:GenerateGUID(false)
				local v8 = pendingSentinel(guid)
				local orderedCommentIds2

				if pendingSubmission == nil then
					orderedCommentIds2 = table.clone(v7.orderedCommentIds)
				else
					local orderedCommentIds = v7.orderedCommentIds
					local v9 = pendingSentinel(pendingSubmission.clientRequestId)
					orderedCommentIds2 = {}

					for _, orderedCommentId in orderedCommentIds do
						if orderedCommentId ~= v9 then
							table.insert(orderedCommentIds2, orderedCommentId)
						end
					end
				end

				table.insert(orderedCommentIds2, 1, v8)
				v6.set({
					orderedCommentIds = orderedCommentIds2,
					channelId = v7.channelId,
					nextCursor = v7.nextCursor,
					hasMore = v7.hasMore,
					initialLoadStatus = v7.initialLoadStatus,
					loadMoreStatus = v7.loadMoreStatus,
					errorCode = v7.errorCode,
					pendingSubmission = { clientRequestId = guid, text = text, status = "Sending" },
					stickyPostedCommentIds = v7.stickyPostedCommentIds,
					pinnedCommentId = v7.pinnedCommentId,
					submissionError = nil
				})

				return guid
			end

			if v7.submissionError ~= nil then
				v6.set({
					orderedCommentIds = v7.orderedCommentIds,
					channelId = v7.channelId,
					nextCursor = v7.nextCursor,
					hasMore = v7.hasMore,
					initialLoadStatus = v7.initialLoadStatus,
					loadMoreStatus = v7.loadMoreStatus,
					errorCode = v7.errorCode,
					pendingSubmission = pendingSubmission,
					stickyPostedCommentIds = v7.stickyPostedCommentIds,
					pinnedCommentId = v7.pinnedCommentId,
					submissionError = nil
				})
			end

			return pendingSubmission.clientRequestId
		end,
		markPendingSending = function(p: string)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			local pendingSubmission = v7.pendingSubmission

			if pendingSubmission == nil then
				return
			end

			v6.set({
				orderedCommentIds = v7.orderedCommentIds,
				channelId = v7.channelId,
				nextCursor = v7.nextCursor,
				hasMore = v7.hasMore,
				initialLoadStatus = v7.initialLoadStatus,
				loadMoreStatus = v7.loadMoreStatus,
				errorCode = v7.errorCode,
				pendingSubmission = {
					clientRequestId = pendingSubmission.clientRequestId,
					text = pendingSubmission.text,
					status = "Sending"
				},
				stickyPostedCommentIds = v7.stickyPostedCommentIds,
				pinnedCommentId = v7.pinnedCommentId,
				submissionError = v7.submissionError
			})
		end,
		markPendingOutcomeUnknown = function(p: string)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			local pendingSubmission = v7.pendingSubmission

			if pendingSubmission == nil then
				return
			end

			v6.set({
				orderedCommentIds = v7.orderedCommentIds,
				channelId = v7.channelId,
				nextCursor = v7.nextCursor,
				hasMore = v7.hasMore,
				initialLoadStatus = v7.initialLoadStatus,
				loadMoreStatus = v7.loadMoreStatus,
				errorCode = v7.errorCode,
				pendingSubmission = {
					clientRequestId = pendingSubmission.clientRequestId,
					text = pendingSubmission.text,
					status = "OutcomeUnknown"
				},
				stickyPostedCommentIds = v7.stickyPostedCommentIds,
				pinnedCommentId = v7.pinnedCommentId,
				submissionError = v7.submissionError
			})
		end,
		resolvePendingSubmission = function(p: string, p2)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			local pendingSubmission = v7.pendingSubmission

			if pendingSubmission == nil then
				return
			end

			local v8 = pendingSentinel(pendingSubmission.clientRequestId)
			v6.set({
				orderedCommentIds = replaceId(v7.orderedCommentIds, v8, p2.commentId),
				channelId = v7.channelId,
				nextCursor = v7.nextCursor,
				hasMore = v7.hasMore,
				initialLoadStatus = v7.initialLoadStatus,
				loadMoreStatus = v7.loadMoreStatus,
				errorCode = v7.errorCode,
				pendingSubmission = nil,
				stickyPostedCommentIds = moveToFront(v7.stickyPostedCommentIds, p2.commentId), -- inferred equivalent call
				pinnedCommentId = v7.pinnedCommentId,
				submissionError = nil
			})
		end,
		rejectPendingSubmission = function(p: string, errorCode: string?)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			local pendingSubmission = v7.pendingSubmission

			if pendingSubmission == nil then
				return
			end

			local submissionError = errorCode ~= nil and {
				errorCode = errorCode,
				text = pendingSubmission.text
			} or nil

			v6.set({
				orderedCommentIds = dropId(v7.orderedCommentIds, pendingSentinel(pendingSubmission.clientRequestId)), -- inferred equivalent call
				channelId = v7.channelId,
				nextCursor = v7.nextCursor,
				hasMore = v7.hasMore,
				initialLoadStatus = v7.initialLoadStatus,
				loadMoreStatus = v7.loadMoreStatus,
				errorCode = v7.errorCode,
				pendingSubmission = nil,
				stickyPostedCommentIds = v7.stickyPostedCommentIds,
				pinnedCommentId = v7.pinnedCommentId,
				submissionError = submissionError
			})
		end,
		clearSubmissionError = function(p: string)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)

			if v7.submissionError == nil then
				return
			end

			v6.set({
				orderedCommentIds = v7.orderedCommentIds,
				channelId = v7.channelId,
				nextCursor = v7.nextCursor,
				hasMore = v7.hasMore,
				initialLoadStatus = v7.initialLoadStatus,
				loadMoreStatus = v7.loadMoreStatus,
				errorCode = v7.errorCode,
				pendingSubmission = v7.pendingSubmission,
				stickyPostedCommentIds = v7.stickyPostedCommentIds,
				pinnedCommentId = v7.pinnedCommentId,
				submissionError = nil
			})
		end,
		getPendingSubmission = function(p: string)
			if signal(false) == p then
				return v4.get(false).pendingSubmission
			end

			return nil
		end,
		removeCommentId = function(p: string, p2: string)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			local set = v6.set
			local orderedCommentIds = {}

			local v8 = {
				orderedCommentIds = 0,
				channelId = 0,
				nextCursor = 0,
				hasMore = 0,
				initialLoadStatus = 0,
				loadMoreStatus = 0,
				errorCode = 0,
				pendingSubmission = 0,
				stickyPostedCommentIds = 0,
				pinnedCommentId = 0,
				submissionError = 0
			}

			for _, orderedCommentId in v7.orderedCommentIds do
				if orderedCommentId ~= p2 then
					table.insert(orderedCommentIds, orderedCommentId)
				end
			end

			v8.orderedCommentIds = orderedCommentIds
			v8.channelId = v7.channelId
			v8.nextCursor = v7.nextCursor
			v8.hasMore = v7.hasMore
			v8.initialLoadStatus = v7.initialLoadStatus
			v8.loadMoreStatus = v7.loadMoreStatus
			v8.errorCode = v7.errorCode
			v8.pendingSubmission = v7.pendingSubmission
			local stickyPostedCommentIds = {}

			for _, stickyPostedCommentId in v7.stickyPostedCommentIds do
				if stickyPostedCommentId ~= p2 then
					table.insert(stickyPostedCommentIds, stickyPostedCommentId)
				end
			end

			v8.stickyPostedCommentIds = stickyPostedCommentIds
			local pinnedCommentId

			if v7.pinnedCommentId ~= p2 then
				pinnedCommentId = v7.pinnedCommentId
			end

			v8.pinnedCommentId = pinnedCommentId
			v8.submissionError = v7.submissionError
			set(v8)
		end,
		removeCommentIdsByAuthor = function(p: string, p2: string, callback)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			local orderedCommentIds = {}

			for _, orderedCommentId in v7.orderedCommentIds do
				if callback(orderedCommentId) ~= p2 then
					table.insert(orderedCommentIds, orderedCommentId)
				end
			end

			local stickyPostedCommentIds = {}

			for _, stickyPostedCommentId in v7.stickyPostedCommentIds do
				if callback(stickyPostedCommentId) ~= p2 then
					table.insert(stickyPostedCommentIds, stickyPostedCommentId)
				end
			end

			local set = v6.set
			local v8 = {
				orderedCommentIds = orderedCommentIds,
				channelId = v7.channelId,
				nextCursor = v7.nextCursor,
				hasMore = v7.hasMore,
				initialLoadStatus = v7.initialLoadStatus,
				loadMoreStatus = v7.loadMoreStatus,
				errorCode = v7.errorCode,
				pendingSubmission = v7.pendingSubmission,
				stickyPostedCommentIds = stickyPostedCommentIds,
				pinnedCommentId = 0,
				submissionError = 0
			}
			local pinnedCommentId

			if v7.pinnedCommentId == nil or callback(v7.pinnedCommentId) ~= p2 then
				pinnedCommentId = v7.pinnedCommentId
			end

			v8.pinnedCommentId = pinnedCommentId

			v8.submissionError = v7.submissionError
			set(v8)
		end,
		setPinnedComment = function(p: string, pinnedCommentId: string)
			local v6 = requireSelectedSlot(p) -- inferred equivalent call
			local v7 = v6.get(false)
			local orderedCommentIds = v7.orderedCommentIds

			if v7.initialLoadStatus == LoadStatus.Success then
				local set = {}
				local v8 = pendingSentinelFor(v7) -- inferred equivalent call

				if v8 ~= nil then
					set[v8] = true
				end

				for _, stickyPostedCommentId in v7.stickyPostedCommentIds do
					set[stickyPostedCommentId] = true
				end

				local v9 = false
				orderedCommentIds = {}

				for _, orderedCommentId in v7.orderedCommentIds do
					if not (v9 or set[orderedCommentId]) then
						table.insert(orderedCommentIds, pinnedCommentId)
						v9 = true
					end

					if orderedCommentId ~= pinnedCommentId then
						table.insert(orderedCommentIds, orderedCommentId)
					end
				end

				if not v9 then
					table.insert(orderedCommentIds, pinnedCommentId)
				end
			end

			v6.set({
				orderedCommentIds = orderedCommentIds,
				channelId = v7.channelId,
				nextCursor = v7.nextCursor,
				hasMore = v7.hasMore,
				initialLoadStatus = v7.initialLoadStatus,
				loadMoreStatus = v7.loadMoreStatus,
				errorCode = v7.errorCode,
				pendingSubmission = v7.pendingSubmission,
				stickyPostedCommentIds = v7.stickyPostedCommentIds,
				pinnedCommentId = pinnedCommentId,
				submissionError = v7.submissionError
			})
		end
	}
end

return createCommentCollectionStore
