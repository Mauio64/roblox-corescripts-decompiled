local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local NotificationService = game:GetService("NotificationService")
local UserInputService = game:GetService("UserInputService")

local default = require("@luauforge/bundled/ggu").CredentialsProtocol.default

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local t = require(CorePackages.Packages.t)
local module2 = require("@luauforge/bundled/fBV")

local module3 = require("@luauforge/deferred/fvP")
local module4 = require("@luauforge/deferred/gJh")
local module5 = require("@luauforge/bundled/gJi")
local module6 = require("@luauforge/deferred/gIz")

local module7 = require("@luauforge/bundled/gvg")

local module8 = require("@luauforge/deferred/gJj")

local module9 = require("@luauforge/deferred/gJk")

local module10 = require("@luauforge/deferred/gJl")

local getFFlagLuaAppEnableCredentialsProtocol = require("@luauforge/bundled/ggu").Flags.GetFFlagLuaAppEnableCredentialsProtocol

local getFIntLuaAppCredentialsProtocolTimeout = require("@luauforge/bundled/ggu").Flags.GetFIntLuaAppCredentialsProtocolTimeout

local getFIntLuaAppCredentialsProtocolAvailableTimeout = require("@luauforge/bundled/ggu").Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout

local module11 = require("@luauforge/deferred/gJm")
local module12 = require("@luauforge/deferred/fBU")

local module13 = require("@luauforge/deferred/gJn")

local module14 = require("@luauforge/deferred/gJo")
local defineFastFlag = game:DefineFastFlag("EnableGCSWebViewLaunchFlowLogging", false)

local module15 = require("@luauforge/deferred/gzG")
local module16 = require("@luauforge/bundled/ego")
local module17 = require("@luauforge/bundled/ecq")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module19 = require("@luauforge/bundled/gJp")
local module20 = require("@luauforge/bundled/dVn")
local module21 = require("@luauforge/bundled/egZ")

local Foundation = require(CorePackages.Packages.Foundation)
local colorMode = Foundation.Enums.ColorMode
local default2 = LoggingProtocol.default

local extended = module16.PureComponent:extend("HybridWebView")

local v5 = nil
pcall(function()
	local AccountService = game:GetService("AccountService")
	v5 = AccountService
end)

extended.validateProps = t.intersection(t.interface({
	appContainerNavigation = t.interface({
		isVisible = t.boolean,
		displayOrder = t.integer
	}),
	onChallengeAbandoned = t.callback,
	onChallengeLoadFailed = t.callback,
	forceWebViewVisible = t.optional(t.boolean),
	onChallengeDisplayed = t.optional(t.callback),
	onChallengeUnmounted = t.optional(t.callback)
}), t.union(t.interface({
	challengeType = t.literal(module5.Captcha),
	challengeParameters = t.strictInterface({
		actionType = module4.isEnumValue,
		dataExchangeBlob = t.string,
		captchaId = t.string,
		onChallengeCompleted = t.callback,
		onChallengeInvalidated = t.callback
	})
}), t.interface({
	challengeType = t.literal(module5.SecurityQuestions),
	challengeParameters = t.strictInterface({
		userId = t.string,
		sessionId = t.string,
		onChallengeCompleted = t.callback,
		onChallengeInvalidated = t.callback
	})
}), t.interface({
	challengeType = t.literal(module5.TwoStepVerification),
	challengeParameters = t.strictInterface({
		challengeId = t.string,
		userId = t.string,
		actionType = module19.isEnumValue,
		allowRememberDevice = t.boolean,
		onChallengeCompleted = t.callback,
		onChallengeInvalidated = t.callback,
		clientSupports2svRecovery = t.optional(t.boolean),
		recoverySessionId = t.optional(t.string)
	})
}), t.interface({
	challengeType = t.literal(module5.Reauthentication),
	challengeParameters = t.strictInterface({
		onChallengeCompleted = t.callback,
		onChallengeInvalidated = t.callback
	})
}), t.interface({
	challengeType = t.literal(module5.Generic),
	challengeParameters = t.strictInterface({
		genericChallengeId = t.string,
		genericChallengeType = t.string,
		genericChallengeMetadata = t.string,
		onChallengeCompleted = t.callback,
		onChallengeInvalidated = t.callback
	})
})))

function extended:init()
	self:setState({
		challengeDisplayed = false,
		forceWebViewVisibleOnLoadFailure = false
	})

	self.webViewLoaded = false
	self.challengeInitializationFailed = false
	self.completionData = nil
	self.invalidationData = nil

	local platform = UserInputService:GetPlatform()
	self.appType = platform == Enum.Platform.Android and "android"
		or platform == Enum.Platform.IOS and "ios"
		or platform == Enum.Platform.Windows and "windows"
		or platform == Enum.Platform.OSX and "osx"
		or platform == Enum.Platform.UWP and "uwp"
		or platform == Enum.Platform.XBoxOne and "xbox"
		or "unknown"
end

