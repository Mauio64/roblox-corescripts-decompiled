local v1 = game:DefineFastInt("LuaAppGameIconSmallSizePx", 150)
local v2 = game:DefineFastInt("LuaAppGameIconLargeSizePx", 512)

return {
	FIntGameIconSmallSizePx = v1,
	FIntGameIconLargeSizePx = v2,
	sizeString = function(n1: number) -- line: 4
		return string.format("%dx%d", n1, n1)
	end
}
