local Parent = script:FindFirstAncestor("GameTile").Parent

require(Parent.Foundation)

local FFlagLuaAppMigrateGameTileFixConsoleMetadataText = require(Parent.SharedFlags).FFlagLuaAppMigrateGameTileFixConsoleMetadataText
local FFlagLuaAppNarrowTileSmallerFooterFont = require(Parent.SharedFlags).FFlagLuaAppNarrowTileSmallerFooterFont

local function getGameTileMetadataFont(b1: boolean?, p1, p2, b2: boolean?, b3: boolean?) -- line: 11
	-- upvalues: FFlagLuaAppNarrowTileSmallerFooterFont (copy), FFlagLuaAppMigrateGameTileFixConsoleMetadataText (copy)
	if b2 and p2 then
		if FFlagLuaAppNarrowTileSmallerFooterFont and b3 or FFlagLuaAppMigrateGameTileFixConsoleMetadataText and b1 == false then
			return p2.Typography.BodySmall
		end

		return p2.Typography.BodyMedium
	end

	if b1 then
		return p1.Typography.BodyLarge
	end

	return p1.Typography.CaptionMedium
end

return getGameTileMetadataFont
