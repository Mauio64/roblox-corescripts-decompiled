local module = require("@luauforge/bundled/fxU")
require("@luauforge/bundled/fyl")

local url = module.Url

local function normalizeQueries(responseBody)
	if responseBody == nil or responseBody.error ~= nil or type(responseBody.queries) ~= "table" then
		return {}
	end

	local queries = {}

	for k, query in responseBody.queries do
		if type(query) == "string" and query ~= "" then
			table.insert(queries, query)
		end
	end

	return queries
end

local function getTrendingSearchQueries(callback)
	local v5, v6 = callback(`{url.CATALOG_URL}v1/topic/get-topics`, "POST", {
		postBody = "{}"
	})

	return v5:andThen(function(p2)
		return normalizeQueries(p2.responseBody)
	end), v6
end

return getTrendingSearchQueries
