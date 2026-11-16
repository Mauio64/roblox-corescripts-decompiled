local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.MomentsTypes)
local Dash = require(parent.Dash)
local shallowEqual = Dash.shallowEqual
local CommentCollectionTypes = require(Moments.Components.Comments.GetCommentCollectionStore.CommentCollectionTypes)
require(script.Parent.CommentRowTypes)

local function reusePreviousRows(previousRows, list)
	local v = {}

	for _, item in previousRows do
		v[item.key] = item
	end

	local v2 = #list == #previousRows

	for k, item in list do
		local v3 = v[item.key]

		if v3 ~= nil and shallowEqual(v3, item) then
			list[k] = v3
		end

		v2 = v2 and list[k] == previousRows[k]
	end

	return if v2 then previousRows else list
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

	for _, orderedCommentId in state.orderedCommentIds do
		if CommentCollectionTypes.isPendingSentinel(orderedCommentId) then
			continue
		end

		local comment = resolveComment(orderedCommentId)
		local text = comment == nil and "" or comment.text or ""
		local translatedText

		if comment ~= nil then
			translatedText = comment.translatedText
		end

		local translationState

		if not (translation == nil or translatedText == nil) then
			if (translation.toggledCommentIds[orderedCommentId] == true) == translation.showsTranslationByDefault then
				translationState = "Original"
			else
				text = translatedText
				translationState = "Translated"
			end
		end

		local v = {
			type = "comment",
			key = `comment:{orderedCommentId}`,
			commentId = orderedCommentId,
			text = text,
			createdAt = comment == nil and "" or comment.createdAt,
			isExpanded = expandedCommentIds ~= nil and expandedCommentIds[orderedCommentId] == true,
			translationState = translationState
		}
		table.insert(result, v)
	end

	if previousRows == nil then
		return result
	end

	return reusePreviousRows(previousRows, result)
end

return buildCommentRows
