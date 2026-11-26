local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Loggers").mutedError
local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Loggers").flaggedMutedError

require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")
local tileBadgePositionCalculators = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileConstants").TileBadgePositionCalculators

local function isValidTileBadgePosition(p2)
	local v5 = tileBadgePositionCalculators[p2] ~= nil

	if not v5 then
		flaggedMutedError(
			"GameTileOverlayBadgeInvalidPositionError",
			`Unsupported game tile badge position: {p2}`
		)
	end

	return v5
end

local function getValidTileBadges(items)
	local validTileBadges = {}

	for k, item in items do
		local v5 = tileBadgePositionCalculators[k] ~= nil

		if not v5 then
			flaggedMutedError(
				"GameTileOverlayBadgeInvalidPositionError",
				`Unsupported game tile badge position: {k}`
			)
		end

		if not (v5 and #item > 0) then
			continue
		end

		local v6 = item[1]

		if v6.tileBadgeType and v6.analyticsId then
			validTileBadges[k] = { item[1] }
		else
			mutedError("Invalid tile badge metadata.")
		end
	end

	return validTileBadges
end

return getValidTileBadges
