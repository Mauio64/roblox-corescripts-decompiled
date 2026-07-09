local v1 = game:DefineFastFlag("DebugLuaArgCheck", false)
local v2 = game:GetService("RunService"):IsStudio()
local t1 = {
	isEnabled = function() -- line: 7
		-- upvalues: v1 (copy), v2 (copy)
		return v1 or (_G.__TESTEZ_RUNNING_TEST__ or v2)
	end
}

local function assert_(p1, p2) -- line: 11
	-- upvalues: t1 (copy)
	if t1.isEnabled() then
		assert(p1, p2)
	end
end
local function stubArgCheckFunction() -- line: 17
	return true
end

function t1.wrap(p3) -- line: 43
	-- upvalues: t1 (copy), stubArgCheckFunction (copy)
	if t1.isEnabled() then
		return p3
	end

	return stubArgCheckFunction
end
function t1.isNonNegativeNumber(p4, p5) -- line: 47
	-- upvalues: t1 (copy)
	local v11 = typeof(p4) == "number" and p4 >= 0
	local v12 = string.format("expects %s to be a non-negative number!", p5)

	if t1.isEnabled() then
		assert(v11, v12)
	end

	return p4
end
function t1.isType(p6, p7, p8) -- line: 54
	-- upvalues: t1 (copy)
	local v16 = p7 == typeof(p6)
	local v17 = string.format("expects %s to be a %s! it was: %s", p8, p7, (typeof(p6)))

	if t1.isEnabled() then
		assert(v16, v17)
	end

	return p6
end
function t1.isInTypes(p9, p10, p11) -- line: 63
	-- upvalues: t1 (copy)
	for _, v in ipairs(p10) do
		if v == typeof(p9) then
			return p9
		end
	end

	local v23 = string.format("expects %s to be one of expectedTypes! it was: %s", p11, (typeof(p9)))

	if t1.isEnabled() then
		assert(false, v23)
	end

	return p9
end
function t1.isTypeOrNil(p12, p13, p14) -- line: 75
	-- upvalues: t1 (copy)
	local v27 = p12 == nil or p13 == typeof(p12)
	local v28 = string.format("expects %s to be a %s! it was: %s", p14, p13, (typeof(p12)))

	if t1.isEnabled() then
		assert(v27, v28)
	end

	return p12
end
function t1.isNotNil(p15, p16) -- line: 84
	-- upvalues: t1 (copy)
	local v31 = p15 ~= nil
	local v32 = string.format("expects %s to be not nil!", p16)

	if t1.isEnabled() then
		assert(v31, v32)
	end

	return p15
end
function t1.isNonEmptyString(p17, p18) -- line: 90
	-- upvalues: t1 (copy)
	local v35 = typeof(p17) == "string" and p17 ~= ""
	local v36 = string.format("expects %s to be a non-empty string!", p18)

	if t1.isEnabled() then
		assert(v35, v36)
	end

	return p17
end
function t1.isEqual(p19, p20, p21) -- line: 96
	-- upvalues: t1 (copy)
	local v40 = p19 == p20
	local v41 = string.format("expects %s to equal %s! it was: %s", p21, tostring(p20), (tostring(p19)))

	if t1.isEnabled() then
		assert(v40, v41)
	end

	return p19
end
function t1.representsInteger(p22, p23) -- line: 106
	-- upvalues: t1 (copy)
	local num = tonumber(p22)
	local v45 = num ~= nil
	local v46 = string.format("expects %s to represent a number!", p23)

	if t1.isEnabled() then
		assert(v45, v46)
	end

	local v47 = num % 1 == 0
	local v48 = string.format("expects %s to represent an integer!", p23)

	if t1.isEnabled() then
		assert(v47, v48)
	end

	return p22
end
function t1.matchesInterface(p24, p25, p26, p27) -- line: 137
	-- upvalues: t1 (copy)
	if t1.isEnabled() then
		local t2 = {
			integer = t1.representsInteger,
			nonEmptyString = t1.isNonEmptyString
		}

		if type(p25) == "string" then
			if p27 and p27[p25] then
				t1.matchesInterface(p24, p27[p25], p26, p27)

				return p24
			end

			local v54 = t2[p25]

			if type(v54) == "function" then
				v54(p24, p26)

				return p24
			end

			t1.isType(p24, p25, p26)

			return p24
		end

		t1.isType(p24, "table", p26)

		if p25[1] ~= nil then
			for i, v in ipairs(p24) do
				t1.matchesInterface(v, p25[1], p26 .. "[" .. i .. "]", p27)
			end

			return p24
		end

		for k, v in pairs(p25) do
			if string.sub(k, 1, 1) ~= "_" then
				local v59 = p26 .. "." .. k
				local v60 = p24[k]

				if p25._required and p25._required[k] or v60 ~= nil then
					t1.matchesInterface(v60, v, v59, p27)
				end
			end
		end
	end

	return p24
end
function t1.assert(...) -- line: 179
	-- upvalues: t1 (copy)
	local v61, v62 = ...

	if t1.isEnabled() then
		assert(v61, v62)
	end
end

return t1
