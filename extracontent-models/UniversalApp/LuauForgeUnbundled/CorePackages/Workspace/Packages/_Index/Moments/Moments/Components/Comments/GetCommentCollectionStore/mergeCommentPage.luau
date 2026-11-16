require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore/CommentCollectionTypes")

local v5 = { sessionHiddenCommentIds = {}, recentlyBlockedAuthorIds = {} }

local function mergeCommentPage(data)
	local filters = data.filters or v5
	local stickyPostedCommentIds = data.stickyPostedCommentIds or {}
	local visibleIdsBeforeReconciliation = data.visibleIdsBeforeReconciliation or {}
	local set = {}
	local v6 = {}

	if data.pendingSentinel ~= nil then
		table.insert(v6, data.pendingSentinel)
		set[data.pendingSentinel] = true
	end

	for k, stickyPostedCommentId in stickyPostedCommentIds do
		if set[stickyPostedCommentId] then
			continue
		end

		table.insert(v6, stickyPostedCommentId)
		set[stickyPostedCommentId] = true
	end

	local pinnedCommentId = data.pinnedCommentId

	if
		pinnedCommentId ~= nil
		and not set[pinnedCommentId]
		and filters.sessionHiddenCommentIds[pinnedCommentId] ~= true
	then
		table.insert(v6, pinnedCommentId)
		set[pinnedCommentId] = true
	end

	if not data.replace then
		for k, existingId in data.existingIds do
			if set[existingId] then
				continue
			end

			table.insert(v6, existingId)
			set[existingId] = true
		end
	end

	local commentIds = {}

	for k, pageComment in data.pageComments do
		if
			pageComment.status ~= "Active"
			or set[pageComment.commentId]
			or filters.sessionHiddenCommentIds[pageComment.commentId] == true
		then
			continue
		end

		local userId = if pageComment.author ~= nil then pageComment.author.userId else nil

		if not (userId == nil or filters.recentlyBlockedAuthorIds[userId] ~= true) then
			continue
		end

		table.insert(v6, pageComment.commentId)
		set[pageComment.commentId] = true

		if not visibleIdsBeforeReconciliation[pageComment.commentId] then
			table.insert(commentIds, pageComment.commentId)
		end
	end

	return {
		orderedCommentIds = v6,
		addedIds = commentIds,
		visibleCount = #commentIds,
		shouldContinuePaging = data.hasMore == true and #commentIds == 0
	}
end

return mergeCommentPage
