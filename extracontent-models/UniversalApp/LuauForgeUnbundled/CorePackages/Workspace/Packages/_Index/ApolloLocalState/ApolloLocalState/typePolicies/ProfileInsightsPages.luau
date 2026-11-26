local mergeLists = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/typePolicies/utils/mergeLists")

return {
	fields = {
		profileInsights = {
			merge = function(p2, p3, p4)
				return mergeLists(p3, p4)
			end
		}
	}
}
