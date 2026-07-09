local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 20
	-- upvalues: AppStorageService (copy), HttpService (copy), t1 (copy)
	local t2 = {
		_appStorageService = p1 or AppStorageService,
		_httpService = HttpService,
		_jsonDecodeCache = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.getCachedJsonForKey(t3: {[any]: any}, s1: string, b1: boolean?) -- line: 30
	local v9

	if t3._jsonDecodeCache[s1] == nil or b1 then
		v9 = t3:decodeInternal(s1)
		t3._jsonDecodeCache[s1] = v9
	else
		v9 = t3._jsonDecodeCache[s1]
	end

	return v9.result
end
function t1.decodeInternal(t4: {[any]: any}, s2: string) -- line: 41
	local ok, result = pcall(function() -- line: 42
		-- upvalues: t4 (copy), s2 (copy)
		return t4._appStorageService:GetItem(s2)
	end)

	if not ok then
		return {
			result = nil
		}
	end

	local ok2, result2 = pcall(function() -- line: 50
		-- upvalues: t4 (copy), result (copy)
		return t4._httpService:JSONDecode(result)
	end)

	if not ok2 then
		return {
			result = nil
		}
	end

	return {
		result = result2
	}
end

t1.default = t1.new(nil)

return t1
