local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RoactUtils2 = require(parent.RoactUtils)
local useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local AppLinking = RoactServiceTags.AppLinking
local AppOmniRecommendationsRequest = RoactServiceTags.AppOmniRecommendationsRequest

local DeepLink = require(parent.DeepLink)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local LoginStatus = RobloxAppEnums.LoginStatus
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus

local useEffect = React.useEffect
local useCallback = React.useCallback
local useState = React.useState

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableDeepLinkHistoryWithModalAPI = SharedFlags.FFlagEnableDeepLinkHistoryWithModalAPI
local FFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if FFlagUseSignalsForAuthenticationStatus then
	local AuthenticationStatus = require(parent.AuthenticationStatus)
	getAuthenticationStatusStore = AuthenticationStatus.GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local FFlagUseSignalsForStartup = SharedFlags.FFlagUseSignalsForStartup
local getStartupStore

if FFlagUseSignalsForStartup then
	local StartupStore = require(parent.StartupStore)
	getStartupStore = StartupStore.GetStartupStore
else
	getStartupStore = nil
end

local PostAuthDeepLinkAvailableSignal = require(script.Parent.PostAuthDeepLinkAvailableSignal)
local PostAuthPendingLuaUrlAvailableSignal = require(script.Parent.PostAuthPendingLuaUrlAvailableSignal)
local PreAuthDeepLinkHandler = require(script.Parent.PreAuthDeepLinkHandler)

local Stores = require(AuthCommon.Stores)
local PreAuthDeepLinkUrlStore = Stores.PreAuthDeepLinkUrlStore

local FFlagEnablePreAuthDeepLinkHandler = require(AuthCommon.Flags.FFlagEnablePreAuthDeepLinkHandler)

return function(p): nil
	local v = useRoactService(AppLinking)

	local monoDeps = p.monoDeps
	local launchApp = monoDeps.LaunchApp
	local resetAppState = monoDeps.ResetAppState

	local v2 = {
		networking = useRoactService(RoactNetworking),
		launchApp = launchApp,
		dispatch = useDispatch(),
		omniRecommendationsRequest = useRoactService(AppOmniRecommendationsRequest),
		analytics = useRoactService(RoactAnalytics),
		appPolicy = useAppPolicy(function(p2)
			return p2
		end),
		resetAppState = resetAppState
	}

	local state, setState = useState({ url = nil, attributionUrl = nil })

	local state2, setState2 = useState({ hasPendingUrl = false, attributionUrl = nil, url = nil })
	local v3

	if FFlagUseSignalsForAuthenticationStatus then
		v3 = useSignalState(getAuthenticationStatusStore(false).getStatus) == LoginStatus.LOGGED_OUT
	else
		v3 = useSelector(function(p2): boolean
			return p2.AuthenticationStatus.status == LoginStatus.LOGGED_OUT
		end)
	end

	local v4

	if FFlagUseSignalsForStartup then
		v4 = useSignalState(getStartupStore(false).getAppLoadingStarted)
	else
		v4 = useSelector(function(p2): boolean
			return p2.Startup.AppDataStatus ~= RetrievalStatus.NotStarted
		end)
	end

	local v5

	if FFlagEnableDeepLinkHistoryWithModalAPI then
		v5 = DeepLink.DeepLinkLuaReceiverStatusStore(false)
	else
		v5 = nil
	end

	local v6 = useCallback(function()
		if not v then
			return
		end

		local v6 = not v3 and v4

		if v6 then
			PreAuthDeepLinkUrlStore.setUrl(nil)

			if FFlagEnableDeepLinkHistoryWithModalAPI then
				v5.setDeepLinkLuaPostAuthReceiverStatus(
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
		elseif FFlagEnableDeepLinkHistoryWithModalAPI then
			v5.setDeepLinkLuaPostAuthReceiverStatus(DeepLink.DeepLinkLuaPostAuthReceiverStatus.Disconnected, nil)
		end

		v:getAndClearLastPendingURL():andThen(function(p2)
			if not (p2 and p2.hasPendingUrl) then
				return
			end

			if v6 then
				PostAuthPendingLuaUrlAvailableSignal:fire(p2)

				return
			end

			PreAuthDeepLinkUrlStore.setUrl(p2.url)
			setState2(p2)
		end)

		v:listenForLuaURLs(function(url, attributionUrl)
			if FFlagEnablePreAuthDeepLinkHandler and PreAuthDeepLinkHandler.isPreauthDeeplink(url) then
				PreAuthDeepLinkHandler.firePreauthDeeplink(url, v2)
				return
			end

			if v6 then
				PostAuthDeepLinkAvailableSignal:fire({ url = url, attributionUrl = attributionUrl })

				return
			end

			PreAuthDeepLinkUrlStore.setUrl(url)
			setState({ url = url, attributionUrl = attributionUrl })
		end)
	end, { v, v3, v4, PostAuthDeepLinkAvailableSignal, state, state2 })

	useEffect(function()
		v6()

		return function()
			if v then
				v:stopListeningForLuaURLs()
			end
		end
	end, { v6 })
	return nil
end
