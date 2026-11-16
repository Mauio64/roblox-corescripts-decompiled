local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local IXPService = game:GetService("IXPService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags")

local fStringReportMenuIXPLayer = SharedFlags.FStringReportMenuIXPLayer
local fStringSelectInSceneIXPField = SharedFlags.FStringSelectInSceneIXPField

local function isInSelectInSceneExperiment()
	local success, result = pcall(function()
		return IXPService:GetUserLayerVariables(fStringReportMenuIXPLayer)
	end)

	if not success or not result or result[fStringSelectInSceneIXPField] == nil then
		return false
	end

	IXPService:LogUserLayerExposure(fStringReportMenuIXPLayer)
	return result[fStringSelectInSceneIXPField]
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
		return IXPService:GetUserLayerVariables(fStringReportMenuIXPLayer)
	end)

	if not success or not result or result[fStringSelectInSceneIXPField] == nil then
		return false
	end

	IXPService:LogUserLayerExposure(fStringReportMenuIXPLayer)
	return result[fStringSelectInSceneIXPField]
end

return getIsInExpSceneSelectionAvailable
