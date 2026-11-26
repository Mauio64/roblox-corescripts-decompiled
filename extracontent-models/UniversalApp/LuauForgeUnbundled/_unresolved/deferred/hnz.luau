local module = require("@luauforge/deferred/hnA")

return function(p2, p3)
	return {
		retrievalStatus = module.rodux.GetMetadata.getStatus(p2)
	}
end
