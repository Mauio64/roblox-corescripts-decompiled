local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/LoggingProtocol").default
local TelemetryConfigs = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/RobloxTelemetry/TelemetryConfigs")

local defineFastFlag = game:DefineFastFlag("LuaAppCredentialSheetEventStream", false)

local v5 = {
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
	report = function(p2, p3)
		default:logRobloxTelemetryCounter(p2, 1, p3)

		if not defineFastFlag then
			return
		end

		local v6 = v5[p2.eventName]

		if v6 == nil then
			return
		end

		default:logRobloxTelemetryEvent(v6, nil, p3)
	end
}
