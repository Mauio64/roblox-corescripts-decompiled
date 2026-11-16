local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local Loggers2 = require(parent.Loggers)
local flaggedMutedError = Loggers2.flaggedMutedError

require(GameTile.GameTileTypes)
local GameTileConstants = require(GameTile.GameTileConstants)
local TileBadgePositionCalculators = GameTileConstants.TileBadgePositionCalculators

local function isValidTileBadgePosition(k) -- 1 equivalent call inferred from this helper
	local v = TileBadgePositionCalculators[k] ~= nil

	if not v then
		flaggedMutedError("GameTileOverlayBadgeInvalidPositionError", `Unsupported game tile badge position: {k}`)
	end

	return v
end

local function getValidTileBadges(items)
	local validTileBadges = {}

	for k, item in items do
		if not (isValidTileBadgePosition(k) and #item > 0) then -- inferred equivalent call
			continue
		end

		local v = item[1]

		if v.tileBadgeType and v.analyticsId then
			validTileBadges[k] = { item[1] }
		else
			mutedError("Invalid tile badge metadata.")
		end
	end

	return validTileBadges
end

return getValidTileBadges
