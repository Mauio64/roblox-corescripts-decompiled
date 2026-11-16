local parent = script.Parent.Parent

local CaptureService = game:GetService("CaptureService")

local CaptureType = require(parent.Enums.CaptureType)
local RetrieveCaptures = require(parent.Thunks.RetrieveCaptures)

require(parent.Types)

local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(list)
	local v = {}

	for _, item in ipairs(list) do
		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			table.insert(v, item)
		elseif FFlagUseRbxstorageInGallery and item.type == CaptureType.Video then
			table.insert(v, item.videoCapture)
		elseif item.type == CaptureType.Screenshot then
			table.insert(v, item.filePath)
		end
	end

	return function(object)
		CaptureService:DeleteCapturesAsync(v)
		object:dispatch(RetrieveCaptures())
	end
end
