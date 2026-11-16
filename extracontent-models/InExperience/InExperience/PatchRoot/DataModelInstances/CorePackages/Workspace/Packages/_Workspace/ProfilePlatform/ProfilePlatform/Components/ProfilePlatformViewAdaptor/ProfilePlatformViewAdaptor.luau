local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local InputUi = require(parent.InputUi)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppHooks = require(parent.RobloxAppHooks)

local useScreenSize = RobloxAppHooks.useScreenSize
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local ProfileTopBar = require(ProfilePlatform.Components.ProfileTopBar)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileScrollContext = require(ProfilePlatform.Contexts.ProfileScrollContext.useProfileScrollContext)
local useProfileCardWidth = require(ProfilePlatform.Hooks.useProfileCardWidth)
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local useProfileCardWidth2 = ProfilePlatformCommon.Hooks.useProfileCardWidth
local getPeekViewOpenHeightByProfileType = require(ProfilePlatform.Utils.getPeekViewOpenHeightByProfileType)
local getSafeAreaSize = InputUi.getSafeAreaSize
local useProfilePeekViewHeight = require(ProfilePlatform.Hooks.useProfilePeekViewHeight)
local useShouldShowContextualInformation = require(ProfilePlatform.Hooks.useShouldShowContextualInformation)
local Constants = require(ProfilePlatform.Common.Constants)
local Presence = require(ProfilePlatform.Rodux.Presence)
local NetworkingPresence = require(ProfilePlatform.Networking.NetworkingPresence)
local convertPresenceEnum = require(ProfilePlatform.Utils.convertPresenceEnum)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local Enums = require(ProfilePlatform.Common.Enums)

local ProfileModalView = require(script.Parent.ProfileModalView)
local ProfileFullView = require(script.Parent.ProfileFullView)
local ProfilePlatformPage = require(ProfilePlatform.Components.ProfilePlatformPage)
local ProfilePeekView = require(script.Parent.ProfilePeekView)
local isPeekViewStateFullyOpen = require(ProfilePlatform.Utils.isPeekViewStateFullyOpen)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfileInspectAvatarSlideIn = SharedFlags.FFlagProfileInspectAvatarSlideIn
local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfileInspectAvatarShopChip = SharedFlags2.FFlagProfileInspectAvatarShopChip
local SharedFlags3 = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags3.FFlagProfilePlatformNewProfileHeader

local SharedFlags4 = require(parent.SharedFlags)
local FFlagSwitchProfileWidthHookToSocialCommon = SharedFlags4.FFlagSwitchProfileWidthHookToSocialCommon
local SharedFlags5 = require(parent.SharedFlags)
local FFlagEnableMobileGameJoinCard = SharedFlags5.FFlagEnableMobileGameJoinCard

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

local SharedFlags6 = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags6.FFlagEnableSplitPane
local SplitPane

if FFlagEnableSplitPane then
	SplitPane = require(parent.SplitPane)
else
	SplitPane = nil
end

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local v2 = { skipFetch = true }

