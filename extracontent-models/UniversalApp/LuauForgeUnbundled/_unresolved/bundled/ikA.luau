local Players = game:GetService("Players")

local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking

local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)

local RoactRodux = require(CorePackages.Packages.RoactRodux)
local messageBus = require("@luauforge/bundled/ggr").MessageBus
local t = require(CorePackages.Packages.t)

local module = require("@luauforge/bundled/fzL")
local module2 = require("@luauforge/bundled/egY")
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module3 = require("@luauforge/bundled/fzK")
local module4 = require("@luauforge/bundled/ikB")
local module5 = require("@luauforge/bundled/ikC")

local module6 = require("@luauforge/bundled/ikD")

local module7 = require("@luauforge/bundled/ggq")
local module8 = require("@luauforge/bundled/ikE")
local module9 = require("@luauforge/bundled/ikF")
local module10 = require("@luauforge/bundled/ikG")
local module11 = require("@luauforge/bundled/ikH")
local module12 = require("@luauforge/bundled/ikI")
local module13 = require("@luauforge/bundled/ikJ")
local module14 = require("@luauforge/bundled/ikK")

local module15 = require("@luauforge/bundled/ikL")
local module16 = require("@luauforge/bundled/ikM")
local OPEN_SURVEY_EVENT_DESCRIPTOR = module15.OPEN_SURVEY_EVENT_DESCRIPTOR
local value = t.valueOf(module16)

local fFlagSurvBloxEventTypeEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSurvBloxEventTypeEnabled

local extended = Roact.PureComponent:extend("CsatSurveyInterceptEventReceiver")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	baseUrlFormat = "",
	surveyId = "",
	isQualified = false,
	restrictTextInput = false,
	eventType = "",
	showPrompt = false,
	analyticsService = RbxAnalyticsService,
	titleText = "",
	bodyText = "",
	cancelButtonText = "",
	confirmButtonText = "",
	surveyName = "",
	menuVersion = ""
}

function extended:getSurveyUrl(p2, p3, p4)
	assert(t.boolean(self.props.restrictTextInput))

	local v5 = p2 or tostring(Players.LocalPlayer.UserId)
	assert(t.string(v5))

	local sessionInfoString = self.props.sessionService:generateSessionInfoString(false, true, false, false)

	if module10() then
		if not fFlagSurvBloxEventTypeEnabled then
			p4 = nil
		end

		local v6, v7 = module4(self.props.networking, p4):await()

		if module14() then
			if v6 and v7 then
				self:trackSurveyIdLocally()

				if v7.shouldPromptSurvey then
					if module12() then
						return module3.fromString(v7.surveyLink)({
							userId = v5 or "0",
							restrictTextInput = tostring(self.props.restrictTextInput) or "true",
							sessionIds = sessionInfoString
						})
					end

					return v7.surveyLink
				end
			end
		elseif v6 and v7 and v7.shouldPromptSurvey then
			if module12() then
				return module3.fromString(v7.surveyLink)({
					userId = v5 or "0",
					restrictTextInput = tostring(self.props.restrictTextInput) or "true",
					sessionIds = sessionInfoString
				})
			end

			return v7.surveyLink
		end

		return ""
	end

	assert(t.string(self.props.baseUrlFormat))
	assert(t.string(self.props.surveyId))

	return (module3.fromString(self.props.baseUrlFormat)({
		surveyId = self.props.surveyId or "",
		userId = v5 or "0",
		restrictTextInput = tostring(self.props.restrictTextInput) or "true",
		sessionIds = sessionInfoString,
		menuVersion = self.props.surveyName == module7.CHROME_SURVEY_NAME and self.props.menuVersion or ""
	}))
end

