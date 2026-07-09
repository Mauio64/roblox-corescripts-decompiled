local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local InGameAssetReportingParent = InGameAssetReporting.Parent
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local React = require(InGameAssetReportingParent.React)
local withLocalization = require(InGameAssetReportingParent.Localization).withLocalization
local ScreenshotManager = require(InGameAssetReportingParent.Screenshot).ScreenshotManager
local LuauPolyfill = require(InGameAssetReportingParent.LuauPolyfill)
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
local v26 = game:DefineFastFlag("PreciseSelectionBugfixesEnabled", false)
local FFlagPrefillPreciseSelectionChoices = require(InGameAssetReportingParent.SharedFlags).FFlagPrefillPreciseSelectionChoices
local FFlagReportIPInfringement = require(InGameAssetReportingParent.SharedFlags).FFlagReportIPInfringement
local v29 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
local v30 = string.gsub(string.gsub(v29, "http:", "https:"), "https://www", "https://apis") .. "rights-management-api/rights/v1/snapshots"

return function(t1: {[any]: any}) -- line: 57
	-- upvalues: React (copy), AnalyticsReducer (copy), Constants (copy), setTimeout (copy), clearTimeout (copy), v26 (copy), ScreenshotManager (copy), SceneAnalysis (copy), InGameAssetReportAnalytics (copy), ExperienceStateCaptureService (copy), UserInputService (copy), FFlagReportIPInfringement (copy), HttpService (copy), v30 (copy), getHighlightModeVariant (copy), buildReport (copy), Players (copy), withLocalization (copy), ReportPreciseSelectionPortraitHeaderFooter (copy), ReportPreciseSelectionLandscapeHeader (copy), InGameAssetReportSubmitDialog (copy), FFlagPrefillPreciseSelectionChoices (copy), InGameAssetReportCompleteModal (copy), InGameAssetReportIPInfringementModal (copy), InGameAssetIPInfringementErrorModal (copy)
	local v32, v33 = React.useState(false)
	local v34, v35 = React.useState(false)
	local v36, v37 = React.useState(false)
	local v38, v39 = React.useState("")
	local v40, v41 = React.useState(nil)
	local v42, v43 = React.useState(true)
	local v44, v45 = React.useReducer(AnalyticsReducer, Constants.AnalyticsInitialState)
	local v46, v47 = React.useState(nil)
	local v48, v49 = React.useState(nil)
	local v50, v51 = React.useState(nil)
	local v52, v53 = React.useState(false)
	local v54, v55 = React.useState(nil)
	local v56, v57 = React.useState("")
	local v58, v59 = React.useState(nil)
	local v60, v61 = React.useState(false)
	local ViewportSize = game.Workspace.CurrentCamera.ViewportSize
	local v63 = t1.getIsSmallPortraitMode(ViewportSize)

	React.useEffect(function() -- line: 79
		-- upvalues: v45 (copy), Constants (copy), v55 (copy), setTimeout (copy), v53 (copy)
		v45({
			type = Constants.AnalyticsActions.AccumulateForTimeSpent,
			accumulated_time_ms = workspace:GetServerTimeNow() * 1000
		})
		v45({
			type = Constants.AnalyticsActions.SetPlaceId,
			place_id = game.PlaceId
		})
		v55(setTimeout(function() -- line: 88
			-- upvalues: v53 (copy)
			v53(true)
		end, 10000))
	end, {
		v53,
		v55
	})

	local v64 = React.useCallback(function() -- line: 93
		-- upvalues: v53 (copy), v54 (copy), clearTimeout (copy)
		v53(false)

		if v54 then
			clearTimeout(v54)
		end
	end, {
		v53,
		v54
	})
	local v65 = React.useCallback(function() -- line: 101
		-- upvalues: v26 (copy), v38 (copy), ScreenshotManager (copy), v39 (copy), v64 (copy), v33 (copy), v45 (copy), Constants (copy), ViewportSize (copy), v63 (copy)
		if v26 then
			if v38 == "" then
				ScreenshotManager:TakeScreenshotWithCallback(v39, nil)
			end
		elseif not v38 then
			ScreenshotManager:TakeScreenshotWithCallback(v39, nil)
		end

		v64()
		v33(true)
		v45({
			type = Constants.AnalyticsActions.SetViewportInformation,
			viewport_size_x = ViewportSize.X,
			viewport_size_y = ViewportSize.Y,
			is_portrait_mode = v63
		})
		v45({
			type = Constants.AnalyticsActions.IncrementNextCount
		})
	end, {
		v33,
		v39,
		v38,
		ViewportSize,
		v63,
		v45,
		v64
	})
	local v66 = React.useCallback(function() -- line: 141
		-- upvalues: v41 (copy), SceneAnalysis (copy), v50 (copy), v65 (copy)
		v41(SceneAnalysis.interpretAndExtractItemsFromInstanceForPreciseSelection(v50))
		v65()
	end, {
		v65,
		v41,
		v50
	})
	local v67 = React.useCallback(function() -- line: 147
		-- upvalues: InGameAssetReportAnalytics (copy), v44 (copy), t1 (copy)
		InGameAssetReportAnalytics(v44, 2)
		t1.backAction()
	end, {
		t1.backAction,
		v44
	})

	React.useEffect(function() -- line: 155
		-- upvalues: v48 (copy), ExperienceStateCaptureService (copy), v51 (copy), v45 (copy), Constants (copy), v26 (copy), v64 (copy), UserInputService (copy), v41 (copy), SceneAnalysis (copy), v65 (copy), v49 (copy)
		if v48 then
			v48:Disconnect()
		end

		local connection = ExperienceStateCaptureService.ItemSelectedInCaptureMode:Connect(function(p1) -- line: 159
			-- upvalues: v51 (copy), v45 (copy), Constants (copy), v26 (copy), v64 (copy), UserInputService (copy), v41 (copy), SceneAnalysis (copy), v65 (copy)
			v51(p1)

			if p1 then
				v45({
					type = Constants.AnalyticsActions.IncremementAnnotationCount
				})

				if v26 then
					v64()
				end
			end

			if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
				v41(SceneAnalysis.interpretAndExtractItemsFromInstanceForPreciseSelection(p1))
				v65()
			end
		end)

		v49(connection)
	end, {
		v51,
		v49,
		v65,
		v41,
		v45,
		v64
	})

	local v68 = React.useCallback(function(s1: string, s2: string, p2) -- line: 192
		-- upvalues: FFlagReportIPInfringement (copy), v40 (copy), v59 (copy), Constants (copy), v38 (copy), HttpService (copy), v30 (copy), v57 (copy), v37 (copy), v33 (copy), v35 (copy), v45 (copy), getHighlightModeVariant (copy), buildReport (copy), Players (copy)
		if FFlagReportIPInfringement and s1 == "ip infringement" then
			if not v40 or not v40.extractedAssets then
				v59(Constants.IpErrorCodes.ClientNoAssetsExtracted)

				return
			end

			local t2 = {}

			for k, v in pairs(v40.extractedAssets) do
				for _, v2 in ipairs(v) do
					local v83 = if k ~= "Package" then v2 else v2.id

					if v83 then
						local match = string.match(v83, "%d+")

						if match and match ~= "" then
							table.insert(t2, {
								content_type = "Asset",
								content_id = match
							})
						end
					end
				end
			end

			if #t2 > 0 then
				local t3 = {
					screenshot_id = v38,
					universe_id = game.GameId,
					contents = t2
				}
				local json = HttpService:JSONEncode(t3)

				HttpService:RequestInternal({
					Method = "POST",
					Url = v30,
					Headers = {
						["Content-Type"] = "application/json",
						Accept = "application/json"
					},
					Body = json
				}):Start(function(_, p4) -- line: 235
					-- upvalues: HttpService (copy), v57 (copy), v37 (copy), v59 (copy), Constants (copy)
					if p4.StatusCode == 200 then
						local ok, result = pcall(HttpService.JSONDecode, HttpService, p4.Body)

						if ok and result and result.code then
							v57(result.code)
							v37(true)

							return
						end

						v59(Constants.IpErrorCodes.Unknown)

						return
					end

					local Unknown = Constants.IpErrorCodes.Unknown
					local ok, result = pcall(HttpService.JSONDecode, HttpService, p4.Body)

					if ok and result and result.app_error_code and result.app_error_code ~= "" then
						Unknown = result.app_error_code
					end

					v59(Unknown)
				end)

				return
			end

			v59(Constants.IpErrorCodes.ClientNoAssetsExtracted)

			return
		end

		v33(false)
		v35(true)
		v45({
			final_annotation_count = 0,
			type = Constants.AnalyticsActions.SetExtractionResults,
			results = v40
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
			comment_added = #p2 > 0
		})

		local v87 = getHighlightModeVariant()

		v45({
			type = Constants.AnalyticsActions.SetVariant,
			variant = v87
		})

		local v88 = buildReport(Players.LocalPlayer.UserId, v38, v40, s1, s2, p2, {}, nil, v87)

		if v88 then
			Players:ReportAbuseV3(Players.LocalPlayer, v88)
		end
	end, {
		v40,
		v33,
		v35,
		v38,
		v59,
		v37,
		v57,
		v45
	})
	local v69 = React.useCallback(function() -- line: 321
		-- upvalues: v41 (copy), v33 (copy), ExperienceStateCaptureService (copy)
		v41(nil)
		v33(false)
		ExperienceStateCaptureService:ResetHighlight()
	end, {
		v33,
		v41
	})
	local v70 = React.useCallback(function() -- line: 328
		-- upvalues: v35 (copy), InGameAssetReportAnalytics (copy), v44 (copy), t1 (copy)
		v35(false)
		InGameAssetReportAnalytics(v44, 1)
		t1.onReportComplete()
	end, {
		t1.onReportComplete,
		v35,
		v44
	})
	local v71 = React.useCallback(function() -- line: 334
		-- upvalues: v42 (copy), v43 (copy), v45 (copy), Constants (copy)
		if v42 then
			v43(false)

			return
		end

		v45({
			did_user_resize = true,
			type = Constants.AnalyticsActions.SetDidUserResize
		})
	end, {
		v42,
		v32,
		v45,
		v43
	})

	React.useEffect(function() -- line: 347
		-- upvalues: v46 (copy), UserInputService (copy), v67 (copy), v47 (copy)
		if v46 then
			v46:Disconnect()
		end

		local connection = UserInputService.InputEnded:Connect(function(input) -- line: 352
			-- upvalues: v67 (copy)
			if input.KeyCode == Enum.KeyCode.Escape then
				v67()
			end
		end)

		v47(connection)
	end, {
		v67,
		v47
	})

	local v72 = React.useCallback(function() -- line: 361
		-- upvalues: v59 (copy)
		v59(nil)
	end, {})
	local v73 = React.useCallback(function() -- line: 368
		-- upvalues: v61 (copy), HttpService (copy), v38 (copy), v30 (copy), v57 (copy), v59 (copy), v37 (copy), Constants (copy)
		v61(true)

		local json = HttpService:JSONEncode({
			screenshot_id = v38,
			universe_id = game.GameId,
			contents = {}
		})

		HttpService:RequestInternal({
			Method = "POST",
			Url = v30,
			Headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			},
			Body = json
		}):Start(function(_, p6) -- line: 387
			-- upvalues: v61 (copy), HttpService (copy), v57 (copy), v59 (copy), v37 (copy), Constants (copy)
			v61(false)

			if p6.StatusCode == 200 then
				local ok, result = pcall(HttpService.JSONDecode, HttpService, p6.Body)

				if ok and result and result.code then
					v57(result.code)
					v59(nil)
					v37(true)

					return
				end
			end

			v59(Constants.IpErrorCodes.Unknown)
		end)
	end, {
		v38,
		v57,
		v59,
		v37,
		v61
	})

	return withLocalization({
		mainTitle = "Feature.ReportAbuse.Label.HighlightProblemPrecise",
		next = "Feature.ReportAbuse.Action.Next",
		coachmarkTitle = "Feature.ReportAbuse.Label.CantSelectTitle",
		coachmarkText = "Feature.ReportAbuse.Label.CantSelectSubtitle"
	})(function(p7) -- line: 415
		-- upvalues: React (copy), v71 (copy), v63 (copy), ReportPreciseSelectionPortraitHeaderFooter (copy), v67 (copy), ReportPreciseSelectionLandscapeHeader (copy), v66 (copy), v52 (copy), v64 (copy), v32 (copy), InGameAssetReportSubmitDialog (copy), ViewportSize (copy), v68 (copy), v69 (copy), v45 (copy), FFlagPrefillPreciseSelectionChoices (copy), v40 (copy), v34 (copy), InGameAssetReportCompleteModal (copy), v70 (copy), FFlagReportIPInfringement (copy), v36 (copy), InGameAssetReportIPInfringementModal (copy), v56 (copy), v58 (copy), InGameAssetIPInfringementErrorModal (copy), v72 (copy), v73 (copy), v60 (copy)
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = v71
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
				InGameAssetReportModeHeader = if not v63 then React.createElement(ReportPreciseSelectionLandscapeHeader, {
					titleText = p7.mainTitle,
					nextText = p7.next,
					nextAction = v66,
					backAction = v67,
					coachmarkTitle = p7.coachmarkTitle,
					coachmarkText = p7.coachmarkText,
					isCoachmarkOpen = v52,
					onCoachmarkClose = v64
				}) else React.createElement(ReportPreciseSelectionPortraitHeaderFooter.PortraitModeHeader, {
					titleText = p7.mainTitle,
					nextText = p7.next,
					backAction = v67
				})
			}),
			Footer = if not v63 then nil else React.createElement("TextButton", {
				ZIndex = 2,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 0, 60),
				Position = UDim2.new(0, 0, 1, -60)
			}, {
				InGameAssetReportModeFooter = React.createElement(ReportPreciseSelectionPortraitHeaderFooter.PortraitModeFooter, {
					nextAction = v66,
					nextText = p7.next,
					isCoachmarkOpen = v52,
					onCoachmarkClose = v64,
					coachmarkTitle = p7.coachmarkTitle,
					coachmarkText = p7.coachmarkText
				})
			}),
			SubmitDialog = if not v32 then nil else React.createElement(InGameAssetReportSubmitDialog, {
				screenSize = ViewportSize,
				onSubmit = v68,
				onBack = v69,
				analyticsDispatch = v45,
				extractionResult = if not FFlagPrefillPreciseSelectionChoices then nil else v40
			}),
			ReportCompleteModal = if not v34 then nil else React.createElement(InGameAssetReportCompleteModal, {
				screenSize = ViewportSize,
				onClose = v70
			}),
			IPInfringementModal = if not FFlagReportIPInfringement or not v36 then nil else React.createElement(InGameAssetReportIPInfringementModal, {
				screenSize = ViewportSize,
				reportCode = v56,
				onClose = v70
			}),
			ErrorModal = if not FFlagReportIPInfringement or v58 == nil then nil else React.createElement(InGameAssetIPInfringementErrorModal, {
				screenSize = ViewportSize,
				onBack = v72,
				errorCode = v58,
				onReportExperience = v73,
				isReportExperienceLoading = v60
			})
		})
	end)
end
