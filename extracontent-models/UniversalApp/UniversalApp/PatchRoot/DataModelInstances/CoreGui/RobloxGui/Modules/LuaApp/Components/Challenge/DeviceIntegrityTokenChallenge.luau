local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
local t = require(CorePackages.Packages.t)
local DeviceIntegrityChallengeEvent = require(Modules.LuaApp.Analytics.RobloxTelemetryConfigs.DeviceIntegrityChallengeEvent)
local ChallengeEventConstants = require(Modules.LuaApp.Components.Challenge.ChallengeEventConstants)
local GetFFlagEnableDualNativeCallAppleIntegrity = require(Modules.LuaApp.Flags.GetFFlagEnableDualNativeCallAppleIntegrity)

game:DefineFastInt("DeviceIntegrityNativeTimeoutMilliseconds", 450)

local v12 = Roact.PureComponent:extend(script.Name)

v12.validateProps = t.intersection(t.interface({
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

function v12.onRetrieveTokenFailure(p1, p2) -- line: 44
	-- upvalues: DeviceIntegrityChallengeEvent (copy), ChallengeEventConstants (copy), HttpService (copy)
	p1.props.loggingProtocol:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
		context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
		challengeId = p1.props.challengeId,
		integrityType = p2.integrityType
	})
	p1.props.onChallengeCompleted(HttpService:JSONEncode({
		redemptionToken = "",
		integrityType = p2.integrityType
	}))
end
function v12.init(p3) -- line: 57
	-- upvalues: HttpService (copy), DeviceIntegrityChallengeEvent (copy), ChallengeEventConstants (copy), GetFFlagEnableDualNativeCallAppleIntegrity (copy)
	local data = HttpService:JSONDecode(p3.props.challengeMetadata)

	p3.props.loggingProtocol:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
		context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInitialized,
		challengeId = p3.props.challengeId,
		integrityType = data.integrityType
	})

	local accountService = p3.props.accountService

	if accountService and accountService:DeviceIntegrityAvailable() then
		local DeviceIntegrityTokenYield = nil

		if GetFFlagEnableDualNativeCallAppleIntegrity() and data.integrityType == "appleintegrity" then
			DeviceIntegrityTokenYield = accountService:GetDeviceIntegrityTokenYield((HttpService:JSONEncode({
				challengeId = p3.props.challengeId
			})))
		end

		local DeviceIntegrityTokenYield2 = accountService:GetDeviceIntegrityTokenYield((HttpService:JSONEncode({
			requestHash = data.requestHash,
			tokenType = data.integrityType,
			timeoutMillis = game:GetFastInt("DeviceIntegrityNativeTimeoutMilliseconds")
		})))

		if GetFFlagEnableDualNativeCallAppleIntegrity() and data.integrityType == "appleintegrity" then
			if (DeviceIntegrityTokenYield2 == nil or DeviceIntegrityTokenYield2 == "") and (DeviceIntegrityTokenYield == nil or DeviceIntegrityTokenYield == "") then
				p3:onRetrieveTokenFailure(data)

				return
			end
		elseif DeviceIntegrityTokenYield2 == nil or DeviceIntegrityTokenYield2 == "" then
			p3:onRetrieveTokenFailure(data)

			return
		end

		local t1 = {
			token = "",
			result = ""
		}

		if DeviceIntegrityTokenYield2 ~= nil and DeviceIntegrityTokenYield2 ~= "" then
			t1 = HttpService:JSONDecode(DeviceIntegrityTokenYield2)
		end

		if GetFFlagEnableDualNativeCallAppleIntegrity() and data.integrityType == "appleintegrity" then
			local t2 = {
				redemptionToken = ""
			}

			if DeviceIntegrityTokenYield ~= nil and DeviceIntegrityTokenYield ~= "" then
				t2 = HttpService:JSONDecode(DeviceIntegrityTokenYield)
			end

			p3.props.onChallengeCompleted(HttpService:JSONEncode({
				redemptionToken = t1.token,
				integrityType = data.integrityType,
				attestationToken = t2.redemptionToken
			}), function() -- line: 121
				-- upvalues: data (copy), accountService (copy), HttpService (copy)
				if data.refreshProvider then
					accountService:GetDeviceIntegrityTokenYield(HttpService:JSONEncode({
						refreshTokenProvider = true
					}))
				end
			end)
		else
			p3.props.onChallengeCompleted(HttpService:JSONEncode({
				redemptionToken = t1.token,
				integrityType = data.integrityType
			}), function() -- line: 136
				-- upvalues: data (copy), accountService (copy), HttpService (copy)
				if data.refreshProvider then
					accountService:GetDeviceIntegrityTokenYield(HttpService:JSONEncode({
						refreshTokenProvider = true
					}))
				end
			end)
		end

		p3.props.loggingProtocol:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
			challengeId = p3.props.challengeId,
			integrityType = data.integrityType,
			result = t1.result
		})

		return
	end

	p3:onRetrieveTokenFailure(data)
end
function v12.render(p4) -- line: 158
	-- upvalues: Roact (copy)
	local uDim2 = UDim2.fromOffset(p4.props.screenSize.X, p4.props.screenSize.Y)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Active = true,
		Size = uDim2
	})
end

local v13 = RoactRodux.connect(function(p5, _) -- line: 167
	return {
		screenSize = p5.ScreenSize
	}
end, nil)(v12)

return (RoactServices.connect({
	loggingProtocol = AppLogging
})(v13))
