local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local getDeepValue = require(ProfileQRCodeParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local useSelector = require(ProfileQRCodeParent.RoactUtils).Hooks.RoactRodux.useSelector
local Constants = require(ProfileQRCode.Common.Constants)

return function() -- line: 9
	-- upvalues: useSelector (copy), getDeepValue (copy), Constants (copy)
	return useSelector(function(p1) -- line: 10
		-- upvalues: getDeepValue (copy), Constants (copy)
		return getDeepValue(p1, Constants.RODUX_KEY .. ".ShareUrl.linkId")
	end)
end
