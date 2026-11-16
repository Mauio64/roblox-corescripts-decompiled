local function readInputValue(input_data) -- 2 equivalent calls inferred from this helper
	local kind

	if input_data ~= nil then
		kind = input_data.kind
	end

	return if kind ~= nil then kind.value else nil
end

local function isFeed(p): boolean -- 1 equivalent call inferred from this helper
	return type(p) == "table" and type(p.entry_map) == "table"
end

local v = {
	"universe_items",
	"game_items",
	"song_items",
	"event_items",
	"user_items",
	"items",
	"cards"
}

local function hasItemList(p): boolean
	for _, v2 in v do
		if type(p[v2]) == "table" then
			return true
		end
	end

	return false
end

local function hasSortId(p): boolean -- 1 equivalent call inferred from this helper
	local sort_id = p.sort_id
	return sort_id ~= nil and sort_id ~= ""
end

local function readPoolId(p) -- 2 equivalent calls inferred from this helper
	local pool_id = p.pool_id

	if type(pool_id) == "string" and pool_id ~= "" then
		return pool_id
	end

	return nil
end

local function readSortId(p: string, p2) -- 1 equivalent call inferred from this helper
	local sort_id = p2.sort_id

	if sort_id == nil or sort_id == "" then
		return p
	end

	return (tostring(sort_id))
end

local function countSortItems(p, p2, p3, p4: string)
	local pool_id = readPoolId(p) -- inferred equivalent call

	if pool_id == nil then
		local total = 0

		for _, v2 in v do
			local v3 = p[v2]

			if type(v3) == "table" then
				total += #v3
			end
		end

		return total
	else
		local formatted = `{p4}/{pool_id}`

		if p3[formatted] then
			return 0
		end

		p3[formatted] = true
		local content_pools = p2.content_pools
		local v2

		if type(content_pools) == "table" then
			v2 = content_pools[pool_id]
		end

		local items

		if type(v2) == "table" then
			items = v2.items
		end

		if type(items) == "table" then
			return #items
		end

		return 0
	end
end

local function buildHomeFeedStats(p)
	local homeFeedStats = {}

	if type(p) ~= "table" then
		return homeFeedStats
	end

	local v2 = {}

	for _, v3 in p.page_entries or {} do
		local inputValue = readInputValue(v3.input_data) -- inferred equivalent call

		if not isFeed(inputValue) then -- inferred equivalent call
			continue
		end

		for k, v4 in inputValue.entry_order or {} do
			local v5 = inputValue.entry_map[v4]

			if v5 == nil then
				continue
			end

			local inputValue2 = readInputValue(v5.input_data) -- inferred equivalent call

			if type(inputValue2) ~= "table" then
				continue
			end

			local flag = true

			if readPoolId(inputValue2) == nil then -- inferred equivalent call
				local flag2 = true

				for _, v6 in v do
					if type(inputValue2[v6]) == "table" then
						flag = true
						flag2 = false
						break
					end
				end

				if flag2 then
					flag = false
				end
			end

			if not flag and not hasSortId(inputValue2) then -- inferred equivalent call
				continue
			end

			v4 = readSortId(v4, inputValue2) -- inferred equivalent call
			local itemCount

			if flag then
				itemCount = countSortItems(inputValue2, inputValue, v2, v4)
			end

			local homeFeedStat = homeFeedStats[v4]

			if homeFeedStat == nil then
				homeFeedStats[v4] = { itemCount = itemCount, position = k }
			elseif itemCount ~= nil then
				homeFeedStat.itemCount = (homeFeedStat.itemCount or 0) + itemCount
			end
		end
	end

	return homeFeedStats
end

return buildHomeFeedStats
