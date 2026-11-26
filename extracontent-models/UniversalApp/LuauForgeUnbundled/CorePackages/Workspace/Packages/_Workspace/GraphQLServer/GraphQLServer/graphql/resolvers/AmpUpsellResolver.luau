local AmpUpsellConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/connectors/AmpUpsellConnector")

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
			getFeatureAccess = function(p2, p3, p4)
				return AmpUpsellConnector.getFeatureAccessFromFeatureNamesList(p3.featureNames, p4.fetchImpl)
			end,
			getUpsellFeatureAccess = function(p2, data, p3)
				return AmpUpsellConnector.getUpsellFeatureAccessFromFeatureName(
					data.featureName,
					data.successfulActions,
					p3.fetchImpl,
					data.nameSpace,
					data.extraParameters
				)
			end
		}
	}
}
