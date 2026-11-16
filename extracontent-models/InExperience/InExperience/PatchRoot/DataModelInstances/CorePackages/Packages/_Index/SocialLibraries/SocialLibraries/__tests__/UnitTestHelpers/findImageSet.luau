local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local uiBlox = dependencies.UIBlox

return function(p)
	local image = uiBlox.App.ImageSet.Images[p]

	return {
		Image = image.Image,
		ImageRectSize = image.ImageRectSize,
		ImageRectOffset = image.ImageRectOffset
	}
end
