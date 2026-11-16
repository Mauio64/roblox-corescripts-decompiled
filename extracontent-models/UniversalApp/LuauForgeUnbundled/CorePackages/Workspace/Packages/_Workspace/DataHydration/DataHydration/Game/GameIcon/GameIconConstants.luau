return {
	FIntGameIconSmallSizePx = game:DefineFastInt("LuaAppGameIconSmallSizePx", 150),
	FIntGameIconLargeSizePx = game:DefineFastInt("LuaAppGameIconLargeSizePx", 512),
	sizeString = function(p2)
		return string.format("%dx%d", p2, p2)
	end
}
