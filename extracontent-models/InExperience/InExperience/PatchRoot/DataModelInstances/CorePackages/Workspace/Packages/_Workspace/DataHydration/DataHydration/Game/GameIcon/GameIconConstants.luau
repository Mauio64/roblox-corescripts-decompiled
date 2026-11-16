return {
	FIntGameIconSmallSizePx = game:DefineFastInt("LuaAppGameIconSmallSizePx", 150),
	FIntGameIconLargeSizePx = game:DefineFastInt("LuaAppGameIconLargeSizePx", 512),
	sizeString = function(p: number)
		return string.format("%dx%d", p, p)
	end
}
