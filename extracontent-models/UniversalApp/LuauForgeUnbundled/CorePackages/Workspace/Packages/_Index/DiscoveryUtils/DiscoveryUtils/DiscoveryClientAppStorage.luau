local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")

local DiscoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryUtils/DiscoveryUtils/Telemetry/DiscoveryEventErrorLogger")

local localStorageKey = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryUtils/LocalStorage").Enums.LocalStorageKey

local defineFastInt = game:DefineFastInt("LuaAppDiscoveryClientAppStorageCacheTtlDays", 30)

local defineFastFlag = game:DefineFastFlag("LuaAppDiscoveryClientAppStorageEmptyCacheTelemetry", false)

local defineFastInt2 = game:DefineFastInt(
	"DiscoveryClientAppStorageGetItemErrorThrottleHundredthsPercent",
	10000
)

local v5 = { HomeOmniFeedCache = localStorageKey.DiscoveryClientFallbackCache }

local v6 = defineFastFlag and {
	eventName = "discoveryClientAppStorageEmptyCache",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 25, 11, 19 },
	description = "Cached data not found after omni recommendations fetch fails"
} or nil

function LUAUFORGE_MODULE_GLOBALS_Oz_getJsonStorageData(p2, p3)
	if not game:GetEngineFeature("UniversalAppDiscoveryClientFallbackCacheStorageKey") then
		return nil
	end

	local item = AppStorageService:GetItem(p2)

	if item == nil or item == "" then
		if defineFastFlag then
			TelemetryService:LogEvent(v6, {
				standardizedFields = { "addSessionInfo" },
				customFields = { cacheKey = p2 }
			})
		end

		return nil
	else
		local success, result = pcall(function()
			return HttpService:JSONDecode(item)
		end)

		if not success then
			DiscoveryEventErrorLogger.reportError("DiscoveryClientAppStorageDataError", result)
			error(`Failed to decode cache data for key: {p2}`)
		end

		if not result.version then
			DiscoveryEventErrorLogger.reportError(
				"DiscoveryClientAppStorageDataError",
				`Cached data version not found for key: {p2}`
			)

			error(`Cached data version not found for key: {p2}`)
		end

		if not result.lastUpdatedTime then
			DiscoveryEventErrorLogger.reportError(
				"DiscoveryClientAppStorageDataError",
				`Cached data time not found for key: {p2}`
			)

			error(`Cached data time not found for key: {p2}`)
		end

		if
			result.version == p3
			and not (result.lastUpdatedTime and result.lastUpdatedTime < os.time() - 86400 * defineFastInt)
		then
			return result.data
		end

		return nil
	end
end

function LUAUFORGE_MODULE_GLOBALS_Oz_setJsonStorageData(p2, p3, p4)
	if not game:GetEngineFeature("UniversalAppDiscoveryClientFallbackCacheStorageKey") then
		return
	end

	AppStorageService:SetItem(
		p2,
		(HttpService:JSONEncode({ data = p3, lastUpdatedTime = os.time(), version = p4 }))
	)
end

return {
	CacheKey = v5,
	getJsonStorageData = LUAUFORGE_MODULE_GLOBALS_Oz_getJsonStorageData,
	setJsonStorageData = LUAUFORGE_MODULE_GLOBALS_Oz_setJsonStorageData
}
