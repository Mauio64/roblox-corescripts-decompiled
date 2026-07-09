local Players = game:GetService("Players")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus).MessageBus
local t = require(CorePackages.Packages.t)
local OpenWebview = require(Modules.LuaApp.Thunks.OpenWebview)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local GetSurvey = require(Modules.LuaApp.Http.Requests.GetSurvey)
local OpenCentralOverlayForSurveyPrompt = require(Modules.LuaApp.Thunks.OpenCentralOverlayForSurveyPrompt)
local OpenCentralOverlayForSurveyPromptWithSurvBlox = require(Modules.LuaApp.Thunks.OpenCentralOverlayForSurveyPromptWithSurvBlox)
local CsatSurveyConstants = require(script.Parent.CsatSurveyConstants)
local CsatSurveyInterceptUtils = require(script.Parent.CsatSurveyInterceptUtils)
local CsatSurveyTelemetryConfig = require(script.Parent.CsatSurveyTelemetryConfig)
local GetFFlagSurvBloxEnabled = require(script.Parent.GetFFlagSurvBloxEnabled)
local GetFFlagSurvBloxLocalStorageEnabled = require(script.Parent.GetFFlagSurvBloxLocalStorageEnabled)
local GetFFlagSurvBloxAddSurveyLinkParamsEnabled = require(script.Parent.GetFFlagSurvBloxAddSurveyLinkParamsEnabled)
local GetFIntSurvBloxRequiredCooldownMs = require(script.Parent.GetFIntSurvBloxRequiredCooldownMs)
local GetFFlagSurvBloxTrackingFixes = require(script.Parent.GetFFlagSurvBloxTrackingFixes)
local SurveyEventPublisher = require(CorePackages.Workspace.Packages.OnPlatformSurveys.SurveyEventPublisher)
local WebViewEventType = require(CorePackages.Workspace.Packages.OnPlatformSurveys.WebViewEventType)
local OPEN_SURVEY_EVENT_DESCRIPTOR = SurveyEventPublisher.OPEN_SURVEY_EVENT_DESCRIPTOR
local v35 = t.valueOf(WebViewEventType)
local FFlagSurvBloxEventTypeEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSurvBloxEventTypeEnabled
local v37 = Roact.PureComponent:extend("CsatSurveyInterceptEventReceiver")

v37.validateProps = t.strictInterface({
	RobloxEventReceiver = t.table,
	baseUrlFormat = t.optional(t.string),
	surveyId = t.optional(t.string),
	isQualified = t.optional(t.boolean),
	restrictTextInput = t.boolean,
	openWebView = t.callback,
	openSurveyPrompt = t.optional(t.callback),
	openSurveyPromptWithSurvBlox = t.optional(t.callback),
	eventType = t.optional(t.string),
	showPrompt = t.optional(t.boolean),
	analyticsService = t.optional(t.union(t.Instance, t.table)),
	titleText = t.optional(t.string),
	bodyText = t.optional(t.string),
	cancelButtonText = t.optional(t.string),
	confirmButtonText = t.optional(t.string),
	sessionService = t.optional(t.union(t.Instance, t.table)),
	localization = t.optional(t.table),
	surveyName = t.optional(t.string),
	menuVersion = t.optional(t.string),
	networking = t.callback
})
v37.defaultProps = {
	baseUrlFormat = "",
	surveyId = "",
	isQualified = false,
	restrictTextInput = false,
	eventType = "",
	showPrompt = false,
	titleText = "",
	bodyText = "",
	cancelButtonText = "",
	confirmButtonText = "",
	surveyName = "",
	menuVersion = "",
	analyticsService = RbxAnalyticsService
}

