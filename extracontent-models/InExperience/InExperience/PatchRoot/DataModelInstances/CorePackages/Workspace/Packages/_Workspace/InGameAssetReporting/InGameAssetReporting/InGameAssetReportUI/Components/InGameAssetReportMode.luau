local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local parent = InGameAssetReporting.Parent

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization
local Screenshot = require(parent.Screenshot)
local ScreenshotManager = Screenshot.ScreenshotManager

local Constants = require(InGameAssetReporting.InGameAssetReportUI.Resources.Constants)
local AnalyticsReducer = require(InGameAssetReporting.InGameAssetReportUI.Resources.AnalyticsReducer)
local SceneAnalysis = require(InGameAssetReporting.Analysis.SceneAnalysis)
local InGameAssetReportSubmitDialog = require(InGameAssetReporting.InGameAssetReportUI.Components.InGameAssetReportSubmitDialog)
local InGameAssetReportErrorModal = require(InGameAssetReporting.InGameAssetReportUI.Components.InGameAssetReportErrorModal)
local InGameAssetReportCompleteModal = require(InGameAssetReporting.InGameAssetReportUI.Components.InGameAssetReportCompleteModal)
local InGameAssetReportLandscapeHeader = require(InGameAssetReporting.InGameAssetReportUI.Components.InGameAssetReportLandscapeHeader)

local InGameAssetReportPortraitHeaderFooter = require(InGameAssetReporting.InGameAssetReportUI.Components.InGameAssetReportPortraitHeaderFooter)
local ScreenshotHighlighter = require(InGameAssetReporting.InGameAssetReportUI.Components.ScreenshotHighlighter)
local buildReport = require(InGameAssetReporting.Utility.buildReport)
local InGameAssetReportAnalytics = require(InGameAssetReporting.InGameAssetReportUI.Resources.InGameAssetReportAnalytics)

local function fn(p)
	return p.point
end

local function fn2(p)
	return p.interpretationResult
end

