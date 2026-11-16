local getThumbTravel = require(script.Parent.getThumbTravel)

local function toThumbFraction(p: number, p2: number, p3: number, p4: number)
	local thumbTravel = getThumbTravel(p3, p4)

	if thumbTravel == nil then
		return p
	end

	return (math.clamp((p - (p2 - 1) * p4) / thumbTravel, 0, 1))
end

return toThumbFraction
