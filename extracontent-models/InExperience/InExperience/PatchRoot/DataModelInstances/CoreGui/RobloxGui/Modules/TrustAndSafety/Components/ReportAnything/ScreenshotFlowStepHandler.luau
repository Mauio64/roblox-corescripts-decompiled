local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local ParentParent = script.Parent.Parent.Parent
local ScreenshotDialog = require(ParentParent.Components.ReportAnything.ScreenshotDialog)
local ScreenshotReviewDialog = require(ParentParent.Components.ReportAnything.ScreenshotReviewDialog)
local GetFFlagReportAnythingLocalizationEnabled = require(ParentParent.Flags.GetFFlagReportAnythingLocalizationEnabled)

local function ScreenshotFlowStepHandler(p1) -- line: 21
	-- upvalues: React (copy), ScreenshotReviewDialog (copy), GetFFlagReportAnythingLocalizationEnabled (copy), RobloxTranslator (copy), ScreenshotDialog (copy)
	local v10, v11 = React.useState(if p1.initialPageNumber ~= nil then p1.initialPageNumber else 1)
	local v12, v13 = React.useState(1.7777777777777777)
	local v14, v15 = React.useState(800)
	local v16, v17 = React.useState(800)
	local v18, v19 = React.useState(true)
	local v20 = React.useCallback(function() -- line: 28
		-- upvalues: v11 (copy)
		v11(2)
	end, { v11 })
	local v21 = React.useCallback(function() -- line: 31
		-- upvalues: v11 (copy)
		v11(1)
	end, { v11 })

	React.useEffect(function() -- line: 35
		-- upvalues: v13 (copy), v15 (copy), v17 (copy), v19 (copy), p1 (copy)
		local CurrentCamera = game.Workspace.CurrentCamera

		if CurrentCamera ~= nil then
			local ViewportSize = CurrentCamera.ViewportSize

			v13(ViewportSize.X / ViewportSize.Y)
			v15(ViewportSize.Y)
			v17(ViewportSize.X)
			v19(ViewportSize.X < ViewportSize.Y and ViewportSize.X < 800)

			if p1.reportAnythingAnalytics and ViewportSize.X < ViewportSize.Y then
				p1.reportAnythingAnalytics.setIsPortraitMode()
			end
		end
	end, {})

	if v10 == 1 then
		return (React.createElement(ScreenshotReviewDialog, {
			imageAspectRatio = v12,
			isSmallPortraitMode = v18,
			viewportHeight = v14,
			viewportWidth = v16,
			onNextPage = v20,
			onBack = p1.dismissAction,
			onSkip = p1.skipAnnotationAction,
			onRestart = p1.restartAction,
			screenshot = p1.screenshot,
			reportAnythingAnalytics = p1.reportAnythingAnalytics
		}, {}))
	end

	local v22 = p1.entryPoint ~= "player" and "Select Problem in Scene" or "Select Person in Scene"

	if GetFFlagReportAnythingLocalizationEnabled() then
		v22 = p1.entryPoint == "player" and RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectPerson") or RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectProblem")
	end

	return (React.createElement(ScreenshotDialog, {
		titleText = v22,
		backAction = v21,
		dismissAction = p1.dismissAction,
		reportAction = p1.reportAction,
		initialAnnotationPoints = p1.initialAnnotationPoints,
		isSmallPortraitMode = v18,
		screenshot = p1.screenshot,
		imageAspectRatio = v12,
		reportAnythingAnalytics = p1.reportAnythingAnalytics
	}))
end

return ScreenshotFlowStepHandler
