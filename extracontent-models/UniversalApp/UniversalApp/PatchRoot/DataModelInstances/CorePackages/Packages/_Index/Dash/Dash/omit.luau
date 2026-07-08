local scriptParent = script.Parent
local collectSet = require(scriptParent.collectSet)
local forEach = require(scriptParent.forEach)

require(scriptParent.Types)

local function omit(t1: {[any]: any}, t2: {[any]: any}) -- line: 16
	-- upvalues: collectSet (copy), forEach (copy)
	local t3 = {}
	local v8 = collectSet(t2)

	forEach(t1, function(_, p2) -- line: 19
		-- upvalues: v8 (copy), t3 (copy), t1 (copy)
		if not v8[p2] then
			t3[p2] = t1[p2]
		end
	end)

	return t3
end

return omit
