local parent = script:FindFirstAncestor("GameTile").Parent
require(parent.UIBlox)

local function getMetadataHeight(p) -- 1 equivalent call inferred from this helper
	return p.Size.Size_500
end

local function getFooterHeight(p) -- 1 equivalent call inferred from this helper
	local size_500 = p.Size.Size_500
	local size_200 = p.Size.Size_200
	local size_100 = p.Size.Size_100
	return size_500 + getMetadataHeight(p) + size_200 + size_100 -- inferred equivalent call
end

local WideGameTileViewConfig = {}

function WideGameTileViewConfig.getTileHeight(p, p2: number)
	return p2 * 0.5625 + getFooterHeight(p) -- inferred equivalent call
end

WideGameTileViewConfig.getFooterHeight = getFooterHeight
WideGameTileViewConfig.getMetadataHeight = getMetadataHeight

function WideGameTileViewConfig.getPlayButtonHeight(p)
	return p.Size.Size_900
end

return WideGameTileViewConfig
