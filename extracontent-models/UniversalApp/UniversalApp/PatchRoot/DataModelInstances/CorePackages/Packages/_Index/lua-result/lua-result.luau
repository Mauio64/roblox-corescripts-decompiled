local t1 = {}

t1.__index = t1

local v2 = newproxy(true)

function t1.new(p1, p2) -- line: 6
	-- upvalues: v2 (copy), t1 (copy)
	assert(typeof(p1) == "boolean")

	local t2 = {
		_source = debug.traceback(),
		[v2] = true,
		_status = p1,
		_value = p2
	}

	setmetatable(t2, t1)

	return t2
end
function t1.success(p3) -- line: 27
	-- upvalues: t1 (copy)
	return t1.new(true, p3)
end
function t1.error(p4) -- line: 31
	-- upvalues: t1 (copy)
	return t1.new(false, p4)
end
function t1.is(p5) -- line: 38
	-- upvalues: v2 (copy)
	if typeof(p5) ~= "table" then
		return false
	end

	return p5[v2]
end
function t1.match(p6, p7, p8) -- line: 51
	-- upvalues: t1 (copy)
	assert(typeof(p7) == "function" or typeof(p7) == "nil", string.format("Result:match expects successHandler to be a function or nil, got %s", (typeof(p7))))
	assert(typeof(p8) == "function" or typeof(p8) == "nil", string.format("Result:match expects errorHandler to be a function or nil, got %s", (typeof(p8))))

	local v12

	if p6._status then
		if p7 == nil then
			return p6
		end

		v12 = p7(p6._value)
	else
		if p8 == nil then
			return p6
		end

		v12 = p8(p6._value)
	end

	if t1.is(v12) then
		return v12
	end

	return t1.success(v12)
end
function t1.matchSuccess(p9, p10) -- line: 83
	return p9:match(p10, nil)
end
function t1.matchError(p11, p12) -- line: 92
	return p11:match(nil, p12)
end
function t1.unwrap(p13) -- line: 96
	return p13._status, p13._value
end

return t1
