local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/LuaSocialLibrariesDeps").SocialLibraries.config({}).Dictionary.getDeepValue
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactUtils").Hooks.RoactRodux.useSelector
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Common/Constants")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/UserProfiles")

local FFlagProfileQrCodeDeprecateUserRedux = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Flags/FFlagProfileQrCodeDeprecateUserRedux")

return function(p2)
	if not FFlagProfileQrCodeDeprecateUserRedux then
		return useSelector(function(p3)
			return getDeepValue(p3, Constants.RODUX_KEY .. ".Users.byUserId." .. p2)
		end)
	end

	local v5 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { p2 },
		query = UserProfiles.Queries.userProfilesDisplayNameAndUsernameByUserIds
	})

	if v5.data then
		return {
			displayName = UserProfiles.Selectors.getDisplayNameFromId(v5.data, p2) or "",
			username = UserProfiles.Selectors.getUsernameFromId(v5.data, p2) or ""
		}
	end

	return { displayName = "", username = "" }
end
