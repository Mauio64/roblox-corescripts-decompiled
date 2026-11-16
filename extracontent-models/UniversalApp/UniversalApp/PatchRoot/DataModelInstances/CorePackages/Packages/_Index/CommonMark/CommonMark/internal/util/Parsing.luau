return {
	CODE_BLOCK_INDENT = 4,
	columnsToNextTabStop = function(p: number)
		return 4 - p % 4
	end
}
