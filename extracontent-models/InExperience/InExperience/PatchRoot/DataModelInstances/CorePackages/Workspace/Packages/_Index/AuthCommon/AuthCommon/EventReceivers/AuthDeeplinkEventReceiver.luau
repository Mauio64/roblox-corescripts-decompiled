local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local React = require(AuthCommonParent.React)
local useRoactService = require(AuthCommonParent.RobloxAppHooks).useRoactService
local useSelector = require(AuthCommonParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(AuthCommonParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useAppPolicy = require(AuthCommonParent.UniversalAppPolicy).useAppPolicy
local useSignalState = require(AuthCommonParent.SignalsReact).useSignalState
local RoactServiceTags = require(AuthCommonParent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local AppLinking = RoactServiceTags.AppLinking
local AppOmniRecommendationsRequest = RoactServiceTags.AppOmniRecommendationsRequest
local DeepLink = require(AuthCommonParent.DeepLink)
local LoginStatus = require(AuthCommonParent.RobloxAppEnums).LoginStatus
local RetrievalStatus = require(AuthCommonParent.Http).Enum.RetrievalStatus
local useEffect = React.useEffect
local useCallback = React.useCallback
local useState = React.useState
local SharedFlags = require(AuthCommonParent.SharedFlags)
local FFlagEnableDeepLinkHistoryWithModalAPI = SharedFlags.FFlagEnableDeepLinkHistoryWithModalAPI
local FFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local v23 = if not FFlagUseSignalsForAuthenticationStatus then nil else require(AuthCommonParent.AuthenticationStatus).GetAuthenticationStatusStore
local PostAuthDeepLinkAvailableSignal = require(script.Parent.PostAuthDeepLinkAvailableSignal)
local PostAuthPendingLuaUrlAvailableSignal = require(script.Parent.PostAuthPendingLuaUrlAvailableSignal)
local PreAuthDeepLinkHandler = require(script.Parent.PreAuthDeepLinkHandler)
local PreAuthDeepLinkUrlStore = require(AuthCommon.Stores).PreAuthDeepLinkUrlStore
local FFlagEnablePreAuthDeepLinkHandler = require(AuthCommon.Flags.FFlagEnablePreAuthDeepLinkHandler)

return function(p1) -- line: 41
	-- upvalues: useRoactService (copy), AppLinking (copy), RoactNetworking (copy), useDispatch (copy), AppOmniRecommendationsRequest (copy), RoactAnalytics (copy), useAppPolicy (copy), useState (copy), FFlagUseSignalsForAuthenticationStatus (copy), useSignalState (copy), v23 (copy), LoginStatus (copy), useSelector (copy), RetrievalStatus (copy), FFlagEnableDeepLinkHistoryWithModalAPI (copy), DeepLink (copy), useCallback (copy), PreAuthDeepLinkUrlStore (copy), PostAuthDeepLinkAvailableSignal (copy), PostAuthPendingLuaUrlAvailableSignal (copy), FFlagEnablePreAuthDeepLinkHandler (copy), PreAuthDeepLinkHandler (copy), useEffect (copy)
	local v30 = useRoactService(AppLinking)
	local monoDeps = p1.monoDeps
	local LaunchApp = monoDeps.LaunchApp
	local ResetAppState = monoDeps.ResetAppState
	local v34 = useRoactService(RoactNetworking)
	local v35 = useDispatch()
	local v36 = useRoactService(AppOmniRecommendationsRequest)
	local v37 = useRoactService(RoactAnalytics)
	local v38 = useAppPolicy(function(p2) -- line: 53
		return p2
	end)
	local t1 = {
		networking = v34,
		launchApp = LaunchApp,
		dispatch = v35,
		omniRecommendationsRequest = v36,
		analytics = v37,
		appPolicy = v38,
		resetAppState = ResetAppState
	}
	local v40, v41 = useState({
		url = nil,
		attributionUrl = nil
	})
	local v42, v43 = useState({
		hasPendingUrl = false,
		attributionUrl = nil,
		url = nil
	})
	local v44 = if not FFlagUseSignalsForAuthenticationStatus then useSelector(function(p3) -- line: 89
		-- upvalues: LoginStatus (copy)
		return p3.AuthenticationStatus.status == LoginStatus.LOGGED_OUT
	end) else useSignalState(v23(false).getStatus) == LoginStatus.LOGGED_OUT
	local v45 = useSelector(function(p4) -- line: 93
		-- upvalues: RetrievalStatus (copy)
		return p4.Startup.AppDataStatus ~= RetrievalStatus.NotStarted
	end)
	local u46 = nil

	if FFlagEnableDeepLinkHistoryWithModalAPI then
		u46 = DeepLink.DeepLinkLuaReceiverStatusStore(false)
	end

	local v47 = useCallback(function() -- line: 102
		-- upvalues: v30 (copy), v44 (copy), v45 (copy), PreAuthDeepLinkUrlStore (copy), FFlagEnableDeepLinkHistoryWithModalAPI (copy), u46 (ref), DeepLink (copy), v40 (copy), PostAuthDeepLinkAvailableSignal (copy), v41 (copy), v42 (copy), PostAuthPendingLuaUrlAvailableSignal (copy), v43 (copy), FFlagEnablePreAuthDeepLinkHandler (copy), PreAuthDeepLinkHandler (copy), t1 (copy)
		if not v30 then
			return
		end

		local v51 = not v44 and v45

		if v51 then
			PreAuthDeepLinkUrlStore.setUrl(nil)

			if FFlagEnableDeepLinkHistoryWithModalAPI then
				u46.setDeepLinkLuaPostAuthReceiverStatus(DeepLink.DeepLinkLuaPostAuthReceiverStatus.Ready, v40 and v40.url)
			end

			if v40 and v40.url then
				PostAuthDeepLinkAvailableSignal:fire(v40)
				v41({
					url = nil,
					attributionUrl = nil
				})
			end

			if v42 and v42.hasPendingUrl then
				PostAuthPendingLuaUrlAvailableSignal:fire(v42)
				v43({
					hasPendingUrl = false,
					attributionUrl = nil,
					url = nil
				})
			end
		elseif FFlagEnableDeepLinkHistoryWithModalAPI then
			u46.setDeepLinkLuaPostAuthReceiverStatus(DeepLink.DeepLinkLuaPostAuthReceiverStatus.Disconnected, nil)
		end

		v30:getAndClearLastPendingURL():andThen(function(t2: {[any]: any}) -- line: 144
			-- upvalues: v51 (copy), PreAuthDeepLinkUrlStore (copy), v43 (copy), PostAuthPendingLuaUrlAvailableSignal (copy)
			if not t2 or not t2.hasPendingUrl then
				return
			end

			if not v51 then
				PreAuthDeepLinkUrlStore.setUrl(t2.url)
				v43(t2)

				return
			end

			PostAuthPendingLuaUrlAvailableSignal:fire(t2)
		end)
		v30:listenForLuaURLs(function(p5, p6) -- line: 161
			-- upvalues: FFlagEnablePreAuthDeepLinkHandler (copy), PreAuthDeepLinkHandler (copy), t1 (copy), v51 (copy), PreAuthDeepLinkUrlStore (copy), v41 (copy), PostAuthDeepLinkAvailableSignal (copy)
			if FFlagEnablePreAuthDeepLinkHandler and PreAuthDeepLinkHandler.isPreauthDeeplink(p5) then
				PreAuthDeepLinkHandler.firePreauthDeeplink(p5, t1)

				return
			end

			if not v51 then
				PreAuthDeepLinkUrlStore.setUrl(p5)

				local t3 = {
					url = p5,
					attributionUrl = p6
				}

				v41(t3)

				return
			end

			PostAuthDeepLinkAvailableSignal:fire({
				url = p5,
				attributionUrl = p6
			})
		end)
	end, {
		v30,
		v44,
		v45,
		PostAuthDeepLinkAvailableSignal,
		v40,
		v42
	})

	useEffect(function() -- line: 194
		-- upvalues: v47 (copy), v30 (copy)
		v47()

		return function() -- line: 198
			-- upvalues: v30 (copy)
			if v30 then
				v30:stopListeningForLuaURLs()
			end
		end
	end, { v47 })

	return nil
end
