local createReducerSlice = require(script.Parent.createReducerSlice)

return function(p1) -- line: 2
	-- upvalues: createReducerSlice (copy)
	return createReducerSlice("byGameId", "universeId", p1)
end
