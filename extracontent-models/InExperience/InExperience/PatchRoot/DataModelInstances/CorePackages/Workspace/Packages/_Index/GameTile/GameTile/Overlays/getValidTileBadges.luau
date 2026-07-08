local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local mutedError = require(GameTileParent.Loggers).mutedError
local flaggedMutedError = require(GameTileParent.Loggers).flaggedMutedError

require(GameTile.GameTileTypes)

local TileBadgePositionCalculators = require(GameTile.GameTileConstants).TileBadgePositionCalculators

local function isValidTileBadgePosition(p1) -- line: 13
	-- upvalues: TileBadgePositionCalculators (copy), flaggedMutedError (copy)
	local v9 = TileBadgePositionCalculators[p1] ~= nil

	if not v9 then
		flaggedMutedError("GameTileOverlayBadgeInvalidPositionError", `Unsupported game tile badge position: { p1 }`)
	end

	return v9
end
local function getValidTileBadges(p2) -- line: 26
	-- upvalues: TileBadgePositionCalculators (copy), flaggedMutedError (copy), mutedError (copy)
	local t1 = {}

	for v12, v13 in p2 do
		local v14 = TileBadgePositionCalculators[v12] ~= nil

		if not v14 then
			flaggedMutedError("GameTileOverlayBadgeInvalidPositionError", `Unsupported game tile badge position: { v12 }`)
		end

		if v14 and #v13 > 0 then
			local v15 = v13[1]

			if v15.tileBadgeType and v15.analyticsId then
				t1[v12] = { v13[1] }
			else
				mutedError("Invalid tile badge metadata.")
			end
		end
	end

	return t1
end

return getValidTileBadges
