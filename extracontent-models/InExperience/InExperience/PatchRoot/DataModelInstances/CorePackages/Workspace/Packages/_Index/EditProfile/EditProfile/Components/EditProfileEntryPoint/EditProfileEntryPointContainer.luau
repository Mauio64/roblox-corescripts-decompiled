local EditProfile = script:FindFirstAncestor("EditProfile")
local Players = game:GetService("Players")
local EditProfileParent = EditProfile.Parent
local NavigationRodux = require(EditProfileParent.NavigationRodux)
local NavigateToRoute = NavigationRodux.Thunks.NavigateToRoute
local AppPage = require(EditProfileParent.RobloxAppEnums).AppPage
local React = require(EditProfileParent.React)
local UserProfiles = require(EditProfileParent.UserProfiles)
local RoactUtils = require(EditProfileParent.RoactUtils)
local EditProfileEntryPoint = require(script.Parent.EditProfileEntryPoint)
local useLocalUserId = require(EditProfileParent.RobloxAppHooks).useLocalUserId
local useLocalRobuxBalance = require(EditProfileParent.RobloxAppHooks).useLocalRobuxBalance
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local ProfileScreens = require(EditProfile.Common.Constants).ProfileScreens
local UsersNetworking = require(EditProfile.Networking.UsersNetworking)
local SocialLuaAnalytics = require(EditProfileParent.SocialLuaAnalytics)
local SocialStopwatch = require(EditProfileParent.SocialStopwatch)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local Images = require(EditProfileParent.UIBlox).App.ImageSet.Images
local getDeepValue = require(EditProfileParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(EditProfileParent.SharedFlags).FFlagSignalsNavP3Dispatch
local FFlagAXEnableProfileTab = require(EditProfileParent.SharedFlags).FFlagAXEnableProfileTab
local v26 = if not FFlagSignalsNavP3Dispatch then nil else require(EditProfileParent.RobloxAppNavigation).NavigationCommands
local SocialNetworksInEditProfileIXP = require(EditProfile.Flags.SocialNetworksInEditProfileIXP)
local SocialLinksNetworking = require(EditProfile.Networking.SocialLinksNetworking)
local SocialToast = require(EditProfileParent.SocialToast)
local LoadingStages = SocialLuaAnalytics.Analytics.Enums.LoadingStages
local useUserExperiment = require(EditProfileParent.RoactAppExperiment).useUserExperiment
local FStringEditProfileToAvatarLayerName = require(EditProfile.Flags.FStringEditProfileToAvatarLayerName)
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)
local FFlagEditProfileNavigateToAvatar = require(EditProfile.Flags.FFlagEditProfileNavigateToAvatar)
local Analytics = require(EditProfile.Analytics)
local EventNames = Analytics.EventNames
local useAnalytics = Analytics.useAnalytics
local FFlagMoveInExperienceModeToEditProfile = require(EditProfileParent.SharedFlags).FFlagMoveInExperienceModeToEditProfile
local FFlagEditProfileBackgroundEnabled = require(EditProfileParent.SharedFlags).FFlagEditProfileBackgroundEnabled

