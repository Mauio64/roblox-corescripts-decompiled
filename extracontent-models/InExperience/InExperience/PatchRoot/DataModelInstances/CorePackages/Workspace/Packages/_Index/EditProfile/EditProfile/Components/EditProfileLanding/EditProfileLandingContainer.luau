local EditProfile = script:FindFirstAncestor("EditProfile")
local IXPService = game:GetService("IXPService")
local parent = EditProfile.Parent
local EditProfileLanding = require(EditProfile.Components.EditProfileLanding.EditProfileLanding)
local EditProfileLandingV2 = require(EditProfile.Components.EditProfileLanding.EditProfileLandingV2)
local FFlagEditProfileLandingV2Enabled = require(EditProfile.Flags.FFlagEditProfileLandingV2Enabled)
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local useEffect = React.useEffect
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local UserProfiles = require(parent.UserProfiles)
local v = UserProfiles.Stores.UserProfileStore.get()
local EditProfileStore = require(EditProfile.Stores.EditProfileStore)
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local ProfileRefreshSignal = ProfilePlatformCommon.Signals.ProfileRefreshSignal
local Enums = require(EditProfile.Common.Enums)
local Constants = require(EditProfile.Common.Constants)
local RobloxAppHooks2 = require(parent.RobloxAppHooks)
local useLocalRobuxBalance = RobloxAppHooks2.useLocalRobuxBalance
local useRealNamesInDisplayNamesEnabled = require(EditProfile.Hooks.useRealNamesInDisplayNamesEnabled)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)
local FFlagEditProfilePPEStartOnEmotesPage = require(EditProfile.Flags.FFlagEditProfilePPEStartOnEmotesPage)
local FFlagEditProfileUsernameServerPrice = require(EditProfile.Flags.FFlagEditProfileUsernameServerPrice)

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local Signals = require(parent.Signals)

local DataHydration = require(parent.DataHydration)
local DataHydrationTypes = DataHydration.DataHydrationTypes

local signal = Signals.createSignal("")
local AnalyticsServiceV2 = require(EditProfile.Analytics.AnalyticsServiceV2)
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSplitPaneFullBleedEditProfile = SharedFlags2.FFlagSplitPaneFullBleedEditProfile
local SharedFlags3 = require(parent.SharedFlags)
local FFlagAXPPEReturnToEntrySurface = SharedFlags3.FFlagAXPPEReturnToEntrySurface
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEditProfileImageV2Enabled = SharedFlags4.FFlagEditProfileImageV2Enabled
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local RoactNavigation = require(parent.RoactNavigation)
local NavigationEvents = RoactNavigation.NavigationEvents
local defineFastString = game:DefineFastString("EditProfileIXPLayer", "Social.EditProfilePage")

local function getHostRoute(navigation) -- 1 equivalent call inferred from this helper
	local dangerouslyGetParent = navigation._dangerouslyGetParent()
	local state = dangerouslyGetParent and dangerouslyGetParent.state
	return if state and state.routeName then state else nil
end

local function getCoveredPage(navigation, hostRoute)
	local v2 = navigation._dangerouslyGetParent()

	while v2 do
		local v3

		if v2._dangerouslyGetParent then
			v3 = v2._dangerouslyGetParent()
		end

		navigation = v2
		v2 = v3
	end

	local routes = navigation.state.routes

	if not routes then
		return nil, nil
	end

	for k, route in routes do
		if route.routeName == hostRoute.routeName and k > 1 then
			local v3 = routes[k - 1]

			if v3.routes and v3.index then
				v3 = v3.routes[v3.index]
			end

			return v3.routeName, v3.params
		end
	end

	return nil, nil
end

local function openEditProfileImageFromProfilePlatform(navigation, p)
	local v2 = {}

	if p and p.mode then
		v2.mode = p.mode
	end

	if FFlagAXEnableProfileTab and navigation.getParam and navigation.getParam("fullBleed") == true then
		v2.fullBleed = true
	end

	if next(v2) == nil then
		navigation.navigate(Enums.Screens.EditProfileImageProfilePlatform)
	else
		navigation.navigate(Enums.Screens.EditProfileImageProfilePlatform, v2)
	end
end

