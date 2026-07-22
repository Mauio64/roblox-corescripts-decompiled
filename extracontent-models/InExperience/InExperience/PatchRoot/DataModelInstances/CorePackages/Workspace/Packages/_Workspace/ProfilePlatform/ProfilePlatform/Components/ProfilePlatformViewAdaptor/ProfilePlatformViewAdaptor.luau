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
local t1 = {
	skipFetch = true
}

return function(_: {[any]: any}) -- line: 53
	-- upvalues: useProfileWrapperContext (copy), useProfileScrollContext (copy), useScreenSize (copy), useTopBarHeight (copy), FFlagEnableMobileGameJoinCard (copy), React (copy), useSelector (copy), useProfileFormFactor (copy), Enums (copy), ProfilePlatformPage (copy), ProfileTopBar (copy), getSafeAreaSize (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagSwitchProfileWidthHookToSocialCommon (copy), useProfileCardWidth2 (copy), useProfileCardWidth (copy), Constants (copy), FFlagProfilePlatformPresenceStoreMigration (copy), useEffectOnMount (copy), v36 (copy), v35 (copy), t1 (copy), convertPresenceEnum (copy), Presence (copy), useDispatch (copy), NetworkingPresence (copy), useShouldShowContextualInformation (copy), useProfilePeekViewHeight (copy), getPeekViewOpenHeightByProfileType (copy), ProfileFullView (copy), ProfileModalView (copy), ProfilePeekView (copy)
	local v39 = useProfileWrapperContext()
	local v40 = useProfileScrollContext()
	local profileType = v39.profileType
	local previousView = v39.navigateTo.previousView
	local v43 = useScreenSize()
	local v44 = useTopBarHeight()
	local v45 = not not FFlagEnableMobileGameJoinCard and (v39.mountAsFullView or false)
	local v46 = React.useCallback(function() -- line: 64
		-- upvalues: previousView (copy)
		previousView(false)
	end, { previousView })
	local v47 = React.useCallback(function() -- line: 69
		-- upvalues: previousView (copy)
		previousView(true)
	end, { previousView })
	local v48 = useSelector(function(p1) -- line: 74
		return p1.GlobalGuiInset
	end)
	local v49 = useProfileFormFactor()
	local v50 = v49.formFactor == Enums.ProfileFormFactor.Wide
	local v51 = React.useCallback(function() -- line: 81
		-- upvalues: React (copy), ProfilePlatformPage (copy)
		return React.createElement(ProfilePlatformPage, {})
	end, {})
	local v52 = React.useCallback(function() -- line: 85
		-- upvalues: React (copy), ProfileTopBar (copy), v46 (copy)
		return React.createElement(ProfileTopBar, {
			transparentBackground = true,
			backgroundTransparency = nil,
			navigateBack = v46
		})
	end, {})
	local v53 = getSafeAreaSize(v43, v48)
	local v54 = if not FFlagProfilePlatformNewProfileHeader then math.min(v53.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH) else if not FFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth(v50) else useProfileCardWidth2()
	local v55 = nil

	if FFlagProfilePlatformNewProfileHeader then
		local profileId = v39.profileId
		local v58

		if FFlagProfilePlatformPresenceStoreMigration then
			useEffectOnMount(function() -- line: 106
				-- upvalues: v36 (copy), profileId (copy)
				v36.RefreshPresenceByUserId((tostring(profileId)))
			end)

			local v57 = v35(profileId, t1)

			v58 = convertPresenceEnum(v57 and v57.userPresenceType or Presence.Enums.PresenceType.Offline, v57 and (v57.universeId ~= "" and tonumber(v57.universeId)) or nil)
		else
			local v59 = useDispatch()

			useEffectOnMount(function() -- line: 117
				-- upvalues: v59 (copy), NetworkingPresence (copy), profileId (copy)
				v59(NetworkingPresence.GetPresencesFromUserIds.API({ profileId })):catch(function(_) -- line: 118
				end)
			end)

			local v60 = useSelector(function(p3) -- line: 121
				-- upvalues: Presence (copy), profileId (copy)
				return Presence.Selectors.getUserPresenceByUserId(p3, profileId) or {
					lastLocation = "",
					userPresenceType = Presence.Enums.PresenceType.Offline
				}
			end)

			v58 = convertPresenceEnum(v60.userPresenceType, v60.universeId)
		end

		local v61 = useShouldShowContextualInformation(v58)

		v55 = useProfilePeekViewHeight(v54, v61)
	end

	local v62 = if not FFlagProfilePlatformNewProfileHeader or profileType ~= Enums.ProfileTypes.User then getPeekViewOpenHeightByProfileType(profileType) else v55
	local v63 = if not (v62 > v53.Y.Offset - v44) then UDim.new(0, v62) else UDim.new(1, 0)

	if v49.isFullView then
		return React.createElement(ProfileFullView, {
			renderContent = v51,
			navigateBack = v46
		})
	end

	if v50 then
		return React.createElement(ProfileModalView, {
			renderContent = v51,
			renderTopBar = v52,
			topBarHeight = v44,
			viewWidth = v54,
			navigateBack = v46
		})
	end

	return React.createElement(ProfilePeekView, {
		bottomDockedContainerHeight = 0,
		onViewStateChanged = nil,
		briefViewContentHeight = v63,
		contentSlot = v51(),
		fullViewContentHeight = UDim.new(1, 0),
		mountAsFullView = v45,
		onClosed = v47,
		topBarHeight = v44,
		topBarSlot = v52(),
		viewWidth = UDim.new(0, v53.X.Offset),
		transitionPercentCallback = function(n1: number) -- line: 178
			-- upvalues: v40 (copy)
			v40.setPeekViewOpenPercent(n1)
		end,
		profileType = if not FFlagProfilePlatformNewProfileHeader then nil else profileType
	})
end
