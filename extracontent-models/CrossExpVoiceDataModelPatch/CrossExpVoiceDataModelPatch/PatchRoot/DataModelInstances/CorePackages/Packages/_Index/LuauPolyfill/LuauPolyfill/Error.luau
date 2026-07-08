local t1 = {}

t1.__index = t1

function t1.__tostring(p1) -- line: 8
	-- upvalues: t1 (copy)
	return getmetatable(t1).__tostring(p1)
end
function t1.new(s1: string?) -- line: 13
	-- upvalues: t1 (copy)
	return (setmetatable({
		name = "Error",
		message = s1 or "",
		stack = debug.traceback(nil, 2)
	}, t1))
end

return (setmetatable(t1, {
	__call = function(_, ...) -- line: 24
		-- upvalues: t1 (copy)
		local v5 = t1.new(...)

		v5.stack = debug.traceback(nil, 2)

		return v5
	end,
	__tostring = function(p3) -- line: 29
		if p3.name ~= nil then
			if p3.message and p3.message ~= "" then
				return string.format("%s: %s", tostring(p3.name), (tostring(p3.message)))
			end

			return (tostring(p3.name))
		end

		return (tostring("Error"))
	end
}))
