local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuaSocialLibrariesDeps").llama
local RoduxAliases = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxAliases")

local function convertToNewAliasUpdatedActions(list)
	local result = {}

	for i, item in ipairs(list) do
		local targetUserId = tostring(item.targetUserId)
		local targetUserTag = item.targetUserTag
		table.insert(result, RoduxAliases.Actions.AliasUpdated(targetUserId, targetUserTag))
	end

	return result
end

local v5 = {
	GetAliases_Success = function(p2)
		return convertToNewAliasUpdatedActions(p2.responseBody)
	end,
	ReceivedAliases = function(p2)
		return convertToNewAliasUpdatedActions(p2.aliases)
	end
}

local v6 = RoduxAliases.installReducer()

return function(p2, p3)
	local v7 = v5[p3.type]
	local v8 = not v7 and { p3 } or v7(p3)
	return llama.List.reduce(v8, v6, p2 or {
		byUserId = { ShowUserAlias = true }
	})
end
