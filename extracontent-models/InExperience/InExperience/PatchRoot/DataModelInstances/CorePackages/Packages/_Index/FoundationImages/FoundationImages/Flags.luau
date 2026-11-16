local parent = script:FindFirstAncestor("FoundationImages").Parent
local SafeFlags = require(parent.SafeFlags)

return {
	FoundationImagesWhitelistedIconAssets = SafeFlags.createGetFString("FoundationImagesWhitelistedIconAssets", "")()
}
