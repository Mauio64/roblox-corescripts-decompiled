local AppStoreAgeSignalsManager = script:FindFirstAncestor("AppStoreAgeSignalsManager")
local AppStoreAgeSignalsManagerParent = AppStoreAgeSignalsManager.Parent
local Promise = require(AppStoreAgeSignalsManagerParent.Promise)
local AppAgeSignalsTelemetryConfigs = require(AppStoreAgeSignalsManager.Telemetry.AppAgeSignalsTelemetryConfigs)
local v5 = game:DefineFastFlag("EnableAppAgeSignalsService", false)

return {
	isAvailable = function() -- line: 10
		-- upvalues: v5 (copy), AppAgeSignalsTelemetryConfigs (copy)
		if not v5 then
			return false
		end

		local ok, result = pcall(function() -- line: 14
			return game:GetService("AppAgeSignalsService")
		end)

		if not ok or not result then
			return false
		end

		local ok2, result2 = pcall(function() -- line: 20
			-- upvalues: result (copy)
			return result:IsAvailable()
		end)

		if not ok2 then
			AppAgeSignalsTelemetryConfigs.reportError({
				signalSource = "unknown",
				error = "IsAvailable threw: " .. tostring(result2)
			})

			return false
		end

		return result2
	end,
	getAppAgeSignalsAsync = function() -- line: 32
		-- upvalues: Promise (copy)
		return Promise.new(function(resolve, reject) -- line: 33
			local ok, result = pcall(function() -- line: 34
				return game:GetService("AppAgeSignalsService"):GetAppAgeSignalsAsync()
			end)

			if not ok then
				reject(result)

				return
			end

			if result.Error and result.Error ~= "" then
				reject(result.Error)

				return
			end

			resolve(result.PlatformPayload)
		end)
	end
}
