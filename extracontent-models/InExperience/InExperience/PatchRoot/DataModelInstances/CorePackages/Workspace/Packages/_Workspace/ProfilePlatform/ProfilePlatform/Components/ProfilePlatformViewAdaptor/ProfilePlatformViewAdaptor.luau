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

return function(_: {[any]: any}) -- line: 43
	-- upvalues: useProfileWrapperContext (copy), useProfileScrollContext (copy), useScreenSize (copy), useTopBarHeight (copy), FFlagEnableMobileGameJoinCard (copy), React (copy), useSelector (copy), useProfileFormFactor (copy), Enums (copy), ProfilePlatformPage (copy), ProfileTopBar (copy), getSafeAreaSize (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagSwitchProfileWidthHookToSocialCommon (copy), useProfileCardWidth2 (copy), useProfileCardWidth (copy), Constants (copy), useDispatch (copy), useEffectOnMount (copy), NetworkingPresence (copy), Presence (copy), convertPresenceEnum (copy), useShouldShowContextualInformation (copy), useProfilePeekViewHeight (copy), getPeekViewOpenHeightByProfileType (copy), ProfileFullView (copy), ProfileModalView (copy), ProfilePeekView (copy)
	local v35 = useProfileWrapperContext()
	local v36 = useProfileScrollContext()
	local profileType = v35.profileType
	local previousView = v35.navigateTo.previousView
	local v39 = useScreenSize()
	local v40 = useTopBarHeight()
	local v41 = not not FFlagEnableMobileGameJoinCard and (v35.mountAsFullView or false)
	local v42 = React.useCallback(function() -- line: 54
		-- upvalues: previousView (copy)
		previousView(false)
	end, { previousView })
	local v43 = React.useCallback(function() -- line: 59
		-- upvalues: previousView (copy)
		previousView(true)
	end, { previousView })
	local v44 = useSelector(function(p1) -- line: 64
		return p1.GlobalGuiInset
	end)
	local v45 = useProfileFormFactor()
	local v46 = v45.formFactor == Enums.ProfileFormFactor.Wide
	local v47 = React.useCallback(function() -- line: 71
		-- upvalues: React (copy), ProfilePlatformPage (copy)
		return React.createElement(ProfilePlatformPage, {})
	end, {})
	local v48 = React.useCallback(function() -- line: 75
		-- upvalues: React (copy), ProfileTopBar (copy), v42 (copy)
		return React.createElement(ProfileTopBar, {
			transparentBackground = true,
			backgroundTransparency = nil,
			navigateBack = v42
		})
	end, {})
	local v49 = getSafeAreaSize(v39, v44)
	local v50 = if not FFlagProfilePlatformNewProfileHeader then math.min(v49.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH) else if not FFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth(v46) else useProfileCardWidth2()
	local v51 = nil

	if FFlagProfilePlatformNewProfileHeader then
		local profileId = v35.profileId
		local v53 = useDispatch()

		useEffectOnMount(function() -- line: 95
			-- upvalues: v53 (copy), NetworkingPresence (copy), profileId (copy)
			v53(NetworkingPresence.GetPresencesFromUserIds.API({ profileId })):catch(function(_) -- line: 96
			end)
		end)

		local v54 = useSelector(function(p3) -- line: 99
			-- upvalues: Presence (copy), profileId (copy)
			return Presence.Selectors.getUserPresenceByUserId(p3, profileId) or {
				lastLocation = "",
				userPresenceType = Presence.Enums.PresenceType.Offline
			}
		end)
		local v55 = convertPresenceEnum(v54.userPresenceType, v54.universeId)
		local v56 = useShouldShowContextualInformation(v55)

		v51 = useProfilePeekViewHeight(v50, v56)
	end

	local v57 = if not FFlagProfilePlatformNewProfileHeader or profileType ~= Enums.ProfileTypes.User then getPeekViewOpenHeightByProfileType(profileType) else v51
	local v58 = if not (v57 > v49.Y.Offset - v40) then UDim.new(0, v57) else UDim.new(1, 0)

	if v45.isFullView then
		return React.createElement(ProfileFullView, {
			renderContent = v47,
			navigateBack = v42
		})
	end

	if v46 then
		return React.createElement(ProfileModalView, {
			renderContent = v47,
			renderTopBar = v48,
			topBarHeight = v40,
			viewWidth = v50,
			navigateBack = v42
		})
	end

	return React.createElement(ProfilePeekView, {
		bottomDockedContainerHeight = 0,
		onViewStateChanged = nil,
		briefViewContentHeight = v58,
		contentSlot = v47(),
		fullViewContentHeight = UDim.new(1, 0),
		mountAsFullView = v41,
		onClosed = v43,
		topBarHeight = v40,
		topBarSlot = v48(),
		viewWidth = UDim.new(0, v49.X.Offset),
		transitionPercentCallback = function(n1: number) -- line: 155
			-- upvalues: v36 (copy)
			v36.setPeekViewOpenPercent(n1)
		end,
		profileType = if not FFlagProfilePlatformNewProfileHeader then nil else profileType
	})
end
