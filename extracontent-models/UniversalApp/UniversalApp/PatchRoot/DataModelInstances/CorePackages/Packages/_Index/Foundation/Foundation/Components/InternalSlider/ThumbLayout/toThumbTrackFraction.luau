local getThumbTravel = require(script.Parent.getThumbTravel)

local function toThumbTrackFraction(p: number, p2: number, p3: number, p4: number)
	local thumbTravel = getThumbTravel(p3, p4)

	if thumbTravel == nil then
		return p
	end

	return p * thumbTravel + (p2 - 1) * p4
end

return toThumbTrackFraction
