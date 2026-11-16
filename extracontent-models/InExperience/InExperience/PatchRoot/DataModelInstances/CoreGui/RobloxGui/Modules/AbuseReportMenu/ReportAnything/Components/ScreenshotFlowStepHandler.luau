local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local parent = script.Parent.Parent
local ScreenshotDialog = require(parent.Components.ScreenshotDialog)
local ScreenshotReviewDialog = require(parent.Components.ScreenshotReviewDialog)

require(script.Parent.Parent.Parent.Components.Types)

local function ScreenshotFlowStepHandler(props)
	local state, setState = React.useState(props.initialPageNumber == nil and 1 or props.initialPageNumber)
	local state2, setState2 = React.useState(16 / 9)
	local state3, setState3 = React.useState(800)
	local state4, setState4 = React.useState(800)
	local state5, setState5 = React.useState(true)
	local onNextPage = React.useCallback(function()
		setState(2)
	end, { setState })
	local backAction = React.useCallback(function()
		setState(1)
	end, { setState })

	React.useEffect(function()
		local currentCamera = game.Workspace.CurrentCamera

		if currentCamera ~= nil then
			local viewportSize = currentCamera.viewportSize

			if props.viewportInfo then
				setState2(props.viewportInfo.width / props.viewportInfo.height)
			else
				setState2(viewportSize.X / viewportSize.Y)
			end

			setState3(viewportSize.Y)
			setState4(viewportSize.X)
			setState5(viewportSize.X < viewportSize.Y and viewportSize.X < 800)
		end
	end, {})

	if state == 1 then
		return (React.createElement(ScreenshotReviewDialog, {
			imageAspectRatio = state2,
			isSmallPortraitMode = state5,
			viewportUISafeAreaHeight = state3,
			viewportUISafeAreaWidth = state4,
			onNextPage = onNextPage,
			onBack = props.dismissAction,
			onSkip = props.skipAnnotationAction,
			onRestart = props.restartAction,
			screenshot = props.screenshot,
			reportAnythingAnalytics = props.reportAnythingAnalytics
		}, {}))
	end

	local titleText

	if props.entryPoint == "player" then
		titleText = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectPerson")
	else
		titleText = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectProblem")
	end

	return (React.createElement(ScreenshotDialog, {
		titleText = titleText,
		backAction = backAction,
		dismissAction = props.dismissAction,
		finishAnnotationAction = props.finishAnnotationAction,
		initialAnnotationPoints = props.initialAnnotationPoints,
		isSmallPortraitMode = state5,
		screenshot = props.screenshot,
		imageAspectRatio = state2,
		setAnnotationCircleRadius = props.setAnnotationCircleRadius,
		setAnnotationAreaDimensions = props.setAnnotationAreaDimensions,
		reportAnythingAnalytics = props.reportAnythingAnalytics
	}))
end

return ScreenshotFlowStepHandler
