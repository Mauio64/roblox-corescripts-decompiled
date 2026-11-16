local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local HttpRequest = require(parent.HttpRequest)

require(AvatarExperienceProfilePictureEditor.Common.Enums)

return HttpRequest.config({
	requestFunction = function(p: string, p2, p3)
		return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end
})
