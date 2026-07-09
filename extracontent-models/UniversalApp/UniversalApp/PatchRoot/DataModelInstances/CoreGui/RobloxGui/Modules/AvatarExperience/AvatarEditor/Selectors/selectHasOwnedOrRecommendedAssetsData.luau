local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.Common.Utils)
local ReducerUtils = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Utils.ReducerUtils
local GetFFlagAXEnableRecommendationTypeAllInCustomize = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableRecommendationTypeAllInCustomize)

return function(p1) -- line: 9
	-- upvalues: Utils (copy), GetFFlagAXEnableRecommendationTypeAllInCustomize (copy), ReducerUtils (copy)
	local OwnedItemIdsBySubtype = p1.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
	local v8 = Utils.getAvatarEditorCategoryInfoFromState(p1)
	local v9 = if not v8.SearchUuid then v8.Name else v8.SearchUuid
	local v10 = Utils.getRecommendedKey(v8)

	if GetFFlagAXEnableRecommendationTypeAllInCustomize() then
		v10 = ReducerUtils.generateRecommendedItemsKey(v10, v8.RecommendationsType)
	end

	local v11 = OwnedItemIdsBySubtype ~= nil and (v9 == nil or OwnedItemIdsBySubtype[v9] == nil or #OwnedItemIdsBySubtype[v9] > 0)
	local v12 = p1.AvatarExperience.AvatarEditor.RecommendedItems[v10] or {}

	return v8 and not v8.RenderItemTiles or (v11 or #v12 > 0)
end
