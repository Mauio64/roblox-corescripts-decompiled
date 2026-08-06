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
local v28 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
local v29 = string.gsub(string.gsub(v28, "http:", "https:"), "https://www", "https://apis") .. "rights-management-api/rights/v1/snapshots"

return function(t1: {[any]: any}) -- line: 56
	-- upvalues: React (copy), AnalyticsReducer (copy), Constants (copy), setTimeout (copy), clearTimeout (copy), v26 (copy), ScreenshotManager (copy), SceneAnalysis (copy), InGameAssetReportAnalytics (copy), ExperienceStateCaptureService (copy), UserInputService (copy), HttpService (copy), v29 (copy), getHighlightModeVariant (copy), buildReport (copy), Players (copy), withLocalization (copy), ReportPreciseSelectionPortraitHeaderFooter (copy), ReportPreciseSelectionLandscapeHeader (copy), InGameAssetReportSubmitDialog (copy), FFlagPrefillPreciseSelectionChoices (copy), InGameAssetReportCompleteModal (copy), InGameAssetReportIPInfringementModal (copy), InGameAssetIPInfringementErrorModal (copy)
	local v31, v32 = React.useState(false)
	local v33, v34 = React.useState(false)
	local v35, v36 = React.useState(false)
	local v37, v38 = React.useState("")
	local v39, v40 = React.useState(nil)
	local v41, v42 = React.useState(true)
	local v43, v44 = React.useReducer(AnalyticsReducer, Constants.AnalyticsInitialState)
	local v45, v46 = React.useState(nil)
	local v47, v48 = React.useState(nil)
	local v49, v50 = React.useState(nil)
	local v51, v52 = React.useState(false)
	local v53, v54 = React.useState(nil)
	local v55, v56 = React.useState("")
	local v57, v58 = React.useState(nil)
	local v59, v60 = React.useState(false)
	local ViewportSize = game.Workspace.CurrentCamera.ViewportSize
	local v62 = t1.getIsSmallPortraitMode(ViewportSize)

	React.useEffect(function() -- line: 78
		-- upvalues: v44 (copy), Constants (copy), v54 (copy), setTimeout (copy), v52 (copy)
		v44({
			type = Constants.AnalyticsActions.AccumulateForTimeSpent,
			accumulated_time_ms = workspace:GetServerTimeNow() * 1000
		})
		v44({
			type = Constants.AnalyticsActions.SetPlaceId,
			place_id = game.PlaceId
		})
		v54(setTimeout(function() -- line: 87
			-- upvalues: v52 (copy)
			v52(true)
		end, 10000))
	end, {
		v52,
		v54
	})

	local v63 = React.useCallback(function() -- line: 92
		-- upvalues: v52 (copy), v53 (copy), clearTimeout (copy)
		v52(false)

		if v53 then
			clearTimeout(v53)
		end
	end, {
		v52,
		v53
	})
	local v64 = React.useCallback(function() -- line: 100
		-- upvalues: v26 (copy), v37 (copy), ScreenshotManager (copy), v38 (copy), v63 (copy), v32 (copy), v44 (copy), Constants (copy), ViewportSize (copy), v62 (copy)
		if v26 then
			if v37 == "" then
				ScreenshotManager:TakeScreenshotWithCallback(v38, nil)
			end
		elseif not v37 then
			ScreenshotManager:TakeScreenshotWithCallback(v38, nil)
		end

		v63()
		v32(true)
		v44({
			type = Constants.AnalyticsActions.SetViewportInformation,
			viewport_size_x = ViewportSize.X,
			viewport_size_y = ViewportSize.Y,
			is_portrait_mode = v62
		})
		v44({
			type = Constants.AnalyticsActions.IncrementNextCount
		})
	end, {
		v32,
		v38,
		v37,
		ViewportSize,
		v62,
		v44,
		v63
	})
	local v65 = React.useCallback(function() -- line: 140
		-- upvalues: v40 (copy), SceneAnalysis (copy), v49 (copy), v64 (copy)
		v40(SceneAnalysis.interpretAndExtractItemsFromInstanceForPreciseSelection(v49))
		v64()
	end, {
		v64,
		v40,
		v49
	})
	local v66 = React.useCallback(function() -- line: 146
		-- upvalues: InGameAssetReportAnalytics (copy), v43 (copy), t1 (copy)
		InGameAssetReportAnalytics(v43, 2)
		t1.backAction()
	end, {
		t1.backAction,
		v43
	})

	React.useEffect(function() -- line: 154
		-- upvalues: v47 (copy), ExperienceStateCaptureService (copy), v50 (copy), v44 (copy), Constants (copy), v26 (copy), v63 (copy), UserInputService (copy), v40 (copy), SceneAnalysis (copy), v64 (copy), v48 (copy)
		if v47 then
			v47:Disconnect()
		end

		local connection = ExperienceStateCaptureService.ItemSelectedInCaptureMode:Connect(function(p1) -- line: 158
			-- upvalues: v50 (copy), v44 (copy), Constants (copy), v26 (copy), v63 (copy), UserInputService (copy), v40 (copy), SceneAnalysis (copy), v64 (copy)
			v50(p1)

			if p1 then
				v44({
					type = Constants.AnalyticsActions.IncremementAnnotationCount
				})

				if v26 then
					v63()
				end
			end

			if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
				v40(SceneAnalysis.interpretAndExtractItemsFromInstanceForPreciseSelection(p1))
				v64()
			end
		end)

		v48(connection)
	end, {
		v50,
		v48,
		v64,
		v40,
		v44,
		v63
	})

	local v67 = React.useCallback(function(s1: string, s2: string, p2) -- line: 191
		-- upvalues: v39 (copy), v58 (copy), Constants (copy), v37 (copy), HttpService (copy), v29 (copy), v56 (copy), v36 (copy), v32 (copy), v34 (copy), v44 (copy), getHighlightModeVariant (copy), buildReport (copy), Players (copy)
		if s1 == "ip infringement" then
			if not v39 or not v39.extractedAssets then
				v58(Constants.IpErrorCodes.ClientNoAssetsExtracted)

				return
			end

			local t2 = {}

			for k, v in pairs(v39.extractedAssets) do
				for _, v2 in ipairs(v) do
					local v82 = if k ~= "Package" then v2 else v2.id

					if v82 then
						local match = string.match(v82, "%d+")

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
					screenshot_id = v37,
					universe_id = game.GameId,
					contents = t2
				}
				local json = HttpService:JSONEncode(t3)

				HttpService:RequestInternal({
					Method = "POST",
					Url = v29,
					Headers = {
						["Content-Type"] = "application/json",
						Accept = "application/json"
					},
					Body = json
				}):Start(function(_, p4) -- line: 234
					-- upvalues: HttpService (copy), v56 (copy), v36 (copy), v58 (copy), Constants (copy)
					if p4.StatusCode == 200 then
						local ok, result = pcall(HttpService.JSONDecode, HttpService, p4.Body)

						if ok and result and result.code then
							v56(result.code)
							v36(true)

							return
						end

						v58(Constants.IpErrorCodes.Unknown)

						return
					end

					local Unknown = Constants.IpErrorCodes.Unknown
					local ok, result = pcall(HttpService.JSONDecode, HttpService, p4.Body)

					if ok and result and result.app_error_code and result.app_error_code ~= "" then
						Unknown = result.app_error_code
					end

					v58(Unknown)
				end)

				return
			end

			v58(Constants.IpErrorCodes.ClientNoAssetsExtracted)

			return
		end

		v32(false)
		v34(true)
		v44({
			final_annotation_count = 0,
			type = Constants.AnalyticsActions.SetExtractionResults,
			results = v39
		})
		v44({
			type = Constants.AnalyticsActions.SetReasonSelection,
			reason_selection = s1
		})
		v44({
			type = Constants.AnalyticsActions.SetSurfaceSelection,
			surface_selection = s2
		})
		v44({
			type = Constants.AnalyticsActions.SetCommentAdded,
			comment_added = #p2 > 0
		})

		local v86 = getHighlightModeVariant()

		v44({
			type = Constants.AnalyticsActions.SetVariant,
			variant = v86
		})

		local v87 = buildReport(Players.LocalPlayer.UserId, v37, v39, s1, s2, p2, {}, nil, v86)

		if v87 then
			Players:ReportAbuseV3(Players.LocalPlayer, v87)
		end
	end, {
		v39,
		v32,
		v34,
		v37,
		v58,
		v36,
		v56,
		v44
	})
	local v68 = React.useCallback(function() -- line: 320
		-- upvalues: v40 (copy), v32 (copy), ExperienceStateCaptureService (copy)
		v40(nil)
		v32(false)
		ExperienceStateCaptureService:ResetHighlight()
	end, {
		v32,
		v40
	})
	local v69 = React.useCallback(function() -- line: 327
		-- upvalues: v34 (copy), InGameAssetReportAnalytics (copy), v43 (copy), t1 (copy)
		v34(false)
		InGameAssetReportAnalytics(v43, 1)
		t1.onReportComplete()
	end, {
		t1.onReportComplete,
		v34,
		v43
	})
	local v70 = React.useCallback(function() -- line: 333
		-- upvalues: v41 (copy), v42 (copy), v44 (copy), Constants (copy)
		if v41 then
			v42(false)

			return
		end

		v44({
			did_user_resize = true,
			type = Constants.AnalyticsActions.SetDidUserResize
		})
	end, {
		v41,
		v31,
		v44,
		v42
	})

	React.useEffect(function() -- line: 346
		-- upvalues: v45 (copy), UserInputService (copy), v66 (copy), v46 (copy)
		if v45 then
			v45:Disconnect()
		end

		local connection = UserInputService.InputEnded:Connect(function(input) -- line: 351
			-- upvalues: v66 (copy)
			if input.KeyCode == Enum.KeyCode.Escape then
				v66()
			end
		end)

		v46(connection)
	end, {
		v66,
		v46
	})

	local v71 = React.useCallback(function() -- line: 360
		-- upvalues: v58 (copy)
		v58(nil)
	end, {})
	local v72 = React.useCallback(function() -- line: 367
		-- upvalues: v60 (copy), HttpService (copy), v37 (copy), v29 (copy), v56 (copy), v58 (copy), v36 (copy), Constants (copy)
		v60(true)

		local json = HttpService:JSONEncode({
			screenshot_id = v37,
			universe_id = game.GameId,
			contents = {}
		})

		HttpService:RequestInternal({
			Method = "POST",
			Url = v29,
			Headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			},
			Body = json
		}):Start(function(_, p6) -- line: 386
			-- upvalues: v60 (copy), HttpService (copy), v56 (copy), v58 (copy), v36 (copy), Constants (copy)
			v60(false)

			if p6.StatusCode == 200 then
				local ok, result = pcall(HttpService.JSONDecode, HttpService, p6.Body)

				if ok and result and result.code then
					v56(result.code)
					v58(nil)
					v36(true)

					return
				end
			end

			v58(Constants.IpErrorCodes.Unknown)
		end)
	end, {
		v37,
		v56,
		v58,
		v36,
		v60
	})

	return withLocalization({
		mainTitle = "Feature.ReportAbuse.Label.HighlightProblemPrecise",
		next = "Feature.ReportAbuse.Action.Next",
		coachmarkTitle = "Feature.ReportAbuse.Label.CantSelectTitle",
		coachmarkText = "Feature.ReportAbuse.Label.CantSelectSubtitle"
	})(function(p7) -- line: 414
		-- upvalues: React (copy), v70 (copy), v62 (copy), ReportPreciseSelectionPortraitHeaderFooter (copy), v66 (copy), ReportPreciseSelectionLandscapeHeader (copy), v65 (copy), v51 (copy), v63 (copy), v31 (copy), InGameAssetReportSubmitDialog (copy), ViewportSize (copy), v67 (copy), v68 (copy), v44 (copy), FFlagPrefillPreciseSelectionChoices (copy), v39 (copy), v33 (copy), InGameAssetReportCompleteModal (copy), v69 (copy), v35 (copy), InGameAssetReportIPInfringementModal (copy), v55 (copy), v57 (copy), InGameAssetIPInfringementErrorModal (copy), v71 (copy), v72 (copy), v59 (copy)
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = v70
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
				InGameAssetReportModeHeader = if not v62 then React.createElement(ReportPreciseSelectionLandscapeHeader, {
					titleText = p7.mainTitle,
					nextText = p7.next,
					nextAction = v65,
					backAction = v66,
					coachmarkTitle = p7.coachmarkTitle,
					coachmarkText = p7.coachmarkText,
					isCoachmarkOpen = v51,
					onCoachmarkClose = v63
				}) else React.createElement(ReportPreciseSelectionPortraitHeaderFooter.PortraitModeHeader, {
					titleText = p7.mainTitle,
					nextText = p7.next,
					backAction = v66
				})
			}),
			Footer = if not v62 then nil else React.createElement("TextButton", {
				ZIndex = 2,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 0, 60),
				Position = UDim2.new(0, 0, 1, -60)
			}, {
				InGameAssetReportModeFooter = React.createElement(ReportPreciseSelectionPortraitHeaderFooter.PortraitModeFooter, {
					nextAction = v65,
					nextText = p7.next,
					isCoachmarkOpen = v51,
					onCoachmarkClose = v63,
					coachmarkTitle = p7.coachmarkTitle,
					coachmarkText = p7.coachmarkText
				})
			}),
			SubmitDialog = if not v31 then nil else React.createElement(InGameAssetReportSubmitDialog, {
				screenSize = ViewportSize,
				onSubmit = v67,
				onBack = v68,
				analyticsDispatch = v44,
				extractionResult = if not FFlagPrefillPreciseSelectionChoices then nil else v39
			}),
			ReportCompleteModal = if not v33 then nil else React.createElement(InGameAssetReportCompleteModal, {
				screenSize = ViewportSize,
				onClose = v69
			}),
			IPInfringementModal = if not v35 then nil else React.createElement(InGameAssetReportIPInfringementModal, {
				screenSize = ViewportSize,
				reportCode = v55,
				onClose = v69
			}),
			ErrorModal = if v57 == nil then nil else React.createElement(InGameAssetIPInfringementErrorModal, {
				screenSize = ViewportSize,
				onBack = v71,
				errorCode = v57,
				onReportExperience = v72,
				isReportExperienceLoading = v59
			})
		})
	end)
end
