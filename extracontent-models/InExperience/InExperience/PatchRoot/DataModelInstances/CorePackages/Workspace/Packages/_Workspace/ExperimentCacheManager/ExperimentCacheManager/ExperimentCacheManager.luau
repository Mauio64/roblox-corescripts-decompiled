local AppStorageService = game:GetService("AppStorageService")
local IXPService = game:GetService("IXPService")
local HttpService = game:GetService("HttpService")
local EventIngestService = game:GetService("EventIngestService")

local parent = script:FindFirstAncestor("ExperimentCacheManager").Parent
local Analytics = require(parent.Analytics)
local EventIngest = Analytics.AnalyticsReporters.EventIngest
local AppCommonLib = require(parent.AppCommonLib)
local memoize = AppCommonLib.memoize
local AppCommonLib2 = require(parent.AppCommonLib)
local AppStorageJsonCacheUtils = AppCommonLib2.Utils.AppStorageJsonCacheUtils
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local LocalStorage = require(parent.LocalStorage)
local LocalStorageKey = LocalStorage.Enums.LocalStorageKey

local GetExperimentCacheLayers = require(script.Parent.GetExperimentCacheLayers)
local defineFastFlag = game:DefineFastFlag("EnableAppStorageJsonDecodeCache", false)

local ExperimentCacheManager = {}
ExperimentCacheManager.__index = ExperimentCacheManager

function ExperimentCacheManager.new(p, p2, p3)
	local v = {
		_ixpService = p or IXPService,
		_eventIngest = p2 or EventIngest.new(EventIngestService),
		_cache = {},
		_loadingStatusChanged = nil,
		_layersToCache = p3 or GetExperimentCacheLayers(),
		_exposureLoggingTable = {},
		_hasLoggedMissingLayerError = nil
	}

	setmetatable(v, ExperimentCacheManager)
	return v
end

function ExperimentCacheManager:_getCachedVariables()
	if defineFastFlag then
		local cachedJsonForKey = AppStorageJsonCacheUtils.default:getCachedJsonForKey(
			LocalStorageKey.ExperimentCache,
			true
		)

		if cachedJsonForKey == nil then
			return {}
		end

		return cachedJsonForKey
	else
		local success, result = pcall(function()
			return AppStorageService:GetItem(LocalStorageKey.ExperimentCache)
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

function ExperimentCacheManager:_flushToCache(p)
	assert(type(p) == "table", "expected table type for cache to persist")

	local success, result = pcall(function()
		return HttpService:JSONEncode(p)
	end)

	if success then
		local success2, result2 = pcall(function()
			AppStorageService:SetItem(LocalStorageKey.ExperimentCache, result)
			AppStorageService:Flush()
		end)

		if not success2 then
			warn(result2)
		end
	end
end

function ExperimentCacheManager:_onIXPInitialized()
	local userLayerLoadingStatus = self._ixpService:GetUserLayerLoadingStatus()

	if userLayerLoadingStatus ~= Enum.IXPLoadingStatus.Pending and self._loadingStatusChanged then
		self._loadingStatusChanged:disconnect()
		self._loadingStatusChanged = nil
	end

	if userLayerLoadingStatus == Enum.IXPLoadingStatus.Initialized then
		local userLayerVariables = {}

		for _, v in ipairs(self._layersToCache) do
			local userLayerVariables2 = nil
			pcall(function()
				userLayerVariables2 = self._ixpService:GetUserLayerVariables(v)
			end)

			userLayerVariables[v] = userLayerVariables2
		end

		self:_flushToCache(userLayerVariables)
	end
end

function ExperimentCacheManager:_logCustomExposure(layerName: string)
	assert(type(layerName) == "string", "expected layerName to be a string")
	self._eventIngest:setRBXEventStream("experimentCacheManager", "exposureLog", {
		layerName = layerName
	})
end

function ExperimentCacheManager:_containsLayer(p: string)
	return memoize(function(p2): boolean
		for _, v in ipairs(self._layersToCache) do
			if v == p2 then
				return true
			end
		end

		return false
	end)(p)
end

function ExperimentCacheManager:initialize()
	self._cache = self:_getCachedVariables()

	if self._ixpService:GetUserLayerLoadingStatus() == Enum.IXPLoadingStatus.Initialized then
		self:_onIXPInitialized()
	else
		self._loadingStatusChanged = self._ixpService.OnUserLayerLoadingStatusChanged:Connect(function(p)
			if p == Enum.IXPLoadingStatus.Initialized then
				self:_onIXPInitialized()
			end
		end)
	end
end

function ExperimentCacheManager:getLayerVariables(value: string, _: boolean?)
	assert(type(value) == "string", "expected layerName to be a string")

	if not (self:_containsLayer(value) or self._hasLoggedMissingLayerError) then
		self._hasLoggedMissingLayerError = true
		mutedError("Layer " .. value .. " has not been configured to be cached, please add layer to `GetExperimentCacheLayers`")
	end

	return self._cache[value] or nil
end

function ExperimentCacheManager:clearCache()
	self._cache = {}
	self._exposureLoggingTable = {}

	pcall(function()
		AppStorageService:SetItem(LocalStorageKey.ExperimentCache, "")
		AppStorageService:Flush()
	end)
end

function ExperimentCacheManager:sendCustomExposureLog(p)
	if self._exposureLoggingTable[p] == nil then
		self:_logCustomExposure(p)

		self._exposureLoggingTable[p] = true
	end
end

function ExperimentCacheManager:logLayerExposure(p)
	self._ixpService:LogUserLayerExposure(p)
end

ExperimentCacheManager.default = ExperimentCacheManager.new()
return ExperimentCacheManager
