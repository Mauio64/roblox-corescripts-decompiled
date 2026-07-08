local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local Constants = require(AbuseReportMenu.Components.Constants)
local isInSelectInSceneReportMenuOverrideList = require(AbuseReportMenu.Utility.isInSelectInSceneReportMenuOverrideList)
local u5 = false

task.defer(function() -- line: 8
	-- upvalues: u5 (ref), isInSelectInSceneReportMenuOverrideList (copy)
	u5 = isInSelectInSceneReportMenuOverrideList()
end)

return function(p1: ((...any) -> ...any)) -- line: 12
	-- upvalues: ExperienceStateCaptureService (copy), Constants (copy), u5 (ref)
	if not game:GetEngineFeature("SafetyServiceCaptureModeReportProp") then
		return false
	end

	if not game:GetEngineFeature("CaptureModeEnabled") then
		return false
	end

	if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") then
		if not ExperienceStateCaptureService:CanEnterCaptureMode() then
			p1({
				memoryRequirementMet = 0,
				type = Constants.AnalyticsActions.SetMemoryRequirementMet
			})

			return false
		end

		p1({
			memoryRequirementMet = 1,
			type = Constants.AnalyticsActions.SetMemoryRequirementMet
		})
	end

	if not game:GetEngineFeature("ExperienceStateCaptureHiddenSelection") then
		return false
	end

	if u5 then
		return true
	end

	return true
end
