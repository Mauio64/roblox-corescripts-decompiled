local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").View

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local SocialIdentityContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/SocialIdentityContainer")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/ContextualInformation")

local socialChipCountsRowContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/SocialChipCountsRow").SocialChipCountsRowContainer
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/UserProfileAvatar")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/UserProfileSettingsToggle")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/AvatarHeadshotComponent")
local InspectAvatarTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/InspectAvatarTooltip")

local fFlagMoveInExperienceModeToEditProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagMoveInExperienceModeToEditProfile
local defineFastFlag = game:DefineFastFlag("DisableStreamerModeToggle", false)
local fFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local fFlagSwitchProfileWidthHookToSocialCommon = SharedFlags.FFlagSwitchProfileWidthHookToSocialCommon
local fFlagAddPlatformNameToProfileHeader = SharedFlags.FFlagAddPlatformNameToProfileHeader
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileCardWidth")
local useProfileCardWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatformCommon").Hooks.useProfileCardWidth
local useShouldShowContextualInformation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useShouldShowContextualInformation")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useShouldResizeAvatar = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useShouldResizeAvatar")
local fFlagProfilePlatformMeTabMobileProfileHero = SharedFlags.FFlagProfilePlatformMeTabMobileProfileHero
local Presence = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/Presence")
local convertPresenceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/convertPresenceEnum")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local module19 = require("@luauforge/bundled/fdi")
local fFlagSocialEnableProfileInspectAndBuy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSocialEnableProfileInspectAndBuy
local FFlagProfileInspectAvatarCWEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAvatarCWEntry")

local fFlagSocialEnableProfileInspectAndBuyAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSocialEnableProfileInspectAndBuyAnalytics
local fFlagEnableSocialTabsPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableSocialTabsPage

local FFlagProfilePlatformPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformPresenceStoreMigration")

local useGetPresenceByUserId = if FFlagProfilePlatformPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FriendsCommon").Hooks.useGetPresenceByUserId else nil

local v5 = if FFlagProfilePlatformPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration").Presence.PresenceStore.get() else nil

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useLocalUserId
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")

local v6 = { skipFetch = true }

