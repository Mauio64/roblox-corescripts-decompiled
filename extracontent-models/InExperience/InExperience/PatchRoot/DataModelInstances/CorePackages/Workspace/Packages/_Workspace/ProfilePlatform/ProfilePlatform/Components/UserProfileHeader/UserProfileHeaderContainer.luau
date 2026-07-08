local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local UserLib = require(ProfilePlatformParent.UserLib)
local Navigation = require(ProfilePlatformParent.Navigation)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local SetAlias = require(ProfilePlatformParent.SetAlias)
local NetworkingUsers = require(ProfilePlatform.Networking.NetworkingUsers)
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local useNavigation = Navigation.useNavigation

require(ProfilePlatform.Contexts.ProfileWrapperContext)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local SocialStopwatch = require(ProfilePlatformParent.SocialStopwatch)
local Constants2 = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local UserProfileHeader = require(ProfilePlatform.Components.UserProfileHeader.UserProfileHeader)
local useAppPolicy = require(ProfilePlatformParent.UniversalAppPolicy).useAppPolicy
local FFlagFriendRequestNicknames = require(ProfilePlatformParent.SharedFlags).FFlagFriendRequestNicknames
local FFlagMoveInExperienceModeToEditProfile = require(ProfilePlatformParent.SharedFlags).FFlagMoveInExperienceModeToEditProfile
local Enums2 = require(ProfilePlatformParent.EditProfile.Enums)
local FFlagEditProfileMigration = require(ProfilePlatformParent.EditProfile.Flags).FFlagEditProfileMigration
local FFlagAddPlatformNameToProfileHeader = require(ProfilePlatformParent.SharedFlags).FFlagAddPlatformNameToProfileHeader
local UserProfiles = require(ProfilePlatformParent.UserProfiles)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch

local function UserProfileHeaderContainer(t1: {[any]: any}) -- line: 88
	-- upvalues: useProfileWrapperContext (copy), useNavigation (copy), useDispatch (copy), React (copy), useProfileAnalyticsContext (copy), FFlagFriendRequestNicknames (copy), useAppPolicy (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), Constants2 (copy), useProfileJsonComponent (copy), Enums (copy), FFlagAddPlatformNameToProfileHeader (copy), useUserProfilesFetch (copy), UserProfiles (copy), EventNames (copy), FFlagEditProfileMigration (copy), Enums2 (copy), SocialStopwatch (copy), SetAlias (copy), useEffectOnce (copy), NetworkingUsers (copy), FFlagMoveInExperienceModeToEditProfile (copy), UserProfileHeader (copy)
	local v36 = useProfileWrapperContext()
	local v37 = useNavigation()
	local v38 = useDispatch()
	local v39 = React.useRef(false)
	local v40 = useProfileAnalyticsContext()
	local profileId = v36.profileId
	local v42 = not not FFlagFriendRequestNicknames and useAppPolicy(function(p1) -- line: 98
		return p1.getFriendRequestNicknamesEnabled()
	end)
	local v43 = getRbxthumbWithTypeSizeAndOptions(profileId, Constants.RbxthumbTypes.Avatar, Constants2.AVATAR_THUMBNAIL_SIZE)
	local v44 = useProfileJsonComponent(Enums.Components.UserProfileHeader)
	local v45 = nil

	if FFlagAddPlatformNameToProfileHeader then
		local v46 = useUserProfilesFetch({
			userIds = { profileId },
			query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
		})

		if v46.data then
			local v47 = UserProfiles.Selectors.getPlatformNameFromId(v46.data, profileId)

			if v47 and v47 ~= "" then
				v45 = v47
			end
		end
	end

	local v48 = React.useCallback(function() -- line: 125
		-- upvalues: v44 (copy), Enums (copy), v40 (copy), EventNames (copy), v39 (copy), FFlagEditProfileMigration (copy), v37 (copy), Enums2 (copy), SocialStopwatch (copy), profileId (copy), SetAlias (copy)
		if not v44.editName then
			return
		end

		if v44.editName.field == Enums.NameTypes.DisplayName then
			v40.fireAnalyticsEvent(EventNames.EditDisplayNameButton, {
				canSetDisplayName = v39.current
			})

			if v39.current then
				if FFlagEditProfileMigration then
					v37.navigate(Enums2.Screens.EditProfileSubScreen, {
						screen = Enums2.Screens.EditDisplayName,
						initialDisplayName = v44.names.primaryName
					})

					return
				end

				v37.navigate(Enums.Screens.EditDisplayNameModal, {
					showToast = function() -- line: 143
					end,
					setDisplayNameAvailable = function(p2) -- line: 146
						-- upvalues: v39 (copy)
						v39.current = p2
					end,
					displayName = v44.names.primaryName
				})

				return
			end

			v37.navigate(Enums.Screens.EditDisplayNameErrorModal)

			return
		end

		SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CustomizeNameOpened)
		v40.fireAnalyticsEvent(EventNames.SetAliasButton)
		v37.navigate(Enums.Screens.SetAliasModal, {
			profileUserId = profileId,
			origin = SetAlias.Analytics.EntryPoints.ProfileCardName
		})
	end, {
		v37,
		v44.editName,
		v44.names
	})

	useEffectOnce(function() -- line: 165
		-- upvalues: v38 (copy), NetworkingUsers (copy), profileId (copy), v39 (copy)
		v38(NetworkingUsers.GetDisplayNameValidation.API(profileId, "testName")):andThen(function() -- line: 171
			-- upvalues: v39 (copy)
			v39.current = true
		end):catch(function() -- line: 174
			-- upvalues: v39 (copy)
			v39.current = false
		end)
	end, v44.editName and v44.editName.field == Enums.NameTypes.DisplayName)

	local v49 = v44.counts ~= nil
	local v50 = nil
	local isInExperienceNameEnabled = nil

	if not FFlagMoveInExperienceModeToEditProfile then
		v50 = v44.userProfileSettings ~= nil

		if v50 then
			isInExperienceNameEnabled = v44.userProfileSettings.isInExperienceNameEnabled
		end
	end

	local createElement = React.createElement
	local v53 = UserProfileHeader
	local t2 = {
		userThumbnail = v43,
		layoutOrder = t1.layoutOrder,
		userId = tonumber(profileId),
		openEditName = if not v44.editName then nil else v48
	}
	local v55 = v44.names.primaryName or ""

	t2.primaryName = if not v36.profileUserNickname or (not v42 or v36.profileUserNickname == "") then v55 else v36.profileUserNickname .. " (" .. v55 .. ")"
	t2.username = v44.names.username
	t2.isPremium = v44.isPremium
	t2.isVerified = v44.isVerified
	t2.isRobloxAdmin = v44.isRobloxAdmin
	t2.isEdited = v44.editName and v44.editName.isEdited
	t2.shouldDisplayUserProfileSettings = if not FFlagMoveInExperienceModeToEditProfile then v50 else nil
	t2.isInExperienceNameEnabled = if not FFlagMoveInExperienceModeToEditProfile then isInExperienceNameEnabled else nil
	t2.shouldDisplayCounts = v49
	t2.platformName = if not FFlagAddPlatformNameToProfileHeader then nil else v45

	return createElement(v53, t2)
end

return UserProfileHeaderContainer
