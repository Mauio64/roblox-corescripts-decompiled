local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)

local function tokenize(s1: string) -- line: 41
	local t1 = {}

	for match in string.gmatch(s1, "%S+") do
		table.insert(t1, match)
	end

	return t1
end
local function trim(s2: string) -- line: 49
	return string.match(s2, "^%s*(.-)%s*$") or ""
end
local function startsWith(s3: string, s4: string) -- line: 53
	if #s4 > #s3 then
		return false
	end

	return s4 == string.sub(s3, 1, #s4)
end
local function anyWordEquals(t2: {[any]: any}, s5: string) -- line: 60
	for _, v22 in t2 do
		if v22 == s5 then
			return true
		end
	end

	return false
end
local function anyWordStartsWith(t3: {[any]: any}, s6: string) -- line: 69
	for _, v26 in t3 do
		if not (#s6 > #v26) and s6 == string.sub(v26, 1, #s6) then
			return true
		end
	end

	return false
end
local function anyWordIncludes(t4: {[any]: any}, s7: string) -- line: 78
	for _, v30 in t4 do
		if string.find(v30, s7, 1, true) ~= nil then
			return true
		end
	end

	return false
end
local function maxEditsFor(n1: number) -- line: 87
	if n1 >= 8 then
		return 2
	end

	return 1
end
local function editDistanceWithin(s8: string, s9: string, n2: number) -- line: 95
	if s8 == s9 then
		return true
	end

	local v35 = #s8
	local v36 = #s9

	if n2 < math.abs(v35 - v36) then
		return false
	end

	if v35 < v36 then
		local v37 = s8

		s8 = s9

		local v38 = v35

		v35 = v36
		s9 = v37
		v36 = v38
	end

	if v36 == 0 then
		return v35 <= n2
	end

	local t5 = table.create(v36 + 1)
	local t6 = table.create(v36 + 1)
	local t7 = table.create(v36 + 1)

	for i = 0, v36 do
		t6[i + 1] = i
	end

	for i = 1, v35 do
		t7[1] = i

		local v44 = i
		local byte = string.byte(s8, i)
		local v46 = not (i >= 2) and 0 or string.byte(s8, i - 1)

		for j = 1, v36 do
			local byte2 = string.byte(s9, j)
			local v49 = byte ~= byte2 and 1 or 0
			local v50 = t6[j + 1] + 1
			local v51 = t7[j] + 1
			local v52 = t6[j] + v49

			if v51 < v50 then
				v50 = v51
			end

			if v52 < v50 then
				v50 = v52
			end

			if i >= 2 and j >= 2 and byte == string.byte(s9, j - 1) and v46 == byte2 then
				local v53 = t5[j - 1] + 1

				if v53 < v50 then
					v50 = v53
				end
			end

			t7[j + 1] = v50

			if v50 < v44 then
				v44 = v50
			end
		end

		if n2 < v44 then
			return false
		end

		local v54 = t7

		t7 = t5
		t5 = t6
		t6 = v54
	end

	return n2 >= t6[v36 + 1]
end
local function anyWordWithinEditDistance(t8: {[any]: any}, s10: string, n3: number) -- line: 164
	-- upvalues: editDistanceWithin (copy)
	for _, v59 in t8 do
		if editDistanceWithin(s10, v59, n3) then
			return true
		end
	end

	return false
end
local function anyWordHasFuzzyPrefix(t9: {[any]: any}, s11: string, n4: number) -- line: 176
	-- upvalues: editDistanceWithin (copy)
	local v63 = #s11

	for _, v65 in t9 do
		if v63 <= #v65 and editDistanceWithin(s11, string.sub(v65, 1, v63), n4) then
			return true
		end
	end

	return false
end
local function scoreToken(s12: string, t10: {[any]: any}, s13: string, n5: number) -- line: 215
	-- upvalues: anyWordHasFuzzyPrefix (copy), anyWordIncludes (copy), editDistanceWithin (copy)
	if s12 == s13 then
		return 100
	end

	local g80 = nil
	local v79 = nil
	local g84 = nil
	local v83 = nil
	local g89 = nil
	local v88 = nil

	for _, v78 in t10 do
		if v78 == s13 then
			v79 = true
			g80 = true
		end

		if g80 then
			break
		end
	end

	if not g80 then
		v79 = false
	end

	g80 = false

	if v79 then
		return 50
	end

	for _, v82 in t10 do
		if not (#s13 > #v82) and s13 == string.sub(v82, 1, #s13) then
			v83 = true
			g84 = true
		end

		if g84 then
			break
		end
	end

	if not g84 then
		v83 = false
	end

	g84 = false

	if v83 then
		return 20
	end

	if #s13 >= 5 and anyWordHasFuzzyPrefix(t10, s13, not (#s13 >= 8) and 1 or 2) then
		return 8
	end

	if #s13 > 1 and string.find(s12, s13, 1, true) ~= nil then
		return 5
	end

	if #s13 == 1 and n5 > 1 and anyWordIncludes(t10, s13) then
		return 5
	end

	if #s13 >= 4 then
		local v85 = not (#s13 >= 8) and 1 or 2

		for _, v87 in t10 do
			if editDistanceWithin(s13, v87, v85) then
				v88 = true
				g89 = true
			end

			if g89 then
				break
			end
		end

		if not g89 then
			v88 = false
		end

		g89 = false

		if v88 then
			return 12
		end
	end

	return 0
end

return {
	substringMatch = function(t11: {[any]: any}, s14: string, n6: number) -- line: 191
		if n6 <= 0 then
			return {}
		end

		if s14 == "" then
			return {}
		end

		local v69 = string.lower(s14)
		local t12 = {}

		for _, v72 in t11 do
			if string.find(string.lower(v72.name), v69, 1, true) ~= nil then
				table.insert(t12, v72)

				if n6 <= #t12 then
					return t12
				end
			end
		end

		return t12
	end,
	fuzzyMatch = function(t13: {[any]: any}, s15: string, n7: number) -- line: 256
		-- upvalues: scoreToken (copy)
		if n7 <= 0 then
			return {}
		end

		local v93 = string.lower(string.match(s15, "^%s*(.-)%s*$") or "")

		if v93 == "" then
			return t13
		end

		local t14 = {}

		for match in string.gmatch(v93, "%S+") do
			table.insert(t14, match)
		end

		local v96 = #t14
		local t15 = {}

		for v98, v99 in t13 do
			local v100 = string.lower(v99.name)
			local t16 = {}

			for match in string.gmatch(v100, "%S+") do
				table.insert(t16, match)
			end

			local n8 = 0
			local v104 = false

			for _, v106 in t14 do
				local v107 = scoreToken(v100, t16, v106, v96)

				if v107 == 0 then
					v104 = true

					break
				end

				n8 += v107
			end

			if not v104 then
				table.insert(t15, {
					item = v99,
					score = n8,
					index = v98
				})
			end
		end

		table.sort(t15, function(p1, p2) -- line: 294
			if p1.score ~= p2.score then
				return p1.score > p2.score
			end

			return p1.index < p2.index
		end)

		local v108 = math.min(n7, #t15)
		local t17 = table.create(v108)

		for i = 1, v108 do
			t17[i] = t15[i].item
		end

		return t17
	end
}
