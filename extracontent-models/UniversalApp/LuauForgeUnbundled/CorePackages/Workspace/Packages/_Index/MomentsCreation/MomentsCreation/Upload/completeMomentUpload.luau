local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local Logger = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Logger")

local function completeMomentUpload(p2, data)
	data.uploadStore.setSuccess(p2)
	MomentsCommon.Analytics.reportMomentsCreationStep("upload", "success")
	local feedStore = data.feedStore

	if feedStore then
		feedStore.prependItem({ assetId = p2 })
	end

	local myCreationsStore = data.myCreationsStore

	if myCreationsStore then
		myCreationsStore.prependItem({ assetId = p2 })
		myCreationsStore.invalidateCount()
	end

	data.onPostedToFeed()
	Logger:debug(
		"event=completion assetId={} MomentsUseBackendPostStatusNotification={} localSuccessToast={}",
		tostring(p2),
		tostring(true),
		"suppressed"
	)
end

return completeMomentUpload
