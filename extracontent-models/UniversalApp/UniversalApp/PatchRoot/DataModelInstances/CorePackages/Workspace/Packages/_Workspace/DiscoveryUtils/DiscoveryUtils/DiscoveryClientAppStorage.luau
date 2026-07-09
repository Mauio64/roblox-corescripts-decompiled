local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local DiscoveryUtils = script:FindFirstAncestor("DiscoveryUtils")
local DiscoveryEventErrorLogger = require(DiscoveryUtils.Telemetry.DiscoveryEventErrorLogger)
local DiscoveryUtilsParent = DiscoveryUtils.Parent
local LocalStorageKey = require(DiscoveryUtilsParent.LocalStorage).Enums.LocalStorageKey
local v8 = game:DefineFastInt("LuaAppDiscoveryClientAppStorageCacheTtlDays", 30)
local v9 = game:DefineFastFlag("LuaAppDiscoveryClientAppStorageEmptyCacheTelemetry", false)
local v10 = game:DefineFastInt("DiscoveryClientAppStorageGetItemErrorThrottleHundredthsPercent", 10000)
local t1 = {
	HomeOmniFeedCache = LocalStorageKey.DiscoveryClientFallbackCache
}
local v12 = v9 and {
	eventName = "discoveryClientAppStorageEmptyCache",
	description = "Cached data not found after omni recommendations fetch fails",
	backends = { "EventIngest" },
	throttlingPercentage = v10,
	lastUpdated = {
		25,
		11,
		19
	}
} or nil

function getJsonStorageData(p1, n1: number) -- line: 54
	-- upvalues: AppStorageService (copy), v9 (copy), TelemetryService (copy), v12 (copy), HttpService (copy), DiscoveryEventErrorLogger (copy), v8 (copy)
	if not game:GetEngineFeature("UniversalAppDiscoveryClientFallbackCacheStorageKey") then
		return nil
	end

	local Item = AppStorageService:GetItem(p1)

	if Item == nil or Item == "" then
		if v9 then
			TelemetryService:LogEvent(v12, {
				standardizedFields = { "addSessionInfo" },
				customFields = {
					cacheKey = p1
				}
			})
		end

		return nil
	end

	local ok, result = pcall(function() -- line: 74
		-- upvalues: HttpService (copy), Item (copy)
		return HttpService:JSONDecode(Item)
	end)

	if not ok then
		DiscoveryEventErrorLogger.reportError("DiscoveryClientAppStorageDataError", result)
		error(`Failed to decode cache data for key: { p1 }`)
	end

	if not result.version then
		DiscoveryEventErrorLogger.reportError("DiscoveryClientAppStorageDataError", `Cached data version not found for key: { p1 }`)
		error(`Cached data version not found for key: { p1 }`)
	end

	if not result.lastUpdatedTime then
		DiscoveryEventErrorLogger.reportError("DiscoveryClientAppStorageDataError", `Cached data time not found for key: { p1 }`)
		error(`Cached data time not found for key: { p1 }`)
	end

	if n1 ~= result.version or result.lastUpdatedTime and result.lastUpdatedTime < os.time() - 86400 * v8 then
		return nil
	end

	return result.data
end
function setJsonStorageData(p2, p3, n2: number) -- line: 120
	-- upvalues: HttpService (copy), AppStorageService (copy)
	if not game:GetEngineFeature("UniversalAppDiscoveryClientFallbackCacheStorageKey") then
		return
	end

	local t2 = {
		data = p3,
		lastUpdatedTime = os.time(),
		version = n2
	}
	local json = HttpService:JSONEncode(t2)

	AppStorageService:SetItem(p2, json)
end

return {
	CacheKey = t1,
	getJsonStorageData = getJsonStorageData,
	setJsonStorageData = setJsonStorageData
}
