local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local FFlagSduiGetItemCollectionKeys = require(Parent.SharedFlags).FFlagSduiGetItemCollectionKeys

return {
	FFlagSduiTileDisableLegacyHover = game:DefineFastFlag("SduiTileDisableLegacyHover", false),
	FFlagSduiGetItemCollectionKeys = FFlagSduiGetItemCollectionKeys,
	FFlagSduiEnableHeroUnitBottomRow = game:DefineFastFlag("SduiEnableHeroUnitBottomRow", false)
}
