local Parent = script:FindFirstAncestor("SongDetailRodux").Parent
local Url = require(Parent.Http).Url

local function generateQueryParams(p1) -- line: 9
	local t1 = {}

	for _, v in ipairs(p1) do
		table.insert(t1, "asset_ids=" .. v)
	end

	return "?" .. table.concat(t1, "&")
end

return function(p2, p3) -- line: 17
	-- upvalues: generateQueryParams (copy), Url (copy)
	assert(type(p3) == "table", "BatchGetSongDetail request expects songIds to be a table")

	if #p3 == 0 or #p3 > 20 then
		error(`BatchGetSongDetail request expects songIds count between 1-{ 20 }`)
	end

	local v10 = generateQueryParams(p3)

	return p2(string.format("%smusic-discovery/v1/batch-song-details%s", Url.APIS_URL, v10), "GET")
end
