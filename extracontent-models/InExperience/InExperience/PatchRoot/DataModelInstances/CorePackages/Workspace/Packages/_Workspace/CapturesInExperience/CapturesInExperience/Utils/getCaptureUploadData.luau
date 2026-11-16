local parent = script.Parent.Parent
local CaptureService = game:GetService("CaptureService")

local CaptureType = require(parent.Enums.CaptureType)
require(parent.Types)

local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)

local function getCaptureUploadData(p)
	if FFlagUseRbxstorageInGallery and p.type == CaptureType.Video then
		return nil
	end

	local success, result = pcall(function()
		return CaptureService:GetCaptureUploadDataAsync(p.filePath)
	end)
	return if success then result else nil
end

return getCaptureUploadData
