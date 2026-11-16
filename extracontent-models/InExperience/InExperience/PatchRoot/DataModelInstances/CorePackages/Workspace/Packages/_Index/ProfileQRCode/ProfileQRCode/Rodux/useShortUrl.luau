local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Constants = require(ProfileQRCode.Common.Constants)

return function()
	return useSelector(function(p)
		return getDeepValue(p, Constants.RODUX_KEY .. ".ShareUrl.shortUrl")
	end)
end
