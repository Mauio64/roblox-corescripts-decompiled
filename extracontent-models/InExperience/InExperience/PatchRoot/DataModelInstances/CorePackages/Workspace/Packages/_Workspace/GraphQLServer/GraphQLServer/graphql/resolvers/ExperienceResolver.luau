local parent = script:FindFirstAncestor("GraphQLServer").Parent
local Promise = require(parent.Promise)
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
require(script.Parent.Parent.generatedTypes)

return {
	Experience = {
		thumbnails = function(p, _, p2)
			local thumbnails = p2.dataLoaders.thumbnails

			if thumbnails then
				return (thumbnails:load(p.universeId):andThen(function(p3)
					if p3 then
						return {
							{ url = p3.imageUrl }
						}
					end

					return {}
				end):catch(function()
					return {}
				end))
			end

			return Promise.resolve({})
		end
	},
	Query = {
		experienceThumbnails = function(_, p)
			return Array.map(p.universeIds, function(universeId)
				return { universeId = universeId }
			end)
		end
	}
}
