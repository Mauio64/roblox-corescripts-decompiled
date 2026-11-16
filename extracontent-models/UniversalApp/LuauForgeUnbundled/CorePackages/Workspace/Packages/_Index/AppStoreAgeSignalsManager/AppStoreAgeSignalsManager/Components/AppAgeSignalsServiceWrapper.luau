local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStoreAgeSignalsManager/Promise")
local AppAgeSignalsTelemetryConfigs = require("@game/CorePackages/Workspace/Packages/_Index/AppStoreAgeSignalsManager/AppStoreAgeSignalsManager/Telemetry/AppAgeSignalsTelemetryConfigs")

local defineFastFlag = game:DefineFastFlag("EnableAppAgeSignalsService", false)

return {
	isAvailable = function()
		if not defineFastFlag then
			return false
		end

		local success, result = pcall(function()
			return game:GetService("AppAgeSignalsService")
		end)

		if not (success and result) then
			return false
		end

		local success2, result2 = pcall(function()
			return result:IsAvailable()
		end)

		if success2 then
			return result2
		end

		AppAgeSignalsTelemetryConfigs.reportError({
			error = "IsAvailable threw: " .. tostring(result2),
			signalSource = "unknown"
		})

		return false
	end,
	getAppAgeSignalsAsync = function()
		return Promise.new(function(callback, callback2)
			local success, result = pcall(function()
				local AppAgeSignalsService = game:GetService("AppAgeSignalsService")
				return AppAgeSignalsService:GetAppAgeSignalsAsync()
			end)

			if not success then
				callback2(result)
			elseif result.Error and result.Error ~= "" then
				callback2(result.Error)
			else
				callback(result.PlatformPayload)
			end
		end)
	end
}
