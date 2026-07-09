local ParentParent = script.Parent.Parent
local CaptureService = game:GetService("CaptureService")
local CaptureType = require(ParentParent.Enums.CaptureType)
local RetrieveCaptures = require(ParentParent.Thunks.RetrieveCaptures)

require(ParentParent.Types)

local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), FFlagUseRbxstorageInGallery (copy), CaptureType (copy), CaptureService (copy), RetrieveCaptures (copy)
	local t2 = {}

	for _, v in ipairs(t1) do
		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			table.insert(t2, v)
		elseif FFlagUseRbxstorageInGallery and v.type == CaptureType.Video then
			table.insert(t2, v.videoCapture)
		elseif v.type == CaptureType.Screenshot then
			table.insert(t2, v.filePath)
		end
	end

	return function(p1) -- line: 26
		-- upvalues: CaptureService (copy), t2 (copy), RetrieveCaptures (copy)
		CaptureService:DeleteCapturesAsync(t2)
		p1:dispatch(RetrieveCaptures())
	end
end
