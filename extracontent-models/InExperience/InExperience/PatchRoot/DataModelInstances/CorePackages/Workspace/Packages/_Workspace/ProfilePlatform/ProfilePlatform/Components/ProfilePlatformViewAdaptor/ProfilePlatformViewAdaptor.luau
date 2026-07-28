local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local InputUi = require(ProfilePlatformParent.InputUi)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local RobloxAppHooks = require(ProfilePlatformParent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local ProfileTopBar = require(ProfilePlatform.Components.ProfileTopBar)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileScrollContext = require(ProfilePlatform.Contexts.ProfileScrollContext.useProfileScrollContext)
local useProfileCardWidth = require(ProfilePlatform.Hooks.useProfileCardWidth)
local useProfileCardWidth2 = require(ProfilePlatformParent.ProfilePlatformCommon).Hooks.useProfileCardWidth
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
local FFlagProfilePlatformNewProfileHeader = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local FFlagSwitchProfileWidthHookToSocialCommon = require(ProfilePlatformParent.SharedFlags).FFlagSwitchProfileWidthHookToSocialCommon
local FFlagEnableMobileGameJoinCard = require(ProfilePlatformParent.SharedFlags).FFlagEnableMobileGameJoinCard
local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local v35 = if not FFlagProfilePlatformPresenceStoreMigration then nil else require(ProfilePlatformParent.FriendsCommon).Hooks.useGetPresenceByUserId
local v36 = if not FFlagProfilePlatformPresenceStoreMigration then nil else require(ProfilePlatformParent.DataHydration).Presence.PresenceStore.get()
local FFlagEnableSplitPane = require(ProfilePlatformParent.SharedFlags).FFlagEnableSplitPane
local v38 = if not FFlagEnableSplitPane then nil else require(ProfilePlatformParent.SplitPane).SplitPaneStore
local useSignalState = require(ProfilePlatformParent.SignalsReact).useSignalState
local t1 = {
	skipFetch = true
}

return function(_: {[any]: any}) -- line: 56
	-- upvalues: useProfileWrapperContext (copy), useProfileScrollContext (copy), useScreenSize (copy), useTopBarHeight (copy), FFlagEnableMobileGameJoinCard (copy), React (copy), useSelector (copy), useProfileFormFactor (copy), Enums (copy), FFlagEnableSplitPane (copy), useSignalState (copy), v38 (copy), ProfilePlatformPage (copy), ProfileTopBar (copy), getSafeAreaSize (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagSwitchProfileWidthHookToSocialCommon (copy), useProfileCardWidth2 (copy), useProfileCardWidth (copy), Constants (copy), FFlagProfilePlatformPresenceStoreMigration (copy), useEffectOnMount (copy), v36 (copy), v35 (copy), t1 (copy), convertPresenceEnum (copy), Presence (copy), useDispatch (copy), NetworkingPresence (copy), useShouldShowContextualInformation (copy), useProfilePeekViewHeight (copy), getPeekViewOpenHeightByProfileType (copy), ProfileFullView (copy), ProfileModalView (copy), ProfilePeekView (copy)
	local v42 = useProfileWrapperContext()
	local v43 = useProfileScrollContext()
	local profileType = v42.profileType
	local previousView = v42.navigateTo.previousView
	local v46 = useScreenSize()
	local v47 = useTopBarHeight()
	local v48 = not not FFlagEnableMobileGameJoinCard and (v42.mountAsFullView or false)
	local v49 = React.useCallback(function() -- line: 67
		-- upvalues: previousView (copy)
		previousView(false)
	end, { previousView })
	local v50 = React.useCallback(function() -- line: 72
		-- upvalues: previousView (copy)
		previousView(true)
	end, { previousView })
	local v51 = useSelector(function(p1) -- line: 77
		return p1.GlobalGuiInset
	end)
	local v52 = useProfileFormFactor()
	local v53 = v52.formFactor == Enums.ProfileFormFactor.Wide
	local v54 = not not FFlagEnableSplitPane and useSignalState(v38.getStore().getIsSplitEnabled)
	local v55 = React.useCallback(function() -- line: 88
		-- upvalues: React (copy), ProfilePlatformPage (copy)
		return React.createElement(ProfilePlatformPage, {})
	end, {})
	local v56 = FFlagEnableSplitPane and v54
	local v57 = React.useCallback(function() -- line: 94
		-- upvalues: React (copy), ProfileTopBar (copy), v49 (copy), FFlagEnableSplitPane (copy), v56 (copy)
		return React.createElement(ProfileTopBar, {
			transparentBackground = true,
			backgroundTransparency = nil,
			navigateBack = v49,
			hideNavigationButton = if not FFlagEnableSplitPane then nil else v56
		})
	end, if not FFlagEnableSplitPane then {} else {
		v49,
		v56
	})
	local v58 = getSafeAreaSize(v46, v51)
	local v59 = if not FFlagProfilePlatformNewProfileHeader then math.min(v58.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH) else if not FFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth(v53) else useProfileCardWidth2()
	local v60 = nil

	if FFlagProfilePlatformNewProfileHeader then
		local profileId = v42.profileId
		local v63

		if FFlagProfilePlatformPresenceStoreMigration then
			useEffectOnMount(function() -- line: 116
				-- upvalues: v36 (copy), profileId (copy)
				v36.RefreshPresenceByUserId((tostring(profileId)))
			end)

			local v62 = v35(profileId, t1)

			v63 = convertPresenceEnum(v62 and v62.userPresenceType or Presence.Enums.PresenceType.Offline, v62 and (v62.universeId ~= "" and tonumber(v62.universeId)) or nil)
		else
			local v64 = useDispatch()

			useEffectOnMount(function() -- line: 127
				-- upvalues: v64 (copy), NetworkingPresence (copy), profileId (copy)
				v64(NetworkingPresence.GetPresencesFromUserIds.API({ profileId })):catch(function(_) -- line: 128
				end)
			end)

			local v65 = useSelector(function(p3) -- line: 131
				-- upvalues: Presence (copy), profileId (copy)
				return Presence.Selectors.getUserPresenceByUserId(p3, profileId) or {
					lastLocation = "",
					userPresenceType = Presence.Enums.PresenceType.Offline
				}
			end)

			v63 = convertPresenceEnum(v65.userPresenceType, v65.universeId)
		end

		local v66 = useShouldShowContextualInformation(v63)

		v60 = useProfilePeekViewHeight(v59, v66)
	end

	local v67 = if not FFlagProfilePlatformNewProfileHeader or profileType ~= Enums.ProfileTypes.User then getPeekViewOpenHeightByProfileType(profileType) else v60
	local v68 = if not (v67 > v58.Y.Offset - v47) then UDim.new(0, v67) else UDim.new(1, 0)

	if v52.isFullView then
		return React.createElement(ProfileFullView, {
			renderContent = v55,
			navigateBack = v49
		})
	end

	if v53 then
		return React.createElement(ProfileModalView, {
			renderContent = v55,
			renderTopBar = v57,
			topBarHeight = v47,
			viewWidth = v59,
			fillPane = v54,
			navigateBack = v49
		})
	end

	return React.createElement(ProfilePeekView, {
		bottomDockedContainerHeight = 0,
		onViewStateChanged = nil,
		briefViewContentHeight = v68,
		contentSlot = v55(),
		fullViewContentHeight = UDim.new(1, 0),
		mountAsFullView = v48,
		onClosed = v50,
		topBarHeight = v47,
		topBarSlot = v57(),
		viewWidth = UDim.new(0, v58.X.Offset),
		transitionPercentCallback = function(n1: number) -- line: 189
			-- upvalues: v43 (copy)
			v43.setPeekViewOpenPercent(n1)
		end,
		profileType = if not FFlagProfilePlatformNewProfileHeader then nil else profileType
	})
end
