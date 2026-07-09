local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local React = require(AuthCommonParent.React)
local useRoactService = require(AuthCommonParent.RobloxAppHooks).useRoactService
local useSelector = require(AuthCommonParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(AuthCommonParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useAppPolicy = require(AuthCommonParent.UniversalAppPolicy).useAppPolicy
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
local FFlagEnableDeepLinkHistoryWithModalAPI = require(AuthCommonParent.SharedFlags).FFlagEnableDeepLinkHistoryWithModalAPI
local PostAuthDeepLinkAvailableSignal = require(script.Parent.PostAuthDeepLinkAvailableSignal)
local PostAuthPendingLuaUrlAvailableSignal = require(script.Parent.PostAuthPendingLuaUrlAvailableSignal)
local PreAuthDeepLinkHandler = require(script.Parent.PreAuthDeepLinkHandler)
local PreAuthDeepLinkUrlStore = require(AuthCommon.Stores).PreAuthDeepLinkUrlStore
local FFlagEnablePreAuthDeepLinkHandler = require(AuthCommon.Flags.FFlagEnablePreAuthDeepLinkHandler)

return function(p1) -- line: 35
	-- upvalues: useRoactService (copy), AppLinking (copy), RoactNetworking (copy), useDispatch (copy), AppOmniRecommendationsRequest (copy), RoactAnalytics (copy), useAppPolicy (copy), useState (copy), useSelector (copy), LoginStatus (copy), RetrievalStatus (copy), FFlagEnableDeepLinkHistoryWithModalAPI (copy), DeepLink (copy), useCallback (copy), PreAuthDeepLinkUrlStore (copy), PostAuthDeepLinkAvailableSignal (copy), PostAuthPendingLuaUrlAvailableSignal (copy), FFlagEnablePreAuthDeepLinkHandler (copy), PreAuthDeepLinkHandler (copy), useEffect (copy)
	local v26 = useRoactService(AppLinking)
	local monoDeps = p1.monoDeps
	local LaunchApp = monoDeps.LaunchApp
	local ResetAppState = monoDeps.ResetAppState
	local v30 = useRoactService(RoactNetworking)
	local v31 = useDispatch()
	local v32 = useRoactService(AppOmniRecommendationsRequest)
	local v33 = useRoactService(RoactAnalytics)
	local v34 = useAppPolicy(function(p2) -- line: 47
		return p2
	end)
	local t1 = {
		networking = v30,
		launchApp = LaunchApp,
		dispatch = v31,
		omniRecommendationsRequest = v32,
		analytics = v33,
		appPolicy = v34,
		resetAppState = ResetAppState
	}
	local v36, v37 = useState({
		url = nil,
		attributionUrl = nil
	})
	local v38, v39 = useState({
		hasPendingUrl = false,
		attributionUrl = nil,
		url = nil
	})
	local v40 = useSelector(function(p3) -- line: 80
		-- upvalues: LoginStatus (copy)
		return p3.AuthenticationStatus.status == LoginStatus.LOGGED_OUT
	end)
	local v41 = useSelector(function(p4) -- line: 84
		-- upvalues: RetrievalStatus (copy)
		return p4.Startup.AppDataStatus ~= RetrievalStatus.NotStarted
	end)
	local u42 = nil

	if FFlagEnableDeepLinkHistoryWithModalAPI then
		u42 = DeepLink.DeepLinkLuaReceiverStatusStore(false)
	end

	local v43 = useCallback(function() -- line: 93
		-- upvalues: v26 (copy), v40 (copy), v41 (copy), PreAuthDeepLinkUrlStore (copy), FFlagEnableDeepLinkHistoryWithModalAPI (copy), u42 (ref), DeepLink (copy), v36 (copy), PostAuthDeepLinkAvailableSignal (copy), v37 (copy), v38 (copy), PostAuthPendingLuaUrlAvailableSignal (copy), v39 (copy), FFlagEnablePreAuthDeepLinkHandler (copy), PreAuthDeepLinkHandler (copy), t1 (copy)
		if not v26 then
			return
		end

		local v47 = not v40 and v41

		if v47 then
			PreAuthDeepLinkUrlStore.setUrl(nil)

			if FFlagEnableDeepLinkHistoryWithModalAPI then
				u42.setDeepLinkLuaPostAuthReceiverStatus(DeepLink.DeepLinkLuaPostAuthReceiverStatus.Ready, v36 and v36.url)
			end

			if v36 and v36.url then
				PostAuthDeepLinkAvailableSignal:fire(v36)
				v37({
					url = nil,
					attributionUrl = nil
				})
			end

			if v38 and v38.hasPendingUrl then
				PostAuthPendingLuaUrlAvailableSignal:fire(v38)
				v39({
					hasPendingUrl = false,
					attributionUrl = nil,
					url = nil
				})
			end
		elseif FFlagEnableDeepLinkHistoryWithModalAPI then
			u42.setDeepLinkLuaPostAuthReceiverStatus(DeepLink.DeepLinkLuaPostAuthReceiverStatus.Disconnected, nil)
		end

		v26:getAndClearLastPendingURL():andThen(function(t2: {[any]: any}) -- line: 135
			-- upvalues: v47 (copy), PreAuthDeepLinkUrlStore (copy), v39 (copy), PostAuthPendingLuaUrlAvailableSignal (copy)
			if not t2 or not t2.hasPendingUrl then
				return
			end

			if not v47 then
				PreAuthDeepLinkUrlStore.setUrl(t2.url)
				v39(t2)

				return
			end

			PostAuthPendingLuaUrlAvailableSignal:fire(t2)
		end)
		v26:listenForLuaURLs(function(p5, p6) -- line: 152
			-- upvalues: FFlagEnablePreAuthDeepLinkHandler (copy), PreAuthDeepLinkHandler (copy), t1 (copy), v47 (copy), PreAuthDeepLinkUrlStore (copy), v37 (copy), PostAuthDeepLinkAvailableSignal (copy)
			if FFlagEnablePreAuthDeepLinkHandler and PreAuthDeepLinkHandler.isPreauthDeeplink(p5) then
				PreAuthDeepLinkHandler.firePreauthDeeplink(p5, t1)

				return
			end

			if not v47 then
				PreAuthDeepLinkUrlStore.setUrl(p5)

				local t3 = {
					url = p5,
					attributionUrl = p6
				}

				v37(t3)

				return
			end

			PostAuthDeepLinkAvailableSignal:fire({
				url = p5,
				attributionUrl = p6
			})
		end)
	end, {
		v26,
		v40,
		v41,
		PostAuthDeepLinkAvailableSignal,
		v36,
		v38
	})

	useEffect(function() -- line: 185
		-- upvalues: v43 (copy), v26 (copy)
		v43()

		return function() -- line: 189
			-- upvalues: v26 (copy)
			if v26 then
				v26:stopListeningForLuaURLs()
			end
		end
	end, { v43 })

	return nil
end
