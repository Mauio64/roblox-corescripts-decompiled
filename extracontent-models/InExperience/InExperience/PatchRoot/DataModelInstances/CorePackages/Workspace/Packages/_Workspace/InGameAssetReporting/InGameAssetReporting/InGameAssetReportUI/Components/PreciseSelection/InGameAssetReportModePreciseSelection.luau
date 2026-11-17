local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local parent = InGameAssetReporting.Parent

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")

local React = require(parent.React)
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization
local Screenshot = require(parent.Screenshot)
local ScreenshotManager = Screenshot.ScreenshotManager
local LuauPolyfill = require(parent.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout

local Constants = require(InGameAssetReporting.InGameAssetReportUI.Resources.Constants)
local AnalyticsReducer = require(InGameAssetReporting.InGameAssetReportUI.Resources.AnalyticsReducer)
local SceneAnalysis = require(InGameAssetReporting.Analysis.SceneAnalysis)
local InGameAssetReportSubmitDialog = require(InGameAssetReporting.InGameAssetReportUI.Components.InGameAssetReportSubmitDialog)
local InGameAssetReportCompleteModal = require(InGameAssetReporting.InGameAssetReportUI.Components.InGameAssetReportCompleteModal)

local InGameAssetIPInfringementErrorModal = require(InGameAssetReporting.InGameAssetReportUI.Components.InGameAssetIPInfringementErrorModal)

local InGameAssetReportIPInfringementModal = require(InGameAssetReporting.InGameAssetReportUI.Components.InGameAssetReportIPInfringementModal)

local ReportPreciseSelectionLandscapeHeader = require(InGameAssetReporting.InGameAssetReportUI.Components.PreciseSelection.ReportPreciseSelectionLandscapeHeader)

local ReportPreciseSelectionPortraitHeaderFooter = require(InGameAssetReporting.InGameAssetReportUI.Components.PreciseSelection.ReportPreciseSelectionPortraitHeaderFooter)
local buildReport = require(InGameAssetReporting.Utility.buildReport)
local InGameAssetReportAnalytics = require(InGameAssetReporting.InGameAssetReportUI.Resources.InGameAssetReportAnalytics)
local getHighlightModeVariant = require(InGameAssetReporting.Utility.getHighlightModeVariant)

local defineFastFlag = game:DefineFastFlag("PreciseSelectionBugfixesEnabled", false)
local SharedFlags = require(parent.SharedFlags)
local FFlagPrefillPreciseSelectionChoices = SharedFlags.FFlagPrefillPreciseSelectionChoices

local v = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
local url = string.gsub(string.gsub(v, "http:", "https:"), "https://www", "https://apis") .. "rights-management-api/rights/v1/snapshots"

return function(data)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState("")
	local state5, setState5 = React.useState(nil)
	local state6, setState6 = React.useState(true)
	local v2, analyticsDispatch = React.useReducer(AnalyticsReducer, Constants.AnalyticsInitialState)
	local state7, setState7 = React.useState(nil)
	local state8, setState8 = React.useState(nil)
	local state9, setState9 = React.useState(nil)
	local state10, setState10 = React.useState(false)
	local state11, setState11 = React.useState(nil)
	local state12, setState12 = React.useState("")
	local state13, setState13 = React.useState(nil)
	local state14, setState14 = React.useState(false)

	local viewportSize = game.Workspace.CurrentCamera.ViewportSize
	local isSmallPortraitMode = data.getIsSmallPortraitMode(viewportSize)

	React.useEffect(function()
		analyticsDispatch({
			type = Constants.AnalyticsActions.AccumulateForTimeSpent,
			accumulated_time_ms = workspace:GetServerTimeNow() * 1000
		})

		analyticsDispatch({ type = Constants.AnalyticsActions.SetPlaceId, place_id = game.PlaceId })

		setState11(setTimeout(function()
			setState10(true)
		end, 10000))
	end, { setState10, setState11 })

	local onCoachmarkClose = React.useCallback(function()
		setState10(false)

		if state11 then
			clearTimeout(state11)
		end
	end, { setState10, state11 })

	local v3 = React.useCallback(function()
		if defineFastFlag then
			if state4 == "" then
				ScreenshotManager:TakeScreenshotWithCallback(setState4, nil)
			end
		elseif not state4 then
			ScreenshotManager:TakeScreenshotWithCallback(setState4, nil)
		end

		onCoachmarkClose()

		setState(true)

		analyticsDispatch({
			type = Constants.AnalyticsActions.SetViewportInformation,
			viewport_size_x = viewportSize.X,
			viewport_size_y = viewportSize.Y,
			is_portrait_mode = isSmallPortraitMode
		})

		analyticsDispatch({ type = Constants.AnalyticsActions.IncrementNextCount })
	end, {
		setState,
		setState4,
		state4,
		viewportSize,
		isSmallPortraitMode,
		analyticsDispatch,
		onCoachmarkClose
	})

	local nextAction = React.useCallback(function()
		setState5(SceneAnalysis.interpretAndExtractItemsFromInstanceForPreciseSelection(state9))

		v3()
	end, { v3, setState5, state9 })

	local backAction = React.useCallback(function()
		InGameAssetReportAnalytics(v2, 2)
		data.backAction()
	end, { data.backAction, v2 })

	React.useEffect(function()
		if state8 then
			state8:Disconnect()
		end

		setState8((ExperienceStateCaptureService.ItemSelectedInCaptureMode:Connect(function(p)
			setState9(p)

			if p then
				analyticsDispatch({ type = Constants.AnalyticsActions.IncremementAnnotationCount })

				if defineFastFlag then
					onCoachmarkClose()
				end
			end

			if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
				setState5(SceneAnalysis.interpretAndExtractItemsFromInstanceForPreciseSelection(p))
				v3()
			end
		end)))
	end, { setState9, setState8, v3, setState5, analyticsDispatch, onCoachmarkClose })

	local onSubmit = React.useCallback(function(reason_selection: string, surface_selection: string, list)
		if reason_selection == "ip infringement" then
			if not (state5 and state5.extractedAssets) then
				setState13(Constants.IpErrorCodes.ClientNoAssetsExtracted)
				return
			end

			local contents = {}

			for k, list2 in pairs(state5.extractedAssets) do
				for _, id in ipairs(list2) do
					if k == "Package" then
						id = id.id
					end

					if not id then
						continue
					end

					local content_id = string.match(id, "%d+")

					if content_id and content_id ~= "" then
						table.insert(contents, { content_type = "Asset", content_id = content_id })
					end
				end
			end

			if not (#contents > 0) then
				setState13(Constants.IpErrorCodes.ClientNoAssetsExtracted)
				return
			end

			HttpService:RequestInternal({
				Url = url,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
				Body = HttpService:JSONEncode({
					screenshot_id = state4,
					universe_id = game.GameId,
					contents = contents
				})
			}):Start(function(_, p)
				if p.StatusCode == 200 then
					local success, result = pcall(HttpService.JSONDecode, HttpService, p.Body)

					if success and result and result.code then
						setState12(result.code)
						setState3(true)
					else
						setState13(Constants.IpErrorCodes.Unknown)
					end
				else
					local v4 = Constants.IpErrorCodes.Unknown
					local success, result = pcall(HttpService.JSONDecode, HttpService, p.Body)

					if success and result and result.app_error_code and result.app_error_code ~= "" then
						v4 = result.app_error_code
					end

					setState13(v4)
				end
			end)
		else
			setState(false)
			setState2(true)
			analyticsDispatch({
				type = Constants.AnalyticsActions.SetExtractionResults,
				results = state5,
				final_annotation_count = 0
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

			local highlightModeVariant = getHighlightModeVariant()
			analyticsDispatch({
				type = Constants.AnalyticsActions.SetVariant,
				variant = highlightModeVariant
			})

			local report = buildReport(
				Players.LocalPlayer.UserId,
				state4,
				state5,
				reason_selection,
				surface_selection,
				list,
				{},
				nil,
				highlightModeVariant
			)

			if report then
				Players:ReportAbuseV3(Players.LocalPlayer, report)
			end
		end
	end, {
		state5,
		setState,
		setState2,
		state4,
		setState13,
		setState3,
		setState12,
		analyticsDispatch
	})

	local onBack = React.useCallback(function()
		setState5(nil)
		setState(false)
		ExperienceStateCaptureService:ResetHighlight()
	end, { setState, setState5 })

	local onClose = React.useCallback(function()
		setState2(false)
		InGameAssetReportAnalytics(v2, 1)
		data.onReportComplete()
	end, { data.onReportComplete, setState2, v2 })

	local v4 = React.useCallback(function()
		if state6 then
			setState6(false)
		else
			analyticsDispatch({
				type = Constants.AnalyticsActions.SetDidUserResize,
				did_user_resize = true
			})
		end
	end, { state6, state, analyticsDispatch, setState6 })

	React.useEffect(function()
		if state7 then
			state7:Disconnect()
		end

		setState7((UserInputService.InputEnded:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Escape then
				backAction()
			end
		end)))
	end, { backAction, setState7 })

	local onBack2 = React.useCallback(function()
		setState13(nil)
	end, {})

	local onReportExperience = React.useCallback(function()
		setState14(true)

		HttpService:RequestInternal({
			Url = url,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
			Body = HttpService:JSONEncode({
				screenshot_id = state4,
				universe_id = game.GameId,
				contents = {}
			})
		}):Start(function(_, p)
			setState14(false)

			if p.StatusCode == 200 then
				local success, result = pcall(HttpService.JSONDecode, HttpService, p.Body)

				if success and result and result.code then
					setState12(result.code)
					setState13(nil)
					setState3(true)
					return
				end
			end

			setState13(Constants.IpErrorCodes.Unknown)
		end)
	end, { state4, setState12, setState13, setState3, setState14 })

	return withLocalization({
		mainTitle = "Feature.ReportAbuse.Label.HighlightProblemPrecise",
		next = "CommonUI.Controls.Action.Continue",
		coachmarkTitle = "Feature.ReportAbuse.Label.CantSelectTitle",
		coachmarkText = "Feature.ReportAbuse.Label.CantSelectSubtitle"
	})(function(props)
		local createElement = React.createElement
		local v5 = {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = v4
		}

		local createElement2 = React.createElement
		local v6 = {
			Size = UDim2.new(1, 0, 0, 72),
			BackgroundTransparency = 1,
			ZIndex = 2,
			AutoButtonColor = false
		}

		local v7 = {
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
				ReportPreciseSelectionPortraitHeaderFooter.PortraitModeHeader,
				{ titleText = props.mainTitle, nextText = props.next, backAction = backAction }
			)
		else
			inGameAssetReportModeHeader = React.createElement(ReportPreciseSelectionLandscapeHeader, {
				titleText = props.mainTitle,
				nextText = props.next,
				nextAction = nextAction,
				backAction = backAction,
				coachmarkTitle = props.coachmarkTitle,
				coachmarkText = props.coachmarkText,
				isCoachmarkOpen = state10,
				onCoachmarkClose = onCoachmarkClose
			})
		end

		v7.InGameAssetReportModeHeader = inGameAssetReportModeHeader
		local v8 = {
			Header = createElement2("TextButton", v6, v7),
			Footer = 0,
			SubmitDialog = 0,
			ReportCompleteModal = 0,
			IPInfringementModal = 0,
			ErrorModal = 0
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
					ReportPreciseSelectionPortraitHeaderFooter.PortraitModeFooter,
					{
						nextAction = nextAction,
						nextText = props.next,
						isCoachmarkOpen = state10,
						onCoachmarkClose = onCoachmarkClose,
						coachmarkTitle = props.coachmarkTitle,
						coachmarkText = props.coachmarkText
					}
				)
			})
		end

		v8.Footer = footer
		local submitDialog

		if state then
			local createElement3 = React.createElement
			local v9 = {
				screenSize = viewportSize,
				onSubmit = onSubmit,
				onBack = onBack,
				analyticsDispatch = analyticsDispatch,
				extractionResult = nil
			}
			local extractionResult

			if FFlagPrefillPreciseSelectionChoices then
				extractionResult = state5
			end

			v9.extractionResult = extractionResult
			submitDialog = createElement3(InGameAssetReportSubmitDialog, v9)
		end

		v8.SubmitDialog = submitDialog
		local reportCompleteModal

		if state2 then
			reportCompleteModal = React.createElement(InGameAssetReportCompleteModal, {
				screenSize = viewportSize,
				onClose = onClose
			})
		end

		v8.ReportCompleteModal = reportCompleteModal
		local ipInfringementModal

		if state3 then
			ipInfringementModal = React.createElement(InGameAssetReportIPInfringementModal, {
				screenSize = viewportSize,
				reportCode = state12,
				onClose = onClose
			})
		end

		v8.IPInfringementModal = ipInfringementModal
		local errorModal

		if state13 ~= nil then
			errorModal = React.createElement(InGameAssetIPInfringementErrorModal, {
				screenSize = viewportSize,
				onBack = onBack2,
				errorCode = state13,
				onReportExperience = onReportExperience,
				isReportExperienceLoading = state14
			})
		end

		v8.ErrorModal = errorModal
		return createElement("Frame", v5, v8)
	end)
end
