local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.MomentsTypes)
local CommentCollectionTypes = require(Moments.Components.Comments.GetCommentCollectionStore.CommentCollectionTypes)

local LoadStatus = CommentCollectionTypes.LoadStatus

local v = {
	MomentUnavailable = true,
	MomentNotFound = true,
	MomentNotVisible = true,
	ViewerNotEligibleToRead = true
}

local v2 = {
	CommentsDisabledByCreator = true,
	MomentUnavailable = true,
	MomentNotFound = true,
	MomentNotVisible = true,
	ViewerNotEligibleToRead = true,
	ViewerNotEligibleToWrite = true
}

local function getCommentsPanelState(data, data2)
	local errorCode = data2.errorCode
	local isReadOnly = data ~= nil and data.viewerCanWrite == false or errorCode == "ViewerNotEligibleToWrite"
	local v3 = data2.initialLoadStatus == LoadStatus.Success
	local canCompose = not isReadOnly
		and (data == nil or data.creatorEnabled and data.viewerCanRead)
		and (errorCode == nil or v2[errorCode] ~= true)

	local shouldClose = false
	local canRetryInitial = false
	local contentState

	if (v3 or data == nil or data.viewerCanRead ~= false) and (errorCode == nil or v[errorCode] ~= true) then
		if errorCode == "CommentsDisabledByCreator" or not v3 and data ~= nil and data.creatorEnabled == false then
			contentState = "disabled"
			isReadOnly = false
		elseif data == nil and data2.initialLoadStatus ~= LoadStatus.Failed and not v3 then
			contentState = "loading"
		elseif
			#data2.orderedCommentIds > 0
			or data2.pendingSubmission ~= nil and data2.initialLoadStatus ~= LoadStatus.Failed
		then
			contentState = "list"
		elseif data2.loadMoreStatus == LoadStatus.Failed then
			contentState = "unavailable"
			canRetryInitial = true
		elseif v3 then
			if data2.hasMore then
				contentState = "loading"
			else
				contentState = "empty"
			end
		elseif data2.initialLoadStatus == LoadStatus.Failed then
			contentState = "unavailable"
			canRetryInitial = true
		else
			contentState = "loading"
		end
	else
		contentState = "unavailable"
		shouldClose = true
	end

	return {
		contentState = contentState,
		isReadOnly = isReadOnly,
		shouldClose = shouldClose,
		canRetryInitial = canRetryInitial,
		canCompose = canCompose
	}
end

return getCommentsPanelState