local function UserProfileHeader(props)
	local userThumbnail = props.userThumbnail
	local v7 = nil
	local v8 = nil
	local meTabMobile = nil
	local v9 = false
	local v10 = nil
	local v11 = if fFlagSocialEnableProfileInspectAndBuy then useLocalUserId() else nil
	local v12

	if fFlagSocialEnableProfileInspectAndBuy then
		v12 = tostring(props.userId) == tostring(v11)
	end

	local v13 = if fFlagSocialEnableProfileInspectAndBuy then useNavigation() else nil

	local ref = if fFlagSocialEnableProfileInspectAndBuy then React.useRef(nil) else nil

	local ref2 = if fFlagSocialEnableProfileInspectAndBuy then React.useRef(nil) else nil

	local v14 = if fFlagSocialEnableProfileInspectAndBuyAnalytics then useProfileAnalyticsContext() else nil
	local profileSessionId

	if fFlagSocialEnableProfileInspectAndBuyAnalytics then
		profileSessionId = useProfileWrapperContext().profileSessionId
	else
		profileSessionId = nil
	end

	local v15

	if fFlagSocialEnableProfileInspectAndBuy then
		v15 = React.useCallback(function()
			if fFlagSocialEnableProfileInspectAndBuyAnalytics then
				v14.fireAnalyticsEvent(EventNames.InspectAvatarOpened, {
					profileSessionId = profileSessionId
				})
			end

			if ref2.current then
				ref2.current.onDismiss()
			end

			v13.navigate(Enums.Screens.InspectAvatarSheet)
		end, { v14, profileSessionId, v13, ref2 })
	end

	if fFlagProfilePlatformNewProfileHeader then
		local v16 = useProfileFormFactor()
		v7 = v16.formFactor == Enums.ProfileFormFactor.PeekView

		local v17 = v16.formFactor == Enums.ProfileFormFactor.Wide

		local v18 = if fFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth() else module12(v17)

		local profileId = useProfileWrapperContext().profileId

		if FFlagProfilePlatformPresenceStoreMigration then
			useEffectOnMount(function()
				v5.RefreshPresenceByUserId((tostring(profileId)))
			end)
			local v19 = useGetPresenceByUserId(profileId, v6)

			local v21 = if v19 then v19.userPresenceType else Presence.Enums.PresenceType.Offline
			local v22 = if v19 and v19.universeId ~= "" then tonumber(v19.universeId) else nil
			v10 = convertPresenceEnum(v21, v22)
		else
			local v19 = useDispatch()

			useEffectOnMount(function()
				v19(module19.GetPresencesFromUserIds.API({ profileId })):catch(function(p2) end)
			end)

			local v20 = useSelector(function(p2)
				return Presence.Selectors.getUserPresenceByUserId(p2, profileId)
					or {
						userPresenceType = Presence.Enums.PresenceType.Offline,
						lastLocation = ""
					}
			end)

			v10 = convertPresenceEnum(v20.userPresenceType, v20.universeId)
		end

		v9 = useShouldShowContextualInformation(v10)

		local v19 = if fFlagProfilePlatformMeTabMobileProfileHero then useShouldResizeAvatar() else false

		if fFlagProfilePlatformMeTabMobileProfileHero and v19 then
			v8 = v18 * (Constants.ME_TAB_MOBILE_AVATAR_HEIGHT_ASPECT + Constants.ME_TAB_MOBILE_TOP_BACKGROUND_INSET_RATIO)
		else
			v8 = v18 * 0.75
		end

		if fFlagProfilePlatformMeTabMobileProfileHero and v19 then
			meTabMobile = Enums.ProfileAvatarLayoutVariant.MeTabMobile
		end
	end

	if fFlagProfilePlatformNewProfileHeader then
		local createElement = React.createElement
		local v17 = {
			tag = "col gap-large size-full-0 auto-y",
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		}
		local v19

		if fFlagSocialEnableProfileInspectAndBuy and not v12 then
			local createElement2 = React.createElement
			local v21 = {
				Size = UDim2.new(1, 0, 0, v8 or 0),
				BackgroundTransparency = 1,
				Text = "",
				LayoutOrder = 1,
				[React.Event.Activated] = v15
			}
			local v22 = {
				Avatar = React.createElement(module7, {
					userThumbnail = userThumbnail,
					userId = props.userId,
					isPeekView = v7,
					height = v8,
					layoutVariant = meTabMobile,
					layoutOrder = 1
				}),
				TooltipAnchor = 0,
				Tooltip = 0
			}

			local v23 = if not FFlagProfileInspectAvatarCWEntry then React.createElement(view, {
				tag = "position-center-center anchor-center-center size-50",
				BackgroundTransparency = 1,
				ref = ref
			}) else nil
			v22.TooltipAnchor = v23

			local v24 = if not FFlagProfileInspectAvatarCWEntry then React.createElement(InspectAvatarTooltip, {
				anchorRef = ref,
				ref = ref2
			}) else nil
			v22.Tooltip = v24
			v19 = createElement2("TextButton", v21, v22)
		else
			v19 = React.createElement(module7, {
				userThumbnail = userThumbnail,
				userId = props.userId,
				isPeekView = v7,
				height = v8,
				layoutVariant = meTabMobile,
				layoutOrder = 1
			})
		end

		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v24 = {
			layoutOrder = 1,
			userId = tostring(props.userId),
			primaryName = props.primaryName,
			username = props.username,
			userPresenceType = v10,
			isPremium = props.isPremium,
			isVerified = props.isVerified,
			isRobloxAdmin = props.isRobloxAdmin,
			platformName = 0
		}
		local v25 = if fFlagAddPlatformNameToProfileHeader then props.platformName else nil
		v24.platformName = v25
		local v18 = {
			UserProfileAvatar = v19,
			AvatarHeadshotContainer = createElement2(view, {
				tag = { ["size-full-0 auto-y"] = true },
				BackgroundTransparency = 1,
				LayoutOrder = 2
			}, { AvatarHeadshotComponent = createElement3(module9, v24) }),
			ContextualInformation = 0,
			SocialCountsRow = 0
		}

		local v26 = if v9 then React.createElement(module6, {
			size = UDim2.fromScale(1, 0),
			layoutOrder = 3
		}) else nil
		v18.ContextualInformation = v26
		local v27

		if props.shouldDisplayCounts then
			local createElement4 = React.createElement
			local v29 = { size = UDim2.fromScale(1, 0), layoutOrder = 4, title = 0 }

			local v30 = if fFlagEnableSocialTabsPage then `@{props.username}` else nil
			v29.title = v30
			v27 = createElement4(socialChipCountsRowContainer, v29)
		end

		v18.SocialCountsRow = v27
		return createElement(view, v17, v18)
	else
		local createElement = React.createElement
		local v17 = {
			Size = UDim2.new(1, 0, 0, Constants.USER_PROFILE_HEADER_HEIGHT),
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		}
		local v19

		if fFlagSocialEnableProfileInspectAndBuy and not v12 then
			local createElement2 = React.createElement
			local v21 = {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",
				[React.Event.Activated] = v15
			}
			local v22 = {
				Avatar = React.createElement(module7, {
					userThumbnail = userThumbnail,
					userId = props.userId
				}),
				TooltipAnchor = 0,
				Tooltip = 0
			}

			local v23 = if not FFlagProfileInspectAvatarCWEntry then React.createElement(view, {
				tag = "position-center-center anchor-center-center size-50",
				BackgroundTransparency = 1,
				ref = ref
			}) else nil
			v22.TooltipAnchor = v23

			local v24 = if not FFlagProfileInspectAvatarCWEntry then React.createElement(InspectAvatarTooltip, {
				anchorRef = ref,
				ref = ref2
			}) else nil
			v22.Tooltip = v24
			v19 = createElement2("TextButton", v21, v22)
		else
			v19 = React.createElement(module7, {
				userThumbnail = userThumbnail,
				userId = props.userId
			})
		end

		local createElement2 = React.createElement
		local v21 = {
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
		local v23 = {
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
		local v24 = if fFlagAddPlatformNameToProfileHeader then props.platformName else nil
		v23.platformName = v24
		children.SocialIdentity = createElement3(SocialIdentityContainer, v23)

		local v25 = if not (fFlagMoveInExperienceModeToEditProfile or defineFastFlag or not props.shouldDisplayUserProfileSettings) then React.createElement(module8, {
			size = UDim2.new(1, 0, 0, 30),
			layoutOrder = 2,
			isInExperienceNameEnabled = props.isInExperienceNameEnabled
		}) else nil
		children.UserProfileSettingsToggle = v25

		children.ContextualInformation = React.createElement(module6, {
			size = UDim2.fromScale(1, 0),
			layoutOrder = fFlagMoveInExperienceModeToEditProfile and 2 or 3
		})
		local v26

		if props.shouldDisplayCounts then
			local createElement4 = React.createElement
			local v28 = {
				size = UDim2.fromScale(1, 0),
				layoutOrder = fFlagMoveInExperienceModeToEditProfile and 3 or 4,
				title = 0
			}

			local v29 = if fFlagEnableSocialTabsPage then `@{props.username}` else nil
			v28.title = v29
			v26 = createElement4(socialChipCountsRowContainer, v28)
		end

		children.SocialCountsRow = v26
		return createElement("Frame", v17, {
			UserProfileAvatar = v19,
			ProfileTextFrame = createElement2("Frame", v21, children)
		})
	end
end

return UserProfileHeader
