local parent = script:FindFirstAncestor("GameTile").Parent
require(parent.Foundation)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppMigrateGameTileFixConsoleMetadataText = SharedFlags.FFlagLuaAppMigrateGameTileFixConsoleMetadataText

local function getGameTileMetadataFont(flag: boolean?, p, p2, flag2: boolean?, flag3: boolean?)
	if flag2 and p2 then
		if flag3 or FFlagLuaAppMigrateGameTileFixConsoleMetadataText and flag == false then
			return p2.Typography.BodySmall
		end

		return p2.Typography.BodyMedium
	elseif flag then
		return p.Typography.BodyLarge
	else
		return p.Typography.CaptionMedium
	end
end

return getGameTileMetadataFont
