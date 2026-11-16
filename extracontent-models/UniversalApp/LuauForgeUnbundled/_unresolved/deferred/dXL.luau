local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/LuaSocialLibrariesDeps").SocialLibraries.config({}).Dictionary.getDeepValue
local getExperiencesDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/App/Networking").NetworkingGames.GetExperiencesDetails
local module = require("@luauforge/deferred/dXM")
local Networking = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/App/Networking")
require("@luauforge/deferred/dXw")

return function(p2, p3, p4)
	return function(object)
		object:dispatch(Networking.ContentSharingNetworking.GetPostsByCursor.API({
			cursor = p3,
			sortOrder = p4,
			userId = p2
		})):andThen(function()
			local v5 = module(getDeepValue(object:getState(), "ContentSharing.byUserId." .. p2 .. ".posts") or {})
			object:dispatch(getExperiencesDetails.API(v5))
		end):catch(function() end)
	end
end
