local inspect = require(script.Parent.Parent.util).inspect

return function() -- line: 5
	-- upvalues: inspect (copy)
	local t1 = {}
	local n1 = 0

	local function indent() -- line: 9
		-- upvalues: n1 (ref)
		return string.rep("  ", n1)
	end

	function t1.log(p1, ...) -- line: 13
		-- upvalues: inspect (copy), n1 (ref)
		local v6 = if typeof(p1) ~= "string" then inspect(p1) else string.format(p1, ...)

		print(string.rep("  ", n1) .. v6)
	end
	function t1.debug(p2, ...) -- line: 23
		-- upvalues: inspect (copy), n1 (ref)
		local v8 = if typeof(p2) ~= "string" then inspect(p2) else string.format(p2, ...)

		print(string.rep("  ", n1) .. v8)
	end
	function t1.info(p3, ...) -- line: 33
		-- upvalues: inspect (copy), n1 (ref)
		local v10 = if typeof(p3) ~= "string" then inspect(p3) else string.format(p3, ...)

		print(string.rep("  ", n1) .. v10)
	end
	function t1.warn(p4, ...) -- line: 43
		-- upvalues: inspect (copy), n1 (ref)
		local v12 = if typeof(p4) ~= "string" then inspect(p4) else string.format(p4, ...)

		warn(string.rep("  ", n1) .. v12)
	end
	function t1.error(p5, ...) -- line: 53
		-- upvalues: inspect (copy), n1 (ref)
		local v14 = if typeof(p5) ~= "string" then inspect(p5) else string.format(p5, ...)

		warn(string.rep("  ", n1) .. v14)
	end
	function t1.group(p6, ...) -- line: 65
		-- upvalues: inspect (copy), n1 (ref)
		local v16 = if typeof(p6) ~= "string" then inspect(p6) else string.format(p6, ...)

		print(string.rep("  ", n1) .. v16)
		n1 += 1
	end
	function t1.groupCollapsed(p7, ...) -- line: 76
		-- upvalues: inspect (copy), n1 (ref)
		local v18 = if typeof(p7) ~= "string" then inspect(p7) else string.format(p7, ...)

		print(string.rep("  ", n1) .. v18)
		n1 += 1
	end
	function t1.groupEnd() -- line: 88
		-- upvalues: n1 (ref)
		if n1 > 0 then
			n1 -= 1
		end
	end

	return t1
end
