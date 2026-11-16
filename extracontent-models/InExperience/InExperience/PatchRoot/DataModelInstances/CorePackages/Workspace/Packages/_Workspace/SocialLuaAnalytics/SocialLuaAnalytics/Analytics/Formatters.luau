return {
	formatRecommendationContextType = require(script.formatRecommendationContextType),
	formatPresence = require(script.formatPresence),
	createDiagMetricString = require(script.createDiagMetricString),
	repeatValue = function(p: number, p2: number)
		return table.concat(table.create(p2, (tostring(p))), ",")
	end
}
