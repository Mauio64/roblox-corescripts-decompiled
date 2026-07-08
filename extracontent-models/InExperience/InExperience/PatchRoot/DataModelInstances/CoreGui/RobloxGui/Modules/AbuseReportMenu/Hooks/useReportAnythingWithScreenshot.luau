local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Constants = require(AbuseReportMenu.Components.Constants)
local useHideForScreenshot = require(AbuseReportMenu.Hooks.useHideForScreenshot)
local useCaptureScreenshot = require(AbuseReportMenu.Hooks.useCaptureScreenshot)
local reportAnythingReducer = require(AbuseReportMenu.Reducers.reportAnythingReducer)
local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)

return function(p1, p2, p3, p4) -- line: 12
	-- upvalues: TnSIXPWrapper (copy), React (copy), reportAnythingReducer (copy), Constants (copy), useCaptureScreenshot (copy), useHideForScreenshot (copy)
	local v13 = TnSIXPWrapper.getReportAnythingAvatarEnabled()
	local v14 = TnSIXPWrapper.getReportAnythingExperienceEnabled()
	local v15, v16 = React.useReducer(reportAnythingReducer, Constants.ReportAnythingInitialState)
	local v17 = (v13 or v14) and v15.screenshotContentId == ""
	local v18 = useCaptureScreenshot(React.useCallback(function(p5) -- line: 25
		-- upvalues: v16 (copy), Constants (copy)
		v16({
			type = Constants.ReportAnythingActions.SetScreenshotContentId,
			screenshotContentId = p5
		})
	end), React.useCallback(function(p6) -- line: 31
		-- upvalues: v16 (copy), Constants (copy)
		v16({
			type = Constants.ReportAnythingActions.SetScreenshotId,
			screenshotId = p6
		})
	end), React.useCallback(function(p7) -- line: 37
		-- upvalues: v16 (copy), Constants (copy)
		v16({
			type = Constants.ReportAnythingActions.SetIdentificationResults,
			identificationResults = p7
		})
	end))

	useHideForScreenshot(v17, p1, p2, p3, v18, function() -- line: 44
		-- upvalues: p4 (copy), v15 (copy), v16 (copy)
		p4(v15, v16)
	end)

	return v15, v16
end
