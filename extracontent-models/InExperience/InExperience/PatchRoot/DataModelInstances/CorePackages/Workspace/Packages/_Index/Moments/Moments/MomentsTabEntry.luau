local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local HttpService = game:GetService("HttpService")
local MomentsCommon = require(MomentsParent.MomentsCommon)
local Navigation = require(MomentsParent.Navigation)
local React = require(MomentsParent.React)
local RoactNavigation = require(MomentsParent.RoactNavigation)
local SharedFlags = require(MomentsParent.SharedFlags)
local AppPage = require(MomentsParent.RobloxAppEnums).AppPage
local RobloxAppEvents = require(MomentsParent.RobloxAppEvents)
local GetDeepLinkStore = require(Moments.Stores.GetDeepLinkStore)
local createMomentsStore = require(Moments.Stores.GetMomentsStore.createMomentsStore)
local GetImmersiveChromeStore = require(Moments.Stores.GetImmersiveChromeStore)
local GetFFlagMomentsFixShareDeeplink = require(Moments.Flags.GetFFlagMomentsFixShareDeeplink)
local InnerNavigator = require(Moments.Navigation.InnerNavigator)
local MomentsHostShell = require(Moments.Components.MomentsHostShell)
local useResetTeleportingOnGameLeave = require(Moments.Hooks.useResetTeleportingOnGameLeave)
local getExperienceDetailsSheetStore = require(Moments.ExperienceDetailsSheet.Sheet.getExperienceDetailsSheetStore)
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local FunnelEventNames = Analytics.FunnelEventNames
local SessionManager = Analytics.SessionManager
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local fireFunnelAnalyticsEvent = Analytics.fireFunnelAnalyticsEvent
local MomentsSurfaceLoadManager = MomentsCommon.Performance.MomentsSurfaceLoadManager
local useMomentsGating = MomentsCommon.Hooks.useMomentsGating
local FFlagMomentsWatchSessionalization = SharedFlags.FFlagMomentsWatchSessionalization
local FFlagMomentsSurfaceLoadTTI = SharedFlags.FFlagMomentsSurfaceLoadTTI
local v29 = RoactNavigation.createAppContainer(InnerNavigator)
local getActiveRoutes = Navigation.getActiveRoutes
local v31 = GetFFlagMomentsFixShareDeeplink()

local function normalizeDeepLinkedMomentId(p1) -- line: 67
	if type(p1) == "string" and p1 ~= "" then
		return p1
	end

	if type(p1) == "number" then
		return (tostring(p1))
	end

	return nil
end
local function getMomentIdFromLaunchData(p2) -- line: 76
	-- upvalues: HttpService (copy)
	if type(p2) ~= "string" or p2 == "" then
		return nil
	end

	local ok, result = pcall(function() -- line: 81
		-- upvalues: HttpService (copy), p2 (copy)
		return HttpService:JSONDecode(p2)
	end)

	if ok and type(result) == "table" then
		local postId = result.postId

		if type(postId) == "string" and postId ~= "" then
			return postId
		end

		if type(postId) == "number" then
			return (tostring(postId))
		end

		return nil
	end

	return nil
end
local function getDeepLinkedMomentIdFromParams(p3) -- line: 91
	-- upvalues: getMomentIdFromLaunchData (copy)
	if type(p3) ~= "table" then
		return nil
	end

	local extraProps = p3.extraProps

	if type(extraProps) == "table" then
		local postId = extraProps.postId
		local v50 = if type(postId) ~= "string" or postId == "" then if type(postId) ~= "number" then nil else tostring(postId) else postId

		if v50 ~= nil then
			return v50
		end

		local v51 = getMomentIdFromLaunchData(extraProps.launchData)

		if v51 ~= nil then
			return v51
		end
	end

	local postId = p3.postId
	local v53 = if type(postId) ~= "string" or postId == "" then if type(postId) ~= "number" then nil else tostring(postId) else postId

	if v53 ~= nil then
		return v53
	end

	return (getMomentIdFromLaunchData(p3.launchData))
end
local function getDeepLinkRequestFromNavigationParams(p4, s1: string) -- line: 122
	-- upvalues: getDeepLinkedMomentIdFromParams (copy)
	if not p4 or not p4.getParam then
		return nil
	end

	local t1 = {
		extraProps = p4.getParam("extraProps"),
		postId = p4.getParam("postId"),
		launchData = p4.getParam("launchData")
	}
	local v57 = getDeepLinkedMomentIdFromParams(t1)

	if v57 == nil then
		return nil
	end

	return {
		momentId = v57,
		key = `{ s1 }:params:{ tostring(t1.extraProps) }:{ tostring(t1.postId) }:{ tostring(t1.launchData) }:{ v57 }`
	}
