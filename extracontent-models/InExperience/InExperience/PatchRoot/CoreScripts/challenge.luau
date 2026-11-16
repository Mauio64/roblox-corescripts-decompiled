local v, v2 = ...
arg0 = v
arg1 = v2

local function x1(p, p2) -- 1 equivalent call inferred from this helper
	return p + p2
end
local function x2(p, p2) -- 1 equivalent call inferred from this helper
	return p - p2
end
local function x3(p, p2)
	return p2 - p
end
local function x4(p, p2)
	return (tonumber(tostring(p2 % 1000) .. tostring((math.abs(p % 1000)))))
end
local function x5(p, p2)
	return (tonumber(tostring(p2 % 1337) .. tostring((math.abs(p % 1337)))))
end
local function x6(p, p2) -- 1 equivalent call inferred from this helper
	return p % 1000 * (p2 % 1000)
end
local function x7(p, p2)
	return p % 1337 * (p2 % 1337)
end
local function x8(p, p2)
	return x6(x1(p, p2), x2(p, p2)) -- inferred equivalent call
end

local random = Random.new(5)
local v3 = { 1, 2, 3, 4, 5, 6, 7, 8 }

for _ = 1, 32 do
	local integer = random:NextInteger(1, 8)
	local integer2 = random:NextInteger(1, 8)
	local v4 = v3[integer]
	v3[integer] = v3[integer2]
	v3[integer2] = v4
end

local v4 = {}
v4[v3[1]] = x1
v4[v3[2]] = x2
v4[v3[3]] = x3
v4[v3[4]] = x4
v4[v3[5]] = x5
v4[v3[6]] = x6
v4[v3[7]] = x7
v4[v3[8]] = x8

local function x9(arg0, arg1)
	local v5 = 393
	local v6 = 1

	for _ = 1, 16 do
		v5 = (v5 + v4[math.abs(arg1 + v5 + v6) % 8 + 1](v5 + arg0, arg1)) % 10000000
		v6 += 1
	end

	return v5
end

return x9(arg0, arg1)
