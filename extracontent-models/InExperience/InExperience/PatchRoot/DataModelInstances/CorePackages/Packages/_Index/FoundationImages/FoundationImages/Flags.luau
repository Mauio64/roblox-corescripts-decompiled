local Parent = script:FindFirstAncestor("FoundationImages").Parent
local SafeFlags = require(Parent.SafeFlags)

return {
	FixBlurryImages = SafeFlags.createGetFFlag("FixBlurryImages")(),
	FoundationImagesWhitelistedIconAssets = SafeFlags.createGetFString("FoundationImagesWhitelistedIconAssets", "")()
}
