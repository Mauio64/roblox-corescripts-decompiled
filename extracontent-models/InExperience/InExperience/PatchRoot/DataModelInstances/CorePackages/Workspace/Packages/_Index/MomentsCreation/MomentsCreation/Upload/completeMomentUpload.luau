local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local Logger = require(MomentsCreation.Logger)
local GetFFlagMomentsUseBackendPostStatusNotification = require(MomentsCreation.Flags.GetFFlagMomentsUseBackendPostStatusNotification)

local function completeMomentUpload(n1: number, t1: {[any]: any}) -- line: 37
	-- upvalues: GetFFlagMomentsUseBackendPostStatusNotification (copy), Logger (copy)
	t1.uploadStore.setSuccess(n1)

	local feedStore = t1.feedStore

	if feedStore then
		feedStore.prependItem({
			assetId = n1
		})
	end

	local myCreationsStore = t1.myCreationsStore

	if myCreationsStore then
		myCreationsStore.prependItem({
			assetId = n1
		})
		myCreationsStore.invalidateCount()
	end

	t1.onPostedToFeed()

	local v9 = GetFFlagMomentsUseBackendPostStatusNotification()

	Logger:debug("event=completion assetId={} MomentsUseBackendPostStatusNotification={} localSuccessToast={}", tostring(n1), tostring(v9), not v9 and "trigger" or "suppressed")

	if not v9 then
		t1.toastStore.triggerToast({
			title = t1.localizations.publishedTitle,
			text = t1.localizations.publishedBody
		})
	end
end

return completeMomentUpload
