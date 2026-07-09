local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local Promise = require(Parent.Promise)
local Array = require(Parent.LuauPolyfill).Array

require(script.Parent.Parent.generatedTypes)

return {
	Experience = {
		thumbnails = function(p1, _, p3) -- line: 10
			-- upvalues: Promise (copy)
			local thumbnails = p3.dataLoaders.thumbnails

			if not thumbnails then
				return Promise.resolve({})
			end

			return (thumbnails:load(p1.universeId):andThen(function(p4) -- line: 17
				if not p4 then
					return {}
				end

				return {{
					url = p4.imageUrl
				}}
			end):catch(function() -- line: 23
				return {}
			end))
		end
	},
	Query = {
		experienceThumbnails = function(_, p6) -- line: 30
			-- upvalues: Array (copy)
			return Array.map(p6.universeIds, function(p7) -- line: 31
				return {
					universeId = p7
				}
			end)
		end
	}
}
