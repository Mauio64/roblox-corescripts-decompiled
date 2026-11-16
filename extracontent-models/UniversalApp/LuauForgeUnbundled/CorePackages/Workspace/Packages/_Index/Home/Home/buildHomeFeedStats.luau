local function readInputValue(p2)
	local kind = if p2 ~= nil then p2.kind else nil

	if kind == nil then
		return nil
	end

	return kind.value
end

local function isFeed(p2): boolean
	return type(p2) == "table" and type(p2.entry_map) == "table"
end

local v5 = {
	"universe_items",
	"game_items",
	"song_items",
	"event_items",
	"user_items",
	"items",
	"cards"
}

local function hasItemList(p2): boolean
	for k, v6 in v5 do
		if type(p2[v6]) == "table" then
			return true
		end
	end

	return false
end

local function hasSortId(p2): boolean
	local sort_id = p2.sort_id
	return sort_id ~= nil and sort_id ~= ""
end

local function readPoolId(p2)
	local pool_id = p2.pool_id

	if type(pool_id) == "string" and pool_id ~= "" then
		return pool_id
	end

	return nil
end

local function readSortId(p2, p3)
	local sort_id = p3.sort_id

	if sort_id == nil or sort_id == "" then
		return p2
	end

	return (tostring(sort_id))
end

local function countSortItems(value, value2, p2, p3)
	local pool_id = value.pool_id

	if type(pool_id) ~= "string" or pool_id == "" then
		pool_id = nil
	end

	if pool_id == nil then
		local total = 0

		for k, v6 in v5 do
			local v7 = value[v6]

			if type(v7) == "table" then
				total += #v7
			end
		end

		return total
	else
		local formatted = `{p3}/{pool_id}`

		if p2[formatted] then
			return 0
		end

		p2[formatted] = true
		local content_pools = value2.content_pools
		local v6 = if type(content_pools) == "table" then content_pools[pool_id] else nil
		local items = if type(v6) == "table" then v6.items else nil

		if type(items) == "table" then
			return #items
		end

		return 0
	end
end

local function buildHomeFeedStats(p2)
	local homeFeedStats = {}

	if type(p2) ~= "table" then
		return homeFeedStats
	end

	local v6 = {}

	for k, v7 in p2.page_entries or {} do
		local input_data = v7.input_data
		local kind = if input_data ~= nil then input_data.kind else nil
		local value = if kind ~= nil then kind.value else nil

		local v8 = type(value) == "table" and type(value.entry_map) == "table"

		if not v8 then
			continue
		end

		for k2, v9 in value.entry_order or {} do
			local v10 = value.entry_map[v9]

			if v10 == nil then
				continue
			end

			local input_data2 = v10.input_data
			local kind2 = if input_data2 ~= nil then input_data2.kind else nil
			local value2 = if kind2 ~= nil then kind2.value else nil

			if type(value2) ~= "table" then
				continue
			end

			local flag = true
			local pool_id = value2.pool_id

			if type(pool_id) ~= "string" or pool_id == "" then
				pool_id = nil
			end

			if pool_id == nil then
				local flag2 = true

				for k3, v11 in v5 do
					if type(value2[v11]) == "table" then
						flag = true
						flag2 = false
						break
					end
				end

				if flag2 then
					flag = false
				end
			end

			if not flag then
				local sort_id = value2.sort_id
				local v11 = not (sort_id == nil) and sort_id ~= ""

				if not v11 then
					continue
				end
			end

			local sort_id = value2.sort_id

			if sort_id ~= nil and sort_id ~= "" then
				v9 = tostring(sort_id)
			end

			local v11 = if flag then countSortItems(value2, value, v6, v9) else nil
			local homeFeedStat = homeFeedStats[v9]

			if homeFeedStat == nil then
				homeFeedStats[v9] = { itemCount = v11, position = k2 }
			elseif v11 ~= nil then
				homeFeedStat.itemCount = (homeFeedStat.itemCount or 0) + v11
			end
		end
	end

	return homeFeedStats
end

return buildHomeFeedStats
