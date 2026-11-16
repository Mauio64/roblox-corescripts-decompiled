local createReducerSlice = require(script.Parent.createReducerSlice)
return function(p)
	return createReducerSlice("byPlaceId", "placeId", p)
end
