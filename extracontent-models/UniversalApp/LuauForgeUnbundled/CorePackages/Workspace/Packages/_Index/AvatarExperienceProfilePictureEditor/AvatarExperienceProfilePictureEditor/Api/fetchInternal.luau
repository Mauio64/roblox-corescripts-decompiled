local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/HttpRequest")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")

return HttpRequest.config({
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end
})
