local HttpService = game:GetService("HttpService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local CommentCollectionTypes = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore/CommentCollectionTypes")
local mergeCommentPage = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore/mergeCommentPage")

local createCommentSessionFiltersStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentSessionFiltersStore/createCommentSessionFiltersStore")

local loadStatus = CommentCollectionTypes.LoadStatus
local pendingSentinel = CommentCollectionTypes.pendingSentinel
local createSignal = Signals.createSignal

local function specialOrderedIds(p2, options)
	local result = {}
	local set = {}

	if p2 ~= nil then
		local v6 = pendingSentinel(p2.clientRequestId)
		table.insert(result, v6)
		set[v6] = true
	end

	for k, v6 in options or {} do
		if set[v6] then
			continue
		end

		table.insert(result, v6)
		set[v6] = true
	end

	return result
end

local function defaultState(p2, options)
	local v5 = options or {}
	return {
		orderedCommentIds = specialOrderedIds(p2, v5),
		channelId = nil,
		nextCursor = nil,
		hasMore = false,
		initialLoadStatus = loadStatus.Idle,
		loadMoreStatus = loadStatus.Idle,
		errorCode = nil,
		pendingSubmission = p2,
		stickyPostedCommentIds = table.clone(v5),
		pinnedCommentId = nil,
		submissionError = nil
	}
end