function v37.getSurveyUrl(t1: {[any]: any}, s1: string?, _, s2: string?) -- line: 88
	-- upvalues: t (copy), Players (copy), GetFFlagSurvBloxEnabled (copy), FFlagSurvBloxEventTypeEnabled (copy), GetSurvey (copy), GetFFlagSurvBloxTrackingFixes (copy), GetFFlagSurvBloxAddSurveyLinkParamsEnabled (copy), UrlBuilder (copy), CsatSurveyConstants (copy)
	assert(t.boolean(t1.props.restrictTextInput))

	local v44 = s1 or tostring(Players.LocalPlayer.UserId)

	assert(t.string(v44))

	local v45 = t1.props.sessionService:generateSessionInfoString(false, true, false, false)

	if GetFFlagSurvBloxEnabled() then
		local v46 = if not FFlagSurvBloxEventTypeEnabled then nil else s2
		local v47, v48 = GetSurvey(t1.props.networking, v46):await()

		if GetFFlagSurvBloxTrackingFixes() then
			if v47 and v48 then
				t1:trackSurveyIdLocally()

				if v48.shouldPromptSurvey then
					if GetFFlagSurvBloxAddSurveyLinkParamsEnabled() then
						return UrlBuilder.fromString(v48.surveyLink)({
							userId = v44 or "0",
							restrictTextInput = tostring(t1.props.restrictTextInput) or "true",
							sessionIds = v45
						})
					end

					return v48.surveyLink
				end
			end
		elseif v47 and v48 and v48.shouldPromptSurvey then
			if GetFFlagSurvBloxAddSurveyLinkParamsEnabled() then
				return UrlBuilder.fromString(v48.surveyLink)({
					userId = v44 or "0",
					restrictTextInput = tostring(t1.props.restrictTextInput) or "true",
					sessionIds = v45
				})
			end

			return v48.surveyLink
		end

		return ""
	end

	assert(t.string(t1.props.baseUrlFormat))
	assert(t.string(t1.props.surveyId))

	return (UrlBuilder.fromString(t1.props.baseUrlFormat)({
		surveyId = t1.props.surveyId or "",
		userId = v44 or "0",
		restrictTextInput = tostring(t1.props.restrictTextInput) or "true",
		sessionIds = v45,
		menuVersion = t1.props.surveyName == CsatSurveyConstants.CHROME_SURVEY_NAME and t1.props.menuVersion or ""
	}))
end
function v37.getCompletedSurveyIds(p2) -- line: 147
	-- upvalues: AppStorageService (copy), CsatSurveyConstants (copy), HttpService (copy)
	local ok, result = pcall(function() -- line: 149
		-- upvalues: AppStorageService (copy), CsatSurveyConstants (copy)
		return AppStorageService:GetItem(CsatSurveyConstants.LOCAL_STORAGE_KEY_CSAT_SURVEY_COMPLETED_IDS)
	end)

	if ok and result ~= "" then
		return HttpService:JSONDecode(result)
	end

	warn("Unable to fetch completed survey ids from app storage ", result)
	p2.props.analyticsService:SetRBXEventStream(CsatSurveyConstants.ANALYTICS_CONTEXT_APP, CsatSurveyConstants.ANALYTICS_SURVEY_EVENT, CsatSurveyConstants.ANALYTICS_EXPERIMENT_MENU_GET_COMPLETED_SURVEY_IDS_FIELD, {
		error = result
	})

	return {}
end
function v37.hasCompletedSurvey(p3) -- line: 170
	-- upvalues: t (copy)
	assert(t.string(p3.props.surveyId))

	for _, v in ipairs(p3.completedSurveyIds) do
		if v == p3.props.surveyId then
			return true
		end
	end

	return false
