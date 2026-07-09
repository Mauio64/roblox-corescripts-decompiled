local Parent = script:FindFirstAncestor("ExpChatShared").Parent
local Dictionary = require(Parent.llama).Dictionary
local List = require(Parent.llama).List

local function getAutocompletePlayersFromString(p1, s1: string) -- line: 12
	-- upvalues: Dictionary (copy), List (copy)
	local t1 = {}
	local v8 = string.lower(s1)

	if string.sub(v8, 1, 1) == "@" then
		local v9 = string.sub(v8, 2)

		t1 = Dictionary.values(Dictionary.filter(p1.byUsername, function(_, p3) -- line: 17
			-- upvalues: v9 (copy)
			return string.find(p3, "^" .. v9) ~= nil
		end))
	else
		local v10 = v8
		local v11 = Dictionary.filter(p1.byDisplayName, function(_, p5) -- line: 22
			-- upvalues: v10 (copy)
			return string.find(p5, "^" .. v10) ~= nil
		end)

		for _, v in pairs(v11) do
			for _, v2 in ipairs(v) do
				table.insert(t1, v2)
			end
		end
	end

	return List.map(t1, function(p6) -- line: 33
		-- upvalues: p1 (copy)
		return p1.byUserId[tostring(p6)]
	end)
end

return getAutocompletePlayersFromString
