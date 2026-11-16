local Home = script:FindFirstAncestor("Home")

local isHomeSortDetailSortIncluded = require(Home.HomeSortDetailPage.isHomeSortDetailSortIncluded)

local function isValidString(value): boolean -- 4 equivalent calls inferred from this helper
	return typeof(value) == "string" and value ~= ""
end

local function buildHomeSortDropDownOptions(p)
	local homeSortDropDownOptions = {}

	if typeof(p) ~= "table" then
		return homeSortDropDownOptions
	end

	local entry_order = p.entry_order
	local entry_map = p.entry_map

	if typeof(entry_order) ~= "table" or typeof(entry_map) ~= "table" then
		return homeSortDropDownOptions
	end

	for k, entryIdentifier in entry_order do
		local v = entry_map[entryIdentifier]
		local input_data

		if typeof(v) == "table" then
			input_data = v.input_data
		end

		local kind

		if typeof(input_data) == "table" then
			kind = input_data.kind
		end

		local value

		if typeof(kind) == "table" then
			value = kind.value
		end

		local sort_id

		if typeof(value) == "table" then
			sort_id = value.sort_id
		end

		local title

		if typeof(value) == "table" then
			title = value.title
		end

		local roblox_component

		if typeof(v) == "table" then
			roblox_component = v.roblox_component
		end

		if not (isValidString(entryIdentifier) and isValidString(sort_id) and isValidString(title) and isValidString(roblox_component)) then -- inferred equivalent call
			continue
		end

		local v2

		if typeof(kind) == "table" then
			v2 = kind.type
		end

		if isHomeSortDetailSortIncluded(sort_id, v2) then
			table.insert(homeSortDropDownOptions, {
				topicId = tostring(sort_id),
				displayName = title,
				entryIdentifier = entryIdentifier,
				storeIndex = k
			})
		end
	end

	return homeSortDropDownOptions
end

return buildHomeSortDropDownOptions
