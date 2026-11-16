local function getKey(p) -- 1 equivalent call inferred from this helper
	return p.stable_key
end

local function valuesEqual(item, items, options): boolean
	if item == items then
		return true
	end

	if type(item) ~= "table" or type(items) ~= "table" then
		return false
	end

	local items2 = options or {}

	if items2[item] == items then
		return true
	end

	items2[item] = items

	for k, item2 in item do
		if not valuesEqual(item2, items[k], items2) then
			return false
		end
	end

	for k in items do
		if item[k] == nil then
			return false
		end
	end

	return true
end

local function itemContentsEqual(items, items2): boolean
	for k, item in items do
		if k ~= "position" and not valuesEqual(item, items2[k]) then
			return false
		end
	end

	for k in items2 do
		if k ~= "position" and items[k] == nil then
			return false
		end
	end

	return true
end

return {
	build = function(list, p)
		local v = p == nil and {} or p.items
		local v2 = p == nil and {} or p.byKey
		local items = table.create(#list)
		local byKey = {}
		local v3 = false

		for i = #list, 1, -1 do
			local v4 = list[i]
			local key = getKey(v4) -- inferred equivalent call

			if byKey[key] ~= nil then
				continue
			end

			local v5 = v2[key]

			if v5 ~= nil and (v5 == v4 or itemContentsEqual(v5, v4)) then
				v4 = v5
			end

			table.insert(items, v4)
			byKey[key] = v4
			v3 = v3 or v[#items] ~= v4
		end

		if p == nil or v3 or #items ~= #v then
			return { items = items, byKey = byKey }
		end

		return p
	end,
	getKey = getKey
}
