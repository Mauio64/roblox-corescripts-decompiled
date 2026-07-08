local ParentParent = script.Parent.Parent
local CaptureService = game:GetService("CaptureService")
local RetrieveCaptures = require(ParentParent.Thunks.RetrieveCaptures)
local CaptureType = require(ParentParent.Enums.CaptureType)

require(ParentParent.Types)

local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)
local FFlagCapturesVideoDeleteAsync = require(ParentParent.Flags.FFlagCapturesVideoDeleteAsync)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(p1) -- line: 15
	-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureService (copy), FFlagUseRbxstorageInGallery (copy), CaptureType (copy), FFlagCapturesVideoDeleteAsync (copy), RetrieveCaptures (copy)
	return function(p2) -- line: 16
		-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), p1 (copy), CaptureService (copy), FFlagUseRbxstorageInGallery (copy), CaptureType (copy), FFlagCapturesVideoDeleteAsync (copy), RetrieveCaptures (copy)
		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			local t1 = { p1 }

			CaptureService:DeleteCapturesAsync(t1)
		elseif FFlagUseRbxstorageInGallery and p1.type == CaptureType.Video then
			if FFlagCapturesVideoDeleteAsync then
				CaptureService:DeleteVideoCaptureAsync(p1.videoCapture)
			else
				CaptureService:DeleteVideoCapture(p1.videoCapture)
			end
		else
			CaptureService:DeleteCapture(p1.filePath)
		end

		p2:dispatch(RetrieveCaptures())
	end
end
