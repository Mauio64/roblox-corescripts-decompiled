local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local t = require(CorePackages.Packages.t)
local ShopIconClickEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/InExperienceShop/Events/ShopIconClickEvent")
local module4 = require("@luauforge/deferred/hLc")

local module5 = require("@luauforge/deferred/hLd")
game:DefineFastInt("DeviceIntegrityNativeTimeoutMilliseconds", 450)

local extended = module.PureComponent:extend("DeviceIntegrityTokenChallenge")

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

function extended:onRetrieveTokenFailure(p3)
	self.props.loggingProtocol:logRobloxTelemetryEvent(ShopIconClickEvent, {}, {
		context = module4.ChallengeLifecycleEventConstants.ChallengeInvalidated,
		challengeId = self.props.challengeId,
		integrityType = p3.integrityType
	})

	self.props.onChallengeCompleted(HttpService:JSONEncode({
		redemptionToken = "",
		integrityType = p3.integrityType
	}))
end

function extended:init()
	local jsonDecode = HttpService:JSONDecode(self.props.challengeMetadata)
	self.props.loggingProtocol:logRobloxTelemetryEvent(ShopIconClickEvent, {}, {
		context = module4.ChallengeLifecycleEventConstants.ChallengeInitialized,
		challengeId = self.props.challengeId,
		integrityType = jsonDecode.integrityType
	})

	local accountService = self.props.accountService

	if not (accountService and accountService:DeviceIntegrityAvailable()) then
		self:onRetrieveTokenFailure(jsonDecode)

		return
	end

	local deviceIntegrityTokenYield

	if module5() and jsonDecode.integrityType == "appleintegrity" then
		deviceIntegrityTokenYield = accountService:GetDeviceIntegrityTokenYield((HttpService:JSONEncode({
			challengeId = self.props.challengeId
		})))
	end

	local deviceIntegrityTokenYield2 = accountService:GetDeviceIntegrityTokenYield((HttpService:JSONEncode({
		requestHash = jsonDecode.requestHash,
		tokenType = jsonDecode.integrityType,
		timeoutMillis = game:GetFastInt("DeviceIntegrityNativeTimeoutMilliseconds")
	})))

	if module5() and jsonDecode.integrityType == "appleintegrity" then
		if
			(deviceIntegrityTokenYield2 == nil or deviceIntegrityTokenYield2 == "")
			and (deviceIntegrityTokenYield == nil or deviceIntegrityTokenYield == "")
		then
			self:onRetrieveTokenFailure(jsonDecode)
			return
		end
	elseif deviceIntegrityTokenYield2 == nil or deviceIntegrityTokenYield2 == "" then
		self:onRetrieveTokenFailure(jsonDecode)
		return
	end

	local v5 = (deviceIntegrityTokenYield2 == nil or deviceIntegrityTokenYield2 == "")
		and { token = "", result = "" }
		or HttpService:JSONDecode(deviceIntegrityTokenYield2)

	if module5() and jsonDecode.integrityType == "appleintegrity" then
		local v6 = (deviceIntegrityTokenYield == nil or deviceIntegrityTokenYield == "")
			and { redemptionToken = "" }
			or HttpService:JSONDecode(deviceIntegrityTokenYield)

		self.props.onChallengeCompleted(
			HttpService:JSONEncode({
				redemptionToken = v5.token,
				integrityType = jsonDecode.integrityType,
				attestationToken = v6.redemptionToken
			}),
			function()
				if jsonDecode.refreshProvider then
					accountService:GetDeviceIntegrityTokenYield(HttpService:JSONEncode({
						refreshTokenProvider = true
					}))
				end
			end
		)
	else
		self.props.onChallengeCompleted(
			HttpService:JSONEncode({
				redemptionToken = v5.token,
				integrityType = jsonDecode.integrityType
			}),
			function()
				if jsonDecode.refreshProvider then
					accountService:GetDeviceIntegrityTokenYield(HttpService:JSONEncode({
						refreshTokenProvider = true
					}))
				end
			end
		)
	end

	self.props.loggingProtocol:logRobloxTelemetryEvent(ShopIconClickEvent, {}, {
		context = module4.ChallengeLifecycleEventConstants.ChallengeCompleted,
		challengeId = self.props.challengeId,
		integrityType = jsonDecode.integrityType,
		result = v5.result
	})
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
