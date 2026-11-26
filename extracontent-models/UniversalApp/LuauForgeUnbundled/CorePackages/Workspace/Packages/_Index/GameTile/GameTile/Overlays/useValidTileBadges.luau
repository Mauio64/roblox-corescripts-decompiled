local gameInfosReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GameInfosRodux").GameInfosReducer
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils").Hooks.RoactRodux.useSelector

local getGameTileLayoutData = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/getGameTileLayoutData")
local getValidTileBadges = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Overlays/getValidTileBadges")
require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")

local function useValidTileBadges(p2, p3, p4)
	local v6 = getGameTileLayoutData(useSelector(function(p5)
		return p5.Personalization[gameInfosReducer.key][p2]
	end), p3)

	return (React.useMemo(function()
		local v7 = if p4 then p4 elseif v6 and v6.tileBadgesByPosition then v6.tileBadgesByPosition else nil

		if v7 then
			return getValidTileBadges(v7)
		end

		return nil
	end, { v6, p4 }))
end

return useValidTileBadges
