local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local View = require(ProfilePlatformParent.Foundation).View
local Constants = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
local SocialIdentityContainer = require(ProfilePlatform.Components.UserProfileHeader.SocialIdentityContainer)
local ContextualInformation = require(ProfilePlatform.Components.UserProfileHeader.ContextualInformation)
local SocialChipCountsRowContainer = require(ProfilePlatform.Components.UserProfileHeader.SocialChipCountsRow).SocialChipCountsRowContainer
local UserProfileAvatar = require(ProfilePlatform.Components.UserProfileHeader.UserProfileAvatar)
local UserProfileSettingsToggle = require(ProfilePlatform.Components.UserProfileHeader.UserProfileSettingsToggle)
local AvatarHeadshotComponent = require(ProfilePlatform.Components.UserProfileHeader.AvatarHeadshotComponent)
local InspectAvatarTooltip = require(ProfilePlatform.Components.InspectAvatar.InspectAvatarTooltip)
local FFlagMoveInExperienceModeToEditProfile = require(ProfilePlatformParent.SharedFlags).FFlagMoveInExperienceModeToEditProfile
local v16 = game:DefineFastFlag("DisableStreamerModeToggle", false)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagSwitchProfileWidthHookToSocialCommon = SharedFlags.FFlagSwitchProfileWidthHookToSocialCommon
local FFlagAddPlatformNameToProfileHeader = SharedFlags.FFlagAddPlatformNameToProfileHeader
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useProfileCardWidth = require(ProfilePlatform.Hooks.useProfileCardWidth)
local useProfileCardWidth2 = require(ProfilePlatformParent.ProfilePlatformCommon).Hooks.useProfileCardWidth
local useShouldShowContextualInformation = require(ProfilePlatform.Hooks.useShouldShowContextualInformation)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useShouldResizeAvatar = require(ProfilePlatform.Hooks.useShouldResizeAvatar)
local FFlagProfilePlatformMeTabMobileProfileHero = SharedFlags.FFlagProfilePlatformMeTabMobileProfileHero
local Presence = require(ProfilePlatform.Rodux.Presence)
local convertPresenceEnum = require(ProfilePlatform.Utils.convertPresenceEnum)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local NetworkingPresence = require(ProfilePlatform.Networking.NetworkingPresence)
local FFlagSocialEnableProfileInspectAndBuy = require(ProfilePlatformParent.SharedFlags).FFlagSocialEnableProfileInspectAndBuy
local FFlagSocialEnableProfileInspectAndBuyAnalytics = require(ProfilePlatformParent.SharedFlags).FFlagSocialEnableProfileInspectAndBuyAnalytics
local FFlagEnableSocialTabsPage = require(ProfilePlatformParent.SharedFlags).FFlagEnableSocialTabsPage
local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local v38 = if not FFlagProfilePlatformPresenceStoreMigration then nil else require(ProfilePlatformParent.FriendsCommon).Hooks.useGetPresenceByUserId
local v39 = if not FFlagProfilePlatformPresenceStoreMigration then nil else require(ProfilePlatformParent.DataHydration).Presence.PresenceStore.get()
local useNavigation = require(ProfilePlatformParent.Navigation).useNavigation
local useLocalUserId = require(ProfilePlatformParent.RobloxAppHooks).useLocalUserId
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local t1 = {
	skipFetch = true
}

