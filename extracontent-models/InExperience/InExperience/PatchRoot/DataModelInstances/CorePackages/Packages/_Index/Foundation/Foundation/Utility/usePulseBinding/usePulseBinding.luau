local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useClock = ReactUtils.useClock

local numberRange = NumberRange.new(0, 1)

local function usePulseBinding(value: number?, range: NumberRange?)
	local v = useClock()

	local v2 = value or 1
	local v3 = range or numberRange
	return React.useMemo(function()
		return v:map(function(p: number)
			return math.map(math.sin(p * 3.141592653589793 / v2) ^ 2, 0, 1, v3.Min, v3.Max)
		end)
	end, { value, range })
end

return usePulseBinding
