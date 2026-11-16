local module = require("@luauforge/bundled/hyb")
require("@luauforge/bundled/hyc")

local function normalize(value)
	return (string.gsub(string.lower(value), "%s", ""))
end

local function buildSendRobuxSections(data)
	local query = data.query
	local v5 = string.gsub(string.lower(query), "%s", "")

	local search = data.search

	local v6 = not search.isSearching

	if v6 then
		if v5 == "" then
			v6 = false
		else
			local settledQuery = search.settledQuery
			v6 = string.gsub(string.lower(settledQuery), "%s", "") == v5
		end
	end

	local userIdSet = {}

	if v6 then
		for k, result in search.results do
			userIdSet[result.userId] = true
		end
	end

	local userIdSet2 = {}
	local friends = {}

	for k, friend in data.friends do
		userIdSet2[friend.userId] = true

		if v5 ~= "" then
			local find = string.find
			local displayName = friend.displayName

			if
				find(string.gsub(string.lower(displayName), "%s", ""), v5, 1, true) == nil
				and not userIdSet[friend.userId]
			then
				continue
			end
		end

		table.insert(friends, friend)
	end

	local v7 = {}

	if v6 then
		for k, result in search.results do
			if not userIdSet2[result.userId] then
				table.insert(v7, result)
			end
		end
	end

	local sendRobuxSections = {
		friends = friends,
		people = v7,
		showFriends = data.isLoadingFriends or #friends > 0,
		showPeople = #v7 > 0,
		showNoResults = 0
	}
	local v8

	if #v5 >= module.SearchMinCharacters then
		v8 = v6 and not data.isLoadingFriends

		if v8 then
			v8 = #friends == 0 and #v7 == 0
		end
	else
		v8 = false
	end

	sendRobuxSections.showNoResults = v8
	return sendRobuxSections
end

return buildSendRobuxSections
