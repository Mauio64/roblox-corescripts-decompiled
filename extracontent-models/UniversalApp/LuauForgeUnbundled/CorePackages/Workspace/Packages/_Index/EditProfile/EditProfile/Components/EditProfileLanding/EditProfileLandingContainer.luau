local IXPService = game:GetService("IXPService")

local module = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditProfileLanding/EditProfileLanding")
local EditProfileLandingV2 = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditProfileLanding/EditProfileLandingV2")
local FFlagEditProfileLandingV2Enabled = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfileLandingV2Enabled")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Cryo")
local useEffect = React.useEffect
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppHooks").useLocalUserId
local v5 = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/UserProfiles").Stores.UserProfileStore.get()
local EditProfileStore = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Stores/EditProfileStore")
local profileRefreshSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/ProfilePlatformCommon").Signals.ProfileRefreshSignal
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Enums")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Constants")
local useLocalRobuxBalance = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppHooks").useLocalRobuxBalance
local useRealNamesInDisplayNamesEnabled = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Hooks/useRealNamesInDisplayNamesEnabled")
local FocusNavigatorWrapper = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Utils/FocusNavigatorWrapper")
local FFlagEditProfilePPEStartOnEmotesPage = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfilePPEStartOnEmotesPage")
local FFlagEditProfileUsernameServerPrice = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfileUsernameServerPrice")

local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SignalsReact").useSignalState

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Signals")

local dataHydrationTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/DataHydration").DataHydrationTypes

local signal = Signals.createSignal("")
local AnalyticsServiceV2 = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/AnalyticsServiceV2")
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagAXEnableProfileTab
local fFlagSplitPaneFullBleedEditProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagSplitPaneFullBleedEditProfile
local fFlagAXPPEReturnToEntrySurface = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagAXPPEReturnToEntrySurface
local fFlagEditProfileImageV2Enabled = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagEditProfileImageV2Enabled
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/FocusNavigationUtils")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/ReactFocusNavigation")

local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RoactNavigation")
local navigationEvents = RoactNavigation.NavigationEvents
local defineFastString = game:DefineFastString("EditProfileIXPLayer", "Social.EditProfilePage")

local function getHostRoute(p2)
	local dangerouslyGetParent = p2._dangerouslyGetParent()
	local state = dangerouslyGetParent and dangerouslyGetParent.state

	if state and state.routeName then
		return state
	end

	return nil
end

local function getCoveredPage(navigation, state)
	local v6 = navigation._dangerouslyGetParent()

	while v6 do
		local v7 = if v6._dangerouslyGetParent then v6._dangerouslyGetParent() else nil
		navigation = v6
		v6 = v7
	end

	local routes = navigation.state.routes

	if not routes then
		return nil, nil
	end

	for k, route in routes do
		if route.routeName == state.routeName and k > 1 then
			local v7 = routes[k - 1]

			if v7.routes and v7.index then
				v7 = v7.routes[v7.index]
			end

			return v7.routeName, v7.params
		end
	end

	return nil, nil
end

local function openEditProfileImageFromProfilePlatform(navigation, p2)
	local v6 = {}

	if p2 and p2.mode then
		v6.mode = p2.mode
	end

	if fFlagAXEnableProfileTab and navigation.getParam and navigation.getParam("fullBleed") == true then
		v6.fullBleed = true
	end

	if next(v6) == nil then
		navigation.navigate(Enums.Screens.EditProfileImageProfilePlatform)
	else
		navigation.navigate(Enums.Screens.EditProfileImageProfilePlatform, v6)
	end
end

