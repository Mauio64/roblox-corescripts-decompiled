local parent = script.Parent.Parent

local CaptureService = require(parent.Services.CaptureService)

local CaptureType = require(parent.Enums.CaptureType)
local CapturesToastType = require(parent.Enums.CapturesToastType)
local ToastTriggered = require(parent.Actions.ToastTriggered)

require(parent.Types)

local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(captureInfo)
	return function(object)
		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			CaptureService:SaveCapturesToExternalStorageAsync({ captureInfo })
		elseif FFlagUseRbxstorageInGallery and captureInfo.type == CaptureType.Video then
			CaptureService:SaveVideoCaptureToExternalStorage(captureInfo.videoCapture)
		else
			CaptureService:SaveCaptureToExternalStorage(captureInfo.filePath)
		end

		object:dispatch(ToastTriggered(CapturesToastType.CaptureSavedToDevice, {
			captureInfo = captureInfo
		}))
	end
end
