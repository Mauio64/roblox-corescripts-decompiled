local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local AmpUpsellConnector = require(GraphQLServer.graphql.connectors.AmpUpsellConnector)

return {
	default = {
		UpsellFeatureAccessResponse = {
			featureAccess = function(p1) -- line: 7
				return {
					featureName = p1.featureName,
					access = p1.access,
					recourse = p1.recourse,
					recourses = p1.recourses
				}
			end
		},
		Query = {
			getFeatureAccess = function(_, p3, p4) -- line: 18
				-- upvalues: AmpUpsellConnector (copy)
				return AmpUpsellConnector.getFeatureAccessFromFeatureNamesList(p3.featureNames, p4.fetchImpl)
			end,
			getUpsellFeatureAccess = function(_, p6, p7) -- line: 21
				-- upvalues: AmpUpsellConnector (copy)
				return AmpUpsellConnector.getUpsellFeatureAccessFromFeatureName(p6.featureName, p6.successfulActions, p7.fetchImpl, p6.nameSpace, p6.extraParameters)
			end
		}
	}
}
