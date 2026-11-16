local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local InputUi = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/InputUi")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")

local useScreenSize = RobloxAppHooks.useScreenSize
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local ProfileTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfileTopBar")
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileScrollContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileScrollContext/useProfileScrollContext")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileCardWidth")
local useProfileCardWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatformCommon").Hooks.useProfileCardWidth
local getPeekViewOpenHeightByProfileType = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/getPeekViewOpenHeightByProfileType")
local getSafeAreaSize = InputUi.getSafeAreaSize
local useProfilePeekViewHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfilePeekViewHeight")
local useShouldShowContextualInformation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useShouldShowContextualInformation")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local Presence = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/Presence")
local module15 = require("@luauforge/bundled/fdi")
local convertPresenceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/convertPresenceEnum")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local ProfileModalView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfilePlatformViewAdaptor/ProfileModalView")
local ProfileFullView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfilePlatformViewAdaptor/ProfileFullView")
local ProfilePlatformPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfilePlatformPage")
local ProfilePeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfilePlatformViewAdaptor/ProfilePeekView")
local isPeekViewStateFullyOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/isPeekViewStateFullyOpen")
local fFlagProfileInspectAvatarSlideIn = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileInspectAvatarSlideIn
local fFlagProfileInspectAvatarShopChip = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileInspectAvatarShopChip
local fFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformNewProfileHeader

local fFlagSwitchProfileWidthHookToSocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSwitchProfileWidthHookToSocialCommon
local fFlagEnableMobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableMobileGameJoinCard

local FFlagProfilePlatformPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformPresenceStoreMigration")

local useGetPresenceByUserId = if FFlagProfilePlatformPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FriendsCommon").Hooks.useGetPresenceByUserId else nil

local v5 = if FFlagProfilePlatformPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration").Presence.PresenceStore.get() else nil

local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableSplitPane
local v6 = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SplitPane") else nil
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact").useSignalState

local v7 = { skipFetch = true }

return function(p2)
	local v8 = useProfileWrapperContext()
	local v9 = useProfileScrollContext()
	local profileType = v8.profileType
	local previousView = v8.navigateTo.previousView
	local v10 = useScreenSize()
	local v11 = useTopBarHeight()

	local v12 = if fFlagEnableMobileGameJoinCard then v8.mountAsFullView or false else false

	local v13 = React.useCallback(function()
		previousView(false)
	end, { previousView })

	local v14 = React.useCallback(function()
		previousView(true)
	end, { previousView })

	local v15 = useSelector(function(p3)
		return p3.GlobalGuiInset
	end)

	local v16 = useProfileFormFactor()
	local v17 = v16.formFactor == Enums.ProfileFormFactor.Wide
	local v18

	if fFlagEnableSplitPane then
		local v19 = useSignalState(v6.SplitPaneStore.getStore().getSupportPaneModeIfActive)
		v18 = not (v19 == nil) and v6.SplitPaneVariant.getProfileSplitPaneEligibility(v19) ~= nil
	else
		v18 = false
	end

	local v19 = React.useCallback(function()
		return React.createElement(ProfilePlatformPage, {})
	end, {})

	local v20 = fFlagEnableSplitPane and v18

	local v21 = React.useCallback(function()
		return React.createElement(ProfileTopBar, {
			navigateBack = v13,
			transparentBackground = true,
			backgroundTransparency = nil,
			hideNavigationButton = if fFlagEnableSplitPane then v20 else nil
		})
	end, fFlagEnableSplitPane and { v13, v20 } or {})

	local safeAreaSize = getSafeAreaSize(v10, v15)
	local v22

	if fFlagProfilePlatformNewProfileHeader then
		v22 = if fFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth() else module9(v17)
	else
		v22 = math.min(safeAreaSize.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH)
	end

	local v23

	if fFlagProfilePlatformNewProfileHeader then
		local profileId = v8.profileId
		local v24

		if FFlagProfilePlatformPresenceStoreMigration then
			useEffectOnMount(function()
				v5.RefreshPresenceByUserId((tostring(profileId)))
			end)
			local v25 = useGetPresenceByUserId(profileId, v7)

			local userPresenceType = v25 and v25.userPresenceType or Presence.Enums.PresenceType.Offline
			local v27 = if v25 and v25.universeId ~= "" then tonumber(v25.universeId) or nil else nil
			v24 = convertPresenceEnum(userPresenceType, v27)
		else
			local v25 = useDispatch()

			useEffectOnMount(function()
				v25(module15.GetPresencesFromUserIds.API({ profileId })):catch(function(p3) end)
			end)

			local v26 = useSelector(function(p3)
				return Presence.Selectors.getUserPresenceByUserId(p3, profileId)
					or {
						userPresenceType = Presence.Enums.PresenceType.Offline,
						lastLocation = ""
					}
			end)

			v24 = convertPresenceEnum(v26.userPresenceType, v26.universeId)
		end

		v23 = useProfilePeekViewHeight(v22, (useShouldShowContextualInformation(v24)))
	end

	if not fFlagProfilePlatformNewProfileHeader or profileType ~= Enums.ProfileTypes.User then
		v23 = getPeekViewOpenHeightByProfileType(profileType)
	end

	local udim = if safeAreaSize.Y.Offset - v11 < v23 then UDim.new(1, 0) else UDim.new(0, v23)

	if v16.isFullView then
		return React.createElement(ProfileFullView, {
			renderContent = v19,
			navigateBack = v13
		})
	end

	if v17 then
		return React.createElement(ProfileModalView, {
			renderContent = v19,
			renderTopBar = v21,
			topBarHeight = v11,
			viewWidth = v22,
			fillPane = v18,
			navigateBack = v13
		})
	end

	local createElement = React.createElement
	local v25 = {
		bottomDockedContainerHeight = 0,
		briefViewContentHeight = udim,
		contentSlot = v19(),
		fullViewContentHeight = UDim.new(1, 0),
		mountAsFullView = v12,
		onClosed = v14,
		onViewStateChanged = (fFlagProfileInspectAvatarSlideIn or fFlagProfileInspectAvatarShopChip) and function(p3)
			v9.setIsPeekViewFullyOpen(isPeekViewStateFullyOpen(p3))
		end or nil,
		topBarHeight = v11,
		topBarSlot = v21(),
		viewWidth = UDim.new(0, safeAreaSize.X.Offset),
		transitionPercentCallback = function(p3)
			v9.setPeekViewOpenPercent(p3)
		end,
		profileType = 0
	}

	if not fFlagProfilePlatformNewProfileHeader then
		profileType = nil
	end

	v25.profileType = profileType
	return createElement(ProfilePeekView, v25)
end
