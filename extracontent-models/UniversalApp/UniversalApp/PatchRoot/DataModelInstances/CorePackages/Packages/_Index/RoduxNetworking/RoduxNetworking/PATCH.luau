local scriptParent = script.Parent
local makeRequestApi = require(scriptParent.makeRequestApi)

return function(p1) -- line: 4
	-- upvalues: makeRequestApi (copy)
	return makeRequestApi(p1, "PATCH")
end
