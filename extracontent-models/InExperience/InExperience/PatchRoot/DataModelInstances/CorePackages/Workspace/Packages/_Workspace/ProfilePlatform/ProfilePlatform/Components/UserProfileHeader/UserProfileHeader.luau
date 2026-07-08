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
local useNavigation = require(ProfilePlatformParent.Navigation).useNavigation
local useLocalUserId = require(ProfilePlatformParent.RobloxAppHooks).useLocalUserId
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)

local function UserProfileHeader(p1) -- line: 68
	-- upvalues: FFlagSocialEnableProfileInspectAndBuy (copy), useLocalUserId (copy), useNavigation (copy), React (copy), FFlagSocialEnableProfileInspectAndBuyAnalytics (copy), useProfileAnalyticsContext (copy), useProfileWrapperContext (copy), EventNames (copy), Enums (copy), FFlagProfilePlatformNewProfileHeader (copy), useProfileFormFactor (copy), FFlagSwitchProfileWidthHookToSocialCommon (copy), useProfileCardWidth2 (copy), useProfileCardWidth (copy), useDispatch (copy), useEffectOnMount (copy), NetworkingPresence (copy), useSelector (copy), Presence (copy), convertPresenceEnum (copy), useShouldShowContextualInformation (copy), View (copy), UserProfileAvatar (copy), InspectAvatarTooltip (copy), AvatarHeadshotComponent (copy), FFlagAddPlatformNameToProfileHeader (copy), ContextualInformation (copy), SocialChipCountsRowContainer (copy), FFlagEnableSocialTabsPage (copy), Constants (copy), SocialIdentityContainer (copy), FFlagMoveInExperienceModeToEditProfile (copy), v16 (copy), UserProfileSettingsToggle (copy)
	local userThumbnail = p1.userThumbnail
	local v42 = nil
	local v43 = nil
	local v44 = false
	local v45 = nil
	local v46 = if not FFlagSocialEnableProfileInspectAndBuy then nil else useLocalUserId()
	local v47 = if not FFlagSocialEnableProfileInspectAndBuy then nil else tostring(p1.userId) == tostring(v46)
	local v48 = if not FFlagSocialEnableProfileInspectAndBuy then nil else useNavigation()
	local v49 = if not FFlagSocialEnableProfileInspectAndBuy then nil else React.useRef(nil)
	local v50 = if not FFlagSocialEnableProfileInspectAndBuy then nil else React.useRef(nil)
	local v51 = if not FFlagSocialEnableProfileInspectAndBuyAnalytics then nil else useProfileAnalyticsContext()
	local v52 = if not FFlagSocialEnableProfileInspectAndBuyAnalytics then nil else useProfileWrapperContext().profileSessionId
	local v53 = if not FFlagSocialEnableProfileInspectAndBuy then nil else React.useCallback(function() -- line: 98
		-- upvalues: FFlagSocialEnableProfileInspectAndBuyAnalytics (copy), v51 (copy), EventNames (copy), v52 (copy), v50 (copy), v48 (copy), Enums (copy)
		if FFlagSocialEnableProfileInspectAndBuyAnalytics then
			v51.fireAnalyticsEvent(EventNames.InspectAvatarOpened, {
				profileSessionId = v52
			})
		end

		if v50.current then
			v50.current.onDismiss()
		end

		v48.navigate(Enums.Screens.InspectAvatarSheet)
	end, {
		v51,
		v52,
		v48,
		v50
	})

	if FFlagProfilePlatformNewProfileHeader then
		local v54 = useProfileFormFactor()

		v42 = v54.formFactor == Enums.ProfileFormFactor.PeekView

		local v55 = v54.formFactor == Enums.ProfileFormFactor.Wide
		local v56 = if not FFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth(v55) else useProfileCardWidth2()
		local profileId = useProfileWrapperContext().profileId
		local v58 = useDispatch()

		useEffectOnMount(function() -- line: 125
			-- upvalues: v58 (copy), NetworkingPresence (copy), profileId (copy)
			v58(NetworkingPresence.GetPresencesFromUserIds.API({ profileId })):catch(function(_) -- line: 126
			end)
		end)

		local v59 = useSelector(function(p3) -- line: 129
			-- upvalues: Presence (copy), profileId (copy)
			return Presence.Selectors.getUserPresenceByUserId(p3, profileId) or {
				lastLocation = "",
				userPresenceType = Presence.Enums.PresenceType.Offline
			}
		end)

		v45 = convertPresenceEnum(v59.userPresenceType, v59.universeId)
		v44 = useShouldShowContextualInformation(v45)
		v43 = v56 * 0.75
	end

	if FFlagProfilePlatformNewProfileHeader then
		return React.createElement(View, {
			tag = "col gap-large size-full-0 auto-y",
			BackgroundTransparency = 1,
			LayoutOrder = p1.layoutOrder
		}, {
			UserProfileAvatar = if not FFlagSocialEnableProfileInspectAndBuy or v47 then React.createElement(UserProfileAvatar, {
				layoutOrder = 1,
				userThumbnail = userThumbnail,
				userId = p1.userId,
				isPeekView = v42,
				height = v43
			}) else React.createElement("TextButton", {
				Size = UDim2.new(1, 0, 0, v43 or 0),
				BackgroundTransparency = 1,
				Text = "",
				LayoutOrder = 1,
				[React.Event.Activated] = v53
			}, {
				Avatar = React.createElement(UserProfileAvatar, {
					layoutOrder = 1,
					userThumbnail = userThumbnail,
					userId = p1.userId,
					isPeekView = v42,
					height = v43
				}),
				TooltipAnchor = React.createElement(View, {
					tag = "position-center-center anchor-center-center size-50",
					BackgroundTransparency = 1,
					ref = v49
				}),
				Tooltip = React.createElement(InspectAvatarTooltip, {
					anchorRef = v49,
					ref = v50
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
					userPresenceType = v45,
					isPremium = p1.isPremium,
					isVerified = p1.isVerified,
					isRobloxAdmin = p1.isRobloxAdmin,
					platformName = if not FFlagAddPlatformNameToProfileHeader then nil else p1.platformName
				})
			}),
			ContextualInformation = if not v44 then nil else React.createElement(ContextualInformation, {
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
		UserProfileAvatar = if not FFlagSocialEnableProfileInspectAndBuy or v47 then React.createElement(UserProfileAvatar, {
			userThumbnail = userThumbnail,
			userId = p1.userId
		}) else React.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			[React.Event.Activated] = v53
		}, {
			Avatar = React.createElement(UserProfileAvatar, {
				userThumbnail = userThumbnail,
				userId = p1.userId
			}),
			TooltipAnchor = React.createElement(View, {
				tag = "position-center-center anchor-center-center size-50",
				BackgroundTransparency = 1,
				ref = v49
			}),
			Tooltip = React.createElement(InspectAvatarTooltip, {
				anchorRef = v49,
				ref = v50
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
