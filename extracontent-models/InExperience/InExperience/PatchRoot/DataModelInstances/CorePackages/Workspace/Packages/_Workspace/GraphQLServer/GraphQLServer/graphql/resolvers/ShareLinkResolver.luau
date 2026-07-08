local Parent = script:FindFirstAncestor("GraphQLServer").Parent

require(Parent.LuauPolyfill)

local generatedTypes = require(script.Parent.Parent.generatedTypes)
local ShareLinkConnector = require(script.Parent.Parent.connectors.ShareLinkConnector)
local Cryo = require(Parent.Cryo)

return {
	ExperienceDetailsLink = {
		linkType = function() -- line: 14
			-- upvalues: generatedTypes (copy)
			return generatedTypes.ShareLinkType.ExperienceDetails
		end,
		linkId = function(p1) -- line: 17
			return p1.linkId
		end,
		shortUrl = function(p2) -- line: 20
			return p2.shortUrl
		end,
		universeId = function(_, _, _, p6) -- line: 23
			return p6.variableValues.universeId
		end
	},
	Query = {
		experienceDetailsLinkByUniverseId = function(_, p8, p9, _) -- line: 28
			-- upvalues: ShareLinkConnector (copy), Cryo (copy), generatedTypes (copy)
			return ShareLinkConnector.fetchShareLink(Cryo.Dictionary.join({
				linkType = generatedTypes.ShareLinkType.ExperienceDetails,
				data = p8
			}), p9.fetchImpl)
		end
	}
}
