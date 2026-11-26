local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/egx")
local module2 = require("@luauforge/bundled/ego")
local Cryo = require(CorePackages.Packages.Cryo)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local module3 = require("@luauforge/bundled/ecq")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local module5 = require("@luauforge/bundled/hKY")
local module6 = require("@luauforge/bundled/fzK")
local UrlBuilder = require("@game/CorePackages/Packages/_Index/UrlBuilder/UrlBuilder")
local module8 = require("@luauforge/bundled/egs")
local module9 = require("@luauforge/deferred/hKZ")

local module10 = require("@luauforge/deferred/hLa")
local module11 = require("@luauforge/deferred/hLe")
local module12 = require("@luauforge/deferred/hLh")
local module13 = require("@luauforge/deferred/hLj")

local GetFFlagEnableNativeToWebviewMiddleware = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Flags/GetFFlagEnableNativeToWebviewMiddleware")
local module15 = require("@luauforge/bundled/hLm")

local module16 = require("@luauforge/deferred/hLn")

local v5 = nil
pcall(function()
	local AccountService = game:GetService("AccountService")
	v5 = AccountService
end)

local extended = module2.PureComponent:extend("NativeWrapper")
extended.defaultProps = { accountService = v5 }

local v6 = module6.new({ base = UrlBuilder.APIS, path = "challenge/v1/continue" })

function LUAUFORGE_MODULE_GLOBALS_hKX_canRenderNativeChallenge(p2, p3): boolean
	return p2 == module5.DeviceIntegrity
		or p2 == module5.DeviceAccessToken
		or p2 == module5.PrivateAccessToken
		or p2 == module5.Biometric
end

function extended:init()
	self:validateChallengeAndSetState(self.props.challengeType, self.props.challengeMetadata)
end

function extended:render()
	local challengeType = self.state.challengeType
	local challengeMetadata = self.state.challengeMetadata

	if challengeType == module5.DeviceIntegrity then
		return module2.createElement(module10, {
			challengeId = self.props.challengeId,
			challengeMetadata = challengeMetadata,
			onChallengeCompleted = function(p2, p3)
				self:challengeContinue(p2, p3)
			end,
			onChallengeFailed = function(p2)
				self:failSession(p2)
			end,
			accountService = self.props.accountService
		})
	end

	if challengeType == module5.DeviceAccessToken then
		return module2.createElement(module11, {
			challengeId = self.props.challengeId,
			challengeMetadata = challengeMetadata,
			onChallengeCompleted = function(p2)
				self:challengeContinue(p2)
			end,
			onChallengeFailed = function(p2)
				self:failSession(p2)
			end,
			accountService = self.props.accountService
		})
	end

	if challengeType == module5.PrivateAccessToken then
		return module2.createElement(module12, {
			challengeId = self.props.challengeId,
			challengeMetadata = challengeMetadata,
			onChallengeCompleted = function(p2)
				self:challengeContinue(p2)
			end,
			onChallengeFailed = function(p2)
				self:failSession(p2)
			end,
			accountService = self.props.accountService
		})
	end

	if challengeType == module5.Biometric then
		return module2.createElement(module13, {
			challengeId = self.props.challengeId,
			challengeMetadata = challengeMetadata,
			onChallengeCompleted = function(p2, p3)
				self:challengeContinue(p2, p3)
			end,
			onChallengeAbandoned = function(p2)
				self:abandonSession(p2)
			end,
			onChallengeFailed = function(p2)
				self:failSession(p2)
			end
		})
	end

	return nil
end

function extended:clearState()
	self.props.navigation.goBack()
end

function extended:failSession(p2)
	self.props.onSessionFailed(p2)
	self:clearState()
end

function extended:abandonSession(p2)
	self.props.onSessionAbandoned(p2)
	self:clearState()
end

function extended:validateChallengeAndSetState(p2, p3)
	local rawValue = module5.toRawValue(p2)

	if p2 == nil or p2 == module5.Denied or p3 == nil or p3 == "" then
		if GetFFlagEnableNativeToWebviewMiddleware() then
			self.props.loggingProtocol:logRobloxTelemetryEvent(module9, {}, {
				context = "renderFailure",
				challengeId = self.props.challengeId,
				challengeType = rawValue,
				challengeMetadata = p3
			})
		end

		self:failSession()
	elseif LUAUFORGE_MODULE_GLOBALS_hKX_canRenderNativeChallenge(p2, p3) then
		if GetFFlagEnableNativeToWebviewMiddleware() then
			self.props.loggingProtocol:logRobloxTelemetryEvent(module9, {}, {
				context = "challengeTriggered",
				challengeId = self.props.challengeId,
				challengeType = rawValue,
				challengeMetadata = p3
			})
		end

		self:setState({ challengeType = p2, challengeMetadata = p3 })
	elseif module15() then
		if GetFFlagEnableNativeToWebviewMiddleware() then
			self.props.loggingProtocol:logRobloxTelemetryEvent(module9, {}, {
				context = "webviewChallengeTriggered",
				challengeId = self.props.challengeId,
				challengeType = rawValue,
				challengeMetadata = p3
			})
		end

		self:clearState()
		self.props.onWebViewChallengeIssued(rawValue, p3)
	else
		if GetFFlagEnableNativeToWebviewMiddleware() then
			self.props.loggingProtocol:logRobloxTelemetryEvent(module9, {}, {
				context = "renderFailure",
				challengeId = self.props.challengeId,
				challengeType = rawValue,
				challengeMetadata = p3
			})
		end

		self:failSession()
	end
end

function extended:challengeContinue(p2, callback)
	local rawValue = module5.toRawValue(self.state.challengeType)
	return module8.new(function(callback2, p3)
		local v7 = {
			postBody = HttpService:JSONEncode({
				challengeId = self.props.challengeId,
				challengeType = rawValue,
				challengeMetadata = p2
			})
		}

		local networkImpl, v8 = self.props.networkImpl(v6(), "POST", v7)
		return networkImpl:andThen(function(p4)
			if module16() and callback ~= nil then
				callback()
			end

			local responseBody = p4.responseBody

			if responseBody.challengeType == nil or responseBody.challengeType == "" then
				self.props.onSessionCompleted()
				self:clearState()
				callback2()
			else
				self:validateChallengeAndSetState(
					module5.fromRawValue(responseBody.challengeType),
					responseBody.challengeMetadata
				)
				callback2()
			end
		end, function(p4)
			if GetFFlagEnableNativeToWebviewMiddleware() then
				self.props.loggingProtocol:logRobloxTelemetryEvent(module9, {}, {
					context = "continueFailure",
					challengeId = self.props.challengeId,
					challengeType = rawValue,
					challengeMetadata = p2,
					error = tostring(p4.StatusCode)
				})
			end

			self:failSession(p4)
			callback2()
		end)
	end)
end

local v7 = RoactNavigation.withNavigation(function(p2)
	return module2.createElement(
		extended,
		Cryo.Dictionary.join(p2, p2.navigation.getParam("extraProps", {}))
	)
end)
local v8 = useSheetNavigation.connect(nil, nil)(v7)
return (roactServices.connect({
	networkImpl = module,
	analytics = module3,
	loggingProtocol = appLogging
})(v8))
