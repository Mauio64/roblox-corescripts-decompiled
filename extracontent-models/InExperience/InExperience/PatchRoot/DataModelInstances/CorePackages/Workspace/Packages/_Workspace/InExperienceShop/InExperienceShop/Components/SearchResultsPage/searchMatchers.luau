local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)

local function tokenize(value: string) -- 2 equivalent calls inferred from this helper
	local result = {}

	for k in string.gmatch(value, "%S+") do
		table.insert(result, k)
	end

	return result
end

local function trim(value: string) -- 1 equivalent call inferred from this helper
	return string.match(value, "^%s*(.-)%s*$") or ""
end

local function startsWith(item: string, list: string): boolean -- 1 equivalent call inferred from this helper
	return not (#list > #item) and string.sub(item, 1, #list) == list
end

local function anyWordEquals(items, list: string): boolean -- 1 equivalent call inferred from this helper
	for _, item in items do
		if item == list then
			return true
		end
	end

	return false
end

local function anyWordStartsWith(items, list: string): boolean -- 1 equivalent call inferred from this helper
	for _, item in items do
		if startsWith(item, list) then -- inferred equivalent call
			return true
		end
	end

	return false
end

local function anyWordIncludes(items, list: string): boolean
	for _, item in items do
		if string.find(item, list, 1, true) ~= nil then
			return true
		end
	end

	return false
end

local function maxEditsFor(p: number): number -- 2 equivalent calls inferred from this helper
	return if p >= 8 then 2 else 1
end

local function editDistanceWithin(value: string, value2: string, p: number): boolean
	if value == value2 then
		return true
	end

	local v = #value
	local v2 = #value2

	if p < math.abs(v - v2) then
		return false
	end

	if v < v2 then
		local v3 = value2
		value2 = value
		value = v3
		v3 = v
		v = v2
		v2 = v3
	end

	if v2 == 0 then
		return v <= p
	end

	local v3 = table.create(v2 + 1)
	local v4 = table.create(v2 + 1)
	local v5 = table.create(v2 + 1)

	for i = 0, v2 do
		v4[i + 1] = i
	end

	for i = 1, v do
		v5[1] = i

		local v6 = string.byte(value, i)

		local v7 = i < 2 and 0 or string.byte(value, i - 1)
		local v8 = i

		for j = 1, v2 do
			local v9 = string.byte(value2, j)
			local v10 = v6 == v9 and 0 or 1
			local v11 = v4[j + 1] + 1
			local v12 = v5[j] + 1
			local v13 = v4[j] + v10

			if v12 < v11 then
				v11 = v12
			end

			if v13 < v11 then
				v11 = v13
			end

			if i >= 2 and j >= 2 and v6 == string.byte(value2, j - 1) and v7 == v9 then
				local v14 = v3[j - 1] + 1

				if v14 < v11 then
					v11 = v14
				end
			end

			v5[j + 1] = v11

			if v11 < v8 then
				v8 = v11
			end
		end

		if p < v8 then
			return false
		end

		local v9 = v3
		v3 = v4
		v4 = v5
		v5 = v9
	end

	return v4[v2 + 1] <= p
end

local function anyWordWithinEditDistance(items, list: string, p: number): boolean -- 1 equivalent call inferred from this helper
	for _, item in items do
		if editDistanceWithin(list, item, p) then
			return true
		end
	end

	return false
end

local function anyWordHasFuzzyPrefix(items, list: string, p: number): boolean
	local count = #list

	for _, item in items do
		if count <= #item and editDistanceWithin(list, string.sub(item, 1, count), p) then
			return true
		end
	end

	return false
end

local function scoreToken(name: string, items, list: string, p: number): number
	if name == list then
		return 100
	end

	if anyWordEquals(items, list) then -- inferred equivalent call
		return 50
	end

	if anyWordStartsWith(items, list) then -- inferred equivalent call
		return 20
	end

	if #list >= 5 and anyWordHasFuzzyPrefix(items, list, maxEditsFor(#list)) then -- inferred equivalent call
		return 8
	end

	if
		#list > 1 and string.find(name, list, 1, true) ~= nil
		or #list == 1 and p > 1 and anyWordIncludes(items, list)
	then
		return 5
	end

	if #list >= 4 and anyWordWithinEditDistance(items, list, maxEditsFor(#list)) then -- inferred equivalent call
		return 12
	end

	return 0
end

local SearchMatchers = {}

function SearchMatchers.substringMatch(items, value: string, p: number)
	if p <= 0 or value == "" then
		return {}
	end

	local v = string.lower(value)
	local result = {}

	for _, item in items do
		if string.find(string.lower(item.name), v, 1, true) == nil then
			continue
		end

		table.insert(result, item)

		if p <= #result then
			break
		end
	end

	return result
end

function SearchMatchers.fuzzyMatch(items, value: string, p: number)
	if p <= 0 then
		return {}
	end

	local v = string.lower(trim(value)) -- inferred equivalent call

	if v == "" then
		return items
	end

	local result2 = tokenize(v) -- inferred equivalent call
	local v2 = #result2

	local v3 = {}

	for k, item in items do
		local name = string.lower(item.name)
		local result = tokenize(name) -- inferred equivalent call
		local total = 0
		local v4 = false

		for _, v5 in result2 do
			local v6 = scoreToken(name, result, v5, v2)

			if v6 == 0 then
				v4 = true
				break
			end

			total += v6
		end

		if not v4 then
			table.insert(v3, { item = item, score = total, index = k })
		end
	end

	table.sort(v3, function(a, b): boolean
		if a.score == b.score then
			return a.index < b.index
		end

		return a.score > b.score
	end)

	local v4 = math.min(p, #v3)
	local result = table.create(v4)

	for i = 1, v4 do
		result[i] = v3[i].item
	end

	return result
end

return SearchMatchers
