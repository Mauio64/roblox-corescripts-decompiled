return function(p1, p2, p3) -- line: 30
	local t1 = {}

	t1.__index = t1

	function t1.__tostring(p4) -- line: 33
		-- upvalues: p1 (copy)
		return getmetatable(p1).__tostring(p4)
	end

	local t2 = {}

	function t1.new(...) -- line: 39
		-- upvalues: p3 (copy), t1 (copy)
		local t3 = {}

		p3(t3, ...)

		return (setmetatable(t3, t1))
	end

	if typeof((getmetatable(p1))) == "table" and getmetatable(p1).__call then
		function t2.__call(_, ...) -- line: 46
			-- upvalues: t1 (copy)
			return t1.new(...)
		end
	end

	t2.__index = p1

	function t2.__tostring(p6) -- line: 52
		-- upvalues: t1 (copy), p2 (copy), p1 (copy)
		if p6 == t1 then
			return (tostring(p2))
		end

		return getmetatable(p1).__tostring(p6)
	end

	setmetatable(t1, t2)

	return t1
end
