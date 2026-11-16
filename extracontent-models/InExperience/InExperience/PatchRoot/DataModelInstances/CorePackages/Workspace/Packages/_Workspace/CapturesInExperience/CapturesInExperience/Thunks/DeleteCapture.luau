local parent = script.Parent.Parent

local CaptureService = game:GetService("CaptureService")

local RetrieveCaptures = require(parent.Thunks.RetrieveCaptures)

local CaptureType = require(parent.Enums.CaptureType)
require(parent.Types)

local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)
local FFlagCapturesVideoDeleteAsync = require(parent.Flags.FFlagCapturesVideoDeleteAsync)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(data)
	return function(object)
		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			CaptureService:DeleteCapturesAsync({ data })
		elseif FFlagUseRbxstorageInGallery and data.type == CaptureType.Video then
			if FFlagCapturesVideoDeleteAsync then
				CaptureService:DeleteVideoCaptureAsync(data.videoCapture)
			else
				CaptureService:DeleteVideoCapture(data.videoCapture)
			end
		else
			CaptureService:DeleteCapture(data.filePath)
		end

		object:dispatch(RetrieveCaptures())
	end
end
