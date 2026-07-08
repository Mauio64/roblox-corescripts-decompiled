local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local ParentParent = script.Parent.Parent
local ScreenshotDialog = require(ParentParent.Components.ScreenshotDialog)
local ScreenshotReviewDialog = require(ParentParent.Components.ScreenshotReviewDialog)

require(script.Parent.Parent.Parent.Components.Types)

local GetFFlagAvatarIdentificationSafeAreaFix = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAvatarIdentificationSafeAreaFix

local function ScreenshotFlowStepHandler(p1) -- line: 28
	-- upvalues: React (copy), GetFFlagAvatarIdentificationSafeAreaFix (copy), ScreenshotReviewDialog (copy), RobloxTranslator (copy), ScreenshotDialog (copy)
	local v10, v11 = React.useState(if p1.initialPageNumber ~= nil then p1.initialPageNumber else 1)
	local v12, v13 = React.useState(1.7777777777777777)
	local v14, v15 = React.useState(800)
	local v16, v17 = React.useState(800)
	local v18, v19 = React.useState(true)
	local v20 = React.useCallback(function() -- line: 35
		-- upvalues: v11 (copy)
		v11(2)
	end, { v11 })
	local v21 = React.useCallback(function() -- line: 38
		-- upvalues: v11 (copy)
		v11(1)
	end, { v11 })

	React.useEffect(function() -- line: 42
		-- upvalues: GetFFlagAvatarIdentificationSafeAreaFix (copy), p1 (copy), v13 (copy), v15 (copy), v17 (copy), v19 (copy)
		local CurrentCamera = game.Workspace.CurrentCamera

		if CurrentCamera ~= nil then
			local viewportSize = CurrentCamera.viewportSize

			if GetFFlagAvatarIdentificationSafeAreaFix() and p1.viewportInfo then
				v13(p1.viewportInfo.width / p1.viewportInfo.height)
			else
				v13(viewportSize.X / viewportSize.Y)
			end

			v15(viewportSize.Y)
			v17(viewportSize.X)
			v19(viewportSize.X < viewportSize.Y and viewportSize.X < 800)
		end
	end, {})

	if v10 == 1 then
		return (React.createElement(ScreenshotReviewDialog, {
			imageAspectRatio = v12,
			isSmallPortraitMode = v18,
			viewportUISafeAreaHeight = v14,
			viewportUISafeAreaWidth = v16,
			onNextPage = v20,
			onBack = p1.dismissAction,
			onSkip = p1.skipAnnotationAction,
			onRestart = p1.restartAction,
			screenshot = p1.screenshot,
			reportAnythingAnalytics = p1.reportAnythingAnalytics
		}, {}))
	end

	local v22 = if p1.entryPoint ~= "player" then RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectProblem") else RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectPerson")

	return (React.createElement(ScreenshotDialog, {
		titleText = v22,
		backAction = v21,
		dismissAction = p1.dismissAction,
		finishAnnotationAction = p1.finishAnnotationAction,
		initialAnnotationPoints = p1.initialAnnotationPoints,
		isSmallPortraitMode = v18,
		screenshot = p1.screenshot,
		imageAspectRatio = v12,
		setAnnotationCircleRadius = p1.setAnnotationCircleRadius,
		setAnnotationAreaDimensions = p1.setAnnotationAreaDimensions,
		reportAnythingAnalytics = p1.reportAnythingAnalytics
	}))
end

return ScreenshotFlowStepHandler
