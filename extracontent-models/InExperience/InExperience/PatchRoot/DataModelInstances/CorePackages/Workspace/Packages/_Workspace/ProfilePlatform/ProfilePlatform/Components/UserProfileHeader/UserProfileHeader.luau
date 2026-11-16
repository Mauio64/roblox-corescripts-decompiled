local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Foundation = require(parent.Foundation)

local View = Foundation.View

local Constants = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
local SocialIdentityContainer = require(ProfilePlatform.Components.UserProfileHeader.SocialIdentityContainer)
local ContextualInformation = require(ProfilePlatform.Components.UserProfileHeader.ContextualInformation)

local SocialChipCountsRow = require(ProfilePlatform.Components.UserProfileHeader.SocialChipCountsRow)
local SocialChipCountsRowContainer = SocialChipCountsRow.SocialChipCountsRowContainer
local UserProfileAvatar = require(ProfilePlatform.Components.UserProfileHeader.UserProfileAvatar)
local UserProfileSettingsToggle = require(ProfilePlatform.Components.UserProfileHeader.UserProfileSettingsToggle)
local AvatarHeadshotComponent = require(ProfilePlatform.Components.UserProfileHeader.AvatarHeadshotComponent)
local InspectAvatarTooltip = require(ProfilePlatform.Components.InspectAvatar.InspectAvatarTooltip)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagMoveInExperienceModeToEditProfile = SharedFlags2.FFlagMoveInExperienceModeToEditProfile
local defineFastFlag = game:DefineFastFlag("DisableStreamerModeToggle", false)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagSwitchProfileWidthHookToSocialCommon = SharedFlags.FFlagSwitchProfileWidthHookToSocialCommon
local FFlagAddPlatformNameToProfileHeader = SharedFlags.FFlagAddPlatformNameToProfileHeader
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useProfileCardWidth = require(ProfilePlatform.Hooks.useProfileCardWidth)
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local useProfileCardWidth2 = ProfilePlatformCommon.Hooks.useProfileCardWidth
local useShouldShowContextualInformation = require(ProfilePlatform.Hooks.useShouldShowContextualInformation)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useShouldResizeAvatar = require(ProfilePlatform.Hooks.useShouldResizeAvatar)
local FFlagProfilePlatformMeTabMobileProfileHero = SharedFlags.FFlagProfilePlatformMeTabMobileProfileHero
local Presence = require(ProfilePlatform.Rodux.Presence)
local convertPresenceEnum = require(ProfilePlatform.Utils.convertPresenceEnum)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local NetworkingPresence = require(ProfilePlatform.Networking.NetworkingPresence)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuy = SharedFlags3.FFlagSocialEnableProfileInspectAndBuy
local FFlagProfileInspectAvatarCWEntry = require(ProfilePlatform.Flags.FFlagProfileInspectAvatarCWEntry)

local SharedFlags4 = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuyAnalytics = SharedFlags4.FFlagSocialEnableProfileInspectAndBuyAnalytics
local SharedFlags5 = require(parent.SharedFlags)
local FFlagEnableSocialTabsPage = SharedFlags5.FFlagEnableSocialTabsPage

local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local useGetPresenceByUserId

if FFlagProfilePlatformPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local v

if FFlagProfilePlatformPresenceStoreMigration then
	local DataHydration = require(parent.DataHydration)
	v = DataHydration.Presence.PresenceStore.get()
else
	v = nil
end

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)

local v2 = { skipFetch = true }

