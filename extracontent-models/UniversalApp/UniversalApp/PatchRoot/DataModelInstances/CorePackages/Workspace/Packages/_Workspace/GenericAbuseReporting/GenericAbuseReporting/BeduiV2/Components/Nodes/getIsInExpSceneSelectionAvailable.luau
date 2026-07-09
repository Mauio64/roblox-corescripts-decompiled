local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local IXPService = game:GetService("IXPService")
local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local SharedFlags = require(Parent.SharedFlags)
local v5 = game:DefineFastFlag("GateAbuseReportInExpSceneSelectionOnIXP", false)
local FStringReportMenuIXPLayer = SharedFlags.FStringReportMenuIXPLayer
local FStringSelectInSceneIXPField = SharedFlags.FStringSelectInSceneIXPField

local function isInSelectInSceneExperiment() -- line: 15
	-- upvalues: IXPService (copy), FStringReportMenuIXPLayer (copy), FStringSelectInSceneIXPField (copy)
	local ok, result = pcall(function() -- line: 16
		-- upvalues: IXPService (copy), FStringReportMenuIXPLayer (copy)
		return IXPService:GetUserLayerVariables(FStringReportMenuIXPLayer)
	end)

	if not ok or (not result or result[FStringSelectInSceneIXPField] == nil) then
		return false
	end

	IXPService:LogUserLayerExposure(FStringReportMenuIXPLayer)

	return result[FStringSelectInSceneIXPField]
end
local function getIsInExpSceneSelectionAvailable() -- line: 36
	-- upvalues: ExperienceStateCaptureService (copy), v5 (copy), IXPService (copy), FStringReportMenuIXPLayer (copy), FStringSelectInSceneIXPField (copy)
	if not game:GetEngineFeature("SafetyServiceCaptureModeReportProp") then
		return false
	end

	if not game:GetEngineFeature("CaptureModeEnabled") then
		return false
	end

	if not game:GetEngineFeature("ExperienceStateCaptureHiddenSelection") then
		return false
	end

	if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and not ExperienceStateCaptureService:CanEnterCaptureMode() then
		return false
	end

	if v5 then
		local ok, result = pcall(function() -- line: 16
			-- upvalues: IXPService (copy), FStringReportMenuIXPLayer (copy)
			return IXPService:GetUserLayerVariables(FStringReportMenuIXPLayer)
		end)

		if not ok or not result or result[FStringSelectInSceneIXPField] == nil then
			return false
		end

		IXPService:LogUserLayerExposure(FStringReportMenuIXPLayer)

		return result[FStringSelectInSceneIXPField]
	end

	return true
end

return getIsInExpSceneSelectionAvailable
