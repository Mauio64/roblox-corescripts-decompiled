local module = require("@luauforge/deferred/hcR")

return function(p2, p3)
	return {
		retrievalStatus = module.rodux.GetMetadata.getStatus(p2)
	}
end
