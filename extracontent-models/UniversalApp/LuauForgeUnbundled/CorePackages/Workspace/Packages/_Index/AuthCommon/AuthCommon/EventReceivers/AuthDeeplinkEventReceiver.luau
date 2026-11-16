local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SignalsReact").useSignalState
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppHooks").useRoactService
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactUtils").Hooks.RoactRodux.useDispatch
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UniversalAppPolicy").useAppPolicy

local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactServiceTags")
local roactNetworking = RoactServiceTags.RoactNetworking
local roactAnalytics = RoactServiceTags.RoactAnalytics
local appLinking = RoactServiceTags.AppLinking
local appOmniRecommendationsRequest = RoactServiceTags.AppOmniRecommendationsRequest

local DeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/DeepLink")
local loginStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").LoginStatus
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Enum.RetrievalStatus

local useEffect = React.useEffect
local useCallback = React.useCallback
local useState = React.useState

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags")
local fFlagEnableDeepLinkHistoryWithModalAPI = SharedFlags.FFlagEnableDeepLinkHistoryWithModalAPI
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AuthenticationStatus").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local fFlagUseSignalsForStartup = SharedFlags.FFlagUseSignalsForStartup

local getStartupStore = if fFlagUseSignalsForStartup then require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/StartupStore").GetStartupStore else nil

local PostAuthDeepLinkAvailableSignal = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/EventReceivers/PostAuthDeepLinkAvailableSignal")
local PostAuthPendingLuaUrlAvailableSignal = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/EventReceivers/PostAuthPendingLuaUrlAvailableSignal")
local PreAuthDeepLinkHandler = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/EventReceivers/PreAuthDeepLinkHandler")

local preAuthDeepLinkUrlStore = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Stores").PreAuthDeepLinkUrlStore

local FFlagEnablePreAuthDeepLinkHandler = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/FFlagEnablePreAuthDeepLinkHandler")

return function(p2): nil
	local v5 = useRoactService(appLinking)

	local monoDeps = p2.monoDeps
	local launchApp = monoDeps.LaunchApp
	local resetAppState = monoDeps.ResetAppState

	local v6 = {
		networking = useRoactService(roactNetworking),
		launchApp = launchApp,
		dispatch = useDispatch(),
		omniRecommendationsRequest = useRoactService(appOmniRecommendationsRequest),
		analytics = useRoactService(roactAnalytics),
		appPolicy = useAppPolicy(function(p3)
			return p3
		end),
		resetAppState = resetAppState
	}

	local state, setState = useState({ url = nil, attributionUrl = nil })

	local state2, setState2 = useState({
		hasPendingUrl = false,
		attributionUrl = nil,
		url = nil
	})
	local v7

	if fFlagUseSignalsForAuthenticationStatus then
		v7 = useSignalState(getAuthenticationStatusStore(false).getStatus) == loginStatus.LOGGED_OUT
	else
		v7 = useSelector(function(p3): boolean
			return p3.AuthenticationStatus.status == loginStatus.LOGGED_OUT
		end)
	end

	local v8

	if fFlagUseSignalsForStartup then
		v8 = useSignalState(getStartupStore(false).getAppLoadingStarted)
	else
		v8 = useSelector(function(p3): boolean
			return p3.Startup.AppDataStatus ~= retrievalStatus.NotStarted
		end)
	end

	local v9

	if fFlagEnableDeepLinkHistoryWithModalAPI then
		v9 = DeepLink.DeepLinkLuaReceiverStatusStore(false)
	else
		v9 = nil
	end

	local v10 = useCallback(function()
		if not v5 then
			return
		end

		local v11 = not v7 and v8

		if v11 then
			preAuthDeepLinkUrlStore.setUrl(nil)

			if fFlagEnableDeepLinkHistoryWithModalAPI then
				v9.setDeepLinkLuaPostAuthReceiverStatus(
					DeepLink.DeepLinkLuaPostAuthReceiverStatus.Ready,
					state and state.url
				)
			end

			if state and state.url then
				PostAuthDeepLinkAvailableSignal:fire(state)

				setState({ url = nil, attributionUrl = nil })
			end

			if state2 and state2.hasPendingUrl then
				PostAuthPendingLuaUrlAvailableSignal:fire(state2)
				setState2({ hasPendingUrl = false, attributionUrl = nil, url = nil })
			end
		elseif fFlagEnableDeepLinkHistoryWithModalAPI then
			v9.setDeepLinkLuaPostAuthReceiverStatus(
				DeepLink.DeepLinkLuaPostAuthReceiverStatus.Disconnected,
				nil
			)
		end

		v5:getAndClearLastPendingURL():andThen(function(p3)
			if not (p3 and p3.hasPendingUrl) then
				return
			end

			if v11 then
				PostAuthPendingLuaUrlAvailableSignal:fire(p3)

				return
			end

			preAuthDeepLinkUrlStore.setUrl(p3.url)
			setState2(p3)
		end)

		v5:listenForLuaURLs(function(p3, p4)
			if FFlagEnablePreAuthDeepLinkHandler and PreAuthDeepLinkHandler.isPreauthDeeplink(p3) then
				PreAuthDeepLinkHandler.firePreauthDeeplink(p3, v6)
				return
			end

			if v11 then
				PostAuthDeepLinkAvailableSignal:fire({ url = p3, attributionUrl = p4 })

				return
			end

			preAuthDeepLinkUrlStore.setUrl(p3)
			setState({ url = p3, attributionUrl = p4 })
		end)
	end, { v5, v7, v8, PostAuthDeepLinkAvailableSignal, state, state2 })

	useEffect(function()
		v10()

		return function()
			if v5 then
				v5:stopListeningForLuaURLs()
			end
		end
	end, { v10 })
	return nil
end
