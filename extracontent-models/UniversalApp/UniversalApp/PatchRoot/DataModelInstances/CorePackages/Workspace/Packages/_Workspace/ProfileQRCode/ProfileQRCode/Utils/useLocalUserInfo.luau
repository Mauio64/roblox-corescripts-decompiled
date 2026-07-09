local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local getDeepValue = require(ProfileQRCodeParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local useSelector = require(ProfileQRCodeParent.RoactUtils).Hooks.RoactRodux.useSelector
local Constants = require(ProfileQRCode.Common.Constants)

return function(s1: string) -- line: 9
	-- upvalues: useSelector (copy), getDeepValue (copy), Constants (copy)
	return useSelector(function(p1) -- line: 10
		-- upvalues: getDeepValue (copy), Constants (copy), s1 (copy)
		return getDeepValue(p1, Constants.RODUX_KEY .. ".Users.byUserId." .. s1)
	end)
end
