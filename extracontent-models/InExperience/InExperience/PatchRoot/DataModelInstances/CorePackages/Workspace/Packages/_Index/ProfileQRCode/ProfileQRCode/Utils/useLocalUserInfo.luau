local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Constants = require(ProfileQRCode.Common.Constants)
local UserProfiles = require(parent.UserProfiles)

local FFlagProfileQrCodeDeprecateUserRedux = require(ProfileQRCode.Flags.FFlagProfileQrCodeDeprecateUserRedux)

return function(p: string)
	if not FFlagProfileQrCodeDeprecateUserRedux then
		return useSelector(function(p2)
			return getDeepValue(p2, Constants.RODUX_KEY .. ".Users.byUserId." .. p)
		end)
	end

	local v = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { p },
		query = UserProfiles.Queries.userProfilesDisplayNameAndUsernameByUserIds
	})

	if v.data then
		return {
			displayName = UserProfiles.Selectors.getDisplayNameFromId(v.data, p) or "",
			username = UserProfiles.Selectors.getUsernameFromId(v.data, p) or ""
		}
	end

	return { displayName = "", username = "" }
end
