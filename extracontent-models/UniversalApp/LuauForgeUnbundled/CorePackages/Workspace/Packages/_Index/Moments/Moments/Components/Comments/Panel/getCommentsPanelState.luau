require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local loadStatus = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore/CommentCollectionTypes").LoadStatus

local v5 = {
	MomentUnavailable = true,
	MomentNotFound = true,
	MomentNotVisible = true,
	ViewerNotEligibleToRead = true
}

local v6 = {
	CommentsDisabledByCreator = true,
	MomentUnavailable = true,
	MomentNotFound = true,
	MomentNotVisible = true,
	ViewerNotEligibleToRead = true,
	ViewerNotEligibleToWrite = true
}

local function getCommentsPanelState(data, data2)
	local errorCode = data2.errorCode
	local v7 = data ~= nil and data.viewerCanWrite == false or errorCode == "ViewerNotEligibleToWrite"
	local v8 = data2.initialLoadStatus == loadStatus.Success
	local v9 = not v7
		and (data == nil or data.creatorEnabled and data.viewerCanRead)
		and (errorCode == nil or v6[errorCode] ~= true)

	local v10 = false
	local v11 = false
	local v12

	if
		(v8 or data == nil or data.viewerCanRead ~= false)
		and (errorCode == nil or v5[errorCode] ~= true)
	then
		if
			errorCode == "CommentsDisabledByCreator"
			or not v8 and data ~= nil and data.creatorEnabled == false
		then
			v12 = "disabled"
			v7 = false
		elseif data == nil and data2.initialLoadStatus ~= loadStatus.Failed and not v8 then
			v12 = "loading"
		elseif
			#data2.orderedCommentIds > 0
			or data2.pendingSubmission ~= nil and data2.initialLoadStatus ~= loadStatus.Failed
		then
			v12 = "list"
		elseif data2.loadMoreStatus == loadStatus.Failed then
			v12 = "unavailable"
			v11 = true
		elseif v8 then
			v12 = if data2.hasMore then "loading" else "empty"
		elseif data2.initialLoadStatus == loadStatus.Failed then
			v12 = "unavailable"
			v11 = true
		else
			v12 = "loading"
		end
	else
		v12 = "unavailable"
		v10 = true
	end

	return {
		contentState = v12,
		isReadOnly = v7,
		shouldClose = v10,
		canRetryInitial = v11,
		canCompose = v9
	}
end

return getCommentsPanelState
