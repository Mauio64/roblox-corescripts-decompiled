local AppStorageService = game:GetService("AppStorageService")
local IXPService = game:GetService("IXPService")
local HttpService = game:GetService("HttpService")
local EventIngestService = game:GetService("EventIngestService")
local Parent = script:FindFirstAncestor("ExperimentCacheManager").Parent
local EventIngest = require(Parent.Analytics).AnalyticsReporters.EventIngest
local memoize = require(Parent.AppCommonLib).memoize
local AppStorageJsonCacheUtils = require(Parent.AppCommonLib).Utils.AppStorageJsonCacheUtils
local mutedError = require(Parent.Loggers).mutedError
local LocalStorageKey = require(Parent.LocalStorage).Enums.LocalStorageKey
local GetExperimentCacheLayers = require(script.Parent.GetExperimentCacheLayers)
local v12 = game:DefineFastFlag("EnableAppStorageJsonDecodeCache", false)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, t2: {[any]: any}?) -- line: 73
	-- upvalues: IXPService (copy), EventIngest (copy), EventIngestService (copy), GetExperimentCacheLayers (copy), t1 (copy)
	local t3 = {
		_loadingStatusChanged = nil,
		_hasLoggedMissingLayerError = nil,
		_ixpService = p1 or IXPService,
		_eventIngest = p2 or EventIngest.new(EventIngestService),
		_cache = {},
		_layersToCache = t2 or GetExperimentCacheLayers(),
		_exposureLoggingTable = {}
	}

	setmetatable(t3, t1)

	return t3
end
function t1._getCachedVariables(_) -- line: 88
	-- upvalues: v12 (copy), AppStorageJsonCacheUtils (copy), LocalStorageKey (copy), AppStorageService (copy), HttpService (copy)
	if v12 then
		local v19 = AppStorageJsonCacheUtils.default:getCachedJsonForKey(LocalStorageKey.ExperimentCache, true)

		if v19 == nil then
			return {}
		end

		return v19
	end

	local ok, result = pcall(function() -- line: 98
		-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
		return AppStorageService:GetItem(LocalStorageKey.ExperimentCache)
	end)

	if ok then
		local ok2, result2 = pcall(function() -- line: 103
			-- upvalues: HttpService (copy), result (copy)
			return HttpService:JSONDecode(result)
		end)

		if ok2 then
			return result2
		end
	end

	return {}
end
function t1._flushToCache(_: {[any]: any}, t5: {[any]: any}) -- line: 115
	-- upvalues: HttpService (copy), AppStorageService (copy), LocalStorageKey (copy)
	assert(type(t5) == "table", "expected table type for cache to persist")

	local ok, result = pcall(function() -- line: 119
		-- upvalues: HttpService (copy), t5 (copy)
		return HttpService:JSONEncode(t5)
	end)

	if ok then
		local ok3, result3 = pcall(function() -- line: 124
			-- upvalues: AppStorageService (copy), LocalStorageKey (copy), result (copy)
			AppStorageService:SetItem(LocalStorageKey.ExperimentCache, result)
			AppStorageService:Flush()
		end)

		if not ok3 then
			warn(result3)
		end
	end
end
function t1._onIXPInitialized(p4) -- line: 135
	local UserLayerLoadingStatus = p4._ixpService:GetUserLayerLoadingStatus()

	if UserLayerLoadingStatus ~= Enum.IXPLoadingStatus.Pending and p4._loadingStatusChanged then
		p4._loadingStatusChanged:disconnect()
		p4._loadingStatusChanged = nil
	end

	if UserLayerLoadingStatus == Enum.IXPLoadingStatus.Initialized then
		local t6 = {}

		for _, v in ipairs(p4._layersToCache) do
			local UserLayerVariables = nil

			pcall(function() -- line: 151
				-- upvalues: UserLayerVariables (ref), p4 (copy), v (copy)
				UserLayerVariables = p4._ixpService:GetUserLayerVariables(v)
			end)
			t6[v] = UserLayerVariables
		end

		p4:_flushToCache(t6)
	end
end
function t1._logCustomExposure(t7: {[any]: any}, s1: string) -- line: 163
	assert(type(s1) == "string", "expected layerName to be a string")
	t7._eventIngest:setRBXEventStream("experimentCacheManager", "exposureLog", {
		layerName = s1
	})
end
function t1._containsLayer(t8: {[any]: any}, s2: string) -- line: 170
	-- upvalues: memoize (copy)
	return memoize(function(p5) -- line: 171
		-- upvalues: t8 (copy)
		for _, v in ipairs(t8._layersToCache) do
			if v == p5 then
				return true
			end
		end

		return false
	end)(s2)
end
function t1.initialize(p6) -- line: 183
	p6._cache = p6:_getCachedVariables()

	if p6._ixpService:GetUserLayerLoadingStatus() == Enum.IXPLoadingStatus.Initialized then
		p6:_onIXPInitialized()

		return
	end

	p6._loadingStatusChanged = p6._ixpService.OnUserLayerLoadingStatusChanged:Connect(function(p7) -- line: 191
		-- upvalues: p6 (copy)
		if p7 == Enum.IXPLoadingStatus.Initialized then
			p6:_onIXPInitialized()
		end
	end)
end
function t1.getLayerVariables(t9: {[any]: any}, s3: string, _: boolean?) -- line: 199
	-- upvalues: mutedError (copy)
	assert(type(s3) == "string", "expected layerName to be a string")

	if not t9:_containsLayer(s3) and not t9._hasLoggedMissingLayerError then
		t9._hasLoggedMissingLayerError = true
		mutedError("Layer " .. s3 .. " has not been configured to be cached, please add layer to `GetExperimentCacheLayers`")
	end

	return t9._cache[s3] or nil
end
function t1.clearCache(p8) -- line: 215
	-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
	p8._cache = {}
	p8._exposureLoggingTable = {}
	pcall(function() -- line: 219
		-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
		AppStorageService:SetItem(LocalStorageKey.ExperimentCache, "")
		AppStorageService:Flush()
	end)
end
function t1.sendCustomExposureLog(p9, p10) -- line: 225
	if p9._exposureLoggingTable[p10] == nil then
		p9:_logCustomExposure(p10)
		p9._exposureLoggingTable[p10] = true
	end
end
function t1.logLayerExposure(p11, p12) -- line: 233
	p11._ixpService:LogUserLayerExposure(p12)
end

t1.default = t1.new()

return t1
