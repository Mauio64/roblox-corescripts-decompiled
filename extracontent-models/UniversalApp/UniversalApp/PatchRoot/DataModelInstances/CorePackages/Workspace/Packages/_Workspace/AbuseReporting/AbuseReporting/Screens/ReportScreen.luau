local LocalizationService = game:GetService("LocalizationService")
local AbuseReporting = script:FindFirstAncestor("AbuseReporting")
local AbuseReportingParent = AbuseReporting.Parent
local React = require(AbuseReportingParent.React)
local Analytics = require(AbuseReporting.Analytics)
local ServerUI = require(AbuseReportingParent.ServerUI)
local ReactServerUIView = ServerUI.ReactServerUIView
local Cryo = require(AbuseReportingParent.Cryo)
local Navigation = ServerUI.Navigation
local HttpRequest = require(AbuseReportingParent.HttpRequest)
local RoduxNetworking = require(AbuseReportingParent.RoduxNetworking)
local ReactFocusNavigation = require(AbuseReportingParent.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(AbuseReportingParent.FocusNavigationUtils).FocusNavigationEventNameEnum
local InputHandlers = require(AbuseReportingParent.InputHandlers)
local ToastRodux = require(AbuseReportingParent.ToastRodux)

require(AbuseReporting.Common.Types)

local useState = React.useState
local useDispatch = require(AbuseReportingParent.RoactUtils).Hooks.RoactRodux.useDispatch
local Constants = require(AbuseReporting.Common.Constants)
local useNavigation = require(AbuseReportingParent.Navigation).useNavigation
local tutils = require(AbuseReportingParent.tutils)
local mutedError = require(AbuseReportingParent.Loggers).mutedError
local FFlagLuaAppDefaultHttpRetry = require(AbuseReportingParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local ReportFullscreenTemplate = require(AbuseReporting.Templates.ReportFullscreenTemplate)
local DynamicDialogUITransformer = require(AbuseReporting.Transformers.DynamicDialogUITransformer)
local ReportListSelection = require(AbuseReporting.Components.ReportListSelection)
local ReportSubmission = require(AbuseReporting.Components.ReportSubmission)
local constructAbuseReportTags = require(AbuseReporting.Components.constructAbuseReportTags)
local SharedFlags = require(AbuseReportingParent.SharedFlags)
local GetFFlagDSALuaGeoGateBEDUIDevMode = SharedFlags.GetFFlagDSALuaGeoGateBEDUIDevMode
local GetFFlagEnableAbuseReportMutedError = SharedFlags.GetFFlagEnableAbuseReportMutedError
local isInDSAFeaturesOverrideList = require(AbuseReportingParent.DsaIllegalContentReporting).isInDSAFeaturesOverrideList
local isShowEUDSAIllegalContentReportingLink = require(AbuseReportingParent.DsaIllegalContentReporting).isShowEUDSAIllegalContentReportingLink
local _ = {
	ListSelection = "listSelection",
	Submission = "submission"
}
local t1 = {
	toastMessage = "Feature.ReportAbuse.Label.Confirmation.Title",
	toastSubMessage = "Feature.ReportAbuse.Label.Confirmation.Subheading",
	isLocalized = false,
	toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
}
local t2 = {
	toastMessage = "Feature.ReportAbuse.Message.ErrorSubmit",
	isLocalized = false,
	toastType = ToastRodux.Enums.ToastType.NetworkingError
}

local function ReportScreen(p1) -- line: 81
	-- upvalues: useDispatch (copy), useState (copy), Analytics (copy), Cryo (copy), React (copy), InputHandlers (copy), ReactFocusNavigation (copy), FocusNavigationEventNameEnum (copy), HttpRequest (copy), FFlagLuaAppDefaultHttpRetry (copy), RoduxNetworking (copy), DynamicDialogUITransformer (copy), ReportListSelection (copy), ReportSubmission (copy), constructAbuseReportTags (copy), ToastRodux (copy), t1 (copy), GetFFlagEnableAbuseReportMutedError (copy), mutedError (copy), tutils (copy), t2 (copy), ReportFullscreenTemplate (copy), Constants (copy), GetFFlagDSALuaGeoGateBEDUIDevMode (copy), isShowEUDSAIllegalContentReportingLink (copy), isInDSAFeaturesOverrideList (copy), ReactServerUIView (copy), LocalizationService (copy)
	local v39 = useDispatch()
	local v40, v41 = useState({})
	local u42 = nil
	local v43 = React.useCallback(InputHandlers.onRelease(function(_) -- line: 106
		-- upvalues: u42 (ref), Analytics (copy), p1 (copy)
		if not u42 then
			u42 = Analytics.new(p1.platform, p1.context)
		end

		u42:onReportAbandoned()
	end), { u42 })
	local v44 = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v43)
	local v45 = HttpRequest.config({
		requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
		maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("ReportScreenHttpRetryCount", 4)
	})
	local v46 = RoduxNetworking.config({
		keyPath = "AbuseReporting",
		networkImpl = v45
	})
	local v47 = DynamicDialogUITransformer.new({
		componentMap = {
			listSelection = {
				name = "listSelection",
				component = ReportListSelection,
				props = {
					onItemSelected = function(p3, p4) -- line: 134
						-- upvalues: v41 (copy), Cryo (copy), u42 (ref), Analytics (copy), p1 (copy)
						local params = p3.params
						local tagKey = params.tagKey
						local t3 = {
							tagValues = p4.tagValues,
							heading = params.heading,
							humanReadableText = p4.humanReadableText
						}

						v41(function(p5) -- line: 93
							-- upvalues: Cryo (copy), t3 (copy), tagKey (copy)
							local v70 = table.clone(p5)

							table.insert(v70, Cryo.Dictionary.join(t3, {
								tagKey = tagKey
							}))

							return v70
						end)

						if not u42 then
							u42 = Analytics.new(p1.platform, p1.context)
						end

						u42:onSingleListItemSelected()
					end,
					onCancel = function() -- line: 146
						-- upvalues: u42 (ref), Analytics (copy), p1 (copy)
						if not u42 then
							u42 = Analytics.new(p1.platform, p1.context)
						end

						u42:onReportAbandoned()
						p1.navigation.goBack()
					end
				}
			},
			submission = {
				name = "submission",
				component = ReportSubmission,
				props = {
					onCancel = function() -- line: 156
						-- upvalues: u42 (ref), Analytics (copy), p1 (copy)
						if not u42 then
							u42 = Analytics.new(p1.platform, p1.context)
						end

						u42:onReportAbandoned()
						p1.navigation.goBack()
					end,
					onMounted = function() -- line: 160
						-- upvalues: u42 (ref), Analytics (copy), p1 (copy)
						if not u42 then
							u42 = Analytics.new(p1.platform, p1.context)
						end

						u42:onSubmissionPageMount()
					end,
					onSubmit = function(p6) -- line: 163
						-- upvalues: constructAbuseReportTags (copy), p1 (copy), v46 (copy), v39 (copy), ToastRodux (copy), t1 (copy), GetFFlagEnableAbuseReportMutedError (copy), mutedError (copy), tutils (copy), t2 (copy), u42 (ref), Analytics (copy)
						local url = p6.params.url
						local t4 = {
							safetyEvent = {
								tags = constructAbuseReportTags(p6.report, {
									context = p1.context,
									platform = p1.platform,
									assetId = p1.assetId,
									reportAbuseVector = p1.reportAbuseVector
								})
							}
						}
						local v63 = v46.POST("SubmitAbuseReport", function(p7, _: nil) -- line: 178
							-- upvalues: url (copy), t4 (copy)
							return p7(url):body(t4)
						end)

						v39(v63.API()):andThen(function(_) -- line: 183
							-- upvalues: v39 (copy), ToastRodux (copy), t1 (copy)
							v39(ToastRodux.Actions.SetCurrentToastMessage(t1))
						end):catch(function(p10) -- line: 186
							-- upvalues: GetFFlagEnableAbuseReportMutedError (copy), mutedError (copy), tutils (copy), v39 (copy), ToastRodux (copy), t2 (copy)
							if GetFFlagEnableAbuseReportMutedError() then
								mutedError("(Abuse Reporting [Console]) submission failed: " .. tutils.toString(p10))
							end

							v39(ToastRodux.Actions.SetCurrentToastMessage(t2))
						end)

						if not u42 then
							u42 = Analytics.new(p1.platform, p1.context)
						end

						u42:onReportSubmitted()
						p1.navigation.goBack()
					end
				}
			}
		},
		templateMap = {
			default = {
				component = ReportFullscreenTemplate
			}
		}
	})
	local V1 = Constants.BEDUI_VERSIONS.V1

	if GetFFlagDSALuaGeoGateBEDUIDevMode() then
		if isShowEUDSAIllegalContentReportingLink() then
			V1 = Constants.BEDUI_VERSIONS.DEV
		end
	elseif isInDSAFeaturesOverrideList() then
		V1 = Constants.BEDUI_VERSIONS.DEV
	end

	return React.createElement(ReactServerUIView, {
		url = "abuse-reporting/v1/dynamic-dialog",
		queryArgs = {
			version = V1,
			surface = p1.platform,
			context = p1.context,
			locale = LocalizationService.RobloxLocaleId,
			target_type = p1.reportAbuseVector,
			target_id = p1.assetId
		},
		mapComponentPropsFromState = function(p11) -- line: 208
			-- upvalues: v40 (copy)
			if p11.name == "submission" then
				return {
					report = v40
				}
			end

			return {}
		end,
		transform = function(p12) -- line: 243
			-- upvalues: v47 (copy)
			return v47:transform(p12)
		end,
		onError = function(p13) -- line: 246
			-- upvalues: GetFFlagEnableAbuseReportMutedError (copy), mutedError (copy), tutils (copy), v39 (copy), ToastRodux (copy), t2 (copy), p1 (copy)
			if GetFFlagEnableAbuseReportMutedError() then
				mutedError("(Abuse Reporting [Console]) BEDUI fetch failed: " .. tutils.toString(p13))
			end

			v39(ToastRodux.Actions.SetCurrentToastMessage(t2))
			p1.navigation.goBack()
		end,
		ref = v44
	})
end
local function ReportScreenNavigationWrapper(t5: {[any]: any}) -- line: 257
	-- upvalues: useNavigation (copy), React (copy), Navigation (copy), ReportScreen (copy), Cryo (copy)
	local v50 = useNavigation()
	local v51 = v50.getParam("reportData", {})

	return React.createElement(Navigation, {}, {
		Screen = React.createElement(ReportScreen, Cryo.Dictionary.join(t5, v51, {
			navigation = v50
		}))
	})
end

return ReportScreenNavigationWrapper
