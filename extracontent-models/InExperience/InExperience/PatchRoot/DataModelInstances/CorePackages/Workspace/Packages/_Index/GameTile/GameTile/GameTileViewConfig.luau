local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent

require(GameTileParent.Style)
require(GameTileParent.Foundation)

local memoize = require(GameTileParent.AppCommonLib).memoize

require(GameTile.GameTileTypes)

local FFlagLuaAppMigrateGameTileFooterValueFixes = require(GameTileParent.SharedFlags).FFlagLuaAppMigrateGameTileFooterValueFixes
local FFlagLuaAppUnifyPlayButtonTile = require(GameTileParent.SharedFlags).FFlagLuaAppUnifyPlayButtonTile
local FFlagLuaAppUnifyPlayButtonTileIxp = require(GameTileParent.SharedFlags).FFlagLuaAppUnifyPlayButtonTileIxp
local GameTileExperimentation = require(GameTile.GameTileExperimentation)
local v8 = memoize(function(p1, n1: number?, n2: number?, p2, b1: boolean?, n3: number?) -- line: 75
	-- upvalues: FFlagLuaAppUnifyPlayButtonTileIxp (copy), GameTileExperimentation (copy), FFlagLuaAppUnifyPlayButtonTile (copy)
	local v20 = if not FFlagLuaAppUnifyPlayButtonTileIxp then nil else GameTileExperimentation.getIsPlayButtonMigrationEnabled()

	if p2 and b1 then
		return {
			paddingAboveMetadata = 0,
			footerTopPadding = p2.Gap.Medium,
			titleHeight = (n2 or 1) * (p2.Size.Size_500 + (n1 or 0)),
			metadataHeight = (n3 or 1) * (p2.Size.Size_500 + (n1 or 0)),
			footerBottomPadding = p2.Gap.Medium,
			playButtonHeight = if not FFlagLuaAppUnifyPlayButtonTile or not not FFlagLuaAppUnifyPlayButtonTileIxp and not v20 then p2.Size.Size_900 else p2.Size.Size_1000
		}
	end

	return {
		paddingAboveMetadata = 0,
		footerTopPadding = p1.Size.Size_300,
		titleHeight = (n2 or 1) * (p1.Size.Size_500 + (n1 or 0)),
		metadataHeight = (n3 or 1) * (p1.Size.Size_500 + (n1 or 0)),
		footerBottomPadding = p1.Size.Size_300,
		playButtonHeight = if not FFlagLuaAppUnifyPlayButtonTile or not not FFlagLuaAppUnifyPlayButtonTileIxp and not v20 then p1.Size.Size_900 else p1.Size.Size_1000
	}
end)

return {
	getTileHeight = function(p3, n4: number, p4, b2: boolean?, b3: boolean?, b4: boolean?, n5: number?, n6: number?, n7: number?, n8: number?, p5, b5: boolean?) -- line: 151
		-- upvalues: v8 (copy)
		local v45 = n4 * (p4 ~= "Wide" and p4 ~= "Event" and 1 or 0.5625)
		local v46 = v8(p3, n5, n7, p5, b5, n8)
		local footerTopPadding = v46.footerTopPadding

		if not b4 then
			footerTopPadding += v46.titleHeight
		end

		if not b3 then
			footerTopPadding += v46.paddingAboveMetadata + v46.metadataHeight
		end

		if b2 then
			footerTopPadding += v46.footerBottomPadding
		end

		if n6 then
			footerTopPadding += n6
		end

		return v45 + footerTopPadding
	end,
	getFooterHeight = function(p6, b6: boolean?, b7: boolean?, b8: boolean?, n9: number?, n10: number?, n11: number?, p7, b9: boolean?, n12: number?) -- line: 114
		-- upvalues: v8 (copy)
		local v31 = v8(p6, n9, n11, p7, b9, n12)
		local footerTopPadding = v31.footerTopPadding

		if not b8 then
			footerTopPadding += v31.titleHeight
		end

		if not b7 then
			footerTopPadding += v31.paddingAboveMetadata + v31.metadataHeight
		end

		if b6 then
			footerTopPadding += v31.footerBottomPadding
		end

		if n10 then
			footerTopPadding += n10
		end

		return footerTopPadding
	end,
	getImageAspectRatio = function(p8) -- line: 25
		if p8 == "Wide" or p8 == "Event" then
			return 1.7777777777777777
		end

		return 1
	end,
	getInverseImageAspectRatio = function(p9) -- line: 33
		if p9 == "Wide" or p9 == "Event" then
			return 0.5625
		end

		return 1
	end,
	getElementSizes = v8,
	getContainmentSidePadding = function(p10, p11, p12) -- line: 41
		-- upvalues: FFlagLuaAppMigrateGameTileFooterValueFixes (copy)
		if p12 then
			if p11 == "Wide" or p11 == "Event" then
				if FFlagLuaAppMigrateGameTileFooterValueFixes then
					return p12.Padding.Medium
				end

				return p12.Padding.Large
			end

			if FFlagLuaAppMigrateGameTileFooterValueFixes then
				return p12.Size.Size_150
			end

			return p12.Padding.Small
		end

		if p11 == "Wide" or p11 == "Event" then
			return p10.Size.Size_300
		end

		return p10.Size.Size_150
	end
}