end
function v37.trackSurveyIdLocally(p4) -- line: 182
	-- upvalues: GetFFlagSurvBloxEnabled (copy), GetFFlagSurvBloxLocalStorageEnabled (copy), AppStorageService (copy), CsatSurveyConstants (copy), t (copy), Cryo (copy), HttpService (copy)
	if GetFFlagSurvBloxEnabled() then
		if GetFFlagSurvBloxLocalStorageEnabled() then
			local ok, result = pcall(function() -- line: 185
				-- upvalues: AppStorageService (copy), CsatSurveyConstants (copy)
				AppStorageService:SetItem(CsatSurveyConstants.LOCAL_STORAGE_KEY_CSAT_LAST_SURVBLOX_CALL_TIMESTAMP, (tostring(DateTime.now().UnixTimestampMillis)))
				AppStorageService:Flush()
			end)

			if not ok then
				warn("Uncaught exception for setting last SurvBlox call timestamp on app storage", result)

				return
			end
		end
	else
		assert(t.string(p4.props.surveyId))

		if p4:hasCompletedSurvey() then
			return
		end

		if #p4.completedSurveyIds >= CsatSurveyConstants.LOCAL_STORAGE_CSAT_SURVEY_IDS_LIMIT then
			p4.completedSurveyIds = Cryo.List.getRange(p4.completedSurveyIds, 2, #p4.completedSurveyIds)
		end

		table.insert(p4.completedSurveyIds, p4.props.surveyId)

		local ok, result = pcall(function() -- line: 215
			-- upvalues: HttpService (copy), p4 (copy), AppStorageService (copy), CsatSurveyConstants (copy)
			local json = HttpService:JSONEncode(p4.completedSurveyIds)

			AppStorageService:SetItem(CsatSurveyConstants.LOCAL_STORAGE_KEY_CSAT_SURVEY_COMPLETED_IDS, json or "{}")
			AppStorageService:Flush()
		end)

		if not ok then
			warn("Uncaught exception for setting completed CSAT survey ids on app storage", result)
			p4.props.analyticsService:SetRBXEventStream(CsatSurveyConstants.ANALYTICS_CONTEXT_APP, CsatSurveyConstants.ANALYTICS_SURVEY_EVENT, CsatSurveyConstants.ANALYTICS_EXPERIMENT_MENU_SET_COMPLETED_SURVEY_IDS_FIELD, {
				error = result
			})
		end
	end
end
function v37.canShowSurvey(p5) -- line: 236
	-- upvalues: GetFFlagSurvBloxEnabled (copy), GetFFlagSurvBloxLocalStorageEnabled (copy), AppStorageService (copy), CsatSurveyConstants (copy), CsatSurveyTelemetryConfig (copy), GetFIntSurvBloxRequiredCooldownMs (copy), t (copy), CsatSurveyInterceptUtils (copy)
	if GetFFlagSurvBloxEnabled() then
		if GetFFlagSurvBloxLocalStorageEnabled() then
			local ok, result = pcall(function() -- line: 239
				-- upvalues: AppStorageService (copy), CsatSurveyConstants (copy)
				return AppStorageService:GetItem(CsatSurveyConstants.LOCAL_STORAGE_KEY_CSAT_LAST_SURVBLOX_CALL_TIMESTAMP)
			end)

			if not ok then
				warn("Unable to fetch last time a call to SurvBlox was made ", result)
				CsatSurveyTelemetryConfig.logGetLastSurvBloxCallTimestampError()
			else
				local num = tonumber(result)

				if num == -1 then
					return true
				end

				if DateTime.now().UnixTimestampMillis - num >= GetFIntSurvBloxRequiredCooldownMs() then
					return true
				end
			end

			return false
		end

		return true
	end

	assert(t.string(p5.props.surveyId))

	if p5.props.surveyId == "" or p5.props.surveyId == nil then
		return false
	end

	if p5:hasCompletedSurvey() then
		return false
	end

	if p5.props.surveyName == CsatSurveyConstants.CHROME_SURVEY_NAME then
		local v64 = CsatSurveyInterceptUtils.canShowChromeSurvey(p5.props.menuVersion)

		return p5.props.isQualified and v64
	end

	return p5.props.isQualified
end
function v37.openSurveyWebviewWithPrompt(t2: {[any]: any}, s3: string, s4: string) -- line: 285
	-- upvalues: GetFFlagSurvBloxTrackingFixes (copy)
	function t2.surveyPromptFunc() -- line: 286
		-- upvalues: t2 (copy), s3 (copy), s4 (copy)
		wait(0.2)
		t2.props.openWebView(s3, s4)
		t2:trackSurveyIdLocally()
	end
	function t2.surveyPromptClose() -- line: 296
		-- upvalues: t2 (copy)
		t2:trackSurveyIdLocally()
	end

	if GetFFlagSurvBloxTrackingFixes() then
		t2.props.openSurveyPromptWithSurvBlox(t2.surveyPromptFunc, t2.surveyPromptClose)

		return
	end

	t2.props.openSurveyPrompt(t2.surveyPromptFunc, t2.surveyPromptClose, t2.props.titleText, t2.props.bodyText, t2.props.cancelButtonText, t2.props.confirmButtonText)
end
function v37.openSurveyWebview(t3: {[any]: any}, s5: string?, p6, s6: string?) -- line: 315
	-- upvalues: CsatSurveyConstants (copy), GetFFlagSurvBloxEnabled (copy), GetFFlagSurvBloxTrackingFixes (copy)
	if t3:canShowSurvey() then
		local v72 = t3:getSurveyUrl(s5, p6, s6)
		local v73 = t3.props.localization:Format(CsatSurveyConstants.WEBVIEW_NAME_KEY)

		if GetFFlagSurvBloxEnabled() and v72 == "" then
			return
		end

		if GetFFlagSurvBloxTrackingFixes() then
			t3:openSurveyWebviewWithPrompt(v72, v73)

			return
		end

		if t3.props.showPrompt then
			t3:openSurveyWebviewWithPrompt(v72, v73)

			return
		end

		wait(0.2)
		t3.props.openWebView(v72, v73)
		t3:trackSurveyIdLocally()
	end
end
function v37.triggerEventTypeIsAllowed(t4: {[any]: any}, s7: string) -- line: 342
	-- upvalues: FFlagSurvBloxEventTypeEnabled (copy), v35 (copy), GetFFlagSurvBloxTrackingFixes (copy), CsatSurveyConstants (copy)
	if FFlagSurvBloxEventTypeEnabled then
		return v35(s7) == true
	end

	if GetFFlagSurvBloxTrackingFixes() then
		if s7 == CsatSurveyConstants.EVENT_TYPE_ENUM.ON_LEAVE_BUTTON_CLICK then
			return true
		end
	elseif s7 == t4.props.eventType and s7 == CsatSurveyConstants.EVENT_TYPE_ENUM.ON_LEAVE_BUTTON_CLICK then
		return true
	end

	return false
end
function v37.init(p7) -- line: 361
	-- upvalues: GetFFlagSurvBloxTrackingFixes (copy), MessageBus (copy), FFlagSurvBloxEventTypeEnabled (copy), OPEN_SURVEY_EVENT_DESCRIPTOR (copy), CsatSurveyConstants (copy)
	if not GetFFlagSurvBloxTrackingFixes() then
		p7.completedSurveyIds = p7:getCompletedSurveyIds()
	end

	p7.subscriber = MessageBus.Subscriber.new()

	local v77 = if not FFlagSurvBloxEventTypeEnabled then CsatSurveyConstants.ON_SURVEY_EVENT_DESCRIPTOR else OPEN_SURVEY_EVENT_DESCRIPTOR

	p7.subscriber:subscribe(v77, function(t5: {[any]: any}) -- line: 374
		-- upvalues: p7 (copy), v77 (copy)
		if p7:triggerEventTypeIsAllowed(t5.eventType) then
			p7.subscriber:unsubscribe(v77)
			p7:openSurveyWebview(t5.userId, t5.customProps, t5.eventType)
		end
	end)
end
function v37.render(_) -- line: 383
end

local v38 = if not GetFFlagSurvBloxTrackingFixes() then RoactRodux.connect(nil, function(p9) -- line: 397
	-- upvalues: OpenWebview (copy), OpenCentralOverlayForSurveyPrompt (copy)
	return {
		openWebView = function(p10, p11) -- line: 399
			-- upvalues: p9 (copy), OpenWebview (copy)
			return p9(OpenWebview(p10, p11))
		end,
		openSurveyPrompt = function(p12, p13, p14, p15, p16, p17) -- line: 402
			-- upvalues: p9 (copy), OpenCentralOverlayForSurveyPrompt (copy)
			p9(OpenCentralOverlayForSurveyPrompt(p12, p13, p14, p15, p16, p17))
		end
	}
end)(v37) else RoactRodux.connect(nil, function(p18) -- line: 386
	-- upvalues: OpenWebview (copy), OpenCentralOverlayForSurveyPromptWithSurvBlox (copy)
	return {
		openWebView = function(p19, p20) -- line: 388
			-- upvalues: p18 (copy), OpenWebview (copy)
			return p18(OpenWebview(p19, p20))
		end,
		openSurveyPromptWithSurvBlox = function(p21, p22) -- line: 391
			-- upvalues: p18 (copy), OpenCentralOverlayForSurveyPromptWithSurvBlox (copy)
			p18(OpenCentralOverlayForSurveyPromptWithSurvBlox(p21, p22))
		end
	}
end)(v37)

if not GetFFlagSurvBloxTrackingFixes() then
	v38 = RoactAppExperiment.connectUserLayer({
		AppUserLayers.GameLeaveLayer,
		AppUserLayers.ExperienceMenuLayer
	}, function(p23, _) -- line: 429
		-- upvalues: AppUserLayers (copy)
		local v83 = p23[AppUserLayers.GameLeaveLayer] or {}
		local v84 = p23[AppUserLayers.ExperienceMenuLayer] or {}

		return {
			baseUrlFormat = v83.baseUrlFormat,
			surveyId = v83.surveyId,
			isQualified = v83.isQualified,
			eventType = v83.eventType,
			showPrompt = v83.showPrompt,
			titleText = v83.titleText or "",
			bodyText = v83.bodyText or "",
			cancelButtonText = v83.cancelButtonText or "",
			confirmButtonText = v83.confirmButtonText or "",
			surveyName = v83.surveyName,
			menuVersion = v84.menuVersion
		}
	end)(v38)
end

local v39 = RoactAppPolicy.connect(function(p25, _) -- line: 452
	return {
		restrictTextInput = p25.getCsatSurveyRestrictTextInput() or false
	}
end)(v38)

return (RoactServices.connect({
	sessionService = AppSessionService,
	localization = RoactLocalization,
	networking = RoactNetworking
})(v39))
