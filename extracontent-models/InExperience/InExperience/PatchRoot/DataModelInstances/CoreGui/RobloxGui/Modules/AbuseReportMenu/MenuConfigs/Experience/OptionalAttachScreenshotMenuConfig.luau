local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

require(AbuseReportMenu.Components.Types)

local Constants = require(AbuseReportMenu.Components.Constants)
local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)
local AnnotationModal = require(AbuseReportMenu.ReportAnything.Components.AnnotationModal)

return {
	componentType = "button",
	variant = "secondary",
	fieldLabel = "AttachScreenshot",
	componentName = "OptionalScreenshot",
	getIsVisible = function(_) -- line: 11
		-- upvalues: TnSIXPWrapper (copy)
		return TnSIXPWrapper.getReportAnythingExperienceEnabled()
	end,
	getIsDisabled = function(_, p3) -- line: 14
		return p3.reportAnythingState.attachCompleted
	end,
	getIconSrc = function(p4) -- line: 18
		if p4.reportAnythingState.attachCompleted then
			return "icons/actions/accept"
		end

		return "icons/controls/screenshot"
	end,
	getButtonLabel = function(p5) -- line: 23
		if p5.reportAnythingState.attachCompleted then
			return "SceneCaptured"
		end

		return "CaptureScene"
	end,
	onClick = function(_, _, p8) -- line: 26
		-- upvalues: Constants (copy), AnnotationModal (copy)
		p8.analyticsDispatch({
			type = Constants.AnalyticsActions.IncrementCaptureScene
		})
		AnnotationModal.mountAnnotationPage(Constants.ReportTypes.Experience, p8.hideReportTab, p8.reportAnythingAnalytics, p8.reportAnythingState, p8.reportAnythingDispatch)
	end
}
