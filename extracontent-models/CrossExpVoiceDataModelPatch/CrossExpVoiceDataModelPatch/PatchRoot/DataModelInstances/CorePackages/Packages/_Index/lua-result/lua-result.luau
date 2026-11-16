local LuaResult = {}
LuaResult.__index = LuaResult

local v = newproxy(true)

function LuaResult.new(status, p)
	assert(typeof(status) == "boolean")

	local v2 = { _source = debug.traceback(), [v] = true, _status = status, _value = p }

	setmetatable(v2, LuaResult)

	return v2
end

function LuaResult.success(p)
	return LuaResult.new(true, p)
end

function LuaResult.error(p)
	return LuaResult.new(false, p)
end

function LuaResult.is(p)
	return typeof(p) == "table" and p[v]
end

function LuaResult:match(callback, callback2)
	assert(
		typeof(callback) == "function" or typeof(callback) == "nil",
		string.format("Result:match expects successHandler to be a function or nil, got %s", (typeof(callback)))
	)
	assert(
		typeof(callback2) == "function" or typeof(callback2) == "nil",
		string.format("Result:match expects errorHandler to be a function or nil, got %s", (typeof(callback2)))
	)
	local v2

	if self._status then
		if callback == nil then
			return self
		end

		v2 = callback(self._value)
	elseif callback2 == nil then
		return self
	else
		v2 = callback2(self._value)
	end

	if LuaResult.is(v2) then
		return v2
	end

	return LuaResult.success(v2)
end

function LuaResult:matchSuccess(p)
	return self:match(p, nil)
end

function LuaResult:matchError(p)
	return self:match(nil, p)
end

function LuaResult:unwrap()
	return self._status, self._value
end

return LuaResult
