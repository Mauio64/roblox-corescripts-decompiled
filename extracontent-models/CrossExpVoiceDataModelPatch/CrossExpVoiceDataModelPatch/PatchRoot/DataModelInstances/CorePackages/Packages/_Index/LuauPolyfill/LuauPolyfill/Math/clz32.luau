local rshift = bit32.rshift
local log = math.log
local floor = math.floor

return function(p: number)
	local v = rshift(p, 0)

	if v == 0 then
		return 32
	end

	return 31 - floor(log(v) / 0.6931471805599453)
end
