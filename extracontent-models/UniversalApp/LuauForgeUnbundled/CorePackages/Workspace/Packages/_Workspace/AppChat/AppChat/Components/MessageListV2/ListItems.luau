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
	build = function(list, p2)
		local v5 = p2 == nil and {} or p2.items
		local v6 = p2 == nil and {} or p2.byKey
		local v7 = table.create(#list)
		local v8 = {}
		local v9 = false

		for i = #list, 1, -1 do
			local v10 = list[i]
			local stable_key = v10.stable_key

			if v8[stable_key] ~= nil then
				continue
			end

			local v11 = v6[stable_key]

			if v11 ~= nil and (v11 == v10 or itemContentsEqual(v11, v10)) then
				v10 = v11
			end

			table.insert(v7, v10)
			v8[stable_key] = v10
			v9 = v9 or v5[#v7] ~= v10
		end

		if p2 == nil or v9 or #v7 ~= #v5 then
			return { items = v7, byKey = v8 }
		end

		return p2
	end,
	getKey = function(p2)
		return p2.stable_key
	end
}
