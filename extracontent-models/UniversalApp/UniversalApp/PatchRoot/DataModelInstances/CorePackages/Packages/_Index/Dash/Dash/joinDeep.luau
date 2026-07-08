local scriptParent = script.Parent
local None = require(scriptParent.None)

require(scriptParent.Types)

local forEach = require(scriptParent.forEach)

local function joinDeep(t1: {[any]: any}, t2: {[any]: any}) -- line: 21
	-- upvalues: forEach (copy), joinDeep (copy), None (copy)
	local v7 = table.clone(t1)

	forEach(t2, function(p1, p2) -- line: 24
		-- upvalues: t1 (copy), v7 (copy), joinDeep (copy), None (copy)
		if typeof(t1[p2]) == "table" and typeof(p1) == "table" then
			v7[p2] = joinDeep(t1[p2], p1)

			return
		end

		if p1 == None then
			v7[p2] = nil

			return
		end

		v7[p2] = p1
	end)

	return v7
end

return joinDeep
