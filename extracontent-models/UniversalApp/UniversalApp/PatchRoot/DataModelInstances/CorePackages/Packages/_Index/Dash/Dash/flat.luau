local scriptParent = script.Parent
local append = require(scriptParent.append)
local forEach = require(scriptParent.forEach)

local function flat(t1: {[any]: any}) -- line: 14
	-- upvalues: forEach (copy), append (copy)
	local t2 = {}

	forEach(t1, function(t3: {[any]: any}) -- line: 16
		-- upvalues: append (copy), t2 (copy)
		append(t2, t3)
	end)

	return t2
end

return flat
