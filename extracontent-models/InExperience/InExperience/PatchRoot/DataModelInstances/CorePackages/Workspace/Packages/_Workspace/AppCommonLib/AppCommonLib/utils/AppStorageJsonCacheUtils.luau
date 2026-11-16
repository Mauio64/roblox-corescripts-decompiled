local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local AppStorageJsonCacheUtils = {}

AppStorageJsonCacheUtils.__index = AppStorageJsonCacheUtils

function AppStorageJsonCacheUtils.new(p)
	local v = {
		_appStorageService = p or AppStorageService,
		_httpService = HttpService,
		_jsonDecodeCache = {}
	}

	setmetatable(v, AppStorageJsonCacheUtils)
	return v
end

function AppStorageJsonCacheUtils:getCachedJsonForKey(p: string, flag: boolean?)
	local v

	if self._jsonDecodeCache[p] == nil or flag then
		v = self:decodeInternal(p)
		self._jsonDecodeCache[p] = v
	else
		v = self._jsonDecodeCache[p]
	end

	return v.result
end

function AppStorageJsonCacheUtils:decodeInternal(p: string)
	local success, result = pcall(function()
		return self._appStorageService:GetItem(p)
	end)

	if not success then
		return { result = nil }
	end

	local success2, result2 = pcall(function()
		return self._httpService:JSONDecode(result)
	end)

	if success2 then
		return { result = result2 }
	end

	return { result = nil }
end

AppStorageJsonCacheUtils.default = AppStorageJsonCacheUtils.new(nil)
return AppStorageJsonCacheUtils