function extended:didMount()
	self.isMounted = true

	local analytics = self.props.analytics

	local unixTimestampMillis = DateTime.now().UnixTimestampMillis
	spawn(function()
		local unixTimestampMillis2 = DateTime.now().UnixTimestampMillis

		while unixTimestampMillis2 - unixTimestampMillis < module11() * 1000 do
			wait(1)

			if self.webViewLoaded then
				return
			end

			if
				module13()
				and unixTimestampMillis2 - unixTimestampMillis >= module14() * 1000
				and not self.state.forceWebViewVisibleOnLoadFailure
			then
				self:setState({ forceWebViewVisibleOnLoadFailure = true })
			end

			unixTimestampMillis2 = DateTime.now().UnixTimestampMillis
		end

		if analytics ~= nil and analytics.Diag ~= nil then
			analytics.Diag:reportCounter("ChallengeHybridWebView_Timeout", 1)
		end

		if self.isMounted then
			if defineFastFlag then
				default2:logEventOnce("challenge_launch_fail")
			end

			self:navigateBack()
		end
	end)
end

function extended:willUnmount()
	self.isMounted = false

	if self.props.onChallengeUnmounted ~= nil then
		self.props.onChallengeUnmounted()
	end

	local v6

	if self.completionData == nil then
		if self.invalidationData == nil then
			if self.webViewLoaded and not self.challengeInitializationFailed then
				self.props.onChallengeAbandoned()
				v6 = "Abandoned"
			else
				v6 = self.webViewLoaded and "InitializationFailed" or "LoadFailed"
				self.props.onChallengeLoadFailed()
			end
		else
			self.props.challengeParameters.onChallengeInvalidated(self.invalidationData)
			v6 = "Invalidated"
		end
	else
		self.props.challengeParameters.onChallengeCompleted(self.completionData)
		v6 = "Completed"
	end

	if self.props.analytics ~= nil then
		local v7 = module5.toRawValue(self.props.challengeType):gsub("%-", "")

		if self.props.analytics.Diag ~= nil then
			local v8 = string.format("ChallengeHybridWebView_Result_%s_%s_%s", v6, self.appType, v7)
			self.props.analytics.Diag:reportCounter(v8, 1)
		end

		if self.props.analytics.EventStream ~= nil then
			self.props.analytics.EventStream:setRBXEventStream(v6, "challengeHybridWebViewResult", {
				appType = self.appType,
				challengeType = v7,
				queryParameters = self:getBaseQueryParameters() .. self:getChallengeTypeQueryParameters()
			})
		end
	end
end

local function buildQueryParametersFromTable(items)
	local queryParametersFromTable = ""

	for k, item in pairs(items) do
		queryParametersFromTable ..= string.format("%s=%s&", k, item)
	end

	return queryParametersFromTable
end

function extended:getChallengeTypeQueryParameters()
	local v6 = {
		[module5.Captcha] = function()
			return buildQueryParametersFromTable({
				["action-type"] = module4.toRawValue(self.props.challengeParameters.actionType),
				["data-exchange-blob"] = self.props.challengeParameters.dataExchangeBlob,
				["captcha-id"] = self.props.challengeParameters.captchaId
			})
		end,
		[module5.TwoStepVerification] = function()
			local v7 = {
				["challenge-id"] = self.props.challengeParameters.challengeId,
				["user-id"] = self.props.challengeParameters.userId,
				["action-type"] = module19.toRawValue(self.props.challengeParameters.actionType),
				["allow-remember-device"] = self.props.challengeParameters.allowRememberDevice and "true" or "false",
				["client-supports-2sv-recovery"] = self.props.challengeParameters.clientSupports2svRecovery and "true" or "false"
			}

			local recoverySessionId = self.props.challengeParameters.recoverySessionId

			if recoverySessionId ~= nil and string.len(recoverySessionId) > 0 then
				v7["recovery-session-id"] = recoverySessionId
			end

			return buildQueryParametersFromTable(v7)
		end,
		[module5.SecurityQuestions] = function()
			return buildQueryParametersFromTable({
				["user-id"] = self.props.challengeParameters.userId,
				["session-id"] = self.props.challengeParameters.sessionId
			})
		end,
		[module5.Reauthentication] = function()
			return buildQueryParametersFromTable({})
		end,
		[module5.Generic] = function()
			return buildQueryParametersFromTable({
				["generic-challenge-id"] = self.props.challengeParameters.genericChallengeId,
				["generic-challenge-type"] = self.props.challengeParameters.genericChallengeType,
				["challenge-metadata-json"] = self.props.challengeParameters.genericChallengeMetadata
			})
		end
	}

	return v6[self.props.challengeType]()
end

function extended:getBaseQueryParameters()
	local v6 = NotificationService.SelectedTheme == colorMode.Dark
	local v7 = {
		["challenge-type"] = module5.toRawValue(self.props.challengeType),
		["app-type"] = self.appType,
		["dark-mode"] = v6 and "true" or "false"
	}

	if module9() then
		v7.fc_nosuppress = "1"
	end

	if module8() then
		v7.fc_suppress = "1"
	end

	return buildQueryParametersFromTable(v7)
end

function extended.navigateBack(p2)
	p2.props.navigation.goBack()
end

