return {
	extractFieldsFromGameEntry = function(p2)
		if p2 then
			return { universeId = p2.universeId, placeId = p2.placeId }
		end

		return {}
	end
}
