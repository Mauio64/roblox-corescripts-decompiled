local function getMappedStyleTokens(p2)
	return {
		smallTileContainerSize = p2.Size.Size_1600,
		smallTileImageSize = p2.Size.Size_1000,
		largeTileContainerSize = p2.Size.Size_2200,
		largeTileImageSize = p2.Size.Size_1600,
		tileListPaddingBetweenItems = p2.Size.Size_200,
		tileListPaddingLeft = p2.Size.Size_500,
		tileListPaddingRight = p2.Size.Size_500,
		tileListPaddingTop = p2.Size.Size_50,
		tileListPaddingBottom = p2.Size.Size_50
	}
end

return getMappedStyleTokens
