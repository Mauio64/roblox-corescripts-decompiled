local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")

local Constants = require(AbuseReportMenu.Components.Constants)
local isInSelectInSceneReportMenuOverrideList = require(AbuseReportMenu.Utility.isInSelectInSceneReportMenuOverrideList)

local v = false
task.defer(function()
	v = isInSelectInSceneReportMenuOverrideList()
end)

return function(callback): boolean
	if not (game:GetEngineFeature("SafetyServiceCaptureModeReportProp") and game:GetEngineFeature("CaptureModeEnabled")) then
		return false
	end

	if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") then
		if ExperienceStateCaptureService:CanEnterCaptureMode() then
			callback({
				type = Constants.AnalyticsActions.SetMemoryRequirementMet,
				memoryRequirementMet = 1
			})
		else
			callback({
				type = Constants.AnalyticsActions.SetMemoryRequirementMet,
				memoryRequirementMet = 0
			})

			return false
		end
	end

	if not game:GetEngineFeature("ExperienceStateCaptureHiddenSelection") then
		return false
	end

	if v then
	end

	return true
end