local function UserProfileHeader(props)
	local userThumbnail = props.userThumbnail
	local isPeekView = nil
	local height = nil
	local meTabMobile = nil
	local v3 = false
	local userPresenceType = nil
	local v4

	if FFlagSocialEnableProfileInspectAndBuy then
		v4 = useLocalUserId()
	end

	local v5

	if FFlagSocialEnableProfileInspectAndBuy then
		v5 = tostring(props.userId) == tostring(v4)
	end

	local v6

	if FFlagSocialEnableProfileInspectAndBuy then
		v6 = useNavigation()
	else
		v6 = nil
	end

	local ref

	if FFlagSocialEnableProfileInspectAndBuy then
		ref = React.useRef(nil)
	end

	local ref2

	if FFlagSocialEnableProfileInspectAndBuy then
		ref2 = React.useRef(nil)
	else
		ref2 = nil
	end

	local v7

	if FFlagSocialEnableProfileInspectAndBuyAnalytics then
		v7 = useProfileAnalyticsContext()
	else
		v7 = nil
	end

	local profileSessionId

	if FFlagSocialEnableProfileInspectAndBuyAnalytics then
		profileSessionId = useProfileWrapperContext().profileSessionId
	else
		profileSessionId = nil
	end

	local v8

	if FFlagSocialEnableProfileInspectAndBuy then
		v8 = React.useCallback(function()
			if FFlagSocialEnableProfileInspectAndBuyAnalytics then
				v7.fireAnalyticsEvent(EventNames.InspectAvatarOpened, {
					profileSessionId = profileSessionId
				})
			end

			if ref2.current then
				ref2.current.onDismiss()
			end

			v6.navigate(Enums.Screens.InspectAvatarSheet)
		end, { v7, profileSessionId, v6, ref2 })
	end

	if FFlagProfilePlatformNewProfileHeader then
		local v9 = useProfileFormFactor()
		isPeekView = v9.formFactor == Enums.ProfileFormFactor.PeekView

		local v10 = v9.formFactor == Enums.ProfileFormFactor.Wide
		local v11

		if FFlagSwitchProfileWidthHookToSocialCommon then
			v11 = useProfileCardWidth2()
		else
			v11 = useProfileCardWidth(v10)
		end

		local profileId = useProfileWrapperContext().profileId

		if FFlagProfilePlatformPresenceStoreMigration then
			useEffectOnMount(function()
				v.RefreshPresenceByUserId((tostring(profileId)))
			end)
			local v12 = useGetPresenceByUserId(profileId, v2)
			local v13

			if v12 then
				v13 = v12.userPresenceType
			else
				v13 = Presence.Enums.PresenceType.Offline
			end

			local v14

			if v12 and v12.universeId ~= "" then
				v14 = tonumber(v12.universeId)
			end

			userPresenceType = convertPresenceEnum(v13, v14)
		else
			local v12 = useDispatch()

			useEffectOnMount(function()
				v12(NetworkingPresence.GetPresencesFromUserIds.API({ profileId })):catch(function(_) end)
			end)

			local v13 = useSelector(function(p)
				return Presence.Selectors.getUserPresenceByUserId(p, profileId)
					or { userPresenceType = Presence.Enums.PresenceType.Offline, lastLocation = "" }
			end)

			userPresenceType = convertPresenceEnum(v13.userPresenceType, v13.universeId)
		end

		v3 = useShouldShowContextualInformation(userPresenceType)
		local v12

		if FFlagProfilePlatformMeTabMobileProfileHero then
			v12 = useShouldResizeAvatar()
		else
			v12 = false
		end

		if FFlagProfilePlatformMeTabMobileProfileHero and v12 then
			height = v11 * (Constants.ME_TAB_MOBILE_AVATAR_HEIGHT_ASPECT + Constants.ME_TAB_MOBILE_TOP_BACKGROUND_INSET_RATIO)
		else
			height = v11 * 0.75
		end

		if FFlagProfilePlatformMeTabMobileProfileHero and v12 then
			meTabMobile = Enums.ProfileAvatarLayoutVariant.MeTabMobile
		end
	end

	if FFlagProfilePlatformNewProfileHeader then
		local createElement = React.createElement
		local v9 = {
			tag = "col gap-large size-full-0 auto-y",
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		}
		local userProfileAvatar

		if FFlagSocialEnableProfileInspectAndBuy and not v5 then
			local createElement2 = React.createElement
			local v10 = {
				Size = UDim2.new(1, 0, 0, height or 0),
				BackgroundTransparency = 1,
				Text = "",
				LayoutOrder = 1,
				[React.Event.Activated] = v8
			}
			local v11 = {
				Avatar = React.createElement(UserProfileAvatar, {
					userThumbnail = userThumbnail,
					userId = props.userId,
					isPeekView = isPeekView,
					height = height,
					layoutVariant = meTabMobile,
					layoutOrder = 1
				}),
				TooltipAnchor = 0,
				Tooltip = 0
			}
			local tooltipAnchor

			if not FFlagProfileInspectAvatarCWEntry then
				tooltipAnchor = React.createElement(View, {
					tag = "position-center-center anchor-center-center size-50",
					BackgroundTransparency = 1,
					ref = ref
				})
			end

			v11.TooltipAnchor = tooltipAnchor
			local tooltip

			if not FFlagProfileInspectAvatarCWEntry then
				tooltip = React.createElement(InspectAvatarTooltip, { anchorRef = ref, ref = ref2 })
			end

			v11.Tooltip = tooltip
			userProfileAvatar = createElement2("TextButton", v10, v11)
		else
			userProfileAvatar = React.createElement(UserProfileAvatar, {
				userThumbnail = userThumbnail,
				userId = props.userId,
				isPeekView = isPeekView,
				height = height,
				layoutVariant = meTabMobile,
				layoutOrder = 1
			})
		end

		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v10 = {
			layoutOrder = 1,
			userId = tostring(props.userId),
			primaryName = props.primaryName,
			username = props.username,
			userPresenceType = userPresenceType,
			isPremium = props.isPremium,
			isVerified = props.isVerified,
			isRobloxAdmin = props.isRobloxAdmin,
			platformName = 0
		}
		local platformName

		if FFlagAddPlatformNameToProfileHeader then
			platformName = props.platformName
		end

		v10.platformName = platformName
		local v11 = {
			UserProfileAvatar = userProfileAvatar,
			AvatarHeadshotContainer = createElement2(View, {
				tag = { ["size-full-0 auto-y"] = true },
				BackgroundTransparency = 1,
				LayoutOrder = 2
			}, {
				AvatarHeadshotComponent = createElement3(AvatarHeadshotComponent, v10)
			}),
			ContextualInformation = 0,
			SocialCountsRow = 0
		}
		local contextualInformation

		if v3 then
			contextualInformation = React.createElement(ContextualInformation, {
				size = UDim2.fromScale(1, 0),
				layoutOrder = 3
			})
		end

		v11.ContextualInformation = contextualInformation
		local socialCountsRow

		if props.shouldDisplayCounts then
			local createElement4 = React.createElement
			local v12 = { size = UDim2.fromScale(1, 0), layoutOrder = 4, title = 0 }
			local title

			if FFlagEnableSocialTabsPage then
				title = `@{props.username}`
			end

			v12.title = title
			socialCountsRow = createElement4(SocialChipCountsRowContainer, v12)
		end

		v11.SocialCountsRow = socialCountsRow
		return createElement(View, v9, v11)
	else
		local createElement = React.createElement
		local v9 = {
			Size = UDim2.new(1, 0, 0, Constants.USER_PROFILE_HEADER_HEIGHT),
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		}
		local userProfileAvatar

		if FFlagSocialEnableProfileInspectAndBuy and not v5 then
			local createElement2 = React.createElement
			local v10 = {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",
				[React.Event.Activated] = v8
			}
			local v11 = {
				Avatar = React.createElement(UserProfileAvatar, {
					userThumbnail = userThumbnail,
					userId = props.userId
				}),
				TooltipAnchor = 0,
				Tooltip = 0
			}
			local tooltipAnchor

			if not FFlagProfileInspectAvatarCWEntry then
				tooltipAnchor = React.createElement(View, {
					tag = "position-center-center anchor-center-center size-50",
					BackgroundTransparency = 1,
					ref = ref
				})
			end

			v11.TooltipAnchor = tooltipAnchor
			local tooltip

			if not FFlagProfileInspectAvatarCWEntry then
				tooltip = React.createElement(InspectAvatarTooltip, { anchorRef = ref, ref = ref2 })
			end

			v11.Tooltip = tooltip
			userProfileAvatar = createElement2("TextButton", v10, v11)
		else
			userProfileAvatar = React.createElement(UserProfileAvatar, {
				userThumbnail = userThumbnail,
				userId = props.userId
			})
		end

		local createElement2 = React.createElement
		local v10 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			ZIndex = 10
		}

		local children = {
			UIListLayoutOrder = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 8)
			}),
			SocialIdentity = 0,
			UserProfileSettingsToggle = 0,
			ContextualInformation = 0,
			SocialCountsRow = 0
		}

		local createElement3 = React.createElement
		local v11 = {
			size = UDim2.fromScale(1, 0),
			layoutOrder = 1,
			primaryName = props.primaryName,
			username = props.username,
			isPremium = props.isPremium,
			isVerified = props.isVerified,
			isRobloxAdmin = props.isRobloxAdmin,
			isEdited = props.isEdited,
			openEditName = props.openEditName,
			platformName = 0
		}
		local platformName

		if FFlagAddPlatformNameToProfileHeader then
			platformName = props.platformName
		end

		v11.platformName = platformName
		children.SocialIdentity = createElement3(SocialIdentityContainer, v11)
		local userProfileSettingsToggle

		if not (FFlagMoveInExperienceModeToEditProfile or defineFastFlag or not props.shouldDisplayUserProfileSettings) then
			userProfileSettingsToggle = React.createElement(UserProfileSettingsToggle, {
				size = UDim2.new(1, 0, 0, 30),
				layoutOrder = 2,
				isInExperienceNameEnabled = props.isInExperienceNameEnabled
			})
		end

		children.UserProfileSettingsToggle = userProfileSettingsToggle

		children.ContextualInformation = React.createElement(ContextualInformation, {
			size = UDim2.fromScale(1, 0),
			layoutOrder = FFlagMoveInExperienceModeToEditProfile and 2 or 3
		})
		local socialCountsRow

		if props.shouldDisplayCounts then
			local createElement4 = React.createElement
			local v12 = {
				size = UDim2.fromScale(1, 0),
				layoutOrder = FFlagMoveInExperienceModeToEditProfile and 3 or 4,
				title = 0
			}
			local title

			if FFlagEnableSocialTabsPage then
				title = `@{props.username}`
			end

			v12.title = title
			socialCountsRow = createElement4(SocialChipCountsRowContainer, v12)
		end

		children.SocialCountsRow = socialCountsRow
		return createElement("Frame", v9, {
			UserProfileAvatar = userProfileAvatar,
			ProfileTextFrame = createElement2("Frame", v10, children)
		})
	end
end

return UserProfileHeader
