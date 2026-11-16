local getThumbTravel = require(script.Parent.getThumbTravel)

local function getThumbOffset(p: number, p2: number, p3: number, p4: number, flag: boolean?)
	if getThumbTravel(p3, p4, flag) == nil then
		return 0
	end

	if flag then
		return (p2 - 0.5 - p * p3) * p4
	end

	return (p2 - 1 - p * (p3 - 1)) * p4
end

return getThumbOffset