function extended:render()
	local isVisible = self.props.appContainerNavigation.isVisible
	local displayOrder = self.props.appContainerNavigation.displayOrder
	local v6 = self.props.forceWebViewVisible and true
	local challengeDisplayed = self.state.challengeDisplayed
	local forceWebViewVisibleOnLoadFailure = self.state.forceWebViewVisibleOnLoadFailure

	local STATIC_CDN_URL = module7(self.props.challengeParameters.userId) and module20.STATIC_CDN_URL
		or module20.WWW_URL
	local v7 = string.format(
		"%schallenge/cdn/hybrid?%s%s",
		STATIC_CDN_URL,
		self:getBaseQueryParameters(),
		self:getChallengeTypeQueryParameters()
	)

	if defineFastFlag then
		default2:logEventOnce("challenge_launch_begin")
	end

	return module21({ title = "Feature.AccountSettings.Heading.Tab.Security" })(function(p2)
		return module16.createElement(module3, {
			isVisible = isVisible,
			displayOrder = displayOrder,
			ignoreBackNavigationDisabled = module10(),
			backNavigationHandledByParent = true,
			webViewVisible = v6 or isVisible and challengeDisplayed or forceWebViewVisibleOnLoadFailure,
			windowClosedCallback = function()
				if not module12() then
					self:navigateBack()
				end
			end,
			modal = false,
			isGenericWebview = true,
			enableOverlayReplacement = true,
			title = p2.title,
			url = v7,
			javaScriptCallback = function(json)
				if not self.isMounted then
					return
				end

				local jsonDecode = HttpService:JSONDecode(json)

				if
					jsonDecode.moduleID ~= module15.Module.Navigation
					or jsonDecode.functionName ~= module15.Function.navigateToFeature
					or not (jsonDecode.params and jsonDecode.params.params)
				then
					return
				end

				if not self.webViewLoaded then
					if defineFastFlag then
						default2:logEventOnce("challenge_launch_end")
					end

					self.webViewLoaded = true

					if self.props.analytics ~= nil and self.props.analytics.Diag ~= nil then
						self.props.analytics.Diag:reportCounter("ChallengeHybridWebView_NotTimeout", 1)
					end
				end

				local params = jsonDecode.params.params

				if params.feature == module15.Feature.ChallengeParsed and params.data.parsed == false then
					self.challengeInitializationFailed = true
					self:navigateBack()
				elseif
					params.feature == module15.Feature.ChallengeInitialized
					and params.data.initialized == false
				then
					self.challengeInitializationFailed = true
					self:navigateBack()
				elseif
					getFFlagLuaAppEnableCredentialsProtocol()
					and params.feature == module15.Feature.CredentialsProtocolAvailable
				then
					default:isAvailable(
						default.CredentialsTypes.FIDO2,
						getFIntLuaAppCredentialsProtocolAvailableTimeout()
					):andThen(function(p3)
						local isAvailable = p3.isAvailable or false
						module6.Execute(params.data.callId, (tostring(isAvailable)))
					end):catch(function()
						module6.Execute(params.data.callId, "false")
					end)
				elseif
					getFFlagLuaAppEnableCredentialsProtocol()
					and params.feature == module15.Feature.GetCredentials
				then
					default:getCredentials(
						default.CredentialsTypes.FIDO2,
						params.data.authenticationOptionsJSON,
						getFIntLuaAppCredentialsProtocolTimeout()
					):andThen(function(p3)
						if p3 ~= nil then
							logging.warn("Executing javascript on webview to return GetCredentialsResponse")
							local jsonEncode = HttpService:JSONEncode(p3)
							module6.Execute(params.data.callId, jsonEncode)
						end
					end):catch(function()
						module6.Execute(params.data.callId, "")
					end)
				elseif params.feature == module15.Feature.GetIntegrityToken then
					if game:GetEngineFeature("AccountService") and v5 and v5:DeviceIntegrityAvailable() then
						local deviceIntegrityTokenYield = v5:GetDeviceIntegrityTokenYield(params.data.deviceIntegrityParams)

						if deviceIntegrityTokenYield ~= nil then
							local jsonEncode = HttpService:JSONEncode(deviceIntegrityTokenYield)
							module6.Execute(params.data.callId, jsonEncode)
							return
						end
					end

					module6.Execute(params.data.callId, "")
				elseif params.feature == module15.Feature.ChallengeCompleted then
					self.completionData = params.data

					self:navigateBack()
				elseif params.feature == module15.Feature.ChallengeInvalidated then
					self.invalidationData = params.data

					self:navigateBack()
				elseif jsonDecode.params.params.feature == module15.Feature.ChallengeDisplayed then
					self:setState({ challengeDisplayed = true })

					if self.props.onChallengeDisplayed ~= nil then
						self.props.onChallengeDisplayed()
					end
				end
			end
		})
	end)
end

local v6 = RoactNavigation.withNavigation(extended)

local v7 = useSheetNavigation.connect(nil, function(p2)
	return {
		setBackNavigationDisabled = function(p3)
			return module2.setDisabled(p3)
		end
	}
end)(v6)

return (roactServices.connect({ analytics = module17 })(v7))
