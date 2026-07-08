local ParentParent = script.Parent.Parent
local None = require(ParentParent.Object.None)

require(ParentParent.types)

local function v3(p1, p2) -- line: 7
	return type(p1) .. tostring(p1) < type(p2) .. tostring(p2)
end

return function(p3, p4: ((...any) -> ...any)?) -- line: 11
	-- upvalues: v3 (copy), None (copy)
	local v8 = v3

	if p4 ~= nil and p4 ~= None then
		if typeof(p4) ~= "function" then
			error("invalid argument to Array.sort: compareFunction must be a function")
		end

		function v8(p5, p6) -- line: 18
			-- upvalues: p4 (copy)
			local v11 = p4(p5, p6)

			if typeof(v11) ~= "number" then
				error(("invalid result from compare function, expected number but got %s"):format((typeof(v11))))
			end

			return v11 < 0
		end
	end

	table.sort(p3, v8)

	return p3
end
