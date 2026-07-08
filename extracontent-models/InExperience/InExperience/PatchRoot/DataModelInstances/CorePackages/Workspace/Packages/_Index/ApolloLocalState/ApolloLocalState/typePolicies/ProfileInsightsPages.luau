local mergeLists = require(script.Parent.utils.mergeLists)

return {
	fields = {
		profileInsights = {
			merge = function(_, p2, p3) -- line: 6
				-- upvalues: mergeLists (copy)
				return mergeLists(p2, p3)
			end
		}
	}
}
