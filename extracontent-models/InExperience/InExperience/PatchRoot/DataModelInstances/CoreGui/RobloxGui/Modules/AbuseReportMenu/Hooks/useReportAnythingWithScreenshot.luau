local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local Constants = require(AbuseReportMenu.Components.Constants)
local useHideForScreenshot = require(AbuseReportMenu.Hooks.useHideForScreenshot)
local useCaptureScreenshot = require(AbuseReportMenu.Hooks.useCaptureScreenshot)
local reportAnythingReducer = require(AbuseReportMenu.Reducers.reportAnythingReducer)
local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)

return function(p, p2, p3, callback)
	local reportAnythingAvatarEnabled = TnSIXPWrapper.getReportAnythingAvatarEnabled()
	local v = TnSIXPWrapper.getReportAnythingExperienceEnabled()

	local v2, v3 = React.useReducer(reportAnythingReducer, Constants.ReportAnythingInitialState)

	if reportAnythingAvatarEnabled or v then
		v = v2.screenshotContentId == ""
	end

	useHideForScreenshot(v, p, p2, p3, useCaptureScreenshot(React.useCallback(function(screenshotContentId)
		v3({
			type = Constants.ReportAnythingActions.SetScreenshotContentId,
			screenshotContentId = screenshotContentId
		})
	end), React.useCallback(function(screenshotId)
		v3({ type = Constants.ReportAnythingActions.SetScreenshotId, screenshotId = screenshotId })
	end), React.useCallback(function(identificationResults)
		v3({
			type = Constants.ReportAnythingActions.SetIdentificationResults,
			identificationResults = identificationResults
		})
	end)), function()
		callback(v2, v3)
	end)

	return v2, v3
end
