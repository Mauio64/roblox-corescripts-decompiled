local ParentParent = script.Parent.Parent
local CaptureService = require(ParentParent.Services.CaptureService)
local CaptureType = require(ParentParent.Enums.CaptureType)
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)
local ToastTriggered = require(ParentParent.Actions.ToastTriggered)

require(ParentParent.Types)

local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(p1) -- line: 15
	-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureService (copy), FFlagUseRbxstorageInGallery (copy), CaptureType (copy), ToastTriggered (copy), CapturesToastType (copy)
	return function(p2) -- line: 16
		-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureService (copy), p1 (copy), FFlagUseRbxstorageInGallery (copy), CaptureType (copy), ToastTriggered (copy), CapturesToastType (copy)
		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			CaptureService:SaveCapturesToExternalStorageAsync({ p1 })
		elseif FFlagUseRbxstorageInGallery and p1.type == CaptureType.Video then
			CaptureService:SaveVideoCaptureToExternalStorage(p1.videoCapture)
		else
			CaptureService:SaveCaptureToExternalStorage(p1.filePath)
		end

		p2:dispatch(ToastTriggered(CapturesToastType.CaptureSavedToDevice, {
			captureInfo = p1
		}))
	end
end
