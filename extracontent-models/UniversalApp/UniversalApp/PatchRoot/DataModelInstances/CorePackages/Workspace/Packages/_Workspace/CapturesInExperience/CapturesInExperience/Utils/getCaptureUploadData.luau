local ParentParent = script.Parent.Parent
local CaptureService = game:GetService("CaptureService")
local CaptureType = require(ParentParent.Enums.CaptureType)

require(ParentParent.Types)

local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)

local function getCaptureUploadData(p1) -- line: 9
	-- upvalues: FFlagUseRbxstorageInGallery (copy), CaptureType (copy), CaptureService (copy)
	if FFlagUseRbxstorageInGallery and p1.type == CaptureType.Video then
		return nil
	end

	local ok, result = pcall(function() -- line: 14
		-- upvalues: CaptureService (copy), p1 (copy)
		return CaptureService:GetCaptureUploadDataAsync(p1.filePath)
	end)

	if not ok then
		return nil
	end

	return result
end

return getCaptureUploadData
