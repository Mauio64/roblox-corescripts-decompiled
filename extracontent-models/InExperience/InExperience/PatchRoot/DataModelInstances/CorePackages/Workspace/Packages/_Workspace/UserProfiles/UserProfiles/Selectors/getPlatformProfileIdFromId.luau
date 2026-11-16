local getUserProfileFromId = require(script.Parent.getUserProfileFromId)

return function(p, p2)
	return getUserProfileFromId(p, p2).platformProfileId
end
