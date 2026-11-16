local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local UserLib = require(parent.UserLib)
local Navigation = require(parent.Navigation)
local RoactUtils = require(parent.RoactUtils)
local SetAlias = require(parent.SetAlias)

local NetworkingUsers = require(ProfilePlatform.Networking.NetworkingUsers)
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local useNavigation = Navigation.useNavigation

require(ProfilePlatform.Contexts.ProfileWrapperContext)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local SocialStopwatch = require(parent.SocialStopwatch)

local Constants2 = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)

local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local UserProfileHeader = require(ProfilePlatform.Components.UserProfileHeader.UserProfileHeader)
local SharedFlags = require(parent.SharedFlags)
local FFlagMoveInExperienceModeToEditProfile = SharedFlags.FFlagMoveInExperienceModeToEditProfile

local Enums2 = require(parent.EditProfile.Enums)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddPlatformNameToProfileHeader = SharedFlags2.FFlagAddPlatformNameToProfileHeader

local UserProfiles = require(parent.UserProfiles)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch

local function UserProfileHeaderContainer(p)
	local v = useProfileWrapperContext()
	local v2 = useNavigation()
	local v3 = useDispatch()
	local ref = React.useRef(false)
	local v4 = useProfileAnalyticsContext()

	local profileId = v.profileId

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		profileId,
		Constants.RbxthumbTypes.Avatar,
		Constants2.AVATAR_THUMBNAIL_SIZE
	)

	local v5 = useProfileJsonComponent(Enums.Components.UserProfileHeader)

	local platformName = nil

	if FFlagAddPlatformNameToProfileHeader then
		local v6 = useUserProfilesFetch({
			userIds = { profileId },
			query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
		})

		if v6.data then
			local platformNameFromId = UserProfiles.Selectors.getPlatformNameFromId(v6.data, profileId)

			if platformNameFromId and platformNameFromId ~= "" then
				platformName = platformNameFromId
			end
		end
	end

	local openEditName = React.useCallback(function()
		if not v5.editName then
			return
		end

		if v5.editName.field == Enums.NameTypes.DisplayName then
			v4.fireAnalyticsEvent(EventNames.EditDisplayNameButton, {
				canSetDisplayName = ref.current
			})

			if ref.current then
				v2.navigate(Enums2.Screens.EditProfileSubScreen, {
					screen = Enums2.Screens.EditDisplayName,
					initialDisplayName = v5.names.primaryName
				})
			else
				v2.navigate(Enums.Screens.EditDisplayNameErrorModal)
			end
		else
			SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CustomizeNameOpened)
			v4.fireAnalyticsEvent(EventNames.SetAliasButton)
			v2.navigate(Enums.Screens.SetAliasModal, {
				profileUserId = profileId,
				origin = SetAlias.Analytics.EntryPoints.ProfileCardName
			})
		end
	end, { v2, v5.editName, v5.names })

	useEffectOnce(function()
		local function fn() -- 1 equivalent call inferred from this helper
			return v3(NetworkingUsers.GetDisplayNameValidation.API(profileId, "testName"))
		end

		fn():andThen(function() -- inferred equivalent call
			ref.current = true
		end):catch(function()
			ref.current = false
		end)
	end, v5.editName and v5.editName.field == Enums.NameTypes.DisplayName)

	local shouldDisplayCounts = v5.counts ~= nil

	local isInExperienceNameEnabled = nil
	local shouldDisplayUserProfileSettings

	if not FFlagMoveInExperienceModeToEditProfile then
		shouldDisplayUserProfileSettings = v5.userProfileSettings ~= nil

		if shouldDisplayUserProfileSettings then
			isInExperienceNameEnabled = v5.userProfileSettings.isInExperienceNameEnabled
		end
	end

	local createElement = React.createElement
	local v6 = {
		userThumbnail = rbxthumbWithTypeSizeAndOptions,
		layoutOrder = p.layoutOrder,
		userId = tonumber(profileId),
		openEditName = 0,
		primaryName = 0,
		username = 0,
		isPremium = 0,
		isVerified = 0,
		isRobloxAdmin = 0,
		isEdited = 0,
		shouldDisplayUserProfileSettings = 0,
		isInExperienceNameEnabled = 0,
		shouldDisplayCounts = 0,
		platformName = 0
	}

	if not v5.editName then
		openEditName = nil
	end

	v6.openEditName = openEditName
	local primaryName = v5.names.primaryName or ""

	local _profileUserNickname = v.profileUserNickname

	v6.primaryName = primaryName
	v6.username = v5.names.username
	v6.isPremium = v5.isPremium
	v6.isVerified = v5.isVerified
	v6.isRobloxAdmin = v5.isRobloxAdmin
	v6.isEdited = v5.editName and v5.editName.isEdited

	if FFlagMoveInExperienceModeToEditProfile then
		shouldDisplayUserProfileSettings = nil
	end

	v6.shouldDisplayUserProfileSettings = shouldDisplayUserProfileSettings

	if FFlagMoveInExperienceModeToEditProfile then
		isInExperienceNameEnabled = nil
	end

	v6.isInExperienceNameEnabled = isInExperienceNameEnabled
	v6.shouldDisplayCounts = shouldDisplayCounts

	if not FFlagAddPlatformNameToProfileHeader then
		platformName = nil
	end

	v6.platformName = platformName
	return createElement(UserProfileHeader, v6)
end

return UserProfileHeaderContainer
