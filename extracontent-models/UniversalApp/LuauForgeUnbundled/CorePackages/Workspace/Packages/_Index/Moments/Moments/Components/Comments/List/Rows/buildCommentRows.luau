require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local shallowEqual = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Dash").shallowEqual
local CommentCollectionTypes = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore/CommentCollectionTypes")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRowTypes")

local function reusePreviousRows(previousRows, list)
	local v5 = {}

	for k, item in previousRows do
		v5[item.key] = item
	end

	local v6 = #list == #previousRows

	for k, item in list do
		local v7 = v5[item.key]

		if v7 ~= nil and shallowEqual(v7, item) then
			list[k] = v7
		end

		v6 = v6 and list[k] == previousRows[k]
	end

	if v6 then
		return previousRows
	end

	return list
end

local function buildCommentRows(data)
	local state = data.state
	local resolveComment = data.resolveComment
	local previousRows = data.previousRows
	local expandedCommentIds = data.expandedCommentIds
	local translation = data.translation
	local result = table.create(#state.orderedCommentIds + (state.pendingSubmission == nil and 0 or 1))
	local pendingSubmission = state.pendingSubmission

	if pendingSubmission ~= nil then
		table.insert(result, {
			type = "pending",
			key = CommentCollectionTypes.pendingSentinel(pendingSubmission.clientRequestId),
			text = pendingSubmission.text,
			status = pendingSubmission.status
		})
	end

	for k, orderedCommentId in state.orderedCommentIds do
		if CommentCollectionTypes.isPendingSentinel(orderedCommentId) then
			continue
		end

		local comment = resolveComment(orderedCommentId)
		local v5 = comment == nil and "" or comment.text or ""
		local translatedText = if comment ~= nil then comment.translatedText else nil
		local v6

		if not (translation == nil or translatedText == nil) then
			if (translation.toggledCommentIds[orderedCommentId] == true) == translation.showsTranslationByDefault then
				v6 = "Original"
			else
				v5 = translatedText
				v6 = "Translated"
			end
		end

		local v7 = {
			type = "comment",
			key = `comment:{orderedCommentId}`,
			commentId = orderedCommentId,
			text = v5,
			createdAt = comment == nil and "" or comment.createdAt,
			isExpanded = expandedCommentIds ~= nil and expandedCommentIds[orderedCommentId] == true,
			translationState = v6
		}
		table.insert(result, v7)
	end

	if previousRows == nil then
		return result
	end

	return reusePreviousRows(previousRows, result)
end

return buildCommentRows