end
local function getDeepLinkRequestFromNavigationState(p5, s2: string) -- line: 143
	-- upvalues: getActiveRoutes (copy), getDeepLinkedMomentIdFromParams (copy)
	local v60 = getActiveRoutes(p5)

	for i = #v60, 1, -1 do
		local v62 = v60[i]
		local v63 = getDeepLinkedMomentIdFromParams(v62.params)

		if v63 ~= nil then
			return {
				momentId = v63,
				key = `{ s2 }:state:{ tostring(v62.key) }:{ tostring(v62.params) }:{ v63 }`
			}
		end
	end

	return nil
end
local function getDeepLinkRequest(p6) -- line: 159
	-- upvalues: getDeepLinkRequestFromNavigationParams (copy), getDeepLinkRequestFromNavigationState (copy)
	local n1 = 0

	while p6 ~= nil do
		local str = tostring(n1)
		local v67 = getDeepLinkRequestFromNavigationParams(p6, str) or getDeepLinkRequestFromNavigationState(p6.state, str)

		if v67 ~= nil then
			return v67
		end

		if not p6._dangerouslyGetParent then
			return nil
		end

		p6 = p6._dangerouslyGetParent()
		n1 += 1
	end

	return nil
end
local function getEntrySource(p7) -- line: 180
	if not p7 or not p7.getParam then
		return "watch_tab"
	end

	local v69 = p7.getParam("extraProps")

	if type(v69) == "table" and type(v69.source) == "string" then
		return v69.source
	end

	return p7.getParam("source", "watch_tab")
