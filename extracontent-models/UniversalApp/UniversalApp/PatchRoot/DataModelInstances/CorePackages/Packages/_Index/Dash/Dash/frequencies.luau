local scriptParent = script.Parent

require(scriptParent.Types)

local reduce = require(scriptParent.reduce)

local function frequencies(t1: {[any]: any}, p1: ((...any) -> ...any)?) -- line: 31
	-- upvalues: reduce (copy)
	return reduce(t1, function(p2, p3, p4) -- line: 32
		-- upvalues: p1 (copy)
		local v9 = if not p1 then p3 else p1(p3, p4)

		if p2[v9] == nil then
			p2[v9] = 1

			return p2
		end

		p2[v9] = p2[v9] + 1

		return p2
	end, {})
end

return frequencies
