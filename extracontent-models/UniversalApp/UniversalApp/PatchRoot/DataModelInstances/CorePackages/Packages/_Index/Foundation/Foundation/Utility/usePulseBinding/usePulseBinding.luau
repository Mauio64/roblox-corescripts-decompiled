local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)
local useClock = require(Parent.ReactUtils).useClock
local numberRange = NumberRange.new(0, 1)

local function usePulseBinding(n1: number?, numberRange2: NumberRange?) -- line: 15
	-- upvalues: useClock (copy), numberRange (copy), React (copy)
	local v8 = useClock()
	local v9 = n1 or 1
	local v10 = numberRange2 or numberRange

	return React.useMemo(function() -- line: 21
		-- upvalues: v8 (copy), v9 (copy), v10 (copy)
		return v8:map(function(n2: number) -- line: 22
			-- upvalues: v9 (copy), v10 (copy)
			return math.map(math.sin(n2 * 3.141592653589793 / v9) ^ 2, 0, 1, v10.Min, v10.Max)
		end)
	end, {
		n1,
		numberRange2
	})
end

return usePulseBinding
