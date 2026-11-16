local function applySplice(data, list, list2, p: number, count: number, items)
	local v = #list - p - count
	local v2 = #list2 - p - count

	if v > 0 then
		data.remove(p + 1, v)
	end

	for i = 1, v2 do
		data.insert(p + i, list2[p + i])
	end

	if items ~= nil then
		for _, item in items do
			data.setItem(item, list2[item])
		end
	end

	for i = 0, count - 1 do
		local v3 = #list2 - i

		if list[#list - i] ~= list2[v3] then
			data.setItem(v3, list2[v3])
		end
	end
end

local function reconcileSplice(data, list, list2, callback): boolean
	local count = #list
	local count2 = #list2
	local v = math.min(count, count2)
	local v2 = 0
	local v3 = nil

	while v2 < v do
		local v4 = v2 + 1
		local item = list[v4]
		local item2 = list2[v4]

		if item ~= item2 then
			if callback(item, v4) ~= callback(item2, v4) then
				break
			end

			v3 = v3 == nil and {} or v3

			table.insert(v3, v4)
		end

		v2 = v4
	end

	local count3 = 0

	while count3 < v - v2 do
		local v4 = count - count3
		local v5 = count2 - count3

		if callback(list[v4], v4) ~= callback(list2[v5], v5) then
			break
		end

		count3 += 1
	end

	if v2 + count3 ~= v then
		return false
	end

	data.transaction(function()
		applySplice(data, list, list2, v2, count3, v3)
	end)
	return true
end

local function reconcileSnapshot(data, list, list2, callback)
	if reconcileSplice(data, list, list2, callback) then
		return
	end

	local v = table.create(#list)
	local v2 = table.create(#list2)

	local set = {}
	local v3 = {}

	for k, item in list do
		local v4 = callback(item, k)

		if set[v4] ~= nil then
			error(`DataSource.reconcileSnapshot: duplicate key "{v4}"`, 2)
		end

		set[v4] = true
		v[k] = v4
		v3[v4] = item
	end

	table.clear(set)

	for k, item in list2 do
		local v4 = callback(item, k)

		if set[v4] ~= nil then
			error(`DataSource.reconcileSnapshot: duplicate key "{v4}"`, 2)
		end

		set[v4] = true
		v2[k] = v4
	end

	local v4 = #v == #v2

	if v4 then
		for _, v5 in v2 do
			if v3[v5] == nil then
				v4 = false
				break
			end
		end
	end

	local count = 0

	while count < math.min(#v, #v2) and v[count + 1] == v2[count + 1] do
		count += 1
	end

	local function updateRetainedValues()
		for k, item in list2 do
			if v3[v2[k]] ~= item then
				data.setItem(k, item)
			end
		end
	end

	data.transaction(function()
		if not v4 then
			data.reset(list2)

			return
		end

		local v5 = count + 1
		local v6 = table.find(v, v2[v5])

		local function matchesMove(p: number?, p2: number?): boolean
			if p == nil or p2 == nil then
				return false
			end

			local clone = table.clone(v)
			table.insert(clone, p2, (table.remove(clone, p)))

			for k, v7 in v2 do
				if clone[k] ~= v7 then
					return false
				end
			end

			return true
		end

		local v7

		if matchesMove(v6, v5) then
			v7 = v5
		else
			v7 = table.find(v2, v[v5])
			v6 = v5
		end

		if matchesMove(v6, v7) then
			data.moveItem(v6, v7)
		else
			data.reorder(v2)
		end

		updateRetainedValues()
	end)
end

return reconcileSnapshot
