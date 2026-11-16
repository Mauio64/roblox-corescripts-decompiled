local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

require(AbuseReportMenu.Components.Types)
local Constants = require(AbuseReportMenu.Components.Constants)

local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)
local AnnotationModal = require(AbuseReportMenu.ReportAnything.Components.AnnotationModal)
local OptionalAttachScreenshotMenuConfig = {}
OptionalAttachScreenshotMenuConfig.componentType = "button"

function OptionalAttachScreenshotMenuConfig.getIsVisible(_)
	return TnSIXPWrapper.getReportAnythingExperienceEnabled()
end

function OptionalAttachScreenshotMenuConfig.getIsDisabled(_, p)
	return p.reportAnythingState.attachCompleted
end

OptionalAttachScreenshotMenuConfig.variant = "secondary"

function OptionalAttachScreenshotMenuConfig.getIconSrc(p): string
	if p.reportAnythingState.attachCompleted then
		return "icons/actions/accept"
	end

	return "icons/controls/screenshot"
end

function OptionalAttachScreenshotMenuConfig.getButtonLabel(p): string
	if p.reportAnythingState.attachCompleted then
		return "SceneCaptured"
	end

	return "CaptureScene"
end

function OptionalAttachScreenshotMenuConfig.onClick(_, _, data)
	data.analyticsDispatch({ type = Constants.AnalyticsActions.IncrementCaptureScene })
	AnnotationModal.mountAnnotationPage(
		Constants.ReportTypes.Experience,
		data.hideReportTab,
		data.reportAnythingAnalytics,
		data.reportAnythingState,
		data.reportAnythingDispatch
	)
end

OptionalAttachScreenshotMenuConfig.fieldLabel = "AttachScreenshot"
OptionalAttachScreenshotMenuConfig.componentName = "OptionalScreenshot"
return OptionalAttachScreenshotMenuConfig
