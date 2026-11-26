return {
	identity = function(data)
		local v5 = if data.rank > 0 then `rank:{data.rank}` else `cell:{data.cell}`
		return `{v5}/{data.universeId}/{data.adFlag}/{data.adId}`
	end
}
