local dictionary = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").Dictionary
local list = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").List

local function getAutocompletePlayersFromString(data, value)
	local v5 = {}
	local v6 = string.lower(value)

	if string.sub(v6, 1, 1) == "@" then
		local v7 = string.sub(v6, 2)
		v5 = dictionary.values(dictionary.filter(data.byUsername, function(p2, value2): boolean
			return string.find(value2, "^" .. v7) ~= nil
		end))
	else
		local filtered = dictionary.filter(data.byDisplayName, function(p2, value2): boolean
			return string.find(value2, "^" .. v6) ~= nil
		end)

		for k, list2 in pairs(filtered) do
			for i, item in ipairs(list2) do
				table.insert(v5, item)
			end
		end
	end

	return list.map(v5, function(p2)
		return data.byUserId[tostring(p2)]
	end)
end

return getAutocompletePlayersFromString
