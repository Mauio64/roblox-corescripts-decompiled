local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserLib")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local SetAlias = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SetAlias")

local NetworkingUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/NetworkingUsers")
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local useNavigation = Navigation.useNavigation

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileWrapperContext")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local SocialStopwatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialStopwatch")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local UserProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/UserProfileHeader")
local fFlagMoveInExperienceModeToEditProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagMoveInExperienceModeToEditProfile

local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfile/Enums")
local fFlagAddPlatformNameToProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAddPlatformNameToProfileHeader

local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserProfiles")
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch

local function UserProfileHeaderContainer(p2)
	local v5 = useProfileWrapperContext()
	local v6 = useNavigation()
	local v7 = useDispatch()
	local ref = React.useRef(false)
	local v8 = useProfileAnalyticsContext()

	local profileId = v5.profileId

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		profileId,
		constants.RbxthumbTypes.Avatar,
		Constants.AVATAR_THUMBNAIL_SIZE
	)

	local v9 = useProfileJsonComponent(Enums.Components.UserProfileHeader)

	local v10 = nil

	if fFlagAddPlatformNameToProfileHeader then
		local v11 = useUserProfilesFetch({
			userIds = { profileId },
			query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
		})

		if v11.data then
			local platformNameFromId = UserProfiles.Selectors.getPlatformNameFromId(v11.data, profileId)

			if platformNameFromId and platformNameFromId ~= "" then
				v10 = platformNameFromId
			end
		end
	end

	local v11 = React.useCallback(function()
		if not v9.editName then
			return
		end

		if v9.editName.field == Enums.NameTypes.DisplayName then
			v8.fireAnalyticsEvent(EventNames.EditDisplayNameButton, {
				canSetDisplayName = ref.current
			})

			if ref.current then
				v6.navigate(module15.Screens.EditProfileSubScreen, {
					screen = module15.Screens.EditDisplayName,
					initialDisplayName = v9.names.primaryName
				})
			else
				v6.navigate(Enums.Screens.EditDisplayNameErrorModal)
			end
		else
			SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CustomizeNameOpened)
			v8.fireAnalyticsEvent(EventNames.SetAliasButton)
			v6.navigate(Enums.Screens.SetAliasModal, {
				profileUserId = profileId,
				origin = SetAlias.Analytics.EntryPoints.ProfileCardName
			})
		end
	end, { v6, v9.editName, v9.names })

	useEffectOnce(function()
		v7(NetworkingUsers.GetDisplayNameValidation.API(profileId, "testName")):andThen(function()
			ref.current = true
		end):catch(function()
			ref.current = false
		end)
	end, v9.editName and v9.editName.field == Enums.NameTypes.DisplayName)

	local v12 = v9.counts ~= nil

	local isInExperienceNameEnabled = nil
	local v13

	if not fFlagMoveInExperienceModeToEditProfile then
		v13 = v9.userProfileSettings ~= nil

		if v13 then
			isInExperienceNameEnabled = v9.userProfileSettings.isInExperienceNameEnabled
		end
	end

	local createElement = React.createElement
	local v15 = {
		userThumbnail = rbxthumbWithTypeSizeAndOptions,
		layoutOrder = p2.layoutOrder,
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

	if not v9.editName then
		v11 = nil
	end

	v15.openEditName = v11
	local primaryName = v9.names.primaryName or ""

	local profileUserNickname = v5.profileUserNickname

	v15.primaryName = primaryName
	v15.username = v9.names.username
	v15.isPremium = v9.isPremium
	v15.isVerified = v9.isVerified
	v15.isRobloxAdmin = v9.isRobloxAdmin
	v15.isEdited = v9.editName and v9.editName.isEdited

	if fFlagMoveInExperienceModeToEditProfile then
		v13 = nil
	end

	v15.shouldDisplayUserProfileSettings = v13

	if fFlagMoveInExperienceModeToEditProfile then
		isInExperienceNameEnabled = nil
	end

	v15.isInExperienceNameEnabled = isInExperienceNameEnabled
	v15.shouldDisplayCounts = v12

	if not fFlagAddPlatformNameToProfileHeader then
		v10 = nil
	end

	v15.platformName = v10
	return createElement(UserProfileHeader, v15)
end

return UserProfileHeaderContainer
