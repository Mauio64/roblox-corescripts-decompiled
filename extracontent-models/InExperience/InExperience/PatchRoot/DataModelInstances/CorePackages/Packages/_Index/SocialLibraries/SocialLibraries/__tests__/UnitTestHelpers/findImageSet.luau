local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local UIBlox = require(SocialLibraries.dependencies).UIBlox

return function(p1) -- line: 5
	-- upvalues: UIBlox (copy)
	local v4 = UIBlox.App.ImageSet.Images[p1]

	return {
		Image = v4.Image,
		ImageRectSize = v4.ImageRectSize,
		ImageRectOffset = v4.ImageRectOffset
	}
end
