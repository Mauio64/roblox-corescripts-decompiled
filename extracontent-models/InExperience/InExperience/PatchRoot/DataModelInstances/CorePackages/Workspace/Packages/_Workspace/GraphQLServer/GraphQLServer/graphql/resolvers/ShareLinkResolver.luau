local parent = script:FindFirstAncestor("GraphQLServer").Parent
require(parent.LuauPolyfill)
local generatedTypes = require(script.Parent.Parent.generatedTypes)
local ShareLinkConnector = require(script.Parent.Parent.connectors.ShareLinkConnector)
local Cryo = require(parent.Cryo)

return {
	ExperienceDetailsLink = {
		linkType = function()
			return generatedTypes.ShareLinkType.ExperienceDetails
		end,
		linkId = function(p)
			return p.linkId
		end,
		shortUrl = function(p)
			return p.shortUrl
		end,
		universeId = function(_, _, _, p)
			return p.variableValues.universeId
		end
	},
	Query = {
		experienceDetailsLinkByUniverseId = function(_, p, p2, _)
			return ShareLinkConnector.fetchShareLink(
				Cryo.Dictionary.join({
					linkType = generatedTypes.ShareLinkType.ExperienceDetails,
					data = p
				}),
				p2.fetchImpl
			)
		end
	}
}
