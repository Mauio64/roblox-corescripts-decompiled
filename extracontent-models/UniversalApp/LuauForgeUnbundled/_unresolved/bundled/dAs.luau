local url = require("@luauforge/bundled/dAg").Url

local function generateQueryParams(list)
	local v5 = {}

	for i, item in ipairs(list) do
		table.insert(v5, "asset_ids=" .. item)
	end

	return "?" .. table.concat(v5, "&")
end

return function(callback, list)
	assert(type(list) == "table", "BatchGetSongDetail request expects songIds to be a table")

	if #list == 0 or #list > 20 then
		error(`BatchGetSongDetail request expects songIds count between 1-{20}`)
	end

	local v5 = generateQueryParams(list)
	return callback(string.format("%smusic-discovery/v1/batch-song-details%s", url.APIS_URL, v5), "GET")
end