local function createCommentCollectionStore(options)
	local v5 = options or {}
	local v6 = if v5.sessionFilters == nil then createCommentSessionFiltersStore() else v5.sessionFilters

	local signal, v7 = createSignal(nil)
	local signal2, v8 = createSignal(defaultState())
	local v9 = { get = signal2, set = v8 }

	local v10 = nil
	local flag = false

	local function requireSelectedSlot(p2)
		assert(not flag, "Comment collection store is disposed")
		assert(signal(false) == p2, "Comment feed must be selected before mutation")
		return v9
	end

	local function currentFilters(p2)
		if p2 == nil then
			return v6.getFilters(false)
		end

		return p2
	end

	local function pendingSentinelFor(p2)
		local pendingSubmission = p2.pendingSubmission

		if pendingSubmission == nil then
			return nil
		end

		return pendingSentinel(pendingSubmission.clientRequestId)
	end

	local function applyMerge(p2, data, replace, filters)
		assert(not flag, "Comment collection store is disposed")
		assert(signal(false) == p2, "Comment feed must be selected before mutation")
		local v11 = v9

		local v12 = v11.get(false)
		local orderedCommentIdSet = {}

		for k, orderedCommentId in v12.orderedCommentIds do
			orderedCommentIdSet[orderedCommentId] = true
		end

		local commentIdSet = {}

		for k, comment in data.comments do
			commentIdSet[comment.commentId] = true
		end

		local stickyPostedCommentIdSet = {}
		local stickyPostedCommentIds = {}

		for k, stickyPostedCommentId in v12.stickyPostedCommentIds do
			if commentIdSet[stickyPostedCommentId] then
				stickyPostedCommentIdSet[stickyPostedCommentId] = true
			else
				table.insert(stickyPostedCommentIds, stickyPostedCommentId)
			end
		end

		local orderedCommentIds = {}

		for k, orderedCommentId in v12.orderedCommentIds do
			if not stickyPostedCommentIdSet[orderedCommentId] then
				table.insert(orderedCommentIds, orderedCommentId)
			end
		end

		local v14 = {
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

		if filters == nil then
			filters = v6.getFilters(false)
		end

		v14.filters = filters
		v14.replace = replace
		local pendingSubmission = v12.pendingSubmission

		local v15 = if pendingSubmission ~= nil then pendingSentinel(pendingSubmission.clientRequestId) else nil

		v14.pendingSentinel = v15
		v14.stickyPostedCommentIds = stickyPostedCommentIds
		v14.pinnedCommentId = v12.pinnedCommentId
		v14.visibleIdsBeforeReconciliation = orderedCommentIdSet
		v14.hasMore = data.hasMore
		local v16 = mergeCommentPage(v14)

		local set = v11.set
		local v17 = {
			orderedCommentIds = v16.orderedCommentIds,
			channelId = data.channelId or v12.channelId,
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
		local v18 = if replace then loadStatus.Success else v12.initialLoadStatus
		v17.initialLoadStatus = v18
		local v19 = if replace then loadStatus.Idle else loadStatus.Success
		v17.loadMoreStatus = v19

		v17.pendingSubmission = v12.pendingSubmission
		v17.stickyPostedCommentIds = stickyPostedCommentIds
		v17.pinnedCommentId = v12.pinnedCommentId
		v17.submissionError = v12.submissionError
		set(v17)

		return v16
	end

	local function dropId(items, p2)
		local result = {}

		for k, item in items do
			if item ~= p2 then
				table.insert(result, item)
			end
		end

		return result
	end

	local function replaceId(orderedCommentIds, p2, commentId)
		local set = {}
		local result = {}
		local v11 = false

		for k, item in orderedCommentIds do
			local v12 = if item == p2 then commentId else item

			if set[v12] then
				continue
			end

			table.insert(result, v12)
			set[v12] = true

			if item == p2 then
				v11 = true
			end
		end

		if not (v11 or set[commentId]) then
			table.insert(result, 1, commentId)
		end

		return result
	end

	local function moveToFront(items, p2)
		local result = { p2 }

		for k, item in items do
			if item ~= p2 then
				table.insert(result, item)
			end
		end

		return result
	end

	return {
		getState = function(p2)
			return function(p3)
				if signal(p3) == p2 then
					return v9.get(p3)
				end

				return defaultState()
			end
		end,
		selectFeed = function(p2, p3)
			assert(not flag, "Comment collection store is disposed")

			if signal(false) == p2 and v10 == p3 then
				return
			end

			v9.set(defaultState())
			v10 = p3
			v7(p2)
			v6.reset()
		end,
		clear = function()
			if flag then
				return
			end

			v9.set(defaultState())
			v10 = nil
			v7(nil)
			v6.reset()
		end,
		dispose = function()
			if flag then
				return
			end

			if not flag then
				v9.set(defaultState())
				v10 = nil
				v7(nil)
				v6.reset()
			end

			flag = true
		end,
		beginListSession = function(p2)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			v11.set(defaultState(v12.pendingSubmission, v12.stickyPostedCommentIds))
		end,
		resetListSession = function(p2)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			v11.set({
				orderedCommentIds = specialOrderedIds(v12.pendingSubmission, v12.stickyPostedCommentIds),
				channelId = nil,
				nextCursor = nil,
				hasMore = false,
				initialLoadStatus = loadStatus.Idle,
				loadMoreStatus = loadStatus.Idle,
				errorCode = nil,
				pendingSubmission = v12.pendingSubmission,
				stickyPostedCommentIds = v12.stickyPostedCommentIds,
				pinnedCommentId = v12.pinnedCommentId,
				submissionError = v12.submissionError
			})
		end,
		beginInitialLoad = function(p2)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			v11.set({
				orderedCommentIds = v12.orderedCommentIds,
				channelId = v12.channelId,
				nextCursor = v12.nextCursor,
				hasMore = v12.hasMore,
				initialLoadStatus = loadStatus.Loading,
				loadMoreStatus = v12.loadMoreStatus,
				errorCode = nil,
				pendingSubmission = v12.pendingSubmission,
				stickyPostedCommentIds = v12.stickyPostedCommentIds,
				pinnedCommentId = v12.pinnedCommentId,
				submissionError = v12.submissionError
			})
		end,
		completeInitialLoad = function(p2, p3, p4)
			return applyMerge(p2, p3, true, p4)
		end,
		beginLoadMore = function(p2)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			v11.set({
				orderedCommentIds = v12.orderedCommentIds,
				channelId = v12.channelId,
				nextCursor = v12.nextCursor,
				hasMore = v12.hasMore,
				initialLoadStatus = v12.initialLoadStatus,
				loadMoreStatus = loadStatus.Loading,
				errorCode = v12.errorCode,
				pendingSubmission = v12.pendingSubmission,
				stickyPostedCommentIds = v12.stickyPostedCommentIds,
				pinnedCommentId = v12.pinnedCommentId,
				submissionError = v12.submissionError
			})
		end,
		completeLoadMore = function(p2, p3, p4)
			return applyMerge(p2, p3, false, p4)
		end,
		failLoad = function(p2, p3, errorCode)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			local set = v11.set
			local v13 = {
				orderedCommentIds = v12.orderedCommentIds,
				channelId = v12.channelId,
				nextCursor = v12.nextCursor,
				hasMore = v12.hasMore,
				initialLoadStatus = 0,
				loadMoreStatus = 0,
				errorCode = 0,
				pendingSubmission = 0,
				stickyPostedCommentIds = 0,
				pinnedCommentId = 0,
				submissionError = 0
			}
			local v14 = if p3 == "initial" then loadStatus.Failed else v12.initialLoadStatus
			v13.initialLoadStatus = v14
			local v15 = if p3 == "more" then loadStatus.Failed else v12.loadMoreStatus
			v13.loadMoreStatus = v15
			v13.errorCode = errorCode
			v13.pendingSubmission = v12.pendingSubmission
			v13.stickyPostedCommentIds = v12.stickyPostedCommentIds
			v13.pinnedCommentId = v12.pinnedCommentId
			v13.submissionError = v12.submissionError
			set(v13)
		end,
		beginPendingSubmission = function(p2, p3)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			local pendingSubmission = v12.pendingSubmission

			if pendingSubmission == nil or pendingSubmission.text ~= p3 then
				local guid = HttpService:GenerateGUID(false)
				local v13 = pendingSentinel(guid)
				local v14

				if pendingSubmission == nil then
					v14 = table.clone(v12.orderedCommentIds)
				else
					local orderedCommentIds = v12.orderedCommentIds
					local v15 = pendingSentinel(pendingSubmission.clientRequestId)
					v14 = {}

					for k, orderedCommentId in orderedCommentIds do
						if orderedCommentId ~= v15 then
							table.insert(v14, orderedCommentId)
						end
					end
				end

				table.insert(v14, 1, v13)
				v11.set({
					orderedCommentIds = v14,
					channelId = v12.channelId,
					nextCursor = v12.nextCursor,
					hasMore = v12.hasMore,
					initialLoadStatus = v12.initialLoadStatus,
					loadMoreStatus = v12.loadMoreStatus,
					errorCode = v12.errorCode,
					pendingSubmission = {
						clientRequestId = guid,
						text = p3,
						status = "Sending"
					},
					stickyPostedCommentIds = v12.stickyPostedCommentIds,
					pinnedCommentId = v12.pinnedCommentId,
					submissionError = nil
				})

				return guid
			end

			if v12.submissionError ~= nil then
				v11.set({
					orderedCommentIds = v12.orderedCommentIds,
					channelId = v12.channelId,
					nextCursor = v12.nextCursor,
					hasMore = v12.hasMore,
					initialLoadStatus = v12.initialLoadStatus,
					loadMoreStatus = v12.loadMoreStatus,
					errorCode = v12.errorCode,
					pendingSubmission = pendingSubmission,
					stickyPostedCommentIds = v12.stickyPostedCommentIds,
					pinnedCommentId = v12.pinnedCommentId,
					submissionError = nil
				})
			end

			return pendingSubmission.clientRequestId
		end,
		markPendingSending = function(p2)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			local pendingSubmission = v12.pendingSubmission

			if pendingSubmission == nil then
				return
			end

			v11.set({
				orderedCommentIds = v12.orderedCommentIds,
				channelId = v12.channelId,
				nextCursor = v12.nextCursor,
				hasMore = v12.hasMore,
				initialLoadStatus = v12.initialLoadStatus,
				loadMoreStatus = v12.loadMoreStatus,
				errorCode = v12.errorCode,
				pendingSubmission = {
					clientRequestId = pendingSubmission.clientRequestId,
					text = pendingSubmission.text,
					status = "Sending"
				},
				stickyPostedCommentIds = v12.stickyPostedCommentIds,
				pinnedCommentId = v12.pinnedCommentId,
				submissionError = v12.submissionError
			})
		end,
		markPendingOutcomeUnknown = function(p2)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			local pendingSubmission = v12.pendingSubmission

			if pendingSubmission == nil then
				return
			end

			v11.set({
				orderedCommentIds = v12.orderedCommentIds,
				channelId = v12.channelId,
				nextCursor = v12.nextCursor,
				hasMore = v12.hasMore,
				initialLoadStatus = v12.initialLoadStatus,
				loadMoreStatus = v12.loadMoreStatus,
				errorCode = v12.errorCode,
				pendingSubmission = {
					clientRequestId = pendingSubmission.clientRequestId,
					text = pendingSubmission.text,
					status = "OutcomeUnknown"
				},
				stickyPostedCommentIds = v12.stickyPostedCommentIds,
				pinnedCommentId = v12.pinnedCommentId,
				submissionError = v12.submissionError
			})
		end,
		resolvePendingSubmission = function(p2, p3)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			local pendingSubmission = v12.pendingSubmission

			if pendingSubmission == nil then
				return
			end

			local v13 = pendingSentinel(pendingSubmission.clientRequestId)
			local set = v11.set
			local v14 = {
				orderedCommentIds = replaceId(v12.orderedCommentIds, v13, p3.commentId),
				channelId = v12.channelId,
				nextCursor = v12.nextCursor,
				hasMore = v12.hasMore,
				initialLoadStatus = v12.initialLoadStatus,
				loadMoreStatus = v12.loadMoreStatus,
				errorCode = v12.errorCode,
				pendingSubmission = nil,
				stickyPostedCommentIds = 0,
				pinnedCommentId = 0,
				submissionError = nil
			}

			local stickyPostedCommentIds = v12.stickyPostedCommentIds
			local commentId = p3.commentId
			local stickyPostedCommentIds2 = { commentId }

			for k, stickyPostedCommentId in stickyPostedCommentIds do
				if stickyPostedCommentId ~= commentId then
					table.insert(stickyPostedCommentIds2, stickyPostedCommentId)
				end
			end

			v14.stickyPostedCommentIds = stickyPostedCommentIds2
			v14.pinnedCommentId = v12.pinnedCommentId
			set(v14)
		end,
		rejectPendingSubmission = function(p2, p3)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			local pendingSubmission = v12.pendingSubmission

			if pendingSubmission == nil then
				return
			end

			local v13 = p3 ~= nil and { errorCode = p3, text = pendingSubmission.text } or nil

			local set = v11.set
			local orderedCommentIds = v12.orderedCommentIds
			local v14 = pendingSentinel(pendingSubmission.clientRequestId)
			local orderedCommentIds2 = {}

			local v15 = {
				orderedCommentIds = 0,
				channelId = 0,
				nextCursor = 0,
				hasMore = 0,
				initialLoadStatus = 0,
				loadMoreStatus = 0,
				errorCode = 0,
				pendingSubmission = nil,
				stickyPostedCommentIds = 0,
				pinnedCommentId = 0,
				submissionError = 0
			}

			for k, orderedCommentId in orderedCommentIds do
				if orderedCommentId ~= v14 then
					table.insert(orderedCommentIds2, orderedCommentId)
				end
			end

			v15.orderedCommentIds = orderedCommentIds2
			v15.channelId = v12.channelId
			v15.nextCursor = v12.nextCursor
			v15.hasMore = v12.hasMore
			v15.initialLoadStatus = v12.initialLoadStatus
			v15.loadMoreStatus = v12.loadMoreStatus
			v15.errorCode = v12.errorCode

			v15.stickyPostedCommentIds = v12.stickyPostedCommentIds
			v15.pinnedCommentId = v12.pinnedCommentId
			v15.submissionError = v13
			set(v15)
		end,
		clearSubmissionError = function(p2)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)

			if v12.submissionError == nil then
				return
			end

			v11.set({
				orderedCommentIds = v12.orderedCommentIds,
				channelId = v12.channelId,
				nextCursor = v12.nextCursor,
				hasMore = v12.hasMore,
				initialLoadStatus = v12.initialLoadStatus,
				loadMoreStatus = v12.loadMoreStatus,
				errorCode = v12.errorCode,
				pendingSubmission = v12.pendingSubmission,
				stickyPostedCommentIds = v12.stickyPostedCommentIds,
				pinnedCommentId = v12.pinnedCommentId,
				submissionError = nil
			})
		end,
		getPendingSubmission = function(p2)
			if signal(false) == p2 then
				return v9.get(false).pendingSubmission
			end

			return nil
		end,
		removeCommentId = function(p2, p3)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			local set = v11.set
			local orderedCommentIds = {}

			local v13 = {
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

			for k, orderedCommentId in v12.orderedCommentIds do
				if orderedCommentId ~= p3 then
					table.insert(orderedCommentIds, orderedCommentId)
				end
			end

			v13.orderedCommentIds = orderedCommentIds
			v13.channelId = v12.channelId
			v13.nextCursor = v12.nextCursor
			v13.hasMore = v12.hasMore
			v13.initialLoadStatus = v12.initialLoadStatus
			v13.loadMoreStatus = v12.loadMoreStatus
			v13.errorCode = v12.errorCode
			v13.pendingSubmission = v12.pendingSubmission
			local stickyPostedCommentIds = {}

			for k, stickyPostedCommentId in v12.stickyPostedCommentIds do
				if stickyPostedCommentId ~= p3 then
					table.insert(stickyPostedCommentIds, stickyPostedCommentId)
				end
			end

			v13.stickyPostedCommentIds = stickyPostedCommentIds
			local v14 = if v12.pinnedCommentId ~= p3 then v12.pinnedCommentId else nil
			v13.pinnedCommentId = v14
			v13.submissionError = v12.submissionError
			set(v13)
		end,
		removeCommentIdsByAuthor = function(p2, p3, callback)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			local orderedCommentIds = {}

			for k, orderedCommentId in v12.orderedCommentIds do
				if callback(orderedCommentId) ~= p3 then
					table.insert(orderedCommentIds, orderedCommentId)
				end
			end

			local stickyPostedCommentIds = {}

			for k, stickyPostedCommentId in v12.stickyPostedCommentIds do
				if callback(stickyPostedCommentId) ~= p3 then
					table.insert(stickyPostedCommentIds, stickyPostedCommentId)
				end
			end

			local set = v11.set
			local v13 = {
				orderedCommentIds = orderedCommentIds,
				channelId = v12.channelId,
				nextCursor = v12.nextCursor,
				hasMore = v12.hasMore,
				initialLoadStatus = v12.initialLoadStatus,
				loadMoreStatus = v12.loadMoreStatus,
				errorCode = v12.errorCode,
				pendingSubmission = v12.pendingSubmission,
				stickyPostedCommentIds = stickyPostedCommentIds,
				pinnedCommentId = 0,
				submissionError = 0
			}

			local v14 = if v12.pinnedCommentId == nil or callback(v12.pinnedCommentId) ~= p3 then v12.pinnedCommentId else nil
			v13.pinnedCommentId = v14

			v13.submissionError = v12.submissionError
			set(v13)
		end,
		setPinnedComment = function(p2, p3)
			assert(not flag, "Comment collection store is disposed")
			assert(signal(false) == p2, "Comment feed must be selected before mutation")
			local v11 = v9

			local v12 = v11.get(false)
			local v13 = v12.orderedCommentIds

			if v12.initialLoadStatus == loadStatus.Success then
				local set = {}
				local pendingSubmission = v12.pendingSubmission
				local v14

				if pendingSubmission ~= nil then
					v14 = pendingSentinel(pendingSubmission.clientRequestId)
				end

				if v14 ~= nil then
					set[v14] = true
				end

				for k, stickyPostedCommentId in v12.stickyPostedCommentIds do
					set[stickyPostedCommentId] = true
				end

				local v15 = false
				v13 = {}

				for k, orderedCommentId in v12.orderedCommentIds do
					if not (v15 or set[orderedCommentId]) then
						table.insert(v13, p3)
						v15 = true
					end

					if orderedCommentId ~= p3 then
						table.insert(v13, orderedCommentId)
					end
				end

				if not v15 then
					table.insert(v13, p3)
				end
			end

			v11.set({
				orderedCommentIds = v13,
				channelId = v12.channelId,
				nextCursor = v12.nextCursor,
				hasMore = v12.hasMore,
				initialLoadStatus = v12.initialLoadStatus,
				loadMoreStatus = v12.loadMoreStatus,
				errorCode = v12.errorCode,
				pendingSubmission = v12.pendingSubmission,
				stickyPostedCommentIds = v12.stickyPostedCommentIds,
				pinnedCommentId = p3,
				submissionError = v12.submissionError
			})
		end
	}
end

return createCommentCollectionStore
