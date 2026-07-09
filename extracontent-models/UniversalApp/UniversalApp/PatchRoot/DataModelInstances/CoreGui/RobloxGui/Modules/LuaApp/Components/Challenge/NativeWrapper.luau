local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Roact = require(Modules.Common.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
local GenericType = require(Modules.LuaApp.Enum.Challenge.GenericType)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local UrlBase = require(Modules.LuaApp.Http.UrlBase)
local Promise = require(Modules.LuaApp.Promise)
local ChallengeNativeWrapperEvent = require(Modules.LuaApp.Analytics.RobloxTelemetryConfigs.ChallengeNativeWrapperEvent)
local DeviceIntegrityTokenChallenge = require(Modules.LuaApp.Components.Challenge.DeviceIntegrityTokenChallenge)
local DeviceAccessTokenChallenge = require(Modules.LuaApp.Components.Challenge.DeviceAccessTokenChallenge)
local PrivateAccessTokenChallenge = require(Modules.LuaApp.Components.Challenge.PrivateAccessTokenChallenge)
local BiometricChallenge = require(Modules.LuaApp.Components.Challenge.BiometricChallenge)
local GetFFlagLuaAppChallengeMoreTelemetryEnabled = require(Modules.LuaApp.Flags.GetFFlagLuaAppChallengeMoreTelemetryEnabled)
local GetFFlagEnableNativeToWebviewMiddleware = require(Modules.LuaApp.Flags.GetFFlagEnableNativeToWebviewMiddleware)
local GetFFlagLuaAppSupportOnChallengeContinued = require(Modules.LuaApp.Flags.GetFFlagLuaAppSupportOnChallengeContinued)
local AccountService = nil

pcall(function() -- line: 29
	-- upvalues: AccountService (ref)
	AccountService = game:GetService("AccountService")
end)

local v25 = Roact.PureComponent:extend(script.Name)

v25.defaultProps = {
	accountService = AccountService
}

local v26 = UrlBuilder.new({
	path = "challenge/v1/continue",
	base = UrlBase.APIS
})

function canRenderNativeChallenge(p1, _) -- line: 47
	-- upvalues: GenericType (copy)
	return p1 == GenericType.DeviceIntegrity or (p1 == GenericType.DeviceAccessToken or (p1 == GenericType.PrivateAccessToken or p1 == GenericType.Biometric))
end
function v25.init(p3) -- line: 72
	p3:validateChallengeAndSetState(p3.props.challengeType, p3.props.challengeMetadata)
end
function v25.render(p4) -- line: 76
	-- upvalues: GenericType (copy), Roact (copy), DeviceIntegrityTokenChallenge (copy), DeviceAccessTokenChallenge (copy), PrivateAccessTokenChallenge (copy), BiometricChallenge (copy)
	local challengeType = p4.state.challengeType
	local challengeMetadata = p4.state.challengeMetadata

	if challengeType == GenericType.DeviceIntegrity then
		return Roact.createElement(DeviceIntegrityTokenChallenge, {
			challengeId = p4.props.challengeId,
			challengeMetadata = challengeMetadata,
			onChallengeCompleted = function(p5, p6) -- line: 84
				-- upvalues: p4 (copy)
				p4:challengeContinue(p5, p6)
			end,
			onChallengeFailed = function(p7) -- line: 87
				-- upvalues: p4 (copy)
				p4:failSession(p7)
			end,
			accountService = p4.props.accountService
		})
	end

	if challengeType == GenericType.DeviceAccessToken then
		return Roact.createElement(DeviceAccessTokenChallenge, {
			challengeId = p4.props.challengeId,
			challengeMetadata = challengeMetadata,
			onChallengeCompleted = function(p8) -- line: 96
				-- upvalues: p4 (copy)
				p4:challengeContinue(p8)
			end,
			onChallengeFailed = function(p9) -- line: 99
				-- upvalues: p4 (copy)
				p4:failSession(p9)
			end,
			accountService = p4.props.accountService
		})
	end

	if challengeType == GenericType.PrivateAccessToken then
		return Roact.createElement(PrivateAccessTokenChallenge, {
			challengeId = p4.props.challengeId,
			challengeMetadata = challengeMetadata,
			onChallengeCompleted = function(p10) -- line: 108
				-- upvalues: p4 (copy)
				p4:challengeContinue(p10)
			end,
			onChallengeFailed = function(p11) -- line: 111
				-- upvalues: p4 (copy)
				p4:failSession(p11)
			end,
			accountService = p4.props.accountService
		})
	end

	if challengeType == GenericType.Biometric then
		return Roact.createElement(BiometricChallenge, {
			challengeId = p4.props.challengeId,
			challengeMetadata = challengeMetadata,
			onChallengeCompleted = function(p12, p13) -- line: 120
				-- upvalues: p4 (copy)
				p4:challengeContinue(p12, p13)
			end,
			onChallengeAbandoned = function(p14) -- line: 123
				-- upvalues: p4 (copy)
				p4:abandonSession(p14)
			end,
			onChallengeFailed = function(p15) -- line: 126
				-- upvalues: p4 (copy)
				p4:failSession(p15)
			end
		})
	end

	return nil
end
function v25.clearState(p16) -- line: 135
	p16.props.navigation.goBack()
end
function v25.failSession(p17, p18) -- line: 139
	p17.props.onSessionFailed(p18)
	p17:clearState()
end
function v25.abandonSession(p19, p20) -- line: 144
	p19.props.onSessionAbandoned(p20)
	p19:clearState()
end
function v25.validateChallengeAndSetState(p21, p22, p23) -- line: 149
	-- upvalues: GenericType (copy), GetFFlagLuaAppChallengeMoreTelemetryEnabled (copy), ChallengeNativeWrapperEvent (copy), GetFFlagEnableNativeToWebviewMiddleware (copy)
	local v44 = GenericType.toRawValue(p22)

	if p22 == nil or (p22 == GenericType.Denied or p23 == nil or p23 == "") then
		if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
			p21.props.loggingProtocol:logRobloxTelemetryEvent(ChallengeNativeWrapperEvent, {}, {
				context = "renderFailure",
				challengeId = p21.props.challengeId,
				challengeType = v44,
				challengeMetadata = p23
			})
		end

		p21:failSession()

		return
	end

	if canRenderNativeChallenge(p22, p23) then
		if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
			p21.props.loggingProtocol:logRobloxTelemetryEvent(ChallengeNativeWrapperEvent, {}, {
				context = "challengeTriggered",
				challengeId = p21.props.challengeId,
				challengeType = v44,
				challengeMetadata = p23
			})
		end

		p21:setState({
			challengeType = p22,
			challengeMetadata = p23
		})

		return
	end

	if GetFFlagEnableNativeToWebviewMiddleware() then
		if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
			p21.props.loggingProtocol:logRobloxTelemetryEvent(ChallengeNativeWrapperEvent, {}, {
				context = "webviewChallengeTriggered",
				challengeId = p21.props.challengeId,
				challengeType = v44,
				challengeMetadata = p23
			})
		end

		p21:clearState()
		p21.props.onWebViewChallengeIssued(v44, p23)

		return
	end

	if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
		p21.props.loggingProtocol:logRobloxTelemetryEvent(ChallengeNativeWrapperEvent, {}, {
			context = "renderFailure",
			challengeId = p21.props.challengeId,
			challengeType = v44,
			challengeMetadata = p23
		})
	end

	p21:failSession()
end
function v25.challengeContinue(p24, p25, p26) -- line: 215
	-- upvalues: GenericType (copy), Promise (copy), HttpService (copy), v26 (copy), GetFFlagLuaAppSupportOnChallengeContinued (copy), GetFFlagLuaAppChallengeMoreTelemetryEnabled (copy), ChallengeNativeWrapperEvent (copy)
	local v48 = GenericType.toRawValue(p24.state.challengeType)

	return Promise.new(function(resolve, _) -- line: 217
		-- upvalues: HttpService (copy), p24 (copy), v48 (copy), p25 (copy), v26 (copy), GetFFlagLuaAppSupportOnChallengeContinued (copy), p26 (copy), GenericType (copy), GetFFlagLuaAppChallengeMoreTelemetryEnabled (copy), ChallengeNativeWrapperEvent (copy)
		local t1 = {
			postBody = HttpService:JSONEncode({
				challengeId = p24.props.challengeId,
				challengeType = v48,
				challengeMetadata = p25
			})
		}
		local v64, _ = p24.props.networkImpl(v26(), "POST", t1)

		return v64:andThen(function(p28) -- line: 226
			-- upvalues: GetFFlagLuaAppSupportOnChallengeContinued (copy), p26 (copy), GenericType (copy), p24 (copy), resolve (copy)
			if GetFFlagLuaAppSupportOnChallengeContinued() and p26 ~= nil then
				p26()
			end

			local responseBody = p28.responseBody

			if responseBody.challengeType ~= nil and responseBody.challengeType ~= "" then
				local v68 = GenericType.fromRawValue(responseBody.challengeType)

				p24:validateChallengeAndSetState(v68, responseBody.challengeMetadata)
				resolve()

				return
			end

			p24.props.onSessionCompleted()
			p24:clearState()
			resolve()
		end, function(p29) -- line: 240
			-- upvalues: GetFFlagLuaAppChallengeMoreTelemetryEnabled (copy), p24 (copy), ChallengeNativeWrapperEvent (copy), v48 (copy), p25 (copy), resolve (copy)
			if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
				p24.props.loggingProtocol:logRobloxTelemetryEvent(ChallengeNativeWrapperEvent, {}, {
					context = "continueFailure",
					challengeId = p24.props.challengeId,
					challengeType = v48,
					challengeMetadata = p25,
					error = tostring(p29.StatusCode)
				})
			end

			p24:failSession(p29)
			resolve()
		end)
	end)
end

local v27 = v25
local v28 = RoactNavigation.withNavigation(function(p30) -- line: 258
	-- upvalues: Roact (copy), v27 (copy), Cryo (copy)
	return Roact.createElement(v27, Cryo.Dictionary.join(p30, p30.navigation.getParam("extraProps", {})))
end)
local v29 = RoactRodux.connect(nil, nil)(v28)

return (RoactServices.connect({
	networkImpl = RoactNetworking,
	analytics = RoactAnalytics,
	loggingProtocol = AppLogging
})(v29))
