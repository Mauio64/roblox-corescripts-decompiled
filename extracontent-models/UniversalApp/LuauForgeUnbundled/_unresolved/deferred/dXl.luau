local module = require("@luauforge/deferred/dWi")
local Networking = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/App/Networking")

return function(p2)
	return function(object)
		object:dispatch(Networking.NetworkingCurrentlyWearing.GetItemDetails.API(p2)):andThen(function()
			object:dispatch(module(p2))
		end):catch(function() end)
	end
end
