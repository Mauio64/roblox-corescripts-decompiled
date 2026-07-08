local rshift = bit32.rshift
local log = math.log
local floor = math.floor

return function(n1: number) -- line: 7
	-- upvalues: rshift (copy), log (copy), floor (copy)
	local v5 = rshift(n1, 0)

	if v5 == 0 then
		return 32
	end

	return 31 - floor(log(v5) / 0.6931471805599453)
end
