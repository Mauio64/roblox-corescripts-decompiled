local Networking = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/App/Networking")

return function(p2)
	return function(object)
		object:dispatch(Networking.ContentSharingNetworking.DeletePost.API({ postId = p2 })):andThen(function() end):catch(function() end)
	end
end