local function UserProfileHeader(p1) -- line: 80
	-- upvalues: FFlagSocialEnableProfileInspectAndBuy (copy), useLocalUserId (copy), useNavigation (copy), React (copy), FFlagSocialEnableProfileInspectAndBuyAnalytics (copy), useProfileAnalyticsContext (copy), useProfileWrapperContext (copy), EventNames (copy), Enums (copy), FFlagProfilePlatformNewProfileHeader (copy), useProfileFormFactor (copy), FFlagSwitchProfileWidthHookToSocialCommon (copy), useProfileCardWidth2 (copy), useProfileCardWidth (copy), FFlagProfilePlatformPresenceStoreMigration (copy), useEffectOnMount (copy), v39 (copy), v38 (copy), t1 (copy), convertPresenceEnum (copy), Presence (copy), useDispatch (copy), NetworkingPresence (copy), useSelector (copy), useShouldShowContextualInformation (copy), FFlagProfilePlatformMeTabMobileProfileHero (copy), useShouldResizeAvatar (copy), Constants (copy), View (copy), UserProfileAvatar (copy), InspectAvatarTooltip (copy), AvatarHeadshotComponent (copy), FFlagAddPlatformNameToProfileHeader (copy), ContextualInformation (copy), SocialChipCountsRowContainer (copy), FFlagEnableSocialTabsPage (copy), SocialIdentityContainer (copy), FFlagMoveInExperienceModeToEditProfile (copy), v16 (copy), UserProfileSettingsToggle (copy)
	local userThumbnail = p1.userThumbnail
	local v48 = nil
	local v49 = nil
	local v50 = nil
	local v51 = false
	local v52 = nil
	local v53 = if not FFlagSocialEnableProfileInspectAndBuy then nil else useLocalUserId()
	local v54 = if not FFlagSocialEnableProfileInspectAndBuy then nil else tostring(p1.userId) == tostring(v53)
	local v55 = if not FFlagSocialEnableProfileInspectAndBuy then nil else useNavigation()
	local v56 = if not FFlagSocialEnableProfileInspectAndBuy then nil else React.useRef(nil)
	local v57 = if not FFlagSocialEnableProfileInspectAndBuy then nil else React.useRef(nil)
	local v58 = if not FFlagSocialEnableProfileInspectAndBuyAnalytics then nil else useProfileAnalyticsContext()
	local v59 = if not FFlagSocialEnableProfileInspectAndBuyAnalytics then nil else useProfileWrapperContext().profileSessionId
	local v60 = if not FFlagSocialEnableProfileInspectAndBuy then nil else React.useCallback(function() -- line: 111
		-- upvalues: FFlagSocialEnableProfileInspectAndBuyAnalytics (copy), v58 (copy), EventNames (copy), v59 (copy), v57 (copy), v55 (copy), Enums (copy)
		if FFlagSocialEnableProfileInspectAndBuyAnalytics then
			v58.fireAnalyticsEvent(EventNames.InspectAvatarOpened, {
				profileSessionId = v59
			})
		end

		if v57.current then
			v57.current.onDismiss()
		end

		v55.navigate(Enums.Screens.InspectAvatarSheet)
	end, {
		v58,
		v59,
		v55,
		v57
	})

	if FFlagProfilePlatformNewProfileHeader then
		local v61 = useProfileFormFactor()

		v48 = v61.formFactor == Enums.ProfileFormFactor.PeekView

		local v62 = v61.formFactor == Enums.ProfileFormFactor.Wide
		local v63 = if not FFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth(v62) else useProfileCardWidth2()
		local profileId = useProfileWrapperContext().profileId

		if FFlagProfilePlatformPresenceStoreMigration then
			useEffectOnMount(function() -- line: 138
				-- upvalues: v39 (copy), profileId (copy)
				v39.RefreshPresenceByUserId((tostring(profileId)))
			end)

			local v65 = v38(profileId, t1)

			v52 = convertPresenceEnum(if not v65 then Presence.Enums.PresenceType.Offline else v65.userPresenceType, if not v65 or v65.universeId == "" then nil else tonumber(v65.universeId))
		else
			local v66 = useDispatch()

			useEffectOnMount(function() -- line: 149
				-- upvalues: v66 (copy), NetworkingPresence (copy), profileId (copy)
				v66(NetworkingPresence.GetPresencesFromUserIds.API({ profileId })):catch(function(_) -- line: 150
				end)
			end)

			local v67 = useSelector(function(p3) -- line: 153
				-- upvalues: Presence (copy), profileId (copy)
				return Presence.Selectors.getUserPresenceByUserId(p3, profileId) or {
					lastLocation = "",
					userPresenceType = Presence.Enums.PresenceType.Offline
				}
			end)

			v52 = convertPresenceEnum(v67.userPresenceType, v67.universeId)
		end

		v51 = useShouldShowContextualInformation(v52)

		local v68 = not not FFlagProfilePlatformMeTabMobileProfileHero and useShouldResizeAvatar()

		v49 = if not FFlagProfilePlatformMeTabMobileProfileHero or not v68 then v63 * 0.75 else v63 * (Constants.ME_TAB_MOBILE_AVATAR_HEIGHT_ASPECT + Constants.ME_TAB_MOBILE_TOP_BACKGROUND_INSET_RATIO)
		v50 = if not FFlagProfilePlatformMeTabMobileProfileHero or not v68 then nil else Enums.ProfileAvatarLayoutVariant.MeTabMobile
	end

	if FFlagProfilePlatformNewProfileHeader then
		return React.createElement(View, {
			tag = "col gap-large size-full-0 auto-y",
			BackgroundTransparency = 1,
			LayoutOrder = p1.layoutOrder
		}, {
			UserProfileAvatar = if not FFlagSocialEnableProfileInspectAndBuy or v54 then React.createElement(UserProfileAvatar, {
				layoutOrder = 1,
				userThumbnail = userThumbnail,
				userId = p1.userId,
				isPeekView = v48,
				height = v49,
				layoutVariant = v50
			}) else React.createElement("TextButton", {
				Size = UDim2.new(1, 0, 0, v49 or 0),
				BackgroundTransparency = 1,
				Text = "",
				LayoutOrder = 1,
				[React.Event.Activated] = v60
			}, {
				Avatar = React.createElement(UserProfileAvatar, {
					layoutOrder = 1,
					userThumbnail = userThumbnail,
					userId = p1.userId,
					isPeekView = v48,
					height = v49,
					layoutVariant = v50
				}),
				TooltipAnchor = React.createElement(View, {
					tag = "position-center-center anchor-center-center size-50",
					BackgroundTransparency = 1,
					ref = v56
				}),
				Tooltip = React.createElement(InspectAvatarTooltip, {
					anchorRef = v56,
					ref = v57
				})
			}),
			AvatarHeadshotContainer = React.createElement(View, {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				tag = {
					["size-full-0 auto-y"] = true
				}
			}, {
				AvatarHeadshotComponent = React.createElement(AvatarHeadshotComponent, {
					layoutOrder = 1,
					userId = tostring(p1.userId),
					primaryName = p1.primaryName,
					username = p1.username,
					userPresenceType = v52,
					isPremium = p1.isPremium,
					isVerified = p1.isVerified,
					isRobloxAdmin = p1.isRobloxAdmin,
					platformName = if not FFlagAddPlatformNameToProfileHeader then nil else p1.platformName
				})
			}),
			ContextualInformation = if not v51 then nil else React.createElement(ContextualInformation, {
				layoutOrder = 3,
				size = UDim2.fromScale(1, 0)
			}),
			SocialCountsRow = if not p1.shouldDisplayCounts then nil else React.createElement(SocialChipCountsRowContainer, {
				layoutOrder = 4,
				size = UDim2.fromScale(1, 0),
				title = if not FFlagEnableSocialTabsPage then nil else `@{ p1.username }`
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, Constants.USER_PROFILE_HEADER_HEIGHT),
		LayoutOrder = p1.layoutOrder
	}, {
		UserProfileAvatar = if not FFlagSocialEnableProfileInspectAndBuy or v54 then React.createElement(UserProfileAvatar, {
			userThumbnail = userThumbnail,
			userId = p1.userId
		}) else React.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			[React.Event.Activated] = v60
		}, {
			Avatar = React.createElement(UserProfileAvatar, {
				userThumbnail = userThumbnail,
				userId = p1.userId
			}),
			TooltipAnchor = React.createElement(View, {
				tag = "position-center-center anchor-center-center size-50",
				BackgroundTransparency = 1,
				ref = v56
			}),
			Tooltip = React.createElement(InspectAvatarTooltip, {
				anchorRef = v56,
				ref = v57
			})
		}),
		ProfileTextFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 10,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1)
		}, {
			UIListLayoutOrder = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 8)
			}),
			SocialIdentity = React.createElement(SocialIdentityContainer, {
				layoutOrder = 1,
				size = UDim2.fromScale(1, 0),
				primaryName = p1.primaryName,
				username = p1.username,
				isPremium = p1.isPremium,
				isVerified = p1.isVerified,
				isRobloxAdmin = p1.isRobloxAdmin,
				isEdited = p1.isEdited,
				openEditName = p1.openEditName,
				platformName = if not FFlagAddPlatformNameToProfileHeader then nil else p1.platformName
			}),
			UserProfileSettingsToggle = if FFlagMoveInExperienceModeToEditProfile or (v16 or not p1.shouldDisplayUserProfileSettings) then nil else React.createElement(UserProfileSettingsToggle, {
				layoutOrder = 2,
				size = UDim2.new(1, 0, 0, 30),
				isInExperienceNameEnabled = p1.isInExperienceNameEnabled
			}),
			ContextualInformation = React.createElement(ContextualInformation, {
				size = UDim2.fromScale(1, 0),
				layoutOrder = not FFlagMoveInExperienceModeToEditProfile and 3 or 2
			}),
			SocialCountsRow = if not p1.shouldDisplayCounts then nil else React.createElement(SocialChipCountsRowContainer, {
				size = UDim2.fromScale(1, 0),
				layoutOrder = not FFlagMoveInExperienceModeToEditProfile and 4 or 3,
				title = if not FFlagEnableSocialTabsPage then nil else `@{ p1.username }`
			})
		})
	})
end

return UserProfileHeader