end
local function MomentsTabEntry(t2: {[any]: any}) -- line: 191
	-- upvalues: React (copy), createMomentsStore (copy), useResetTeleportingOnGameLeave (copy), v31 (copy), getDeepLinkRequest (copy), GetDeepLinkStore (copy), RobloxAppEvents (copy), AppPage (copy), fireAnalyticsEvent (copy), EventNames (copy), SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy), FFlagMomentsSurfaceLoadTTI (copy), MomentsSurfaceLoadManager (copy), getExperienceDetailsSheetStore (copy), GetImmersiveChromeStore (copy), RoactNavigation (copy), useMomentsGating (copy), InnerNavigator (copy), v29 (copy), MomentsHostShell (copy)
	local v71 = React.useRef(t2)

	v71.current = t2

	local v72 = React.useRef(false)
	local v73 = React.useRef(false)
	local v74 = React.useRef(nil)

	if v74.current == nil then
		v74.current = createMomentsStore()
	end

	useResetTeleportingOnGameLeave()

	local u75 = nil

	if v31 then
		local v76 = getDeepLinkRequest(t2.navigation)
		local v77 = if v76 == nil then nil else v76.momentId
		local v78 = if v76 == nil then nil else v76.key

		u75 = React.useRef(nil)

		if v77 ~= nil and v78 ~= u75.current then
			GetDeepLinkStore().setDeepLinkedMomentId(v77)
			u75.current = v78
		end

		React.useEffect(function() -- line: 227
			-- upvalues: v77 (copy), v73 (copy), RobloxAppEvents (copy), AppPage (copy)
			if v77 ~= nil and v73.current then
				RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
			end

			v73.current = true
		end, {
			v78,
			v77,
			t2.navigation
		})
	else
		React.useEffect(function() -- line: 238
			-- upvalues: t2 (copy), GetDeepLinkStore (copy), v73 (copy), RobloxAppEvents (copy), AppPage (copy)
			local navigation = t2.navigation

			if not navigation or not navigation.getParam then
				return
			end

			local v88 = navigation.getParam("extraProps")

			if type(v88) == "table" and type(v88.postId) == "string" then
				GetDeepLinkStore().setDeepLinkedMomentId(v88.postId)

				if v73.current then
					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end
			end

			v73.current = true
		end, { t2.navigation })
	end

	local v79 = React.useCallback(function() -- line: 255
		-- upvalues: v72 (copy), v74 (copy), v71 (copy), fireAnalyticsEvent (copy), EventNames (copy), SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy)
		if v72.current then
			return
		end

		v72.current = true

		local current = v74.current
		local navigation = v71.current.navigation
		local s3

		if not navigation or not navigation.getParam then
			s3 = "watch_tab"
		else
			local v92 = navigation.getParam("extraProps")

			s3 = if type(v92) ~= "table" or type(v92.source) ~= "string" then navigation.getParam("source", "watch_tab") else v92.source
		end

		current.resetSession()
		current.setSessionSource(s3)
		fireAnalyticsEvent(EventNames.TapMomentsTab, {
			moments_session_id = current.getMomentsSessionId(false),
			source = s3
		})

		local v93 = SessionManager.startSession(FunnelEventNames.FunnelTypes.AppNavigation)

		fireFunnelAnalyticsEvent(FunnelEventNames.FunnelTypes.AppNavigation, FunnelEventNames.AppNavigationSteps.AppLaunched, v93)
	end, {})
	local v80 = React.useCallback(function() -- line: 280
		-- upvalues: v72 (copy), FFlagMomentsSurfaceLoadTTI (copy), MomentsSurfaceLoadManager (copy), getExperienceDetailsSheetStore (copy), v74 (copy), fireAnalyticsEvent (copy), EventNames (copy), SessionManager (copy), FunnelEventNames (copy)
		if not v72.current then
			return
		end

		v72.current = false

		if FFlagMomentsSurfaceLoadTTI then
			MomentsSurfaceLoadManager.abort()
		end

		getExperienceDetailsSheetStore(false).close()

		local current = v74.current
		local v95 = os.clock() - current.getSessionStartTime(false)

		fireAnalyticsEvent(EventNames.MomentsSessionEnded, {
			moments_session_id = current.getMomentsSessionId(false),
			source = current.getSessionSource(false),
			duration_seconds = tostring((math.floor(v95)))
		})
		SessionManager.endSession(FunnelEventNames.FunnelTypes.AppNavigation)
	end, {})
	local v81 = React.useCallback(function() -- line: 310
		-- upvalues: GetImmersiveChromeStore (copy), v71 (copy)
		GetImmersiveChromeStore(false).setOverlayCovering(false)

		local onTabFocused = v71.current.onTabFocused

		if onTabFocused then
			onTabFocused()
		end
	end, {})

	React.useEffect(function() -- line: 323
		-- upvalues: t2 (copy), v79 (copy), v81 (copy), v80 (copy), RoactNavigation (copy), v31 (copy), getDeepLinkRequest (copy), GetDeepLinkStore (copy), u75 (ref), RobloxAppEvents (copy), AppPage (copy)
		local navigation = t2.navigation

		if not navigation or not navigation.addListener then
			v79()
			v81()

			return function() -- line: 328
				-- upvalues: v80 (copy)
				v80()
			end
		end

		v79()
		v81()

		local v98 = navigation.addListener(RoactNavigation.Events.DidFocus, function() -- line: 336
			-- upvalues: v31 (copy), getDeepLinkRequest (copy), navigation (copy), GetDeepLinkStore (copy), u75 (ref), RobloxAppEvents (copy), AppPage (copy), v79 (copy), v81 (copy)
			if v31 then
				local v102 = getDeepLinkRequest(navigation)

				if v102 ~= nil then
					GetDeepLinkStore().setDeepLinkedMomentId(v102.momentId)
					u75.current = v102.key
					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end
			else
				local v103 = navigation.getParam("extraProps")

				if type(v103) == "table" and type(v103.postId) == "string" then
					GetDeepLinkStore().setDeepLinkedMomentId(v103.postId)
					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end
			end

			v79()
			v81()
		end)
		local v99 = navigation.addListener(RoactNavigation.Events.WillBlur, function() -- line: 355
			-- upvalues: v80 (copy)
			v80()
		end)

		return function() -- line: 359
			-- upvalues: v80 (copy), v98 (copy), v99 (copy)
			v80()
			v98.remove()
			v99.remove()
		end
	end, {
		v79,
		v80,
		v81
	})

	local v82 = React.useMemo(function() -- line: 370
		-- upvalues: t2 (copy), GetImmersiveChromeStore (copy)
		local openProfile = t2.openProfile
		local openOwnMoments = t2.openOwnMoments

		return {
			openProfile = if not openProfile then nil else function(n2: number) -- line: 375
				-- upvalues: GetImmersiveChromeStore (copy), openProfile (copy)
				GetImmersiveChromeStore(false).setOverlayCovering(true)
				openProfile(n2)
			end,
			openOwnMoments = if not openOwnMoments then nil else function() -- line: 381
				-- upvalues: GetImmersiveChromeStore (copy), openOwnMoments (copy)
				GetImmersiveChromeStore(false).setOverlayCovering(true)
				openOwnMoments()
			end
		}
	end, {
		t2.openProfile,
		t2.openOwnMoments
	})
	local v83 = useMomentsGating()

	if not v83.isTabEnabled and (not v83.isFlyoutEntryEnabled or not v83.platformIntegrationEnabled) then
		return nil
	end

	local v84 = if not t2.useRootOwnedNavigation then React.createElement(v29) else React.createElement(InnerNavigator, {
		navigation = t2.navigation
	})

	return React.createElement(MomentsHostShell, {
		sessionStore = v74.current,
		openProfile = v82.openProfile,
		openOwnMoments = v82.openOwnMoments
	}, v84)
end
local function MomentsTabEntrySessionized(t3: {[any]: any}) -- line: 417
	-- upvalues: React (copy), MomentsTabEntry (copy)
	return React.createElement(MomentsTabEntry, {
		useRootOwnedNavigation = true,
		navigation = t3.navigation,
		openProfile = t3.openProfile,
		openOwnMoments = t3.openOwnMoments,
		onTabFocused = t3.onTabFocused
	})
end

local v41 = React.Component:extend("MomentsTabEntryScreen")

function v41.render(p8) -- line: 432
	-- upvalues: React (copy), MomentsTabEntrySessionized (copy)
	return React.createElement(MomentsTabEntrySessionized, p8.props)
end

v41.router = InnerNavigator.router

if FFlagMomentsWatchSessionalization then
	return v41
end

return MomentsTabEntry