local function EditProfileLandingContainer(p2)
	local v6 = useLocalUserId()
	local v7 = useRealNamesInDisplayNamesEnabled()
	local function onClose()
		profileRefreshSignal.notifyProfileRefresh()
		p2.navigation.pop()
	end

	local ref = React.useRef(nil)
	local currents = {}
	local v8 = FocusNavigationUtils.useAutoFocus(currents, 0.1)
	local v9 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

	useEffect(function()
		currents[1] = ref.current

		local v10 = if v9 and v9.focusedGuiObject:getValue() ~= nil and v8 then v8() else nil

		return function()
			if v10 then
				v10.cancel()
			end
		end
	end, { v8 })

	local v10 = fFlagAXEnableProfileTab and p2.navigation.getParam("fullBleed") == true
	local v11

	if fFlagSplitPaneFullBleedEditProfile then
		local v12 = React.useContext(require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SplitPane").PaneHostContext)
		v11 = if v12 == nil then v10 else not v12.isFullScreen
	else
		v11 = v10
	end

	local function fn()
		AnalyticsServiceV2.sendDisplayNameModalOpened()
		p2.navigation.navigate(Enums.Screens.EditProfileSubScreen, {
			screen = Enums.Screens.EditDisplayName,
			fullBleed = v10
		})
	end

	local function showToast(p3)
		p2.navigation.goBack()
		p2.navigation.navigate(Enums.Screens.EditProfileToast, { text = p3 })
	end
	local param = p2.navigation.getParam(Constants.EditUserNameWebView)
	local function fn2()
		p2.navigation.navigate(Enums.Screens.UsernameInsufficientFundsModal)
	end
	local v12 = useLocalRobuxBalance()
	local v13

	if FFlagEditProfileUsernameServerPrice then
		v13 = useSignalState(EditProfileStore.getUsernameChangePrice((tostring(v6))).data)
	else
		v13 = nil
	end

	local function fn3()
		local v14 = if FFlagEditProfileUsernameServerPrice then v13 and v13.priceInRobux else Constants.ChangeUsernamePrice

		local v15 = FFlagEditProfileUsernameServerPrice

		if v15 then
			v15 = not (v13 == nil) and v13.isFreeUsernameChange
		end

		if v15 or v14 == nil or v14 <= v12 then
			param(showToast)
		else
			p2.navigation.navigate(Enums.Screens.UsernameInsufficientFundsModal, {
				robux = v14 - v12,
				navigateDownToPurchaseRobux = fn2
			})
		end

		AnalyticsServiceV2.sendEditUsernameOpened()
	end

	local function fn4()
		p2.navigation.navigate(Enums.Screens.EditProfileSubScreen, {
			screen = Enums.Screens.EditBio,
			fullBleed = v10
		})
	end

	local function fn5()
		AnalyticsServiceV2.sendOpenAvatarMarketplace()

		if fFlagEditProfileImageV2Enabled then
			openEditProfileImageFromProfilePlatform(p2.navigation)
			return
		end

		if fFlagAXPPEReturnToEntrySurface then
			local v14

			if FFlagEditProfilePPEStartOnEmotesPage then
				v14 = Enums.Screens.ProfilePictureEditorEmotes
			else
				v14 = Enums.Screens.ProfilePictureEditorCamera
			end

			local dangerouslyGetParent = p2.navigation._dangerouslyGetParent()
			local state = dangerouslyGetParent and dangerouslyGetParent.state

			if not (state and state.routeName) then
				state = nil
			end

			if state then
				local coveredPage, v15 = getCoveredPage(p2.navigation, state)
				local v16 = {
					screenName = state.routeName,
					screenParams = state.params,
					reopenAction = RoactNavigation.Actions.navigate({
						routeName = p2.navigation.state.routeName,
						params = p2.navigation.state.params
					}),
					coveredScreenName = coveredPage,
					coveredScreenParams = v15
				}

				p2.navigation.navigate(v14, { entryOrigin = v16 })

				return
			end
		end

		if FFlagEditProfilePPEStartOnEmotesPage then
			p2.navigation.navigate(Enums.Screens.ProfilePictureEditorEmotes)
		else
			p2.navigation.navigate(Enums.Screens.ProfilePictureEditorCamera)
		end
	end

	local v14 = React.useMemo(function()
		return v5.fetchNamesByUserIds({ (tostring(v6)) })
	end, { v6 })
	useEffect(function()
		AnalyticsServiceV2.sendEditProfileOpened()
	end, {})

	local v15 = useSignalState(v14)
	local v16 = not v15 or v15.status ~= "success"
	local v17 = v15 and v15.data and v15.data[1]

	local v18 = if v17 then v17.names.getUsername else signal
	local v19 = if v17 then v17.names.getDisplayName else signal

	local v20 = useSignalState(v18) or ""
	local v21 = useSignalState(v19) or ""

	local description = EditProfileStore.getDescription(v6)
	local v22 = useSignalState(description.status) == dataHydrationTypes.DataStatus.NotReady

	local function onProfileFramesActivated()
		openEditProfileImageFromProfilePlatform(p2.navigation, {
			mode = Enums.EditProfileImageMode.FramesOnly
		})
	end

	local v24 = {
		userId = v6,
		fullBleed = v11,
		onClose = onClose,
		username = v20,
		displayName = v21,
		areNamesLoading = v16,
		bioText = useSignalState(description.data) or "",
		isBioLoading = v22,
		isPolicyEnabled = v7,
		settingButtonOnActivated = {
			displayName = fn,
			username = fn3,
			bio = fn4,
			avatar = fn5
		},
		firstItemRef = ref
	}

	local v27 = {
		EditProfileLandingExposureLogger = React.createElement(navigationEvents, {
			onDidFocus = function()
				IXPService:LogUserLayerExposure(defineFastString)
			end
		}),
		EditProfileLanding = 0
	}

	local v28 = if FFlagEditProfileLandingV2Enabled then React.createElement(
		EditProfileLandingV2,
		Cryo.Dictionary.join(v24, {
			onProfileFramesActivated = onProfileFramesActivated
		})
	) else React.createElement(module, v24)
	v27.EditProfileLanding = v28
	return FocusNavigatorWrapper({ onClose = onClose }, v27)
end

return EditProfileLandingContainer
