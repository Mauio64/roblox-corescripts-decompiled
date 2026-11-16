local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local IXPService = game:GetService("IXPService")

local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local SharedFlags = require(parent.SharedFlags)

local FStringReportMenuIXPLayer = SharedFlags.FStringReportMenuIXPLayer
local FStringSelectInSceneIXPField = SharedFlags.FStringSelectInSceneIXPField

local function isInSelectInSceneExperiment()
	local success, result = pcall(function()
		return IXPService:GetUserLayerVariables(FStringReportMenuIXPLayer)
	end)

	if not success or not result or result[FStringSelectInSceneIXPField] == nil then
		return false
	end

	IXPService:LogUserLayerExposure(FStringReportMenuIXPLayer)
	return result[FStringSelectInSceneIXPField]
end

local function getIsInExpSceneSelectionAvailable()
	if not (game:GetEngineFeature("SafetyServiceCaptureModeReportProp") and game:GetEngineFeature("CaptureModeEnabled") and game:GetEngineFeature("ExperienceStateCaptureHiddenSelection")) then
		return false
	end

	if
		game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled")
		and not ExperienceStateCaptureService:CanEnterCaptureMode()
	then
		return false
	end

	local success, result = pcall(function()
		return IXPService:GetUserLayerVariables(FStringReportMenuIXPLayer)
	end)

	if not success or not result or result[FStringSelectInSceneIXPField] == nil then
		return false
	end

	IXPService:LogUserLayerExposure(FStringReportMenuIXPLayer)
	return result[FStringSelectInSceneIXPField]
end

return getIsInExpSceneSelectionAvailable