local function EditProfileLandingContainer(p)
	local userId = useLocalUserId()
	local isPolicyEnabled = useRealNamesInDisplayNamesEnabled()
	local function onClose()
		ProfileRefreshSignal.notifyProfileRefresh()
		p.navigation.pop()
	end

	local ref = React.useRef(nil)
	local currents = {}
	local v2 = FocusNavigationUtils.useAutoFocus(currents, 0.1)
	local v3 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

	useEffect(function()
		currents[1] = ref.current
		local v4

		if v3 and v3.focusedGuiObject:getValue() ~= nil and v2 then
			v4 = v2()
		else
			v4 = nil
		end

		return function()
			if v4 then
				v4.cancel()
			end
		end
	end, { v2 })

	local fullBleed = FFlagAXEnableProfileTab and p.navigation.getParam("fullBleed") == true
	local fullBleed2

	if FFlagSplitPaneFullBleedEditProfile then
		local useContext = React.useContext
		local SplitPane = require(parent.SplitPane)
		local v4 = useContext(SplitPane.PaneHostContext)

		if v4 == nil then
			fullBleed2 = fullBleed
		else
			fullBleed2 = not v4.isFullScreen
		end
	else
		fullBleed2 = fullBleed
	end

	local function fn()
		AnalyticsServiceV2.sendDisplayNameModalOpened()
		p.navigation.navigate(Enums.Screens.EditProfileSubScreen, {
			screen = Enums.Screens.EditDisplayName,
			fullBleed = fullBleed
		})
	end

	local function showToast(text: string)
		p.navigation.goBack()
		p.navigation.navigate(Enums.Screens.EditProfileToast, { text = text })
	end
	local param = p.navigation.getParam(Constants.EditUserNameWebView)
	local function fn2()
		p.navigation.navigate(Enums.Screens.UsernameInsufficientFundsModal)
	end
	local v4 = useLocalRobuxBalance()
	local v5

	if FFlagEditProfileUsernameServerPrice then
		v5 = useSignalState(EditProfileStore.getUsernameChangePrice((tostring(userId))).data)
	else
		v5 = nil
	end

	local function fn3()
		local v6

		if FFlagEditProfileUsernameServerPrice then
			v6 = v5 and v5.priceInRobux
		else
			v6 = Constants.ChangeUsernamePrice
		end

		local v7 = FFlagEditProfileUsernameServerPrice

		if v7 then
			v7 = not (v5 == nil) and v5.isFreeUsernameChange
		end

		if v7 or v6 == nil or v6 <= v4 then
			param(showToast)
		else
			p.navigation.navigate(Enums.Screens.UsernameInsufficientFundsModal, {
				robux = v6 - v4,
				navigateDownToPurchaseRobux = fn2
			})
		end

		AnalyticsServiceV2.sendEditUsernameOpened()
	end

	local function fn4()
		p.navigation.navigate(Enums.Screens.EditProfileSubScreen, {
			screen = Enums.Screens.EditBio,
			fullBleed = fullBleed
		})
	end

	local function fn5()
		AnalyticsServiceV2.sendOpenAvatarMarketplace()

		if FFlagEditProfileImageV2Enabled then
			openEditProfileImageFromProfilePlatform(p.navigation)
			return
		end

		if FFlagAXPPEReturnToEntrySurface then
			local v6

			if FFlagEditProfilePPEStartOnEmotesPage then
				v6 = Enums.Screens.ProfilePictureEditorEmotes
			else
				v6 = Enums.Screens.ProfilePictureEditorCamera
			end

			local hostRoute = getHostRoute(p.navigation) -- inferred equivalent call

			if hostRoute then
				local coveredPage, coveredScreenParams = getCoveredPage(p.navigation, hostRoute)
				local entryOrigin = {
					screenName = hostRoute.routeName,
					screenParams = hostRoute.params,
					reopenAction = RoactNavigation.Actions.navigate({
						routeName = p.navigation.state.routeName,
						params = p.navigation.state.params
					}),
					coveredScreenName = coveredPage,
					coveredScreenParams = coveredScreenParams
				}

				p.navigation.navigate(v6, { entryOrigin = entryOrigin })

				return
			end
		end

		if FFlagEditProfilePPEStartOnEmotesPage then
			p.navigation.navigate(Enums.Screens.ProfilePictureEditorEmotes)
		else
			p.navigation.navigate(Enums.Screens.ProfilePictureEditorCamera)
		end
	end

	local v6 = React.useMemo(function()
		return v.fetchNamesByUserIds({ (tostring(userId)) })
	end, { userId })
	useEffect(function()
		AnalyticsServiceV2.sendEditProfileOpened()
	end, {})

	local v7 = useSignalState(v6)
	local areNamesLoading = not v7 or v7.status ~= "success"
	local v8 = v7 and v7.data and v7.data[1]

	local v9 = if v8 then v8.names.getUsername else signal
	local v10 = if v8 then v8.names.getDisplayName else signal

	local username = useSignalState(v9) or ""
	local displayName = useSignalState(v10) or ""

	local description = EditProfileStore.getDescription(userId)
	local isBioLoading = useSignalState(description.status) == DataHydrationTypes.DataStatus.NotReady

	local function onProfileFramesActivated()
		openEditProfileImageFromProfilePlatform(p.navigation, {
			mode = Enums.EditProfileImageMode.FramesOnly
		})
	end

	local v11 = {
		userId = userId,
		fullBleed = fullBleed2,
		onClose = onClose,
		username = username,
		displayName = displayName,
		areNamesLoading = areNamesLoading,
		bioText = useSignalState(description.data) or "",
		isBioLoading = isBioLoading,
		isPolicyEnabled = isPolicyEnabled,
		settingButtonOnActivated = { displayName = fn, username = fn3, bio = fn4, avatar = fn5 },
		firstItemRef = ref
	}

	local v12 = {
		EditProfileLandingExposureLogger = React.createElement(NavigationEvents, {
			onDidFocus = function()
				IXPService:LogUserLayerExposure(defineFastString)
			end
		}),
		EditProfileLanding = 0
	}
	local editProfileLanding

	if FFlagEditProfileLandingV2Enabled then
		editProfileLanding = React.createElement(
			EditProfileLandingV2,
			Cryo.Dictionary.join(v11, { onProfileFramesActivated = onProfileFramesActivated })
		)
	else
		editProfileLanding = React.createElement(EditProfileLanding, v11)
	end

	v12.EditProfileLanding = editProfileLanding
	return FocusNavigatorWrapper({ onClose = onClose }, v12)
end

return EditProfileLandingContainer