local function EditProfileEntryPointContainer(p1) -- line: 63
	-- upvalues: useDispatch (copy), useLocalUserId (copy), ProfileScreens (copy), React (copy), useSelector (copy), getDeepValue (copy), FFlagMoveInExperienceModeToEditProfile (copy), SocialNetworksInEditProfileIXP (copy), Players (copy), useLocalRobuxBalance (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateDown (copy), useEffectOnMount (copy), UsersNetworking (copy), useAnalytics (copy), useUserExperiment (copy), FStringEditProfileToAvatarLayerName (copy), EventNames (copy), SocialLinksNetworking (copy), SocialToast (copy), Images (copy), NavigateToRoute (copy), UserProfiles (copy), SocialStopwatch (copy), LoadingStages (copy), useEffectOnce (copy), FFlagAXEnableProfileTab (copy), FFlagEditProfileFixFocusNavigation (copy), FocusNavigatorWrapper (copy), EditProfileEntryPoint (copy), FFlagEditProfileNavigateToAvatar (copy), FFlagEditProfileBackgroundEnabled (copy)
	local v43 = useDispatch()
	local v44 = useLocalUserId()
	local s1 = ""
	local s2 = ""
	local v47 = true
	local v48 = p1.navigation.getParam(ProfileScreens)
	local v49, v50 = React.useState(false)

	useSelector(function(p2) -- line: 71
		-- upvalues: getDeepValue (copy), v44 (copy)
		return getDeepValue(p2, `Profile.AdditionalUserFields.{ v44 }.description`)
	end)

	local v51 = if not FFlagMoveInExperienceModeToEditProfile then nil else useSelector(function(p3) -- line: 75
		-- upvalues: getDeepValue (copy), v44 (copy)
		return getDeepValue(p3, `Profile.AdditionalUserFields.{ v44 }.userProfileSettings`)
	end)
	local isInExperienceNameEnabled = nil
	local inExperienceName = nil
	local inExperienceNameExpirationTime = nil

	if FFlagMoveInExperienceModeToEditProfile and v51 ~= nil then
		isInExperienceNameEnabled = v51.isInExperienceNameEnabled
		inExperienceName = v51.inExperienceName
		inExperienceNameExpirationTime = v51.inExperienceNameExpirationTime
	end

	local v55 = SocialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled()
	local v56 = SocialNetworksInEditProfileIXP.useGetExperimentVariant({
		isExposureEnabled = true
	})
	local v57 = v56 and v56 ~= SocialNetworksInEditProfileIXP.Variants.Control
	local v58 = if not v55 then nil else useSelector(function(p4) -- line: 93
		-- upvalues: getDeepValue (copy)
		return getDeepValue(p4, "Profile.SocialLinks.selfSocialLinks") or {}
	end)
	local v59 = not not v55 and (not not v57 and (not not Players.LocalPlayer and Players.LocalPlayer:GetUnder13()))
	local v60 = useLocalRobuxBalance()
	local v61 = p1.navigation.getParam("navigateToEditUsername")

	local function v62() -- line: 107
		-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), v43 (copy), NavigateDown (copy)
		local t1 = {{
			name = AppPage.PurchaseRobux
		}}

		if FFlagSignalsNavP3Dispatch then
			v26.down(v26.fromLegacyPage(t1[#t1]))

			return
		end

		v43(NavigateDown(t1))
	end

	local v63, v64 = React.useState("")

	useEffectOnMount(function() -- line: 123
		-- upvalues: v43 (copy), UsersNetworking (copy), v44 (copy), v64 (copy)
		v43(UsersNetworking.GetUserV2FromUserId.API(v44)):andThen(function(p5) -- line: 125
			-- upvalues: v64 (copy)
			v64(p5.responseBody.description or "")
		end):catch(function() -- line: 128
			-- upvalues: v64 (copy)
			v64("")
		end)
	end)

	local v65 = useAnalytics()
	local v66 = p1.navigation.getParam("onIdentityChange")
	local v67 = React.useCallback(function(p6) -- line: 136
		-- upvalues: v64 (copy), v66 (copy)
		v64(p6)

		if v66 then
			v66()
		end
	end, {
		v64,
		v66
	})
	local v68 = React.useCallback(function(p7) -- line: 143
		-- upvalues: v50 (copy), v66 (copy)
		v50(p7)

		if v66 then
			v66()
		end
	end, {
		v50,
		v66
	})
	local v69 = useUserExperiment({ FStringEditProfileToAvatarLayerName }, function(p8) -- line: 150
		-- upvalues: FStringEditProfileToAvatarLayerName (copy)
		return (p8[FStringEditProfileToAvatarLayerName] or {}).profile_picture_on
	end)

	useEffectOnMount(function() -- line: 155
		-- upvalues: v65 (copy), EventNames (copy), v43 (copy), UsersNetworking (copy), v44 (copy), v50 (copy), v55 (copy), v57 (copy), SocialLinksNetworking (copy)
		v65.fireAnalyticsEvent(EventNames.EditProfileOpened)
		v43(UsersNetworking.GetDisplayNameValidation.API(v44, "Test")):andThen(function(_) -- line: 160
			-- upvalues: v50 (copy)
			v50(true)
		end):catch(function(_) -- line: 163
		end)

		if v55 and v57 then
			v43(SocialLinksNetworking.GetSelfSocialLinks.API({
				alwaysReturnUrls = false,
				filterLink = false
			})):catch(function(_) -- line: 167
			end)
		end
	end)

	local v70 = SocialToast.useOpenToast()

	local function showToast(s3: string) -- line: 174
		-- upvalues: v70 (copy), Images (copy)
		v70({
			toastTitle = s3,
			iconImage = Images["icons/actions/accept"]
		})
	end

	local v72 = p1.testProp_openEditProfilePicture or function() -- line: 182
		-- upvalues: v65 (copy), EventNames (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), v43 (copy), NavigateToRoute (copy)
		v65.fireAnalyticsEvent(EventNames.OpenAvatarMarketplace)

		local t2 = {{
			name = AppPage.Catalog
		}}

		if FFlagSignalsNavP3Dispatch then
			v26.to(v26.fromLegacyPage(t2[#t2]))

			return
		end

		v43(NavigateToRoute(t2))
	end
	local v73 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { v44 },
		query = UserProfiles.Queries.userProfilesDisplayNameAndUsernameByUserIds
	})

	if v73.data then
		s1 = UserProfiles.Selectors.getUsernameFromId(v73.data, v44)
		s2 = UserProfiles.Selectors.getDisplayNameFromId(v73.data, v44)
		v47 = false
	end

	React.useEffect(function() -- line: 206
		-- upvalues: SocialStopwatch (copy), v65 (copy), EventNames (copy), LoadingStages (copy)
		local v89 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.EditProfileOpened)

		v65.fireAnalyticsEvent(EventNames.EditProfileLoadingStage, {
			status = LoadingStages.Fetching,
			statValue = v89 and v89.timeElapsed
		})

		return function() -- line: 213
			-- upvalues: SocialStopwatch (copy)
			SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.EditProfileOpened)
		end
	end, {})
	useEffectOnce(function() -- line: 218
		-- upvalues: SocialStopwatch (copy), v65 (copy), EventNames (copy), v73 (copy), LoadingStages (copy)
		local v90 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.EditProfileOpened)

		v65.fireAnalyticsEvent(EventNames.EditProfileLoadingStage, {
			status = if not v73.data then LoadingStages.Failed else LoadingStages.Done,
			statValue = v90 and v90.timeElapsed
		})
	end, v73.data or v73.error)

	local function onClose() -- line: 226
		-- upvalues: p1 (copy)
		p1.navigation.pop()
	end

	local v75 = FFlagAXEnableProfileTab and p1.navigation.getParam("fullBleed") == true

	local function openDisplayNameModal() -- line: 235
		-- upvalues: v65 (copy), EventNames (copy), v49 (copy), p1 (copy), v48 (copy), v68 (copy), s2 (ref)
		if v65 then
			v65.fireAnalyticsEvent(EventNames.DisplayNameModalOpened)
		end

		if v49 then
			p1.navigation.navigate(v48.EditDisplayNameModal, {
				setDisplayNameAvailable = v68,
				displayName = s2
			})

			return
		end

		p1.navigation.navigate(v48.EditDisplayNameErrorModal)
	end
	local function openEditUsername() -- line: 250
		-- upvalues: v65 (copy), EventNames (copy), v60 (copy), v61 (copy), showToast (copy), p1 (copy), v48 (copy), v62 (copy)
		v65.fireAnalyticsEvent(EventNames.EditUsernameOpened)

		if v60 >= 1000 then
			v61(showToast)

			return
		end

		p1.navigation.navigate(v48.UsernameInsufficientFundsModal, {
			robux = 1000 - v60,
			navigateDownToPurchaseRobux = v62
		})
	end
	local function openEditDescription() -- line: 264
		-- upvalues: p1 (copy), v48 (copy), v63 (copy), v67 (copy)
		p1.navigation.navigate(v48.EditDescriptionModal, {
			initialText = v63,
			setDescription = v67
		})
	end
	local function openEditSocialLinksModal(n1: number) -- line: 271
		-- upvalues: v55 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), v43 (copy), NavigateDown (copy)
		if v55 then
			local t3 = {
				name = AppPage.EditSocialNetworks,
				extraProps = {
					focusOn = n1
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v26.down(v26.fromLegacyPage(t3))

				return
			end

			v43(NavigateDown(t3))
		end
	end

	if FFlagEditProfileFixFocusNavigation then
		return (FocusNavigatorWrapper({
			onClose = onClose
		}, { React.createElement(EditProfileEntryPoint, {
			shouldShimmerName = v47,
			username = s1,
			displayName = s2,
			description = v63,
			localUserId = v44,
			onClose = onClose,
			openDisplayNameModal = openDisplayNameModal,
			navigateToEditUsername = openEditUsername,
			openEditDescription = openEditDescription,
			openEditProfilePicture = if not FFlagEditProfileNavigateToAvatar and not v69 then nil else v72,
			socialInfo = if not v55 or not v57 then nil else v58,
			openEditSocialLinksModal = if not v55 or not v57 then nil else openEditSocialLinksModal,
			isUnder13 = if not v55 or not v57 then nil else v59,
			canSeeInExperienceMode = not not FFlagMoveInExperienceModeToEditProfile and v51 ~= nil,
			isInExperienceNameEnabled = not not FFlagMoveInExperienceModeToEditProfile and isInExperienceNameEnabled,
			inExperienceName = if not FFlagMoveInExperienceModeToEditProfile then nil else inExperienceName,
			inExperienceNameExpirationTime = if not FFlagMoveInExperienceModeToEditProfile then nil else inExperienceNameExpirationTime,
			onToggleInExperienceMode = if not FFlagMoveInExperienceModeToEditProfile then nil else p1.navigation.getParam("onToggleInExperienceMode"),
			profileScreens = if not FFlagEditProfileBackgroundEnabled then nil else v48,
			fullBleed = v75
		}) }))
	end

	return React.createElement(EditProfileEntryPoint, {
		shouldShimmerName = v47,
		username = s1,
		displayName = s2,
		description = v63,
		localUserId = v44,
		onClose = onClose,
		openDisplayNameModal = openDisplayNameModal,
		navigateToEditUsername = openEditUsername,
		openEditDescription = openEditDescription,
		openEditProfilePicture = if not FFlagEditProfileNavigateToAvatar and not v69 then nil else v72,
		socialInfo = if not v55 or not v57 then nil else v58,
		openEditSocialLinksModal = if not v55 or not v57 then nil else openEditSocialLinksModal,
		isUnder13 = if not v55 or not v57 then nil else v59,
		canSeeInExperienceMode = not not FFlagMoveInExperienceModeToEditProfile and v51 ~= nil,
		isInExperienceNameEnabled = not not FFlagMoveInExperienceModeToEditProfile and isInExperienceNameEnabled,
		inExperienceName = if not FFlagMoveInExperienceModeToEditProfile then nil else inExperienceName,
		inExperienceNameExpirationTime = if not FFlagMoveInExperienceModeToEditProfile then nil else inExperienceNameExpirationTime,
		onToggleInExperienceMode = if not FFlagMoveInExperienceModeToEditProfile then nil else p1.navigation.getParam("onToggleInExperienceMode"),
		profileScreens = if not FFlagEditProfileBackgroundEnabled then nil else v48,
		fullBleed = v75
	})
end

return EditProfileEntryPointContainer
