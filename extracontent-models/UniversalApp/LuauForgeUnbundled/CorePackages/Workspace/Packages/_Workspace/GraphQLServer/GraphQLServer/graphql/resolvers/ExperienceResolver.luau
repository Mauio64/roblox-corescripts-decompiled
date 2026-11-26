local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local array = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill").Array
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

return {
	Experience = {
		thumbnails = function(p2, p3, p4)
			local thumbnails = p4.dataLoaders.thumbnails

			if thumbnails then
				return (thumbnails:load(p2.universeId):andThen(function(p5)
					if p5 then
						return {
							{ url = p5.imageUrl }
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
		experienceThumbnails = function(p2, p3)
			return array.map(p3.universeIds, function(p4)
				return { universeId = p4 }
			end)
		end
	}
}
