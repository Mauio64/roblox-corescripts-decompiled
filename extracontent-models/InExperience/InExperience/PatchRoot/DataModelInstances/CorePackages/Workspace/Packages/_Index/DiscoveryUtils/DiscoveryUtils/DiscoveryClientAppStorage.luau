local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")

local DiscoveryUtils = script:FindFirstAncestor("DiscoveryUtils")
local DiscoveryEventErrorLogger = require(DiscoveryUtils.Telemetry.DiscoveryEventErrorLogger)
local parent = DiscoveryUtils.Parent
local LocalStorage = require(parent.LocalStorage)
local LocalStorageKey = LocalStorage.Enums.LocalStorageKey

local defineFastInt = game:DefineFastInt("LuaAppDiscoveryClientAppStorageCacheTtlDays", 30)

local defineFastFlag = game:DefineFastFlag("LuaAppDiscoveryClientAppStorageEmptyCacheTelemetry", false)

local defineFastInt2 = game:DefineFastInt("DiscoveryClientAppStorageGetItemErrorThrottleHundredthsPercent", 10000)

local cacheKey = { HomeOmniFeedCache = LocalStorageKey.DiscoveryClientFallbackCache }

local v = defineFastFlag and {
	eventName = "discoveryClientAppStorageEmptyCache",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 25, 11, 19 },
	description = "Cached data not found after omni recommendations fetch fails"
} or nil

function getJsonStorageData(cacheKey2, p: number)
	if not game:GetEngineFeature("UniversalAppDiscoveryClientFallbackCacheStorageKey") then
		return nil
	end

	local item = AppStorageService:GetItem(cacheKey2)

	if item == nil or item == "" then
		if defineFastFlag then
			TelemetryService:LogEvent(v, {
				standardizedFields = { "addSessionInfo" },
				customFields = { cacheKey = cacheKey2 }
			})
		end

		return nil
	else
		local success, result = pcall(function()
			return HttpService:JSONDecode(item)
		end)

		if not success then
			DiscoveryEventErrorLogger.reportError("DiscoveryClientAppStorageDataError", result)
			error(`Failed to decode cache data for key: {cacheKey2}`)
		end

		if not result.version then
			DiscoveryEventErrorLogger.reportError(
				"DiscoveryClientAppStorageDataError",
				`Cached data version not found for key: {cacheKey2}`
			)

			error(`Cached data version not found for key: {cacheKey2}`)
		end

		if not result.lastUpdatedTime then
			DiscoveryEventErrorLogger.reportError(
				"DiscoveryClientAppStorageDataError",
				`Cached data time not found for key: {cacheKey2}`
			)

			error(`Cached data time not found for key: {cacheKey2}`)
		end

		if
			result.version == p
			and not (result.lastUpdatedTime and result.lastUpdatedTime < os.time() - 86400 * defineFastInt)
		then
			return result.data
		end

		return nil
	end
end

function setJsonStorageData(p, p2, version: number)
	if not game:GetEngineFeature("UniversalAppDiscoveryClientFallbackCacheStorageKey") then
		return
	end

	AppStorageService:SetItem(
		p,
		(HttpService:JSONEncode({ data = p2, lastUpdatedTime = os.time(), version = version }))
	)
end

return {
	CacheKey = cacheKey,
	getJsonStorageData = getJsonStorageData,
	setJsonStorageData = setJsonStorageData
}
