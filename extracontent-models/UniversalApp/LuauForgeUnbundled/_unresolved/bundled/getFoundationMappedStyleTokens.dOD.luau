local function getFoundationMappedStyleTokens(p2)
	return {
		smallTileContainerSize = p2.Size.Size_1600,
		smallTileImageSize = p2.Size.Size_1000,
		largeTileContainerSize = p2.Size.Size_2200,
		largeTileImageSize = p2.Size.Size_1600,
		tileListPaddingBetweenItems = p2.Padding.Small,
		tileListPaddingLeft = p2.Padding.XLarge,
		tileListPaddingRight = p2.Padding.XLarge,
		tileListPaddingTop = p2.Padding.XXSmall,
		tileListPaddingBottom = p2.Padding.XXSmall,
		containerPaddingTop = p2.Padding.XXLarge,
		containerPaddingBottom = p2.Padding.XXLarge
	}
end

return getFoundationMappedStyleTokens
