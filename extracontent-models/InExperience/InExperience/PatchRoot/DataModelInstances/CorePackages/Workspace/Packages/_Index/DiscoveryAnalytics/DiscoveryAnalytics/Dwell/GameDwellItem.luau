return {
	identity = function(data)
		local v

		if data.rank > 0 then
			v = `rank:{data.rank}`
		else
			v = `cell:{data.cell}`
		end

		return `{v}/{data.universeId}/{data.adFlag}/{data.adId}`
	end
}
