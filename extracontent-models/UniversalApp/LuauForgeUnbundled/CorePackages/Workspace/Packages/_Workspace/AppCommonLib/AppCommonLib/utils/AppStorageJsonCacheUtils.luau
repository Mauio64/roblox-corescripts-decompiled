local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local class = {}

class.__index = class

function class.new(p2)
	local v5 = {
		_appStorageService = p2 or AppStorageService,
		_httpService = HttpService,
		_jsonDecodeCache = {}
	}

	setmetatable(v5, class)
	return v5
end

function class:getCachedJsonForKey(p2, p3)
	local v5

	if self._jsonDecodeCache[p2] == nil or p3 then
		v5 = self:decodeInternal(p2)
		self._jsonDecodeCache[p2] = v5
	else
		v5 = self._jsonDecodeCache[p2]
	end

	return v5.result
end

function class:decodeInternal(p3)
	local success, result = pcall(function()
		return self._appStorageService:GetItem(p3)
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

class.default = class.new(nil)
return class
