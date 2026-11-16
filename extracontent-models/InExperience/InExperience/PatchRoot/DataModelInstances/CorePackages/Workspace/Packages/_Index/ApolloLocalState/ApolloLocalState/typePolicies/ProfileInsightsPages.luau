local mergeLists = require(script.Parent.utils.mergeLists)

return {
	fields = {
		profileInsights = {
			merge = function(_, p, p2)
				return mergeLists(p, p2)
			end
		}
	}
}
