local getUserProfileFromId = require(script.Parent.getUserProfileFromId)

return function(p1, p2) -- line: 3
	-- upvalues: getUserProfileFromId (copy)
	return getUserProfileFromId(p1, p2).platformProfileId
end
