local isHomeSortDetailSortIncluded = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/isHomeSortDetailSortIncluded")

local function isValidString(value): boolean
	return typeof(value) == "string" and value ~= ""
end

local function buildHomeSortDropDownOptions(p2)
	local homeSortDropDownOptions = {}

	if typeof(p2) ~= "table" then
		return homeSortDropDownOptions
	end

	local entry_order = p2.entry_order
	local entry_map = p2.entry_map

	if typeof(entry_order) ~= "table" or typeof(entry_map) ~= "table" then
		return homeSortDropDownOptions
	end

	for k, v5 in entry_order do
		local v6 = entry_map[v5]
		local input_data = if typeof(v6) == "table" then v6.input_data else nil
		local kind = if typeof(input_data) == "table" then input_data.kind else nil
		local value = if typeof(kind) == "table" then kind.value else nil
		local sort_id = if typeof(value) == "table" then value.sort_id else nil
		local title = if typeof(value) == "table" then value.title else nil
		local roblox_component = if typeof(v6) == "table" then v6.roblox_component else nil
		local v7 = typeof(v5) == "string" and v5 ~= ""

		if not v7 then
			continue
		end

		local v8 = typeof(sort_id) == "string" and sort_id ~= ""

		if not v8 then
			continue
		end

		local v9 = typeof(title) == "string" and title ~= ""

		if not v9 then
			continue
		end

		local v10 = typeof(roblox_component) == "string" and roblox_component ~= ""

		if not v10 then
			continue
		end

		local v12 = if typeof(kind) == "table" then kind.type else nil

		if isHomeSortDetailSortIncluded(sort_id, v12) then
			table.insert(homeSortDropDownOptions, {
				topicId = tostring(sort_id),
				displayName = title,
				entryIdentifier = v5,
				storeIndex = k
			})
		end
	end

	return homeSortDropDownOptions
end

return buildHomeSortDropDownOptions
