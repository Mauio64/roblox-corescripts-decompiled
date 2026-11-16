local parent = script:FindFirstAncestor("Moments").Parent

local v = game:DefineFastFlag("MomentsCommentTranslation", false)

if v then
	local SharedFlags = require(parent.SharedFlags)
	return SharedFlags.FFlagMomentsComments
end

return v
