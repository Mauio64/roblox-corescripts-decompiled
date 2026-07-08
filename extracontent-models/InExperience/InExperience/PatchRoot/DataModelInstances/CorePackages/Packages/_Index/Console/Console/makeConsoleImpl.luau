local ParentParent = script.Parent.Parent
local inspect = require(ParentParent.Collections).inspect

return function() -- line: 22
	-- upvalues: inspect (copy)
	local t1 = {}
	local n1 = 0

	local function indent() -- line: 26
		-- upvalues: n1 (ref)
		return string.rep("  ", n1)
	end

	function t1.log(p1, ...) -- line: 30
		-- upvalues: inspect (copy), n1 (ref)
		local v7 = if typeof(p1) ~= "string" then inspect(p1) else string.format(p1, ...)

		print(string.rep("  ", n1) .. v7)
	end
	function t1.debug(p2, ...) -- line: 40
		-- upvalues: inspect (copy), n1 (ref)
		local v9 = if typeof(p2) ~= "string" then inspect(p2) else string.format(p2, ...)

		print(string.rep("  ", n1) .. v9)
	end
	function t1.info(p3, ...) -- line: 50
		-- upvalues: inspect (copy), n1 (ref)
		local v11 = if typeof(p3) ~= "string" then inspect(p3) else string.format(p3, ...)

		print(string.rep("  ", n1) .. v11)
	end
	function t1.warn(p4, ...) -- line: 60
		-- upvalues: inspect (copy), n1 (ref)
		local v13 = if typeof(p4) ~= "string" then inspect(p4) else string.format(p4, ...)

		warn(string.rep("  ", n1) .. v13)
	end
	function t1.error(p5, ...) -- line: 70
		-- upvalues: inspect (copy), n1 (ref)
		local v15 = if typeof(p5) ~= "string" then inspect(p5) else string.format(p5, ...)

		warn(string.rep("  ", n1) .. v15)
	end
	function t1.group(p6, ...) -- line: 82
		-- upvalues: inspect (copy), n1 (ref)
		local v17 = if typeof(p6) ~= "string" then inspect(p6) else string.format(p6, ...)

		print(string.rep("  ", n1) .. v17)
		n1 += 1
	end
	function t1.groupCollapsed(p7, ...) -- line: 93
		-- upvalues: inspect (copy), n1 (ref)
		local v19 = if typeof(p7) ~= "string" then inspect(p7) else string.format(p7, ...)

		print(string.rep("  ", n1) .. v19)
		n1 += 1
	end
	function t1.groupEnd() -- line: 105
		-- upvalues: n1 (ref)
		if n1 > 0 then
			n1 -= 1
		end
	end

	return t1
end
