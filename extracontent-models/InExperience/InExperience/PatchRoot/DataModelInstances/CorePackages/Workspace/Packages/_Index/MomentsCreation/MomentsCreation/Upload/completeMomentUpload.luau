local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local MomentsCommon = require(parent.MomentsCommon)
local Logger = require(MomentsCreation.Logger)

local function completeMomentUpload(assetId: number, data)
	data.uploadStore.setSuccess(assetId)
	MomentsCommon.Analytics.reportMomentsCreationStep("upload", "success")
	local feedStore = data.feedStore

	if feedStore then
		feedStore.prependItem({ assetId = assetId })
	end

	local myCreationsStore = data.myCreationsStore

	if myCreationsStore then
		myCreationsStore.prependItem({ assetId = assetId })
		myCreationsStore.invalidateCount()
	end

	data.onPostedToFeed()
	Logger:debug(
		"event=completion assetId={} MomentsUseBackendPostStatusNotification={} localSuccessToast={}",
		tostring(assetId),
		tostring(true),
		"suppressed"
	)
end

return completeMomentUpload
