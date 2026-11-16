local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama
local RoduxAliases = require(AppChat.Http.RoduxAliases)

local function convertToNewAliasUpdatedActions(list)
	local result = {}

	for _, item in ipairs(list) do
		local targetUserId = tostring(item.targetUserId)
		local targetUserTag = item.targetUserTag
		table.insert(result, RoduxAliases.Actions.AliasUpdated(targetUserId, targetUserTag))
	end

	return result
end

local v = {
	GetAliases_Success = function(p)
		return convertToNewAliasUpdatedActions(p.responseBody)
	end,
	ReceivedAliases = function(p)
		return convertToNewAliasUpdatedActions(p.aliases)
	end
}

local v2 = RoduxAliases.installReducer()

return function(p, p2)
	local v3 = v[p2.type]
	local v4 = not v3 and { p2 } or v3(p2)
	return llama.List.reduce(v4, v2, p or {
		byUserId = { ShowUserAlias = true }
	})
end
