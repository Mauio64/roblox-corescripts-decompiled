local GraphQLServer = script:FindFirstAncestor("GraphQLServer")

local AmpUpsellConnector = require(GraphQLServer.graphql.connectors.AmpUpsellConnector)

return {
	default = {
		UpsellFeatureAccessResponse = {
			featureAccess = function(data)
				return {
					featureName = data.featureName,
					access = data.access,
					recourse = data.recourse,
					recourses = data.recourses
				}
			end
		},
		Query = {
			getFeatureAccess = function(_, p, p2)
				return AmpUpsellConnector.getFeatureAccessFromFeatureNamesList(p.featureNames, p2.fetchImpl)
			end,
			getUpsellFeatureAccess = function(_, data, p)
				return AmpUpsellConnector.getUpsellFeatureAccessFromFeatureName(
					data.featureName,
					data.successfulActions,
					p.fetchImpl,
					data.nameSpace,
					data.extraParameters
				)
			end
		}
	}
}
