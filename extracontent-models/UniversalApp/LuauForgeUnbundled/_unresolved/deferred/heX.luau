local module = require("@luauforge/bundled/fCe")
local reducerUtils = require("@luauforge/bundled/dKU").Utils.ReducerUtils

local module2 = require("@luauforge/bundled/dRI")

return function(p2)
	local ownedItemIdsBySubtype = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
	local avatarEditorCategoryInfoFromState = module.getAvatarEditorCategoryInfoFromState(p2)
	local v5

	if avatarEditorCategoryInfoFromState.SearchUuid then
		v5 = avatarEditorCategoryInfoFromState.SearchUuid
	else
		v5 = avatarEditorCategoryInfoFromState.Name
	end

	local recommendedKey = module.getRecommendedKey(avatarEditorCategoryInfoFromState)

	if module2() then
		recommendedKey = reducerUtils.generateRecommendedItemsKey(
			recommendedKey,
			avatarEditorCategoryInfoFromState.RecommendationsType
		)
	end

	local v6

	if ownedItemIdsBySubtype == nil or v5 == nil or ownedItemIdsBySubtype[v5] == nil then
		v6 = false
	else
		v6 = #ownedItemIdsBySubtype[v5] > 0
	end

	local v7 = p2.AvatarExperience.AvatarEditor.RecommendedItems[recommendedKey] or {}
	return avatarEditorCategoryInfoFromState and not avatarEditorCategoryInfoFromState.RenderItemTiles
		or v6
		or #v7 > 0
end
