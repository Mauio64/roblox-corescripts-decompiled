local v1, v2 = ...

arg0 = v1
arg1 = v2

local function x1(p1, p2) -- line: 6
	return p1 + p2
end
local function x2(p3, p4) -- line: 7
	return p3 - p4
end
local function x3(p5, p6) -- line: 8
	return p6 - p5
end
local function x4(p7, p8) -- line: 9
	return (tonumber(tostring(p8 % 1000) .. tostring((math.abs(p7 % 1000)))))
end
local function x5(p9, p10) -- line: 10
	return (tonumber(tostring(p10 % 1337) .. tostring((math.abs(p9 % 1337)))))
end
local function x6(p11, p12) -- line: 11
	return p11 % 1000 * (p12 % 1000)
end
local function x7(p13, p14) -- line: 12
	return p13 % 1337 * (p14 % 1337)
end
local function x8(p15, p16) -- line: 13
	local v35 = p15 + p16
	local v36 = p15 - p16

	return v35 % 1000 * (v36 % 1000)
end

local t1 = {
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8
}
local random = Random.new(5)

for _ = 1, 32 do
	local v14 = random:NextInteger(1, 8)
	local v15 = random:NextInteger(1, 8)
	local v16 = t1[v14]

	t1[v14] = t1[v15]
	t1[v15] = v16
end

local t2 = {
	[t1[1]] = x1,
	[t1[2]] = x2,
	[t1[3]] = x3,
	[t1[4]] = x4,
	[t1[5]] = x5,
	[t1[6]] = x6,
	[t1[7]] = x7,
	[t1[8]] = x8
}

local function x9(p17, p18) -- line: 35
	-- upvalues: t2 (copy)
	local n1 = 393
	local n2 = 1

	for _ = 1, 16 do
		n1 = (n1 + t2[math.abs(p18 + n1 + n2) % 8 + 1](n1 + p17, p18)) % 10000000
		n2 += 1
	end

	return n1
end

return (x9(arg0, arg1))