function extended:getCompletedSurveyIds()
	local success, result = pcall(function()
		return AppStorageService:GetItem(module7.LOCAL_STORAGE_KEY_CSAT_SURVEY_COMPLETED_IDS)
	end)

	if success and result ~= "" then
		return HttpService:JSONDecode(result)
	end

	warn("Unable to fetch completed survey ids from app storage ", result)
	self.props.analyticsService:SetRBXEventStream(
		module7.ANALYTICS_CONTEXT_APP,
		module7.ANALYTICS_SURVEY_EVENT,
		module7.ANALYTICS_EXPERIMENT_MENU_GET_COMPLETED_SURVEY_IDS_FIELD,
		{ error = result }
	)

	return {}
end

function extended:hasCompletedSurvey(): boolean
	assert(t.string(self.props.surveyId))

	for i, completedSurveyId in ipairs(self.completedSurveyIds) do
		if completedSurveyId == self.props.surveyId then
			return true
		end
	end

	return false
end

function extended:trackSurveyIdLocally()
	if module10() then
		if module11() then
			local success, result = pcall(function()
				AppStorageService:SetItem(
					module7.LOCAL_STORAGE_KEY_CSAT_LAST_SURVBLOX_CALL_TIMESTAMP,
					(tostring(DateTime.now().UnixTimestampMillis))
				)

				AppStorageService:Flush()
			end)

			if not success then
				warn("Uncaught exception for setting last SurvBlox call timestamp on app storage", result)
			end
		end
	else
		assert(t.string(self.props.surveyId))

		if self:hasCompletedSurvey() then
			return
		end

		if #self.completedSurveyIds >= module7.LOCAL_STORAGE_CSAT_SURVEY_IDS_LIMIT then
			self.completedSurveyIds = Cryo.List.getRange(
				self.completedSurveyIds,
				2,
				#self.completedSurveyIds
			)
		end

		table.insert(self.completedSurveyIds, self.props.surveyId)

		local success, result = pcall(function()
			local jsonEncode = HttpService:JSONEncode(self.completedSurveyIds)
			AppStorageService:SetItem(
				module7.LOCAL_STORAGE_KEY_CSAT_SURVEY_COMPLETED_IDS,
				jsonEncode or "{}"
			)
			AppStorageService:Flush()
		end)

		if not success then
			warn("Uncaught exception for setting completed CSAT survey ids on app storage", result)

			self.props.analyticsService:SetRBXEventStream(
				module7.ANALYTICS_CONTEXT_APP,
				module7.ANALYTICS_SURVEY_EVENT,
				module7.ANALYTICS_EXPERIMENT_MENU_SET_COMPLETED_SURVEY_IDS_FIELD,
				{ error = result }
			)
		end
	end
end

function extended:canShowSurvey()
	if module10() then
		if not module11() then
			return true
		end

		local success, result = pcall(function()
			return AppStorageService:GetItem(module7.LOCAL_STORAGE_KEY_CSAT_LAST_SURVBLOX_CALL_TIMESTAMP)
		end)

		if success then
			local v5 = tonumber(result)

			if v5 == -1 or DateTime.now().UnixTimestampMillis - v5 >= module13() then
				return true
			end
		else
			warn("Unable to fetch last time a call to SurvBlox was made ", result)
			module9.logGetLastSurvBloxCallTimestampError()
		end

		return false
	else
		assert(t.string(self.props.surveyId))

		if self.props.surveyId == "" or self.props.surveyId == nil or self:hasCompletedSurvey() then
			return false
		end

		if self.props.surveyName ~= module7.CHROME_SURVEY_NAME then
			return self.props.isQualified
		end

		local canShowChromeSurvey = module8.canShowChromeSurvey(self.props.menuVersion)
		return self.props.isQualified and canShowChromeSurvey
	end
end

function extended:openSurveyWebviewWithPrompt(p2, p3)
	function self.surveyPromptFunc()
		wait(0.2)

		self.props.openWebView(p2, p3)

		self:trackSurveyIdLocally()
	end

	function self.surveyPromptClose()
		self:trackSurveyIdLocally()
	end

	if module14() then
		self.props.openSurveyPromptWithSurvBlox(self.surveyPromptFunc, self.surveyPromptClose)
	else
		self.props.openSurveyPrompt(
			self.surveyPromptFunc,
			self.surveyPromptClose,
			self.props.titleText,
			self.props.bodyText,
			self.props.cancelButtonText,
			self.props.confirmButtonText
		)
	end
