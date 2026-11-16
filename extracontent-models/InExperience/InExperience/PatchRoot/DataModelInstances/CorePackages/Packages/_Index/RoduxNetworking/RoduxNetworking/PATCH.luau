local parent = script.Parent
local makeRequestApi = require(parent.makeRequestApi)

return function(p)
	return makeRequestApi(p, "PATCH")
end
