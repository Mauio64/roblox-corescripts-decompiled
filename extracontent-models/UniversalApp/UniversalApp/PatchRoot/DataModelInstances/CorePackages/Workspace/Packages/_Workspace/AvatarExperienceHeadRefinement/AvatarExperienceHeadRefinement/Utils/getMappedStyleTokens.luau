local Parent = script:FindFirstAncestor("AvatarExperienceHeadRefinement").Parent
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens

local function getMappedStyleTokens(p1) -- line: 5
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		smallTileContainerSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_800 else p1.Size.Size_1600,
		smallTileImageSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_500 else p1.Size.Size_1000,
		largeTileContainerSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_1100 else p1.Size.Size_2200,
		largeTileImageSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_800 else p1.Size.Size_1600,
		tileListPaddingBetweenItems = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_100 else p1.Size.Size_200,
		tileListPaddingLeft = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_250 else p1.Size.Size_500,
		tileListPaddingRight = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_250 else p1.Size.Size_500,
		tileListPaddingTop = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_25 else p1.Size.Size_50,
		tileListPaddingBottom = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_25 else p1.Size.Size_50
	}
end

return getMappedStyleTokens
