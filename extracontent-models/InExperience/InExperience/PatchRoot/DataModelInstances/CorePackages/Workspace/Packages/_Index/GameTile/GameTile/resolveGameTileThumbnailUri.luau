local GameTile = script:FindFirstAncestor("GameTile")
local formatExperienceIcon = require(GameTile.formatExperienceIcon)
local formatExperienceThumbnail = require(GameTile.formatExperienceThumbnail)
local resolveWideAssetId = require(GameTile.resolveWideAssetId)

local function resolveGameTileThumbnailUri(t1: {[any]: any}) -- line: 20
	-- upvalues: resolveWideAssetId (copy), formatExperienceThumbnail (copy), formatExperienceIcon (copy)
	if t1.useGridTile then
		local v7 = resolveWideAssetId(t1.perEntryWideAssetId, t1.game, t1.topicId)

		if not v7 and not t1.placeId then
			return nil
		end

		return formatExperienceThumbnail(v7, t1.placeId, t1.isEmphasized)
	end

	if not t1.universeId then
		return t1.iconUrl
	end

	return formatExperienceIcon(t1.iconUrl, t1.universeId)
end

return resolveGameTileThumbnailUri
