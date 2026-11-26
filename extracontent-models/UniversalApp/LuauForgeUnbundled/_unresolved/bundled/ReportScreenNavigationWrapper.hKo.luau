local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/hKp")
local module2 = require("@luauforge/bundled/hKq")
local module3 = require("@luauforge/bundled/hKs")
local reactServerUIView = module3.ReactServerUIView
local module4 = require("@luauforge/bundled/hKr")
local navigation = module3.Navigation
local module5 = require("@luauforge/bundled/hKt")
local module6 = require("@luauforge/bundled/hKu")
local module7 = require("@luauforge/bundled/hKv")
local focusNavigationEventNameEnum = require("@luauforge/bundled/hKw").FocusNavigationEventNameEnum
local module8 = require("@luauforge/bundled/hKx")
local module9 = require("@luauforge/bundled/hKy")
require("@luauforge/bundled/hKz")
local useState = module.useState
local useDispatch = require("@luauforge/bundled/hKA").Hooks.RoactRodux.useDispatch
local module10 = require("@luauforge/bundled/hKB")
local useNavigation = require("@luauforge/bundled/hKC").useNavigation
local module11 = require("@luauforge/bundled/hKD")
local mutedError = require("@luauforge/bundled/hKE").mutedError

local fFlagLuaAppDefaultHttpRetry = require("@luauforge/bundled/hKF").FFlagLuaAppDefaultHttpRetry

local module12 = require("@luauforge/bundled/hKG")
local module13 = require("@luauforge/bundled/hKM")

local module14 = require("@luauforge/bundled/hKN")
local module15 = require("@luauforge/bundled/hKS")

local module16 = require("@luauforge/bundled/hKU")
local module17 = require("@luauforge/bundled/hKF")
local getFFlagDSALuaGeoGateBEDUIDevMode = module17.GetFFlagDSALuaGeoGateBEDUIDevMode
local getFFlagEnableAbuseReportMutedError = module17.GetFFlagEnableAbuseReportMutedError

local isInDSAFeaturesOverrideList = require("@luauforge/bundled/hKT").isInDSAFeaturesOverrideList

local isShowEUDSAIllegalContentReportingLink = require("@luauforge/bundled/hKT").isShowEUDSAIllegalContentReportingLink

local v5 = { ListSelection = "listSelection", Submission = "submission" }

local v6 = {
	toastMessage = "Feature.ReportAbuse.Label.Confirmation.Title",
	toastSubMessage = "Feature.ReportAbuse.Label.Confirmation.Subheading",
	isLocalized = false,
	toastType = module9.Enums.ToastType.SuccessConfirmation
}

local v7 = {
	toastMessage = "Feature.ReportAbuse.Message.ErrorSubmit",
	isLocalized = false,
	toastType = module9.Enums.ToastType.NetworkingError
}

local function ReportScreen(props)
	local v8 = useDispatch()
	local state, setState = useState({})
	local v9 = nil

	local v10 = module.useCallback(module8.onRelease(function(p2)
		if not v9 then
			v9 = module2.new(props.platform, props.context)
		end

		v9:onReportAbandoned()
	end), { v9 })

	local v11 = module7.useEventHandler(focusNavigationEventNameEnum.NavigateBack, v10)

	local config = module5.config
	local v12 = {
		requestFunction = module5.requestFunctions.HttpRbxApi,
		maxRetryCount = 0
	}

	local v13 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt("ReportScreenHttpRetryCount", 4) else nil
	v12.maxRetryCount = v13
	local v14 = config(v12)

	local config2 = module6.config({ keyPath = "AbuseReporting", networkImpl = v14 })

	local v15 = module13.new({
		componentMap = {
			listSelection = {
				name = "listSelection",
				component = module14,
				props = {
					onItemSelected = function(p2, p3)
						local params = p2.params
						local tagKey = params.tagKey
						local v16 = {
							tagValues = p3.tagValues,
							heading = params.heading,
							humanReadableText = p3.humanReadableText
						}
						setState(function(p4)
							local clone = table.clone(p4)
							table.insert(clone, module4.Dictionary.join(v16, {
								tagKey = tagKey
							}))

							return clone
						end)

						if not v9 then
							v9 = module2.new(props.platform, props.context)
						end

						v9:onSingleListItemSelected()
					end,
					onCancel = function()
						if not v9 then
							v9 = module2.new(props.platform, props.context)
						end

						v9:onReportAbandoned()
						props.navigation.goBack()
					end
				}
			},
			submission = {
				name = "submission",
				component = module15,
				props = {
					onCancel = function()
						if not v9 then
							v9 = module2.new(props.platform, props.context)
						end

						v9:onReportAbandoned()
						props.navigation.goBack()
					end,
					onMounted = function()
						if not v9 then
							v9 = module2.new(props.platform, props.context)
						end

						v9:onSubmissionPageMount()
					end,
					onSubmit = function(p2)
						local url = p2.params.url
						local v16 = {
							safetyEvent = {
								tags = module16(p2.report, {
									context = props.context,
									platform = props.platform,
									assetId = props.assetId,
									reportAbuseVector = props.reportAbuseVector
								})
							}
						}

						v8(config2.POST("SubmitAbuseReport", function(callback, p3)
							return callback(url):body(v16)
						end).API()):andThen(function(p3)
							v8(module9.Actions.SetCurrentToastMessage(v6))
						end):catch(function(p3)
							if getFFlagEnableAbuseReportMutedError() then
								mutedError("(Abuse Reporting [Console]) submission failed: " .. module11.toString(p3))
							end

							v8(module9.Actions.SetCurrentToastMessage(v7))
						end)

						if not v9 then
							v9 = module2.new(props.platform, props.context)
						end

						v9:onReportSubmitted()
						props.navigation.goBack()
					end
				}
			}
		},
		templateMap = {
			default = { component = module12 }
		}
	})

	local function fn(p2)
		if p2.name == "submission" then
			return { report = state }
		end

		return {}
	end

	local v16 = module10.BEDUI_VERSIONS.V1

	if getFFlagDSALuaGeoGateBEDUIDevMode() then
		if isShowEUDSAIllegalContentReportingLink() then
			v16 = module10.BEDUI_VERSIONS.DEV
		end
	elseif isInDSAFeaturesOverrideList() then
		v16 = module10.BEDUI_VERSIONS.DEV
	end

	return module.createElement(reactServerUIView, {
		url = "abuse-reporting/v1/dynamic-dialog",
		queryArgs = {
			version = v16,
			surface = props.platform,
			context = props.context,
			locale = LocalizationService.RobloxLocaleId,
			target_type = props.reportAbuseVector,
			target_id = props.assetId
		},
		mapComponentPropsFromState = fn,
		transform = function(p2)
			return v15:transform(p2)
		end,
		onError = function(p2)
			if getFFlagEnableAbuseReportMutedError() then
				mutedError("(Abuse Reporting [Console]) BEDUI fetch failed: " .. module11.toString(p2))
			end

			v8(module9.Actions.SetCurrentToastMessage(v7))
			props.navigation.goBack()
		end,
		ref = v11
	})
end

local function ReportScreenNavigationWrapper(p2)
	local v8 = useNavigation()
	local param = v8.getParam("reportData", {})

	return module.createElement(navigation, {}, {
		Screen = module.createElement(ReportScreen, module4.Dictionary.join(p2, param, {
			navigation = v8
		}))
	})
end

return ReportScreenNavigationWrapper
