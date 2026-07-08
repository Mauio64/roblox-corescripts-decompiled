local scriptParent = script.Parent
local None = require(scriptParent.None)

require(scriptParent.Types)

local forEach = require(scriptParent.forEach)
local forEachArgs = require(scriptParent.forEachArgs)

local function assign(t1: {[any]: any}, ...) -- line: 54
	-- upvalues: forEachArgs (copy), None (copy), forEach (copy)
	forEachArgs(function(t2: {[any]: any}?) -- line: 56
		-- upvalues: None (copy), forEach (copy), t1 (copy)
		if t2 == nil or t2 == None then
			return
		end

		forEach(t2, function(p1, p2) -- line: 62
			-- upvalues: None (copy), t1 (copy)
			if p1 == None then
				t1[p2] = nil

				return
			end

			t1[p2] = p1
		end)
	end, ...)

	return t1
end

return assign
