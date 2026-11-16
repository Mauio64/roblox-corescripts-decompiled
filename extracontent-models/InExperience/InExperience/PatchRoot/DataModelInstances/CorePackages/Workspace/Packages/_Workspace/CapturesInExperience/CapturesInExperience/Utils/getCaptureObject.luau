local parent = script.Parent.Parent

local CaptureService = require(parent.Services.CaptureService)
local CaptureType = require(parent.Enums.CaptureType)
require(parent.Types)

local engineFeature = game:GetEngineFeature("CaptureServiceGetScreenshotCaptureObject")

local function getCaptureObject(data)
	if data.CaptureType ~= nil then
		return data
	end

	if data.type == CaptureType.Video then
		return data.videoCapture
	end

	if data.capture ~= nil then
		return data.capture
	end

	if engineFeature then
		return (CaptureService:GetScreenshotCaptureObject(data.filePath))
	end

	return nil
end

return getCaptureObject
