local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/hIN")
local url = require("@luauforge/bundled/hIR").Url

require("@luauforge/bundled/hJp")

local function decodeUser(content)
	if typeof(content) ~= "table" then
		return nil
	end

	local contentId = content.contentId

	if contentId == nil then
		return nil
	end

	local username = if typeof(content.username) == "string" then content.username else nil
	return {
		userId = tostring(contentId),
		displayName = typeof(content.displayName) ~= "string" and (username or "") or content.displayName,
		username = username,
		hasVerifiedBadge = content.hasVerifiedBadge == true
	}
end

local function decodeUsers(p2)
	local result = {}
	local searchResults = if typeof(p2) == "table" then p2.searchResults else nil
	local contents

	if typeof(searchResults) == "table" and typeof(searchResults[1]) == "table" then
		contents = searchResults[1].contents
	end

	if typeof(contents) ~= "table" then
		return result
	end

	for k, content in contents do
		local v5 = decodeUser(content)

		if v5 then
			table.insert(result, v5)
		end
	end

	return result
end

local function searchUsers(p2, p3, p4)
	local v5 = `{url.APIS_URL}search-api/omni-search?verticalType=user&searchQuery={HttpService:UrlEncode(p2)}` .. `&sessionId={HttpService:UrlEncode(p3)}&globalSessionId={HttpService:UrlEncode(p3)}`
	return module.asPromise(module.fetch({
		network = p4,
		method = "GET",
		url = v5,
		analyticsKey = "search-api.omni-search-user",
		decode = decodeUsers,
		retry = false,
		headers = {}
	}))
end

return searchUsers
