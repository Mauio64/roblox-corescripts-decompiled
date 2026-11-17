local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

require(parent.Style)

require(parent.Foundation)

local AppCommonLib = require(parent.AppCommonLib)
local memoize = AppCommonLib.memoize
require(GameTile.GameTileTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppUnifyPlayButtonTile = SharedFlags.FFlagLuaAppUnifyPlayButtonTile
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppUnifyPlayButtonTileIxp = SharedFlags2.FFlagLuaAppUnifyPlayButtonTileIxp

local GameTileExperimentation = require(GameTile.GameTileExperimentation)

local getElementSizes = memoize(function(p, value: number?, value2: number?, p2, flag: boolean?, value3: number?)
	local v

	if FFlagLuaAppUnifyPlayButtonTileIxp then
		v = GameTileExperimentation.getIsPlayButtonMigrationEnabled()
	end

	if p2 and flag then
		local v2 = {
			footerTopPadding = p2.Gap.Medium,
			titleHeight = (value2 or 1) * (p2.Size.Size_500 + (value or 0)),
			paddingAboveMetadata = 0,
			metadataHeight = (value3 or 1) * (p2.Size.Size_500 + (value or 0)),
			footerBottomPadding = p2.Gap.Medium,
			playButtonHeight = 0
		}
		local playButtonHeight

		if FFlagLuaAppUnifyPlayButtonTile and (not FFlagLuaAppUnifyPlayButtonTileIxp or v) then
			playButtonHeight = p2.Size.Size_1000
		else
			playButtonHeight = p2.Size.Size_900
		end

		v2.playButtonHeight = playButtonHeight
		return v2
	else
		local v2 = {
			footerTopPadding = p.Size.Size_300,
			titleHeight = (value2 or 1) * (p.Size.Size_500 + (value or 0)),
			paddingAboveMetadata = 0,
			metadataHeight = (value3 or 1) * (p.Size.Size_500 + (value or 0)),
			footerBottomPadding = p.Size.Size_300,
			playButtonHeight = 0
		}
		local playButtonHeight

		if FFlagLuaAppUnifyPlayButtonTile and (not FFlagLuaAppUnifyPlayButtonTileIxp or v) then
			playButtonHeight = p.Size.Size_1000
		else
			playButtonHeight = p.Size.Size_900
		end

		v2.playButtonHeight = playButtonHeight
		return v2
	end
end)

local function getFooterHeight(p, flag: boolean?, flag2: boolean?, flag3: boolean?, p2: number?, p3: number?, p4: number?, p5, flag4: boolean?, p6: number?) -- 1 equivalent call inferred from this helper
	local v = getElementSizes(p, p2, p4, p5, flag4, p6)

	local footerTopPadding = v.footerTopPadding

	if not flag3 then
		footerTopPadding += v.titleHeight
	end

	if not flag2 then
		footerTopPadding += v.paddingAboveMetadata + v.metadataHeight
	end

	if flag then
		footerTopPadding += v.footerBottomPadding
	end

	if p3 then
		footerTopPadding += p3
	end

	return footerTopPadding
end

local GameTileViewConfig = {}

function GameTileViewConfig.getTileHeight(p, p2: number, p3, flag: boolean?, flag2: boolean?, flag3: boolean?, p4: number?, p5: number?, p6: number?, p7: number?, p8, flag4: boolean?)
	return p2 * ((p3 == "Wide" or p3 == "Event") and 0.5625 or 1) + getFooterHeight( -- inferred equivalent call
		p,
		flag,
		flag2,
		flag3,
		p4,
		p5,
		p6,
		p8,
		flag4,
		p7
	)
end

GameTileViewConfig.getFooterHeight = getFooterHeight

function GameTileViewConfig.getImageAspectRatio(p): number
	if p == "Wide" or p == "Event" then
		return 16 / 9
	end

	return 1
end

function GameTileViewConfig.getInverseImageAspectRatio(p): number
	return if p == "Wide" or p == "Event" then 0.5625 else 1
end

GameTileViewConfig.getElementSizes = getElementSizes

function GameTileViewConfig.getContainmentSidePadding(p, p2, p3)
	if p3 then
		if p2 == "Wide" or p2 == "Event" then
			return p3.Padding.Medium
		end

		return p3.Size.Size_150
	elseif p2 == "Wide" or p2 == "Event" then
		return p.Size.Size_300
	else
		return p.Size.Size_150
	end
end

return GameTileViewConfig
