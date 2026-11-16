require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style")

require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")

local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/AppCommonLib").memoize
require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")

local fFlagLuaAppMigrateGameTileFooterValueFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppMigrateGameTileFooterValueFixes
local fFlagLuaAppUnifyPlayButtonTile = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppUnifyPlayButtonTile
local fFlagLuaAppUnifyPlayButtonTileIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppUnifyPlayButtonTileIxp

local GameTileExperimentation = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileExperimentation")

local v5 = memoize(function(p2, value, value2, p3, p4, value3)
	local v6

	if fFlagLuaAppUnifyPlayButtonTileIxp then
		v6 = GameTileExperimentation.getIsPlayButtonMigrationEnabled()
	end

	if p3 and p4 then
		local v7 = {
			footerTopPadding = p3.Gap.Medium,
			titleHeight = (value2 or 1) * (p3.Size.Size_500 + (value or 0)),
			paddingAboveMetadata = 0,
			metadataHeight = (value3 or 1) * (p3.Size.Size_500 + (value or 0)),
			footerBottomPadding = p3.Gap.Medium,
			playButtonHeight = 0
		}

		local v8 = if fFlagLuaAppUnifyPlayButtonTile and (not fFlagLuaAppUnifyPlayButtonTileIxp or v6) then p3.Size.Size_1000 else p3.Size.Size_900
		v7.playButtonHeight = v8
		return v7
	else
		local v7 = {
			footerTopPadding = p2.Size.Size_300,
			titleHeight = (value2 or 1) * (p2.Size.Size_500 + (value or 0)),
			paddingAboveMetadata = 0,
			metadataHeight = (value3 or 1) * (p2.Size.Size_500 + (value or 0)),
			footerBottomPadding = p2.Size.Size_300,
			playButtonHeight = 0
		}

		local v8 = if fFlagLuaAppUnifyPlayButtonTile and (not fFlagLuaAppUnifyPlayButtonTileIxp or v6) then p2.Size.Size_1000 else p2.Size.Size_900
		v7.playButtonHeight = v8
		return v7
	end
end)
return {
	getTileHeight = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
		local v6 = p3 * ((p4 == "Wide" or p4 == "Event") and 0.5625 or 1)
		local v7 = v5(p2, p8, p10, p12, p13, p11)

		local footerTopPadding = v7.footerTopPadding

		if not p7 then
			footerTopPadding += v7.titleHeight
		end

		if not p6 then
			footerTopPadding += v7.paddingAboveMetadata + v7.metadataHeight
		end

		if p5 then
			footerTopPadding += v7.footerBottomPadding
		end

		if p9 then
			footerTopPadding += p9
		end

		return v6 + footerTopPadding
	end,
	getFooterHeight = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11)
		local v6 = v5(p2, p6, p8, p9, p10, p11)

		local footerTopPadding = v6.footerTopPadding

		if not p5 then
			footerTopPadding += v6.titleHeight
		end

		if not p4 then
			footerTopPadding += v6.paddingAboveMetadata + v6.metadataHeight
		end

		if p3 then
			footerTopPadding += v6.footerBottomPadding
		end

		if p7 then
			footerTopPadding += p7
		end

		return footerTopPadding
	end,
	getImageAspectRatio = function(p2): number
		if p2 == "Wide" or p2 == "Event" then
			return 16 / 9
		end

		return 1
	end,
	getInverseImageAspectRatio = function(p2): number
		if p2 == "Wide" or p2 == "Event" then
			return 0.5625
		end

		return 1
	end,
	getElementSizes = v5,
	getContainmentSidePadding = function(p2, p3, p4)
		if p4 then
			if p3 == "Wide" or p3 == "Event" then
				if fFlagLuaAppMigrateGameTileFooterValueFixes then
					return p4.Padding.Medium
				end

				return p4.Padding.Large
			elseif fFlagLuaAppMigrateGameTileFooterValueFixes then
				return p4.Size.Size_150
			else
				return p4.Padding.Small
			end
		elseif p3 == "Wide" or p3 == "Event" then
			return p2.Size.Size_300
		else
			return p2.Size.Size_150
		end
	end
}
