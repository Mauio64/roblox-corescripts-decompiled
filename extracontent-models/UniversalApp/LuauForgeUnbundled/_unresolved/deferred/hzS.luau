local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/ecR")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local t = require(CorePackages.Packages.t)
local module3 = require("@luauforge/deferred/hzT")
local module4 = require("@luauforge/deferred/hzN")

local extended = module.PureComponent:extend("PrivateAccessTokenChallenge")

extended.validateProps = t.intersection(t.interface({
	challengeId = t.string,
	challengeMetadata = t.string,
	onChallengeCompleted = t.callback,
	onChallengeFailed = t.callback,
	accountService = t.interface({
		DeviceIntegrityAvailable = t.callback,
		GetDeviceIntegrityToken = t.optional(t.callback)
	}),
	loggingProtocol = t.interface({ logRobloxTelemetryEvent = t.callback })
}))

function extended:init()
	self.props.loggingProtocol:logRobloxTelemetryEvent(module3, {}, {
		context = module4.ChallengeLifecycleEventConstants.ChallengeInitialized,
		challengeId = self.props.challengeId
	})

	local accountService = self.props.accountService

	if not (accountService and accountService:DeviceIntegrityAvailable()) then
		self:onRetrieveTokenFailure()
		return
	end

	local deviceIntegrityTokenYield = accountService:GetDeviceIntegrityTokenYield((HttpService:JSONEncode({
		challengeId = self.props.challengeId
	})))

	if deviceIntegrityTokenYield == nil or deviceIntegrityTokenYield == "" then
		self:onRetrieveTokenFailure()
		return
	end

	local jsonDecode = HttpService:JSONDecode(deviceIntegrityTokenYield)

	if jsonDecode.errorCode ~= nil then
		self:onRetrieveTokenFailure()
		return
	end

	self.props.onChallengeCompleted(HttpService:JSONEncode({
		redemptionToken = jsonDecode.redemptionToken
	}))

	self.props.loggingProtocol:logRobloxTelemetryEvent(module3, {}, {
		context = module4.ChallengeLifecycleEventConstants.ChallengeCompleted,
		challengeId = self.props.challengeId
	})
end

function extended:onRetrieveTokenFailure()
	self.props.loggingProtocol:logRobloxTelemetryEvent(module3, {}, {
		context = module4.ChallengeLifecycleEventConstants.ChallengeInvalidated,
		challengeId = self.props.challengeId
	})

	self.props.onChallengeCompleted(HttpService:JSONEncode({ redemptionToken = "" }))
end

function extended.render(p2)
	local udim = UDim2.fromOffset(p2.props.screenSize.X, p2.props.screenSize.Y)
	return module.createElement("Frame", {
		Size = udim,
		BackgroundTransparency = 1,
		Active = true
	})
end

local v5 = useSheetNavigation.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, nil)(extended)

return (roactServices.connect({ loggingProtocol = appLogging })(v5))
