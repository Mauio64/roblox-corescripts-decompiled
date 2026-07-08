local Parent = script:FindFirstAncestor("GameTile").Parent

require(Parent.Foundation)

local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local FFlagLuaAppMigrateGameTileFixConsoleMetadataText = require(Parent.SharedFlags).FFlagLuaAppMigrateGameTileFixConsoleMetadataText
local FFlagLuaAppNarrowTileSmallerFooterFont = require(Parent.SharedFlags).FFlagLuaAppNarrowTileSmallerFooterFont

local function getGameTileMetadataFont(b1: boolean?, p1, p2, b2: boolean?, b3: boolean?) -- line: 13
	-- upvalues: FFlagLuaAppNarrowTileSmallerFooterFont (copy), FFlagLuaAppMigrateGameTileFixConsoleMetadataText (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	if b2 and p2 then
		if FFlagLuaAppNarrowTileSmallerFooterFont and b3 or FFlagLuaAppMigrateGameTileFixConsoleMetadataText and b1 == false then
			return p2.Typography.BodySmall
		end

		return p2.Typography.BodyMedium
	end

	if b1 then
		if FFlagRenameDeprecatedUIBloxTokens then
			return p1.Typography.BodyLarge
		end

		return p1.Semantic.Typography.Body
	end

	if FFlagRenameDeprecatedUIBloxTokens then
		return p1.Typography.CaptionMedium
	end

	return p1.Semantic.Typography.CaptionHeader
end

return getGameTileMetadataFont
