local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

local t1 = {}

t1.__index = t1

function t1.__tostring(p1) -- line: 29
	-- upvalues: t1 (copy)
	return getmetatable(t1).__tostring(p1)
end

local function __createError(s1: string?) -- line: 35
	-- upvalues: t1 (copy)
	local v6 = setmetatable({
		name = "Error",
		message = s1 or ""
	}, t1)

	t1.__captureStackTrace(v6, 4)

	return v6
end

function t1.new(s2: string?) -- line: 44
	-- upvalues: t1 (copy)
	local v8 = setmetatable({
		name = "Error",
		message = s2 or ""
	}, t1)

	t1.__captureStackTrace(v8, 4)

	return v8
end
function t1.captureStackTrace(t2: {[any]: any}, p2) -- line: 48
	-- upvalues: t1 (copy)
	t1.__captureStackTrace(t2, 3, p2)
end
function t1.__captureStackTrace(t3: {[any]: any}, n1: number, p3) -- line: 52
	-- upvalues: t1 (copy)
	if typeof(p3) == "function" then
		local trace = debug.traceback(nil, n1)
		local v15 = debug.info(p3, "n")
		local v16 = debug.info(p3, "s")
		local v17 = string.gsub(v16, "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1") .. ":%d* function " .. v15
		local v18 = string.find(trace, v17)
		local stop = nil

		if v18 ~= nil then
			local start

			start, stop = string.find(trace, "\n", v18 + 1)
		end

		if stop ~= nil then
			trace = string.sub(trace, stop + 1)
		end

		t3.__stack = trace
	else
		t3.__stack = debug.traceback(nil, n1)
	end

	t1.__recalculateStacktrace(t3)
end
function t1.__recalculateStacktrace(t4: {[any]: any}) -- line: 76
	local message = t4.message

	t4.stack = ((t4.name or "Error") .. ((message == nil or message == "") and "" or ": " .. message)) .. "\n" .. (not t4.__stack and "" or t4.__stack)
end

return (setmetatable(t1, {
	__call = function(_, ...) -- line: 88
		-- upvalues: t1 (copy)
		local v24 = setmetatable({
			name = "Error",
			message = ... or ""
		}, t1)

		t1.__captureStackTrace(v24, 4)

		return v24
	end,
	__tostring = function(p5) -- line: 91
		if p5.name ~= nil then
			if p5.message and p5.message ~= "" then
				return string.format("%s: %s", tostring(p5.name), (tostring(p5.message)))
			end

			return (tostring(p5.name))
		end

		return (tostring("Error"))
	end
}))
