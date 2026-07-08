local scriptParent = script.Parent
local None = require(scriptParent.None)
local forEachArgs = require(scriptParent.forEachArgs)
local forEach = require(scriptParent.forEach)
local insert = table.insert

local function append(t1: {[any]: any}, ...) -- line: 16
	-- upvalues: forEachArgs (copy), None (copy), forEach (copy), insert (copy)
	forEachArgs(function(t2: {[any]: any}?) -- line: 17
		-- upvalues: None (copy), forEach (copy), t1 (copy), insert (copy)
		if t2 == None or t2 == nil then
			return
		end

		forEach(t2, function(p1) -- line: 21
			-- upvalues: t1 (copy), insert (copy)
			insert(t1, p1)
		end)
	end, ...)

	return t1
end

return append