end

function extended:openSurveyWebview(p2, p3, p4)
	if self:canShowSurvey() then
		local surveyUrl = self:getSurveyUrl(p2, p3, p4)
		local formatted = self.props.localization:Format(module7.WEBVIEW_NAME_KEY)

		if module10() and surveyUrl == "" then
			return
		end

		if module14() then
			self:openSurveyWebviewWithPrompt(surveyUrl, formatted)
			return
		end

		if self.props.showPrompt then
			self:openSurveyWebviewWithPrompt(surveyUrl, formatted)
			return
		end

		wait(0.2)

		self.props.openWebView(surveyUrl, formatted)

		self:trackSurveyIdLocally()
	end
end

function extended:triggerEventTypeIsAllowed(p3): boolean
	if fFlagSurvBloxEventTypeEnabled then
		return value(p3) == true
	end

	if module14() then
		if p3 == module7.EVENT_TYPE_ENUM.ON_LEAVE_BUTTON_CLICK then
			return true
		end
	elseif self.props.eventType == p3 and p3 == module7.EVENT_TYPE_ENUM.ON_LEAVE_BUTTON_CLICK then
		return true
	end

	return false
end

function extended:init()
	if not module14() then
		self.completedSurveyIds = self:getCompletedSurveyIds()
	end

	self.subscriber = messageBus.Subscriber.new()
	local v5

	if fFlagSurvBloxEventTypeEnabled then
		v5 = OPEN_SURVEY_EVENT_DESCRIPTOR
	else
		v5 = module7.ON_SURVEY_EVENT_DESCRIPTOR
	end

	self.subscriber:subscribe(v5, function(data)
		if self:triggerEventTypeIsAllowed(data.eventType) then
			self.subscriber:unsubscribe(v5)
			self:openSurveyWebview(data.userId, data.customProps, data.eventType)
		end
	end)
end

function extended.render(p2) end

local v5

if module14() then
	v5 = RoactRodux.connect(nil, function(callback)
		return {
			openWebView = function(p2, p3)
				return callback(module(p2, p3))
			end,
			openSurveyPromptWithSurvBlox = function(p2, p3)
				callback(module6(p2, p3))
			end
		}
	end)(extended)
else
	v5 = RoactRodux.connect(nil, function(callback)
		return {
			openWebView = function(p2, p3)
				return callback(module(p2, p3))
			end,
			openSurveyPrompt = function(p2, p3, p4, p5, p6, p7)
				callback(module5(p2, p3, p4, p5, p6, p7))
			end
		}
	end)(extended)
end

if not module14() then
	v5 = RoactAppExperiment.connectUserLayer(
		{ appUserLayers.GameLeaveLayer, appUserLayers.ExperienceMenuLayer },
		function(p2, p3)
			local v6 = p2[appUserLayers.GameLeaveLayer] or {}

			local v7 = p2[appUserLayers.ExperienceMenuLayer] or {}
			return {
				baseUrlFormat = v6.baseUrlFormat,
				surveyId = v6.surveyId,
				isQualified = v6.isQualified,
				eventType = v6.eventType,
				showPrompt = v6.showPrompt,
				titleText = v6.titleText or "",
				bodyText = v6.bodyText or "",
				cancelButtonText = v6.cancelButtonText or "",
				confirmButtonText = v6.confirmButtonText or "",
				surveyName = v6.surveyName,
				menuVersion = v7.menuVersion
			}
		end
	)(v5)
end

local v6 = roactAppPolicy.connect(function(p2, p3)
	return {
		restrictTextInput = p2.getCsatSurveyRestrictTextInput() or false
	}
end)(v5)

return (roactServices.connect({
	sessionService = appSessionService,
	localization = module2,
	networking = roactNetworking
})(v6))
