require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")
local generatedTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")
local ShareLinkConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/connectors/ShareLinkConnector")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Cryo")

return {
	ExperienceDetailsLink = {
		linkType = function()
			return generatedTypes.ShareLinkType.ExperienceDetails
		end,
		linkId = function(p2)
			return p2.linkId
		end,
		shortUrl = function(p2)
			return p2.shortUrl
		end,
		universeId = function(p2, p3, p4, p5)
			return p5.variableValues.universeId
		end
	},
	Query = {
		experienceDetailsLinkByUniverseId = function(p2, p3, p4, p5)
			return ShareLinkConnector.fetchShareLink(
				Cryo.Dictionary.join({
					linkType = generatedTypes.ShareLinkType.ExperienceDetails,
					data = p3
				}),
				p4.fetchImpl
			)
		end
	}
}
