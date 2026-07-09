local selectActiveBackground = require(script.Parent.selectActiveBackground)
local NO_BACKGROUND_ASSET_ID = require(script.Parent.constants).NO_BACKGROUND_ASSET_ID

local function buildOutfitProfileConfiguration(p1) -- line: 15
	-- upvalues: selectActiveBackground (copy), NO_BACKGROUND_ASSET_ID (copy)
	local v5 = selectActiveBackground(p1)

	return {
		BackgroundAssetId = if v5 == nil then NO_BACKGROUND_ASSET_ID else v5
	}
end

return buildOutfitProfileConfiguration
