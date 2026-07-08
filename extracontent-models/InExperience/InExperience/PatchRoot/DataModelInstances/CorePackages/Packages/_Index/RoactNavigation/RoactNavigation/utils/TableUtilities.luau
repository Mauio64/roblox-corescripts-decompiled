local t1 = {}
local t2 = {}

local function makeKeyString(p1) -- line: 8
	if type(p1) == "string" then
		return string.format("%s", p1)
	end

	return string.format("[%s]", (tostring(p1)))
end
local function makeValueString(p2) -- line: 16
	local v11 = type(p2)

	if v11 == "string" then
		return string.format("%q", p2)
	end

	if v11 == "function" or v11 == "table" then
		return string.format("<%s>", (tostring(p2)))
	end

	return string.format("%s", (tostring(p2)))
end
local function printKeypair(p3, p4, p5, p6) -- line: 27
	-- upvalues: makeValueString (copy)
	local v16 = if type(p3) ~= "string" then string.format("[%s]", (tostring(p3))) else string.format("%s", p3)
	local v17 = makeValueString(p4)
	local v18 = not p6 and "" or string.format(" -- %s", p6)

	print(string.format("%s%s = %s,%s", p5, v16, v17, v18))
end

function t1.ShallowEqual(p7, p8, p9) -- line: 39
	-- upvalues: t2 (copy)
	if not p7 or not p8 then
		return false
	end

	if p7 == p8 then
		return true
	end

	if not p9 then
		p9 = t2
	end

	for v22, v23 in p7 do
		if v23 ~= p8[v22] and not p9[v22] then
			return false
		end
	end

	for v24, v25 in p8 do
		if v25 ~= p7[v24] and not p9[v24] then
			return false
		end
	end

	return true
end

local function formatDeepEqualMessage(p10, p11) -- line: 64
	if p11 ~= 0 then
		return p10
	end

	return p10:gsub("{1}", "first"):gsub("{2}", "second")
end

function t1.DeepEqual(p12, p13, p14) -- line: 75
	-- upvalues: formatDeepEqualMessage (copy), t1 (copy)
	local v31 = p14 or 0

	if p12 == p13 then
		return true
	end

	if typeof(p12) ~= typeof(p13) then
		local v32 = ("{1} is of type %s, but {2} is of type %s"):format(typeof(p12), (typeof(p13)))

		return false, formatDeepEqualMessage(v32, v31)
	end

	if typeof(p12) == "table" then
		local t3 = {}

		for v34, v35 in p12 do
			t3[v34] = true

			local v36, v37 = t1.DeepEqual(v35, p13[v34], v31 + 1)

			if not v36 then
				local v38 = v37:gsub("{1}", ("{1}[%s]"):format((tostring(v34)))):gsub("{2}", ("{2}[%s]"):format((tostring(v34))))

				return false, formatDeepEqualMessage(v38, v31)
			end
		end

		for v39, v40 in p13 do
			if t3[v39] then
				continue
			end

			local v41, v42 = t1.DeepEqual(p12[v39], v40, v31 + 1)

			if not v41 then
				local v43 = v42:gsub("{1}", ("{1}[%s]"):format((tostring(v39)))):gsub("{2}", ("{2}[%s]"):format((tostring(v39))))

				return false, formatDeepEqualMessage(v43, v31)
			end
		end

		return true
	end

	return false, formatDeepEqualMessage("{1} ~= {2}", v31)
end
function t1.EqualKey(p15, p16, p17) -- line: 127
	if p15 and (p16 and p17 and p17 ~= "" and p15[p17] and p16[p17] and p15[p17] == p16[p17]) then
		return true
	end

	return false
end
function t1.TableDifference(p18, p19) -- line: 138
	local t4 = {}

	for v50, v51 in p18 do
		if p19[v50] ~= p18[v50] then
			t4[v50] = v51
		end
	end

	return t4
end

local function membershipTable(p20) -- line: 155
	local t5 = {}

	for i = 1, #p20 do
		t5[p20[i]] = true
	end

	return t5
end
local function listOfKeys(p21) -- line: 166
	local t6 = {}

	for v57, _ in p21 do
		table.insert(t6, v57)
	end

	return t6
end

function t1.ListDifference(p22, p23) -- line: 178
	-- upvalues: t1 (copy)
	local TableDifference = t1.TableDifference
	local t7 = {}

	for i = 1, #p22 do
		t7[p22[i]] = true
	end

	local t8 = {}

	for i = 1, #p23 do
		t8[p23[i]] = true
	end

	local t9 = {}

	for v67, _ in (TableDifference(t7, t8)) do
		table.insert(t9, v67)
	end

	return t9
end
function t1.CheckListConsistency(p24) -- line: 188
	local v70 = false
	local v71 = false
	local v72 = true
	local n1 = 1

	for v74, _ in p24 do
		if type(v74) == "string" then
			v71 = true
		else
			if type(v74) ~= "number" then
				return false
			end

			if n1 ~= v74 then
				v72 = false
			end

			v70 = true
		end

		if v71 and v70 then
			return false
		end

		n1 += 1
	end

	if v70 then
		return v72
	end

	return true
end
function t1.RecursiveToString(p25, p26) -- line: 223
	-- upvalues: t1 (copy)
	local v78 = p26 or ""

	if type(p25) == "table" then
		local s1 = ""

		if not t1.CheckListConsistency(p25) then
			s1 ..= "-- WARNING: this table fails the list consistency test\n"
		end

		local v80 = s1 .. "{\n"

		for v81, v82 in p25 do
			if type(v81) == "string" then
				v80 ..= "  " .. v78 .. tostring(v81) .. " = " .. t1.RecursiveToString(v82, "  " .. v78) .. ";\n"
			end

			if type(v81) == "number" then
				v80 ..= "  " .. v78 .. t1.RecursiveToString(v82, "  " .. v78) .. ",\n"
			end
		end

		return v80 .. v78 .. "}"
	end

	return (tostring(p25))
end
function t1.Print(p27, p28) -- line: 257
	-- upvalues: makeValueString (copy), printKeypair (copy)
	local u85 = p28 or "  "

	if type(p27) ~= "table" then
		error("TableUtilities.Print must be passed a table", 2)
	end

	local t10 = {}

	local function recurse(p29, p30, p31) -- line: 267
		-- upvalues: t10 (copy), u85 (ref), makeValueString (copy), printKeypair (copy), recurse (copy)
		t10[p29] = true

		local v94 = string.rep(u85, p31)
		local v95 = string.rep(u85, p31 + 1)

		if p30 then
			print(string.format("%s%s = %s {", v94, if type(p30) ~= "string" then string.format("[%s]", (tostring(p30))) else string.format("%s", p30), makeValueString(p29)))
		else
			print(string.format("%s%s {", v94, makeValueString(p29)))
		end

		for v96, v97 in p29 do
			if type(v97) == "table" then
				if t10[v97] then
					printKeypair(v96, v97, v95, "Possible cycle")
				else
					recurse(v97, v96, p31 + 1)
				end
			else
				local v98 = if type(v96) ~= "string" then string.format("[%s]", (tostring(v96))) else string.format("%s", v96)
				local v99 = makeValueString(v97)

				print(string.format("%s%s = %s,%s", v95, v98, v99, ""))
			end
		end

		print(string.format("%s}%s", v94, not (p31 > 0) and "" or ","))
	end

	recurse(p27, nil, 0)
end
function t1.FieldCount(p32) -- line: 301
	local n2 = 0

	for _ in p32 do
		n2 += 1
	end

	return n2
end

return t1
