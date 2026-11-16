local parent = script:FindFirstAncestor("AuthAnalytics").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local TelemetryConfigs = require(script.Parent.TelemetryConfigs)

local defineFastFlag = game:DefineFastFlag("LuaAppCredentialSheetEventStream", false)

local v = {
	[TelemetryConfigs.IosAuthServiceLoginCredentialSheetShownConfig.eventName] = TelemetryConfigs.IosAuthServiceLoginCredentialSheetShownEventConfig,
	[TelemetryConfigs.IosAuthServiceLoginCredentialSheetPasswordSelectedConfig.eventName] = TelemetryConfigs.IosAuthServiceLoginCredentialSheetPasswordSelectedEventConfig,
	[TelemetryConfigs.IosAuthServiceLoginCredentialSheetPasskeySelectedConfig.eventName] = TelemetryConfigs.IosAuthServiceLoginCredentialSheetPasskeySelectedEventConfig,
	[TelemetryConfigs.IosAuthServiceLoginCredentialSheetErrorConfig.eventName] = TelemetryConfigs.IosAuthServiceLoginCredentialSheetErrorEventConfig,
	[TelemetryConfigs.IosAuthServiceLoginCredentialSheetDismissedConfig.eventName] = TelemetryConfigs.IosAuthServiceLoginCredentialSheetDismissedEventConfig,
	[TelemetryConfigs.IosAuthServiceLoginCredentialSheetLoginSuccessConfig.eventName] = TelemetryConfigs.IosAuthServiceLoginCredentialSheetLoginSuccessEventConfig,
	[TelemetryConfigs.IosAuthServiceLoginCredentialSheetLoginFailureConfig.eventName] = TelemetryConfigs.IosAuthServiceLoginCredentialSheetLoginFailureEventConfig,
	[TelemetryConfigs.IosAuthServiceLoginCredentialSheetUnavailableConfig.eventName] = TelemetryConfigs.IosAuthServiceLoginCredentialSheetUnavailableEventConfig
}

return {
	report = function(p, p2)
		default:logRobloxTelemetryCounter(p, 1, p2)

		if not defineFastFlag then
			return
		end

		local v2 = v[p.eventName]

		if v2 == nil then
			return
		end

		default:logRobloxTelemetryEvent(v2, nil, p2)
	end
}
