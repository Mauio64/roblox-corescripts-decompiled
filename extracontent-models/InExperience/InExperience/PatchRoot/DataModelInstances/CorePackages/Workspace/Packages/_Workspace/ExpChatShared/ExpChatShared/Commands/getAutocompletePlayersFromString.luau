local parent = script:FindFirstAncestor("ExpChatShared").Parent
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local llama2 = require(parent.llama)
local list = llama2.List

local function getAutocompletePlayersFromString(data, value: string)
	local v = {}
	local v2 = string.lower(value)

	if string.sub(v2, 1, 1) == "@" then
		local v3 = string.sub(v2, 2)
		v = dictionary.values(dictionary.filter(data.byUsername, function(_, value2): boolean
			return string.find(value2, "^" .. v3) ~= nil
		end))
	else
		local filtered = dictionary.filter(data.byDisplayName, function(_, value2): boolean
			return string.find(value2, "^" .. v2) ~= nil
		end)

		for _, list2 in pairs(filtered) do
			for _, item in ipairs(list2) do
				table.insert(v, item)
			end
		end
	end

	return list.map(v, function(p)
		return data.byUserId[tostring(p)]
	end)
end

return getAutocompletePlayersFromString
