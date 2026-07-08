require(script.Parent.types)

local function instant(p1) -- line: 5
	return {
		step = function() -- line: 7
			-- upvalues: p1 (copy)
			return {
				complete = true,
				value = p1
			}
		end,
		startingValue = p1
	}
end

return instant
