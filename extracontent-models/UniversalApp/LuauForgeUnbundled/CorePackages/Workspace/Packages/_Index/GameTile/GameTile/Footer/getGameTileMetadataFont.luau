require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")

local fFlagLuaAppMigrateGameTileFixConsoleMetadataText = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppMigrateGameTileFixConsoleMetadataText

local function getGameTileMetadataFont(p2, p3, p4, p5, p6)
	if p5 and p4 then
		if p6 or fFlagLuaAppMigrateGameTileFixConsoleMetadataText and p2 == false then
			return p4.Typography.BodySmall
		end

		return p4.Typography.BodyMedium
	elseif p2 then
		return p3.Typography.BodyLarge
	else
		return p3.Typography.CaptionMedium
	end
end

return getGameTileMetadataFont
