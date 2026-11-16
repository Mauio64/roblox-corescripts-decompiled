return function(object, value)
	assert(type(value) == "string", "Expected placeId to be a string")

	object:setRBXEventStream("PlacesList", "openModalFromGameTile", { placeId = value })
end
