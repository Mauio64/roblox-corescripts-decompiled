local createReducerSlice = require(script.Parent.createReducerSlice)
return function(p)
	return createReducerSlice("byGameInstanceId", "gameId", p)
end
