return function(p1, p2) -- line: 1
	assert(type(p2) == "string", "Expected placeId to be a string")
	p1:setRBXEventStream("PlacesList", "openModalFromGameTile", {
		placeId = p2
	})
end
