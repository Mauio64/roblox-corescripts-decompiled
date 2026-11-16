local function getThumbTravel(p: number, p2: number, flag: boolean?)
	if not flag then
		p -= 1
	end

	local v = 1 - p * p2
	return if v > 0 then v else nil
end

return getThumbTravel
