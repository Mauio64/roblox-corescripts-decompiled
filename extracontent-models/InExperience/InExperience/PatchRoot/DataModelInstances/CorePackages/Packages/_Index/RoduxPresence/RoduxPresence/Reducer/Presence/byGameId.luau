local createReducerSlice = require(script.Parent.createReducerSlice)
return function(p)
	return createReducerSlice("byGameId", "universeId", p)
end