return function(data)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState({})
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState(false)
	local state6, setState6 = React.useState("")
	local state7, setState7 = React.useState(nil)
	local state8, setState8 = React.useState(nil)
	local state9, setState9 = React.useState(true)
	local v, analyticsDispatch = React.useReducer(AnalyticsReducer, Constants.AnalyticsInitialState)
	local state10, setState10 = React.useState(nil)

	local viewportSize = game.Workspace.CurrentCamera.ViewportSize
	local isSmallPortraitMode = data.getIsSmallPortraitMode(viewportSize)

	React.useEffect(function()
		analyticsDispatch({
			type = Constants.AnalyticsActions.AccumulateForTimeSpent,
			accumulated_time_ms = workspace:GetServerTimeNow() * 1000
		})

		analyticsDispatch({ type = Constants.AnalyticsActions.SetPlaceId, place_id = game.PlaceId })
	end, {})

	local handleNewAnnotationPoint = React.useCallback(function(point: Vector2, p: number)
		local v2 = {
			point = point,
			interpretationResult = SceneAnalysis.interpretAnnotation(
				point * viewportSize,
				p * math.max(viewportSize.X, viewportSize.Y),
				function() end
			)
		}

		v2.signalConnection = ExperienceStateCaptureService.ItemSelectedInCaptureMode:Once(function(engineSignalItem)
			v2.engineSignalItem = engineSignalItem
		end)

		for _, v3 in ipairs(state) do
			v3.signalConnection:Disconnect()
		end

		if #state == 0 and state6 == "" then
			ScreenshotManager:TakeScreenshotWithCallback(setState6, nil)
		end

		local clone = table.clone(state)
		table.insert(clone, v2)
		setState(clone)
		setState2({})

		analyticsDispatch({ type = Constants.AnalyticsActions.IncremementAnnotationCount })

		task.defer(v2.interpretationResult.raycastComputation)
	end, { state, setState, setState2, state6 })

	local undoAnnotationPoints = React.useCallback(function()
		if #state > 0 then
			local clone = table.clone(state)
			local clone2 = table.clone(state2)

			table.insert(clone2, table.remove(clone))

			setState2(clone2)
			setState(clone)

			analyticsDispatch({ type = Constants.AnalyticsActions.IncremementAnnotationUndoCount })
		end
	end, { setState, state, setState2, state2 })

	local redoAnnotationPoints = React.useCallback(function()
		if #state2 > 0 then
			local clone = table.clone(state)
			local clone2 = table.clone(state2)

			table.insert(clone, table.remove(clone2))

			setState2(clone2)
			setState(clone)

			analyticsDispatch({ type = Constants.AnalyticsActions.IncremementAnnotationRedoCount })
		end
	end, { state, state2 })

	local nextAction = React.useCallback(function()
		if #state == 0 and state6 == "" then
			ScreenshotManager:TakeScreenshotWithCallback(setState6, nil)
		end

		local mapped = Cryo.List.map(state, function(p)
			return p.engineSignalItem
		end)

		local v2 = { (SceneAnalysis.interpretInstanceListForGUIObjects(mapped)) }
		local itemsFromInterpretations = SceneAnalysis.extractItemsFromInterpretations(v2, function() end)

		setState8(itemsFromInterpretations)
		task.defer(itemsFromInterpretations.computation)

		local mapped2 = Cryo.List.map(state, fn2)
		local itemsFromInterpretations2 = SceneAnalysis.extractItemsFromInterpretations(mapped2, function() end)
		setState7(itemsFromInterpretations2)
		setState3(true)

		analyticsDispatch({
			type = Constants.AnalyticsActions.SetViewportInformation,
			viewport_size_x = viewportSize.X,
			viewport_size_y = viewportSize.Y,
			is_portrait_mode = isSmallPortraitMode
		})

		analyticsDispatch({ type = Constants.AnalyticsActions.IncrementNextCount })

		task.defer(itemsFromInterpretations2.computation)
	end, { state, setState3, setState7, state6, viewportSize, isSmallPortraitMode })

	local backAction = React.useCallback(function()
		InGameAssetReportAnalytics(v, 2)
		data.backAction()
	end, { data.backAction, v })

	local mapped = Cryo.List.map(state, fn)

	local onSubmit = React.useCallback(function(reason_selection: string, surface_selection: string, list)
		setState3(false)
		setState4(true)

		analyticsDispatch({
			type = Constants.AnalyticsActions.SetExtractionResults,
			results = state7,
			final_annotation_count = #state
		})

		analyticsDispatch({
			type = Constants.AnalyticsActions.SetReasonSelection,
			reason_selection = reason_selection
		})

		analyticsDispatch({
			type = Constants.AnalyticsActions.SetSurfaceSelection,
			surface_selection = surface_selection
		})

		analyticsDispatch({
			type = Constants.AnalyticsActions.SetCommentAdded,
			comment_added = #list > 0
		})

		local report = buildReport(
			Players.LocalPlayer.UserId,
			state6,
			state7,
			reason_selection,
			surface_selection,
			list,
			mapped,
			state8
		)

		if report then
			Players:ReportAbuseV3(Players.LocalPlayer, report)
		end
	end, { state7, state8, setState3, setState4, state6, state, mapped })

	local onBack = React.useCallback(function()
		setState7(nil)
		setState3(false)
	end, { setState3, setState7 })

	local onClose = React.useCallback(function()
		setState4(false)
		InGameAssetReportAnalytics(v, 1)
		data.onReportComplete()
	end, { data.onReportComplete, state, setState4, v })

	local onExceedMaxAnnotationLimit = React.useCallback(function()
		for _, v2 in ipairs(state) do
			v2.signalConnection:Disconnect()
		end

		setState5(true)
	end, { setState5, state })

	local onBack2 = React.useCallback(function()
		setState5(false)
	end, {})

	local v2 = React.useCallback(function()
		if state9 then
			setState9(false)
		else
			analyticsDispatch({
				type = Constants.AnalyticsActions.SetDidUserResize,
				did_user_resize = true
			})
		end

		if not state3 then
			setState({})
			setState2({})
		end
	end, { state9, state3 })

	local isUndoEnabled = #state > 0
	local isRedoEnabled = #state2 > 0

	React.useEffect(function()
		if state10 then
			state10:Disconnect()
		end

		setState10((UserInputService.InputEnded:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Escape then
				backAction()
			end
		end)))
	end, { backAction })

	return withLocalization({
		mainTitle = "Feature.ReportAbuse.Label.HighlightProblem",
		next = "CommonUI.Controls.Action.Continue"
	})(function(p)
		local createElement = React.createElement
		local v3 = {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = v2
		}

		local createElement2 = React.createElement
		local v4 = {
			Size = UDim2.new(1, 0, 0, 72),
			BackgroundTransparency = 1,
			ZIndex = 2,
			AutoButtonColor = false
		}

		local v5 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			InGameAssetReportModeHeader = 0
		}
		local inGameAssetReportModeHeader

		if isSmallPortraitMode then
			inGameAssetReportModeHeader = React.createElement(
				InGameAssetReportPortraitHeaderFooter.PortraitModeHeader,
				{
					titleText = p.mainTitle,
					nextText = p.next,
					backAction = backAction,
					undoAnnotationPoints = undoAnnotationPoints,
					redoAnnotationPoints = redoAnnotationPoints,
					isRedoEnabled = isRedoEnabled,
					isUndoEnabled = isUndoEnabled,
					annotationPoints = state
				}
			)
		else
			inGameAssetReportModeHeader = React.createElement(InGameAssetReportLandscapeHeader, {
				titleText = p.mainTitle,
				nextText = p.next,
				nextAction = nextAction,
				backAction = backAction,
				undoAnnotationPoints = undoAnnotationPoints,
				redoAnnotationPoints = redoAnnotationPoints,
				isRedoEnabled = isRedoEnabled,
				isUndoEnabled = isUndoEnabled,
				annotationPoints = state
			})
		end

		v5.InGameAssetReportModeHeader = inGameAssetReportModeHeader
		local children = {
			Header = createElement2("TextButton", v4, v5),
			Footer = 0,
			ScreenshotAnnotation = 0,
			ErrorStateModal = 0,
			SubmitDialog = 0,
			ReportCompleteModal = 0
		}
		local footer

		if isSmallPortraitMode then
			footer = React.createElement("TextButton", {
				Size = UDim2.new(1, 0, 0, 60),
				Position = UDim2.new(0, 0, 1, -60),
				ZIndex = 2,
				BackgroundTransparency = 1,
				AutoButtonColor = false
			}, {
				InGameAssetReportModeFooter = React.createElement(
					InGameAssetReportPortraitHeaderFooter.PortraitModeFooter,
					{ nextAction = nextAction, annotationPoints = state, nextText = p.next }
				)
			})
		end

		children.Footer = footer

		children.ScreenshotAnnotation = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 1
			},
			{
				Highlighter = React.createElement(
					ScreenshotHighlighter,
					{
						annotationPoints = mapped,
						handleNewAnnotationPoint = handleNewAnnotationPoint,
						onExceedMaxAnnotationLimit = onExceedMaxAnnotationLimit,
						ZIndex = 2
					},
					{}
				)
			}
		)
		local errorStateModal

		if state5 then
			errorStateModal = React.createElement(InGameAssetReportErrorModal, {
				screenSize = viewportSize,
				onBack = onBack2
			})
		end

		children.ErrorStateModal = errorStateModal
		local submitDialog

		if state3 then
			submitDialog = React.createElement(InGameAssetReportSubmitDialog, {
				screenSize = viewportSize,
				onSubmit = onSubmit,
				onBack = onBack,
				analyticsDispatch = analyticsDispatch
			})
		end

		children.SubmitDialog = submitDialog
		local reportCompleteModal

		if state4 then
			reportCompleteModal = React.createElement(InGameAssetReportCompleteModal, {
				screenSize = viewportSize,
				onClose = onClose
			})
		end

		children.ReportCompleteModal = reportCompleteModal
		return createElement("Frame", v3, children)
	end)
end
