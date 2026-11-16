require(script.Parent.types)

local function instant(startingValue)
	return {
		step = function()
			return { value = startingValue, complete = true }
		end,
		startingValue = startingValue
	}
end

return instant
