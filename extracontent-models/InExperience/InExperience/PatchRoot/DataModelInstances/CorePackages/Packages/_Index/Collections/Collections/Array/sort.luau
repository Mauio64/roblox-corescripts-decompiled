local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local None = require(ParentParent.Object.None)

require(ParentParentParent.ES7Types)

local function v4(p1, p2) -- line: 23
	return type(p1) .. tostring(p1) < type(p2) .. tostring(p2)
end

return function(p3, p4: ((...any) -> ...any)?) -- line: 27
	-- upvalues: v4 (copy), None (copy)
	local v9 = v4

	if p4 ~= nil and p4 ~= None then
		if typeof(p4) ~= "function" then
			error("invalid argument to Array.sort: compareFunction must be a function")
		end

		function v9(p5, p6) -- line: 34
			-- upvalues: p4 (copy)
			local v12 = p4(p5, p6)

			if typeof(v12) ~= "number" then
				error(("invalid result from compare function, expected number but got %s"):format((typeof(v12))))
			end

			return v12 < 0
		end
	end

	table.sort(p3, v9)

	return p3
end
