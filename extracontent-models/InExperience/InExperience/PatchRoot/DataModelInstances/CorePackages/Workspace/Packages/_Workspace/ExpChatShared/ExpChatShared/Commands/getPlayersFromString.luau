local parent = script:FindFirstAncestor("ExpChatShared").Parent
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local function getPlayersFromCommand(data, value: string?)
	if not value then
		return {}
	end

	assert(value, "will exist")

	local v = string.lower(value)

	if not v or string.sub(v, 1, 1) ~= "@" then
		return dictionary.map(data.byDisplayName[v] or {}, function(p)
			return dictionary.join(data.byUserId[p], {
				nameToDisplay = data.byUserId[p].displayName
			})
		end)
	end

	local v2 = string.sub(v, 2)
	local v3 = data.byUsername[v2]

	if v3 then
		return { dictionary.join(data.byUserId[v3], {
				nameToDisplay = "@" .. data.byUserId[v3].username
			}) }
	end

	return dictionary.map(data.byDisplayName[v] or {}, function(p)
		return dictionary.join(data.byUserId[p], { nameToDisplay = data.byUserId[p].displayName })
	end)
end

return getPlayersFromCommand
