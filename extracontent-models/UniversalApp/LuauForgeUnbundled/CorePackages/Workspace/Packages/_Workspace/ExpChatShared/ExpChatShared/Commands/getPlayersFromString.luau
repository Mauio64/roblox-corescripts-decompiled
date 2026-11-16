local dictionary = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").Dictionary

local function getPlayersFromCommand(data, value)
	if not value then
		return {}
	end

	assert(value, "will exist")

	local v5 = string.lower(value)

	if not v5 or string.sub(v5, 1, 1) ~= "@" then
		return dictionary.map(data.byDisplayName[v5] or {}, function(p2)
			return dictionary.join(data.byUserId[p2], {
				nameToDisplay = data.byUserId[p2].displayName
			})
		end)
	end

	local v6 = string.sub(v5, 2)
	local v7 = data.byUsername[v6]

	if v7 then
		return { dictionary.join(data.byUserId[v7], {
				nameToDisplay = "@" .. data.byUserId[v7].username
			}) }
	end

	return dictionary.map(data.byDisplayName[v5] or {}, function(p2)
		return dictionary.join(data.byUserId[p2], {
			nameToDisplay = data.byUserId[p2].displayName
		})
	end)
end

return getPlayersFromCommand
