local ParentParent = script.Parent.Parent
local CaptureService = game:GetService("CaptureService")
local CaptureType = require(ParentParent.Enums.CaptureType)
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)
local ToastTriggered = require(ParentParent.Actions.ToastTriggered)

require(ParentParent.Types)

local FFlagCapturesVideoBulkManagerStopGap = require(ParentParent.Flags.FFlagCapturesVideoBulkManagerStopGap)
local v7 = game:DefineFastFlag("CapturesVideoSupportLegacyVideos", false)
local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(t1: {[any]: any}) -- line: 17
	-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), FFlagCapturesVideoBulkManagerStopGap (copy), CaptureService (copy), FFlagUseRbxstorageInGallery (copy), CaptureType (copy), v7 (copy), ToastTriggered (copy), CapturesToastType (copy)
	local t2 = {}

	for _, v in ipairs(t1) do
		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			if FFlagCapturesVideoBulkManagerStopGap then
				table.insert(t2, (CaptureService:PreCaptureShared(v)))
			else
				table.insert(t2, v)
			end
		elseif FFlagUseRbxstorageInGallery and v.type == CaptureType.Video then
			if v7 then
				table.insert(t2, (CaptureService:PreVideoCaptureShared(v.videoCapture)))
			else
				table.insert(t2, v.videoCapture)
			end
		elseif v.type == CaptureType.Screenshot then
			table.insert(t2, v.filePath)
		end
	end

	return function(p1) -- line: 39
		-- upvalues: CaptureService (copy), t2 (copy), ToastTriggered (copy), CapturesToastType (copy), t1 (copy)
		CaptureService:SaveCapturesToExternalStorageAsync(t2)
		p1:dispatch(ToastTriggered(CapturesToastType.CaptureSavedToDevice, {
			captureInfo = t1[1]
		}))
	end
end
