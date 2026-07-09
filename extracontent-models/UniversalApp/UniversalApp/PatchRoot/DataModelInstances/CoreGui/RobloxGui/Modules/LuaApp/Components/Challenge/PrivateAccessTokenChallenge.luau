local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
local t = require(CorePackages.Packages.t)
local PrivateAccessTokenChallengeEvent = require(Modules.LuaApp.Analytics.RobloxTelemetryConfigs.PrivateAccessTokenChallengeEvent)
local ChallengeEventConstants = require(Modules.LuaApp.Components.Challenge.ChallengeEventConstants)
local v11 = Roact.PureComponent:extend(script.Name)

v11.validateProps = t.intersection(t.interface({
	challengeId = t.string,
	challengeMetadata = t.string,
	onChallengeCompleted = t.callback,
	onChallengeFailed = t.callback,
	accountService = t.interface({
		DeviceIntegrityAvailable = t.callback,
		GetDeviceIntegrityToken = t.optional(t.callback)
	}),
	loggingProtocol = t.interface({
		logRobloxTelemetryEvent = t.callback
	})
}))

function v11.init(p1) -- line: 41
	-- upvalues: PrivateAccessTokenChallengeEvent (copy), ChallengeEventConstants (copy), HttpService (copy)
	p1.props.loggingProtocol:logRobloxTelemetryEvent(PrivateAccessTokenChallengeEvent, {}, {
		context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInitialized,
		challengeId = p1.props.challengeId
	})

	local accountService = p1.props.accountService

	if accountService and accountService:DeviceIntegrityAvailable() then
		local DeviceIntegrityTokenYield = accountService:GetDeviceIntegrityTokenYield((HttpService:JSONEncode({
			challengeId = p1.props.challengeId
		})))

		if DeviceIntegrityTokenYield == nil or DeviceIntegrityTokenYield == "" then
			p1:onRetrieveTokenFailure()

			return
		end

		local data = HttpService:JSONDecode(DeviceIntegrityTokenYield)

		if data.errorCode ~= nil then
			p1:onRetrieveTokenFailure()

			return
		end

		p1.props.onChallengeCompleted(HttpService:JSONEncode({
			redemptionToken = data.redemptionToken
		}))
		p1.props.loggingProtocol:logRobloxTelemetryEvent(PrivateAccessTokenChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
			challengeId = p1.props.challengeId
		})

		return
	end

	p1:onRetrieveTokenFailure()
end
function v11.onRetrieveTokenFailure(p2) -- line: 75
	-- upvalues: PrivateAccessTokenChallengeEvent (copy), ChallengeEventConstants (copy), HttpService (copy)
	p2.props.loggingProtocol:logRobloxTelemetryEvent(PrivateAccessTokenChallengeEvent, {}, {
		context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
		challengeId = p2.props.challengeId
	})
	p2.props.onChallengeCompleted(HttpService:JSONEncode({
		redemptionToken = ""
	}))
end
function v11.render(p3) -- line: 86
	-- upvalues: Roact (copy)
	local uDim2 = UDim2.fromOffset(p3.props.screenSize.X, p3.props.screenSize.Y)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Active = true,
		Size = uDim2
	})
end

local v12 = RoactRodux.connect(function(p4, _) -- line: 95
	return {
		screenSize = p4.ScreenSize
	}
end, nil)(v11)

return (RoactServices.connect({
	loggingProtocol = AppLogging
})(v12))