return function(_)
	local v3 = useProfileWrapperContext()
	local v4 = useProfileScrollContext()
	local profileType = v3.profileType
	local previousView = v3.navigateTo.previousView
	local v5 = useScreenSize()
	local topBarHeight = useTopBarHeight()
	local mountAsFullView

	if FFlagEnableMobileGameJoinCard then
		mountAsFullView = v3.mountAsFullView or false
	else
		mountAsFullView = false
	end

	local navigateBack = React.useCallback(function()
		previousView(false)
	end, { previousView })

	local onClosed = React.useCallback(function()
		previousView(true)
	end, { previousView })

	local v6 = useSelector(function(p)
		return p.GlobalGuiInset
	end)

	local v7 = useProfileFormFactor()
	local v8 = v7.formFactor == Enums.ProfileFormFactor.Wide
	local fillPane

	if FFlagEnableSplitPane then
		local v9 = useSignalState(SplitPane.SplitPaneStore.getStore().getSupportPaneModeIfActive)

		if v9 == nil then
			fillPane = false
		else
			fillPane = SplitPane.SplitPaneVariant.getProfileSplitPaneEligibility(v9) ~= nil
		end
	else
		fillPane = false
	end

	local renderContent = React.useCallback(function()
		return React.createElement(ProfilePlatformPage, {})
	end, {})

	local v9 = FFlagEnableSplitPane and fillPane

	local renderTopBar = React.useCallback(function()
		local createElement = React.createElement
		local v10 = {
			navigateBack = navigateBack,
			transparentBackground = true,
			backgroundTransparency = nil,
			hideNavigationButton = nil
		}
		local hideNavigationButton

		if FFlagEnableSplitPane then
			hideNavigationButton = v9
		end

		v10.hideNavigationButton = hideNavigationButton
		return createElement(ProfileTopBar, v10)
	end, FFlagEnableSplitPane and { navigateBack, v9 } or {})

	local safeAreaSize = getSafeAreaSize(v5, v6)
	local viewWidth

	if FFlagProfilePlatformNewProfileHeader then
		if FFlagSwitchProfileWidthHookToSocialCommon then
			viewWidth = useProfileCardWidth2()
		else
			viewWidth = useProfileCardWidth(v8)
		end
	else
		viewWidth = math.min(safeAreaSize.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH)
	end

	local v10

	if FFlagProfilePlatformNewProfileHeader then
		local profileId = v3.profileId
		local v11

		if FFlagProfilePlatformPresenceStoreMigration then
			useEffectOnMount(function()
				v.RefreshPresenceByUserId((tostring(profileId)))
			end)
			local v12 = useGetPresenceByUserId(profileId, v2)

			local userPresenceType = v12 and v12.userPresenceType or Presence.Enums.PresenceType.Offline
			local v13

			if v12 and v12.universeId ~= "" then
				v13 = tonumber(v12.universeId) or nil
			end

			v11 = convertPresenceEnum(userPresenceType, v13)
		else
			local v12 = useDispatch()

			useEffectOnMount(function()
				v12(NetworkingPresence.GetPresencesFromUserIds.API({ profileId })):catch(function(_) end)
			end)

			local v13 = useSelector(function(p)
				return Presence.Selectors.getUserPresenceByUserId(p, profileId)
					or { userPresenceType = Presence.Enums.PresenceType.Offline, lastLocation = "" }
			end)

			v11 = convertPresenceEnum(v13.userPresenceType, v13.universeId)
		end

		v10 = useProfilePeekViewHeight(viewWidth, (useShouldShowContextualInformation(v11)))
	end

	if not FFlagProfilePlatformNewProfileHeader or profileType ~= Enums.ProfileTypes.User then
		v10 = getPeekViewOpenHeightByProfileType(profileType)
	end

	local udim

	if safeAreaSize.Y.Offset - topBarHeight < v10 then
		udim = UDim.new(1, 0)
	else
		udim = UDim.new(0, v10)
	end

	if v7.isFullView then
		return React.createElement(ProfileFullView, {
			renderContent = renderContent,
			navigateBack = navigateBack
		})
	end

	if v8 then
		return React.createElement(ProfileModalView, {
			renderContent = renderContent,
			renderTopBar = renderTopBar,
			topBarHeight = topBarHeight,
			viewWidth = viewWidth,
			fillPane = fillPane,
			navigateBack = navigateBack
		})
	end

	local createElement = React.createElement
	local v11 = {
		bottomDockedContainerHeight = 0,
		briefViewContentHeight = udim,
		contentSlot = renderContent(),
		fullViewContentHeight = UDim.new(1, 0),
		mountAsFullView = mountAsFullView,
		onClosed = onClosed,
		onViewStateChanged = (FFlagProfileInspectAvatarSlideIn or FFlagProfileInspectAvatarShopChip) and function(p)
			v4.setIsPeekViewFullyOpen(isPeekViewStateFullyOpen(p))
		end or nil,
		topBarHeight = topBarHeight,
		topBarSlot = renderTopBar(),
		viewWidth = UDim.new(0, safeAreaSize.X.Offset),
		transitionPercentCallback = function(p: number)
			v4.setPeekViewOpenPercent(p)
		end,
		profileType = 0
	}

	if not FFlagProfilePlatformNewProfileHeader then
		profileType = nil
	end

	v11.profileType = profileType
	return createElement(ProfilePeekView, v11)
end
