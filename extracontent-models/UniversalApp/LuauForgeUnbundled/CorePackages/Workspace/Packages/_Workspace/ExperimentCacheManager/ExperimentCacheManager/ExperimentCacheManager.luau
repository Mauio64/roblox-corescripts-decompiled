local AppStorageService = game:GetService("AppStorageService")
local IXPService = game:GetService("IXPService")
local HttpService = game:GetService("HttpService")
local EventIngestService = game:GetService("EventIngestService")

local eventIngest = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperimentCacheManager/Analytics").AnalyticsReporters.EventIngest
local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperimentCacheManager/AppCommonLib").memoize
local appStorageJsonCacheUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperimentCacheManager/AppCommonLib").Utils.AppStorageJsonCacheUtils
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperimentCacheManager/Loggers").mutedError
local localStorageKey = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperimentCacheManager/LocalStorage").Enums.LocalStorageKey

local GetExperimentCacheLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperimentCacheManager/ExperimentCacheManager/GetExperimentCacheLayers")
local defineFastFlag = game:DefineFastFlag("EnableAppStorageJsonDecodeCache", false)

local class = {}
class.__index = class

function class.new(p2, p3, p4)
	local v5 = {
		_ixpService = p2 or IXPService,
		_eventIngest = p3 or eventIngest.new(EventIngestService),
		_cache = {},
		_loadingStatusChanged = nil,
		_layersToCache = p4 or GetExperimentCacheLayers(),
		_exposureLoggingTable = {},
		_hasLoggedMissingLayerError = nil
	}

	setmetatable(v5, class)
	return v5
end

function class:_getCachedVariables()
	if defineFastFlag then
		local cachedJsonForKey = appStorageJsonCacheUtils.default:getCachedJsonForKey(
			localStorageKey.ExperimentCache,
			true
		)

		if cachedJsonForKey == nil then
			return {}
		end

		return cachedJsonForKey
	else
		local success, result = pcall(function()
			return AppStorageService:GetItem(localStorageKey.ExperimentCache)
		end)

		if success then
			local success2, result2 = pcall(function()
				return HttpService:JSONDecode(result)
			end)

			if success2 then
				return result2
			end
		end

		return {}
	end
end

function class:_flushToCache(p3)
	assert(type(p3) == "table", "expected table type for cache to persist")

	local success, result = pcall(function()
		return HttpService:JSONEncode(p3)
	end)

	if success then
		local success2, result2 = pcall(function()
			AppStorageService:SetItem(localStorageKey.ExperimentCache, result)
			AppStorageService:Flush()
		end)

		if not success2 then
			warn(result2)
		end
	end
end

function class:_onIXPInitialized()
	local userLayerLoadingStatus = self._ixpService:GetUserLayerLoadingStatus()

	if userLayerLoadingStatus ~= Enum.IXPLoadingStatus.Pending and self._loadingStatusChanged then
		self._loadingStatusChanged:disconnect()
		self._loadingStatusChanged = nil
	end

	if userLayerLoadingStatus == Enum.IXPLoadingStatus.Initialized then
		local userLayerVariables = {}

		for i, v5 in ipairs(self._layersToCache) do
			local userLayerVariables2 = nil
			pcall(function()
				userLayerVariables2 = self._ixpService:GetUserLayerVariables(v5)
			end)

			userLayerVariables[v5] = userLayerVariables2
		end

		self:_flushToCache(userLayerVariables)
	end
end

function class:_logCustomExposure(value)
	assert(type(value) == "string", "expected layerName to be a string")
	self._eventIngest:setRBXEventStream("experimentCacheManager", "exposureLog", {
		layerName = value
	})
end

function class:_containsLayer(p3)
	return memoize(function(p4): boolean
		for i, v5 in ipairs(self._layersToCache) do
			if v5 == p4 then
				return true
			end
		end

		return false
	end)(p3)
end

function class:initialize()
	self._cache = self:_getCachedVariables()

	if self._ixpService:GetUserLayerLoadingStatus() == Enum.IXPLoadingStatus.Initialized then
		self:_onIXPInitialized()
	else
		self._loadingStatusChanged = self._ixpService.OnUserLayerLoadingStatusChanged:Connect(function(p2)
			if p2 == Enum.IXPLoadingStatus.Initialized then
				self:_onIXPInitialized()
			end
		end)
	end
end

function class:getLayerVariables(value, p2)
	assert(type(value) == "string", "expected layerName to be a string")

	if not (self:_containsLayer(value) or self._hasLoggedMissingLayerError) then
		self._hasLoggedMissingLayerError = true
		mutedError("Layer " .. value .. " has not been configured to be cached, please add layer to `GetExperimentCacheLayers`")
	end

	return self._cache[value] or nil
end

function class:clearCache()
	self._cache = {}
	self._exposureLoggingTable = {}

	pcall(function()
		AppStorageService:SetItem(localStorageKey.ExperimentCache, "")
		AppStorageService:Flush()
	end)
end

function class:sendCustomExposureLog(p2)
	if self._exposureLoggingTable[p2] == nil then
		self:_logCustomExposure(p2)

		self._exposureLoggingTable[p2] = true
	end
end

function class:logLayerExposure(p3)
	self._ixpService:LogUserLayerExposure(p3)
end

class.default = class.new()
return class
