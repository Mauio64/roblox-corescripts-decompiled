return {
	extractFieldsFromGameEntry = function(p)
		if p then
			return { universeId = p.universeId, placeId = p.placeId }
		end

		return {}
	end
}
