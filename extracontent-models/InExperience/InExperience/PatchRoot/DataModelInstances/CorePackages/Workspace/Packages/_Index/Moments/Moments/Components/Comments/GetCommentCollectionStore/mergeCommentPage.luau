require(script.Parent.CommentCollectionTypes)

local v = { sessionHiddenCommentIds = {}, recentlyBlockedAuthorIds = {} }

local function mergeCommentPage(data)
	local filters = data.filters or v
	local stickyPostedCommentIds = data.stickyPostedCommentIds or {}
	local visibleIdsBeforeReconciliation = data.visibleIdsBeforeReconciliation or {}
	local set = {}
	local orderedCommentIds = {}

	if data.pendingSentinel ~= nil then
		table.insert(orderedCommentIds, data.pendingSentinel)
		set[data.pendingSentinel] = true
	end

	for _, stickyPostedCommentId in stickyPostedCommentIds do
		if set[stickyPostedCommentId] then
			continue
		end

		table.insert(orderedCommentIds, stickyPostedCommentId)
		set[stickyPostedCommentId] = true
	end

	local pinnedCommentId = data.pinnedCommentId

	if
		pinnedCommentId ~= nil
		and not set[pinnedCommentId]
		and filters.sessionHiddenCommentIds[pinnedCommentId] ~= true
	then
		table.insert(orderedCommentIds, pinnedCommentId)
		set[pinnedCommentId] = true
	end

	if not data.replace then
		for _, existingId in data.existingIds do
			if set[existingId] then
				continue
			end

			table.insert(orderedCommentIds, existingId)
			set[existingId] = true
		end
	end

	local commentIds = {}

	for _, pageComment in data.pageComments do
		if
			pageComment.status ~= "Active"
			or set[pageComment.commentId]
			or filters.sessionHiddenCommentIds[pageComment.commentId] == true
		then
			continue
		end

		local userId

		if pageComment.author ~= nil then
			userId = pageComment.author.userId
		end

		if not (userId == nil or filters.recentlyBlockedAuthorIds[userId] ~= true) then
			continue
		end

		table.insert(orderedCommentIds, pageComment.commentId)
		set[pageComment.commentId] = true

		if not visibleIdsBeforeReconciliation[pageComment.commentId] then
			table.insert(commentIds, pageComment.commentId)
		end
	end

	return {
		orderedCommentIds = orderedCommentIds,
		addedIds = commentIds,
		visibleCount = #commentIds,
		shouldContinuePaging = data.hasMore == true and #commentIds == 0
	}
end

return mergeCommentPage
