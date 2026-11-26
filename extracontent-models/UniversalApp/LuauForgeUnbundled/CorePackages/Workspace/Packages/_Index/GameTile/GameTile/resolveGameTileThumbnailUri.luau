local formatExperienceIcon = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/formatExperienceIcon")
local formatExperienceThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/formatExperienceThumbnail")
local resolveWideAssetId = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/resolveWideAssetId")

local function resolveGameTileThumbnailUri(data)
	if data.useGridTile then
		local v5 = resolveWideAssetId(data.perEntryWideAssetId, data.game, data.topicId)

		if v5 or data.placeId then
			return formatExperienceThumbnail(v5, data.placeId, data.isEmphasized)
		end

		return nil
	elseif data.universeId then
		return formatExperienceIcon(data.iconUrl, data.universeId)
	else
		return data.iconUrl
	end
end

return resolveGameTileThumbnailUri
