local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/Promise")

return {
	networkError = function(p2, p3)
		return { kind = "Network", message = p2, cause = p3 }
	end,
	parseError = function(p2, p3)
		return { kind = "Parse", message = p2, cause = p3 }
	end,
	schemaError = function(p2, p3)
		return { kind = "Schema", message = p2, cause = p3 }
	end,
	engineError = function(p2, p3)
		return { kind = "Engine", message = p2, cause = p3 }
	end,
	rejectNetwork = function(p2, p3)
		return Promise.reject({ kind = "Network", message = p2, cause = p3 })
	end,
	rejectParse = function(p2, p3)
		return Promise.reject({ kind = "Parse", message = p2, cause = p3 })
	end,
	rejectSchema = function(p2, p3)
		return Promise.reject({ kind = "Schema", message = p2, cause = p3 })
	end,
	rejectEngine = function(p2, p3)
		return Promise.reject({ kind = "Engine", message = p2, cause = p3 })
	end
}
