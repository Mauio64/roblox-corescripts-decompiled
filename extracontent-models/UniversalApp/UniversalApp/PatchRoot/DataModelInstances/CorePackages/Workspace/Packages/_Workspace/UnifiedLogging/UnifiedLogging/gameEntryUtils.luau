return {
	extractFieldsFromGameEntry = function(p1) -- line: 6
		if not p1 then
			return {}
		end

		local universeId = p1.universeId
		local placeId = p1.placeId

		return {
			universeId = universeId,
			placeId = placeId
		}
	end
}
