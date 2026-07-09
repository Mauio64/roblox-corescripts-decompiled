local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local llama = require(AppChatParent.LuaSocialLibrariesDeps).llama
local RoduxAliases = require(AppChat.Http.RoduxAliases)

local function convertToNewAliasUpdatedActions(p1) -- line: 8
	-- upvalues: RoduxAliases (copy)
	local t1 = {}

	for _, v in ipairs(p1) do
		local str = tostring(v.targetUserId)
		local targetUserTag = v.targetUserTag

		table.insert(t1, RoduxAliases.Actions.AliasUpdated(str, targetUserTag))
	end

	return t1
end

local t2 = {
	GetAliases_Success = function(p2) -- line: 20
		-- upvalues: convertToNewAliasUpdatedActions (copy)
		return (convertToNewAliasUpdatedActions(p2.responseBody))
	end,
	ReceivedAliases = function(p3) -- line: 24
		-- upvalues: convertToNewAliasUpdatedActions (copy)
		return (convertToNewAliasUpdatedActions(p3.aliases))
	end
}
local v7 = RoduxAliases.installReducer()

return function(p4, p5) -- line: 31
	-- upvalues: t2 (copy), llama (copy), v7 (copy)
	local v18 = p4 or {
		byUserId = {
			ShowUserAlias = true
		}
	}
	local t3 = { p5 }
	local v20 = t2[p5.type]

	if v20 then
		t3 = v20(p5)
	end

	return llama.List.reduce(t3, v7, v18)
end
