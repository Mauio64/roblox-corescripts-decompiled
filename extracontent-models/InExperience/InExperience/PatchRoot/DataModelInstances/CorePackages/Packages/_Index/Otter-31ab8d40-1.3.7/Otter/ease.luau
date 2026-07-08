require(script.Parent.types)

local function linear(n1: number, _) -- line: 24
	return n1
end
local function quad(n2: number, _) -- line: 28
	return n2 * n2
end
local function cubic(n3: number, _) -- line: 32
	return n3 * n3 * n3
end
local function quart(n4: number, _) -- line: 36
	return n4 * n4 * n4 * n4
end
local function quint(n5: number, _) -- line: 40
	return n5 * n5 * n5 * n5 * n5
end
local function exponential(n6: number, _) -- line: 44
	if n6 == 0 then
		return 0
	end

	return (math.pow(2, (n6 - 1) * 10))
end
local function sine(n7: number, _) -- line: 48
	return 1 - math.cos(n7 * 3.141592653589793 / 2)
end
local function elastic(n8: number, _) -- line: 52
	if n8 == 0 then
		return 0
	end

	if n8 == 1 then
		return 1
	end

	return -math.pow(2, n8 * 10 - 10) * math.sin((n8 * 10 - 10.75) * 2.0943951023931953)
end
local function back(n9: number, _) -- line: 56
	return n9 * 2.70158 * n9 * n9 - n9 * 1.70158 * n9
end
local function easeOutBounce(n10: number) -- line: 62
	if n10 < 0.36363636363636365 then
		return n10 * 7.5625 * n10
	end

	if n10 < 0.7272727272727273 then
		return (n10 - 0.5454545454545454) * 7.5625 * (n10 - 0.5454545454545454) + 0.75
	end

	if n10 < 0.9090909090909091 then
		return (n10 - 0.8181818181818182) * 7.5625 * (n10 - 0.8181818181818182) + 0.9375
	end

	return (n10 - 0.9545454545454546) * 7.5625 * (n10 - 0.9545454545454546) + 0.984375
end
local function bounce(n11: number, _) -- line: 77
	local v38 = 1 - n11

	return 1 - if not (v38 < 0.36363636363636365) then if not (v38 < 0.7272727272727273) then if not (v38 < 0.9090909090909091) then (v38 - 0.9545454545454546) * 7.5625 * (v38 - 0.9545454545454546) + 0.984375 else (v38 - 0.8181818181818182) * 7.5625 * (v38 - 0.8181818181818182) + 0.9375 else (v38 - 0.5454545454545454) * 7.5625 * (v38 - 0.5454545454545454) + 0.75 else v38 * 7.5625 * v38
end
local function circular(n12: number, _) -- line: 81
	return -(math.sqrt(1 - n12 * n12) - 1)
end
local function evaluateBezier(n13: number, n14: number, n15: number) -- line: 86
	local v44 = 1 - n13
	local v45 = v44 * v44
	local v46 = n13 * n13

	return v45 * 3 * n13 * n14 + v44 * 3 * v46 * n15 + n13 * v46
end
local function cubicBezier(n16: number, p12) -- line: 95
	assert(typeof(p12) == "table", "Expected values to be a table")
	assert(#p12 == 4, "Expected values to have 4 elements")

	local v49, v50, v51, v52 = table.unpack(p12)

	assert(v49 >= 0 and v49 <= 1, "x1 must be between 0 and 1")
	assert(v51 >= 0 and v51 <= 1, "x2 must be between 0 and 1")

	if n16 <= 0 then
		return 0
	end

	if n16 >= 1 then
		return 1
	end

	local n17 = 0
	local n18 = 1
	local n19 = 0

	for _ = 1, 10 do
		n19 += 1

		local v57 = (n17 + n18) / 2
		local v58 = 1 - v57
		local v59 = v58 * v58
		local v60 = v57 * v57
		local v61 = v59 * 3 * v57 * v49 + v58 * 3 * v60 * v51 + v57 * v60

		if math.abs(v61 - n16) < 0.0001 then
			local v62 = 1 - v57
			local v63 = v62 * v62
			local v64 = v57 * v57

			return v63 * 3 * v57 * v50 + v62 * 3 * v64 * v52 + v57 * v64
		end

		if v61 < n16 then
			n17 = v57
		else
			n18 = v57
		end
	end

	local v65 = (n17 + n18) / 2
	local v66 = 1 - v65
	local v67 = v66 * v66
	local v68 = v65 * v65

	return v67 * 3 * v65 * v50 + v66 * 3 * v68 * v52 + v65 * v68
end

local t1 = {
	[Enum.EasingStyle.Linear] = linear,
	[Enum.EasingStyle.Quad] = quad,
	[Enum.EasingStyle.Cubic] = cubic,
	[Enum.EasingStyle.Quart] = quart,
	[Enum.EasingStyle.Quint] = quint,
	[Enum.EasingStyle.Exponential] = exponential,
	[Enum.EasingStyle.Sine] = sine,
	[Enum.EasingStyle.Back] = back,
	[Enum.EasingStyle.Bounce] = bounce,
	[Enum.EasingStyle.Elastic] = elastic,
	[Enum.EasingStyle.Circular] = circular
}

local function ease(n20: number, p13) -- line: 158
	-- upvalues: t1 (copy), cubicBezier (copy)
	local v71 = (not p13 or not p13.duration) and 1 or p13.duration
	local v72 = if not p13 or not p13.easingStyle then Enum.EasingStyle.Linear else p13.easingStyle
	local v73 = if typeof(v72) ~= "EnumItem" and typeof(v72) ~= "string" then cubicBezier else t1[v72]

	return {
		step = function(p14, n21: number) -- line: 169
			-- upvalues: n20 (copy), v71 (copy), v73 (copy), v72 (copy)
			local v76 = if p14.initialValue == nil then p14.value or 0 else p14.initialValue
			local v77 = (p14.elapsed or 0) + n21

			if p14.goal and n20 ~= p14.goal then
				v76 = p14.value
				v77 = 0
			end

			local v78 = math.min(v77 / v71, 1)
			local v79 = v73(v78, v72)
			local v80 = v76 + (n20 - v76) * v79
			local v81 = v77 >= v71 or v76 == n20

			if v81 then
				v80 = n20
				v76 = n20
				v77 = 0
			end

			return {
				initialValue = v76,
				goal = n20,
				value = v80,
				elapsed = v77,
				complete = v81
			}
		end,
		startingValue = if not p13 then nil else p13.startingValue
	}
end

return ease
