return function(object, placeId)
	assert(type(placeId) == "string", "Expected placeId to be a string")

	object:setRBXEventStream("PlacesList", "openModalFromGameTile", { placeId = placeId })
end
