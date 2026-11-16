local parent = script.Parent.Parent

local CaptureService = require(parent.Services.CaptureService)

local CaptureType = require(parent.Enums.CaptureType)
local CapturesToastType = require(parent.Enums.CapturesToastType)
local ToastTriggered = require(parent.Actions.ToastTriggered)

require(parent.Types)

local FFlagCapturesVideoBulkManagerStopGap = require(parent.Flags.FFlagCapturesVideoBulkManagerStopGap)
local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local FFlagCapturesInExpMomentsToastDownloadButton = require(parent.Flags.FFlagCapturesInExpMomentsToastDownloadButton)

return function(list)
	local v = {}

	for _, item in ipairs(list) do
		if
			FFlagCapturesInExpMomentsToastDownloadButton
			and not FFlagEnableCapturesGalleryRetrievalCoreScript
			and typeof(item) ~= "table"
		then
			table.insert(v, item)
		elseif FFlagEnableCapturesGalleryRetrievalCoreScript then
			if FFlagCapturesVideoBulkManagerStopGap then
				table.insert(v, (CaptureService:PreCaptureShared(item)))
			else
				table.insert(v, item)
			end
		elseif FFlagUseRbxstorageInGallery and item.type == CaptureType.Video then
			table.insert(v, (CaptureService:PreVideoCaptureShared(item.videoCapture)))
		elseif item.type == CaptureType.Screenshot then
			table.insert(v, item.filePath)
		end
	end

	return function(object)
		CaptureService:SaveCapturesToExternalStorageAsync(v)
		object:dispatch(ToastTriggered(CapturesToastType.CaptureSavedToDevice, {
			captureInfo = list[1]
		}))
	end
end
