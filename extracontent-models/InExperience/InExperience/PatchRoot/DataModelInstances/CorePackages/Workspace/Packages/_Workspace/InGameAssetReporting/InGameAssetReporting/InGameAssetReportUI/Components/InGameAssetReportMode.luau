local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local InGameAssetReportingParent = InGameAssetReporting.Parent
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local Cryo = require(InGameAssetReportingParent.Cryo)
local React = require(InGameAssetReportingParent.React)
local withLocalization = require(InGameAssetReportingParent.Localization).withLocalization
local ScreenshotManager = require(InGameAssetReportingParent.Screenshot).ScreenshotManager
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

local function v21(p1) -- line: 43
	return p1.point
end
local function v22(p2) -- line: 47
	return p2.interpretationResult
end

return function(t1: {[any]: any}) -- line: 51
	-- upvalues: React (copy), AnalyticsReducer (copy), Constants (copy), SceneAnalysis (copy), ExperienceStateCaptureService (copy), ScreenshotManager (copy), Cryo (copy), v22 (copy), InGameAssetReportAnalytics (copy), v21 (copy), buildReport (copy), Players (copy), UserInputService (copy), withLocalization (copy), InGameAssetReportPortraitHeaderFooter (copy), InGameAssetReportLandscapeHeader (copy), ScreenshotHighlighter (copy), InGameAssetReportErrorModal (copy), InGameAssetReportSubmitDialog (copy), InGameAssetReportCompleteModal (copy)
	local v26, v27 = React.useState({})
	local v28, v29 = React.useState({})
	local v30, v31 = React.useState(false)
	local v32, v33 = React.useState(false)
	local v34, v35 = React.useState(false)
	local v36, v37 = React.useState("")
	local v38, v39 = React.useState(nil)
	local v40, v41 = React.useState(nil)
	local v42, v43 = React.useState(true)
	local v44, v45 = React.useReducer(AnalyticsReducer, Constants.AnalyticsInitialState)
	local v46, v47 = React.useState(nil)
	local ViewportSize = game.Workspace.CurrentCamera.ViewportSize
	local v49 = t1.getIsSmallPortraitMode(ViewportSize)

	React.useEffect(function() -- line: 70
		-- upvalues: v45 (copy), Constants (copy)
		v45({
			type = Constants.AnalyticsActions.AccumulateForTimeSpent,
			accumulated_time_ms = workspace:GetServerTimeNow() * 1000
		})
		v45({
			type = Constants.AnalyticsActions.SetPlaceId,
			place_id = game.PlaceId
		})
	end, {})

	local v50 = React.useCallback(function(vector2: Vector2, n1: number) -- line: 82
		-- upvalues: SceneAnalysis (copy), ViewportSize (copy), ExperienceStateCaptureService (copy), v26 (copy), v36 (copy), ScreenshotManager (copy), v37 (copy), v27 (copy), v29 (copy), v45 (copy), Constants (copy)
		local t2 = {
			point = vector2,
			interpretationResult = SceneAnalysis.interpretAnnotation(vector2 * ViewportSize, n1 * math.max(ViewportSize.X, ViewportSize.Y), function() -- line: 88
			end)
		}

		t2.signalConnection = ExperienceStateCaptureService.ItemSelectedInCaptureMode:Once(function(p3) -- line: 92
			-- upvalues: t2 (copy)
			t2.engineSignalItem = p3
		end)

		for _, v in ipairs(v26) do
			v.signalConnection:Disconnect()
		end

		if #v26 == 0 and v36 == "" then
			ScreenshotManager:TakeScreenshotWithCallback(v37, nil)
		end

		local v69 = table.clone(v26)

		table.insert(v69, t2)
		v27(v69)
		v29({})
		v45({
			type = Constants.AnalyticsActions.IncremementAnnotationCount
		})
		task.defer(t2.interpretationResult.raycastComputation)
	end, {
		v26,
		v27,
		v29,
		v36
	})
	local v51 = React.useCallback(function() -- line: 119
		-- upvalues: v26 (copy), v28 (copy), v29 (copy), v27 (copy), v45 (copy), Constants (copy)
		if #v26 > 0 then
			local v70 = table.clone(v26)
			local v71 = table.clone(v28)

			table.insert(v71, table.remove(v70))
			v29(v71)
			v27(v70)
			v45({
				type = Constants.AnalyticsActions.IncremementAnnotationUndoCount
			})
		end
	end, {
		v27,
		v26,
		v29,
		v28
	})
	local v52 = React.useCallback(function() -- line: 136
		-- upvalues: v28 (copy), v26 (copy), v29 (copy), v27 (copy), v45 (copy), Constants (copy)
		if #v28 > 0 then
			local v72 = table.clone(v26)
			local v73 = table.clone(v28)

			table.insert(v72, table.remove(v73))
			v29(v73)
			v27(v72)
			v45({
				type = Constants.AnalyticsActions.IncremementAnnotationRedoCount
			})
		end
	end, {
		v26,
		v28
	})
	local v53 = React.useCallback(function() -- line: 155
		-- upvalues: v26 (copy), v36 (copy), ScreenshotManager (copy), v37 (copy), Cryo (copy), SceneAnalysis (copy), v41 (copy), v22 (copy), v39 (copy), v31 (copy), v45 (copy), Constants (copy), ViewportSize (copy), v49 (copy)
		if #v26 == 0 and v36 == "" then
			ScreenshotManager:TakeScreenshotWithCallback(v37, nil)
		end

		local v74 = Cryo.List.map(v26, function(p4) -- line: 161
			return p4.engineSignalItem
		end)
		local v75 = SceneAnalysis.interpretInstanceListForGUIObjects(v74)
		local v76 = SceneAnalysis.extractItemsFromInterpretations({ v75 }, function() -- line: 167
		end)

		v41(v76)
		task.defer(v76.computation)

		local v77 = Cryo.List.map(v26, v22)
		local v78 = SceneAnalysis.extractItemsFromInterpretations(v77, function() -- line: 173
		end)

		v39(v78)
		v31(true)
		v45({
			type = Constants.AnalyticsActions.SetViewportInformation,
			viewport_size_x = ViewportSize.X,
			viewport_size_y = ViewportSize.Y,
			is_portrait_mode = v49
		})
		v45({
			type = Constants.AnalyticsActions.IncrementNextCount
		})
		task.defer(v78.computation)
	end, {
		v26,
		v31,
		v39,
		v36,
		ViewportSize,
		v49
	})
	local v54 = React.useCallback(function() -- line: 191
		-- upvalues: InGameAssetReportAnalytics (copy), v44 (copy), t1 (copy)
		InGameAssetReportAnalytics(v44, 2)
		t1.backAction()
	end, {
		t1.backAction,
		v44
	})
	local v55 = Cryo.List.map(v26, v21)
	local v56 = React.useCallback(function(s1: string, s2: string, p5) -- line: 203
		-- upvalues: v31 (copy), v33 (copy), v45 (copy), Constants (copy), v38 (copy), v26 (copy), buildReport (copy), Players (copy), v36 (copy), v55 (copy), v40 (copy)
		v31(false)
		v33(true)
		v45({
			type = Constants.AnalyticsActions.SetExtractionResults,
			results = v38,
			final_annotation_count = #v26
		})
		v45({
			type = Constants.AnalyticsActions.SetReasonSelection,
			reason_selection = s1
		})
		v45({
			type = Constants.AnalyticsActions.SetSurfaceSelection,
			surface_selection = s2
		})
		v45({
			type = Constants.AnalyticsActions.SetCommentAdded,
			comment_added = #p5 > 0
		})

		local v82 = buildReport(Players.LocalPlayer.UserId, v36, v38, s1, s2, p5, v55, v40)

		if v82 then
			Players:ReportAbuseV3(Players.LocalPlayer, v82)
		end
	end, {
		v38,
		v40,
		v31,
		v33,
		v36,
		v26,
		v55
	})
	local v57 = React.useCallback(function() -- line: 255
		-- upvalues: v39 (copy), v31 (copy)
		v39(nil)
		v31(false)
	end, {
		v31,
		v39
	})
	local v58 = React.useCallback(function() -- line: 261
		-- upvalues: v33 (copy), InGameAssetReportAnalytics (copy), v44 (copy), t1 (copy)
		v33(false)
		InGameAssetReportAnalytics(v44, 1)
		t1.onReportComplete()
	end, {
		t1.onReportComplete,
		v26,
		v33,
		v44
	})
	local v59 = React.useCallback(function() -- line: 268
		-- upvalues: v26 (copy), v35 (copy)
		for _, v in ipairs(v26) do
			v.signalConnection:Disconnect()
		end

		v35(true)
	end, {
		v35,
		v26
	})
	local v60 = React.useCallback(function() -- line: 279
		-- upvalues: v35 (copy)
		v35(false)
	end, {})
	local v61 = React.useCallback(function() -- line: 283
		-- upvalues: v42 (copy), v43 (copy), v45 (copy), Constants (copy), v30 (copy), v27 (copy), v29 (copy)
		if v42 then
			v43(false)
		else
			v45({
				did_user_resize = true,
				type = Constants.AnalyticsActions.SetDidUserResize
			})
		end

		if not v30 then
			v27({})
			v29({})
		end
	end, {
		v42,
		v30
	})
	local v62 = #v26 > 0
	local v63 = #v28 > 0

	React.useEffect(function() -- line: 305
		-- upvalues: v46 (copy), UserInputService (copy), v54 (copy), v47 (copy)
		if v46 then
			v46:Disconnect()
		end

		local connection = UserInputService.InputEnded:Connect(function(input) -- line: 310
			-- upvalues: v54 (copy)
			if input.KeyCode == Enum.KeyCode.Escape then
				v54()
			end
		end)

		v47(connection)
	end, { v54 })

	return withLocalization({
		mainTitle = "Feature.ReportAbuse.Label.HighlightProblem",
		next = "Feature.ReportAbuse.Action.Next"
	})(function(p6) -- line: 322
		-- upvalues: React (copy), v61 (copy), v49 (copy), InGameAssetReportPortraitHeaderFooter (copy), v54 (copy), v51 (copy), v52 (copy), v63 (copy), v62 (copy), v26 (copy), InGameAssetReportLandscapeHeader (copy), v53 (copy), ScreenshotHighlighter (copy), v55 (copy), v50 (copy), v59 (copy), v34 (copy), InGameAssetReportErrorModal (copy), ViewportSize (copy), v60 (copy), v30 (copy), InGameAssetReportSubmitDialog (copy), v56 (copy), v57 (copy), v45 (copy), v32 (copy), InGameAssetReportCompleteModal (copy), v58 (copy)
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = v61
		}, {
			Header = React.createElement("TextButton", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 0, 72)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				InGameAssetReportModeHeader = if not v49 then React.createElement(InGameAssetReportLandscapeHeader, {
					titleText = p6.mainTitle,
					nextText = p6.next,
					nextAction = v53,
					backAction = v54,
					undoAnnotationPoints = v51,
					redoAnnotationPoints = v52,
					isRedoEnabled = v63,
					isUndoEnabled = v62,
					annotationPoints = v26
				}) else React.createElement(InGameAssetReportPortraitHeaderFooter.PortraitModeHeader, {
					titleText = p6.mainTitle,
					nextText = p6.next,
					backAction = v54,
					undoAnnotationPoints = v51,
					redoAnnotationPoints = v52,
					isRedoEnabled = v63,
					isUndoEnabled = v62,
					annotationPoints = v26
				})
			}),
			Footer = if not v49 then nil else React.createElement("TextButton", {
				ZIndex = 2,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 0, 60),
				Position = UDim2.new(0, 0, 1, -60)
			}, {
				InGameAssetReportModeFooter = React.createElement(InGameAssetReportPortraitHeaderFooter.PortraitModeFooter, {
					nextAction = v53,
					annotationPoints = v26,
					nextText = p6.next
				})
			}),
			ScreenshotAnnotation = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				ZIndex = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Highlighter = React.createElement(ScreenshotHighlighter, {
					ZIndex = 2,
					annotationPoints = v55,
					handleNewAnnotationPoint = v50,
					onExceedMaxAnnotationLimit = v59
				}, {})
			}),
			ErrorStateModal = if not v34 then nil else React.createElement(InGameAssetReportErrorModal, {
				screenSize = ViewportSize,
				onBack = v60
			}),
			SubmitDialog = if not v30 then nil else React.createElement(InGameAssetReportSubmitDialog, {
				screenSize = ViewportSize,
				onSubmit = v56,
				onBack = v57,
				analyticsDispatch = v45
			}),
			ReportCompleteModal = if not v32 then nil else React.createElement(InGameAssetReportCompleteModal, {
				screenSize = ViewportSize,
				onClose = v58
			})
		})
	end)
end
