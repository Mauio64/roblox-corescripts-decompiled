local Parent = script:FindFirstAncestor("ExpChatShared").Parent
local Dictionary = require(Parent.llama).Dictionary

local function getPlayersFromCommand(p1, s1: string?) -- line: 12
	-- upvalues: Dictionary (copy)
	if not s1 then
		return {}
	end

	assert(s1, "will exist")

	local v6 = string.lower(s1)

	if v6 and string.sub(v6, 1, 1) == "@" then
		local v7 = string.sub(v6, 2)
		local v8 = p1.byUsername[v7]

		if v8 then
			return { Dictionary.join(p1.byUserId[v8], {
				nameToDisplay = "@" .. p1.byUserId[v8].username
			}) }
		end
	end

	return Dictionary.map(p1.byDisplayName[v6] or {}, function(p2) -- line: 28
		-- upvalues: Dictionary (copy), p1 (copy)
		return Dictionary.join(p1.byUserId[p2], {
			nameToDisplay = p1.byUserId[p2].displayName
		})
	end)
end

return getPlayersFromCommand
