local ParentParent = script.Parent.Parent
local CaptureService = require(ParentParent.Services.CaptureService)
local CaptureType = require(ParentParent.Enums.CaptureType)

require(ParentParent.Types)

local EngineFeature = game:GetEngineFeature("CaptureServiceGetScreenshotCaptureObject")

local function getCaptureObject(p1) -- line: 9
	-- upvalues: CaptureType (copy), EngineFeature (copy), CaptureService (copy)
	if p1.CaptureType ~= nil then
		return p1
	end

	if p1.type == CaptureType.Video then
		return p1.videoCapture
	end

	if p1.capture ~= nil then
		return p1.capture
	end

	if EngineFeature then
		return (CaptureService:GetScreenshotCaptureObject(p1.filePath))
	end

	return nil
end

return getCaptureObject
