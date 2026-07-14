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
local GetFFlagMomentsFixPeekReturnChrome = require(Moments.Flags.GetFFlagMomentsFixPeekReturnChrome)
local useMomentsTabIsVisible = require(Moments.Hooks.useMomentsTabIsVisible)
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
local v31 = RoactNavigation.createAppContainer(InnerNavigator)
local getActiveRoutes = Navigation.getActiveRoutes
local v33 = GetFFlagMomentsFixShareDeeplink()

local function normalizeDeepLinkedMomentId(p1) -- line: 69
	if type(p1) == "string" and p1 ~= "" then
		return p1
	end

	if type(p1) == "number" then
		return (tostring(p1))
	end

	return nil
end
local function getMomentIdFromLaunchData(p2) -- line: 78
	-- upvalues: HttpService (copy)
	if type(p2) ~= "string" or p2 == "" then
		return nil
	end

	local ok, result = pcall(function() -- line: 83
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
local function getDeepLinkedMomentIdFromParams(p3) -- line: 93
	-- upvalues: getMomentIdFromLaunchData (copy)
	if type(p3) ~= "table" then
		return nil
	end

	local extraProps = p3.extraProps

	if type(extraProps) == "table" then
		local postId = extraProps.postId
		local v52 = if type(postId) ~= "string" or postId == "" then if type(postId) ~= "number" then nil else tostring(postId) else postId

		if v52 ~= nil then
			return v52
		end

		local v53 = getMomentIdFromLaunchData(extraProps.launchData)

		if v53 ~= nil then
			return v53
		end
	end

	local postId = p3.postId
	local v55 = if type(postId) ~= "string" or postId == "" then if type(postId) ~= "number" then nil else tostring(postId) else postId

	if v55 ~= nil then
		return v55
	end

	return (getMomentIdFromLaunchData(p3.launchData))
end
local function getDeepLinkRequestFromNavigationParams(p4, s1: string) -- line: 124
	-- upvalues: getDeepLinkedMomentIdFromParams (copy)
	if not p4 or not p4.getParam then
		return nil
	end

	local t1 = {
		extraProps = p4.getParam("extraProps"),
		postId = p4.getParam("postId"),
		launchData = p4.getParam("launchData")
	}
	local v59 = getDeepLinkedMomentIdFromParams(t1)

	if v59 == nil then
		return nil
	end

	return {
		momentId = v59,
		key = `{ s1 }:params:{ tostring(t1.extraProps) }:{ tostring(t1.postId) }:{ tostring(t1.launchData) }:{ v59 }`
	}
end
local function getDeepLinkRequestFromNavigationState(p5, s2: string) -- line: 145
	-- upvalues: getActiveRoutes (copy), getDeepLinkedMomentIdFromParams (copy)
	local v62 = getActiveRoutes(p5)

	for i = #v62, 1, -1 do
		local v64 = v62[i]
		local v65 = getDeepLinkedMomentIdFromParams(v64.params)

		if v65 ~= nil then
			return {
				momentId = v65,
				key = `{ s2 }:state:{ tostring(v64.key) }:{ tostring(v64.params) }:{ v65 }`
			}
		end
	end

	return nil
end
local function getDeepLinkRequest(p6) -- line: 161
	-- upvalues: getDeepLinkRequestFromNavigationParams (copy), getDeepLinkRequestFromNavigationState (copy)
	local n1 = 0

	while p6 ~= nil do
		local str = tostring(n1)
		local v69 = getDeepLinkRequestFromNavigationParams(p6, str) or getDeepLinkRequestFromNavigationState(p6.state, str)

		if v69 ~= nil then
			return v69
		end

		if not p6._dangerouslyGetParent then
			return nil
		end

		p6 = p6._dangerouslyGetParent()
		n1 += 1
	end

	return nil
end
local function getEntrySource(p7) -- line: 182
	if not p7 or not p7.getParam then
		return "watch_tab"
	end

	local v71 = p7.getParam("extraProps")

	if type(v71) == "table" and type(v71.source) == "string" then
		return v71.source
	end

	return p7.getParam("source", "watch_tab")
end
local function MomentsTabEntry(t2: {[any]: any}) -- line: 193
	-- upvalues: React (copy), createMomentsStore (copy), useResetTeleportingOnGameLeave (copy), v33 (copy), getDeepLinkRequest (copy), GetDeepLinkStore (copy), RobloxAppEvents (copy), AppPage (copy), fireAnalyticsEvent (copy), EventNames (copy), SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy), FFlagMomentsSurfaceLoadTTI (copy), MomentsSurfaceLoadManager (copy), getExperienceDetailsSheetStore (copy), GetImmersiveChromeStore (copy), RoactNavigation (copy), useMomentsTabIsVisible (copy), GetFFlagMomentsFixPeekReturnChrome (copy), useMomentsGating (copy), InnerNavigator (copy), v31 (copy), MomentsHostShell (copy)
	local v73 = React.useRef(t2)

	v73.current = t2

	local v74 = React.useRef(false)
	local v75 = React.useRef(false)
	local v76 = React.useRef(nil)

	if v76.current == nil then
		v76.current = createMomentsStore()
	end

	useResetTeleportingOnGameLeave()

	local u77 = nil

	if v33 then
		local v78 = getDeepLinkRequest(t2.navigation)
		local v79 = if v78 == nil then nil else v78.momentId
		local v80 = if v78 == nil then nil else v78.key

		u77 = React.useRef(nil)

		if v79 ~= nil and v80 ~= u77.current then
			GetDeepLinkStore().setDeepLinkedMomentId(v79)
			u77.current = v80
		end

		React.useEffect(function() -- line: 229
			-- upvalues: v79 (copy), v75 (copy), RobloxAppEvents (copy), AppPage (copy)
			if v79 ~= nil and v75.current then
				RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
			end

			v75.current = true
		end, {
			v80,
			v79,
			t2.navigation
		})
	else
		React.useEffect(function() -- line: 240
			-- upvalues: t2 (copy), GetDeepLinkStore (copy), v75 (copy), RobloxAppEvents (copy), AppPage (copy)
			local navigation = t2.navigation

			if not navigation or not navigation.getParam then
				return
			end

			local v91 = navigation.getParam("extraProps")

			if type(v91) == "table" and type(v91.postId) == "string" then
				GetDeepLinkStore().setDeepLinkedMomentId(v91.postId)

				if v75.current then
					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end
			end

			v75.current = true
		end, { t2.navigation })
	end

	local v81 = React.useCallback(function() -- line: 257
		-- upvalues: v74 (copy), v76 (copy), v73 (copy), fireAnalyticsEvent (copy), EventNames (copy), SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy)
		if v74.current then
			return
		end

		v74.current = true

		local current = v76.current
		local navigation = v73.current.navigation
		local s3

		if not navigation or not navigation.getParam then
			s3 = "watch_tab"
		else
			local v95 = navigation.getParam("extraProps")

			s3 = if type(v95) ~= "table" or type(v95.source) ~= "string" then navigation.getParam("source", "watch_tab") else v95.source
		end

		current.resetSession()
		current.setSessionSource(s3)
		fireAnalyticsEvent(EventNames.TapMomentsTab, {
			moments_session_id = current.getMomentsSessionId(false),
			source = s3
		})

		local v96 = SessionManager.startSession(FunnelEventNames.FunnelTypes.AppNavigation)

		fireFunnelAnalyticsEvent(FunnelEventNames.FunnelTypes.AppNavigation, FunnelEventNames.AppNavigationSteps.AppLaunched, v96)
	end, {})
	local v82 = React.useCallback(function() -- line: 282
		-- upvalues: v74 (copy), FFlagMomentsSurfaceLoadTTI (copy), MomentsSurfaceLoadManager (copy), getExperienceDetailsSheetStore (copy), v76 (copy), fireAnalyticsEvent (copy), EventNames (copy), SessionManager (copy), FunnelEventNames (copy)
		if not v74.current then
			return
		end

		v74.current = false

		if FFlagMomentsSurfaceLoadTTI then
			MomentsSurfaceLoadManager.abort()
		end

		getExperienceDetailsSheetStore(false).close()

		local current = v76.current
		local v98 = os.clock() - current.getSessionStartTime(false)

		fireAnalyticsEvent(EventNames.MomentsSessionEnded, {
			moments_session_id = current.getMomentsSessionId(false),
			source = current.getSessionSource(false),
			duration_seconds = tostring((math.floor(v98)))
		})
		SessionManager.endSession(FunnelEventNames.FunnelTypes.AppNavigation)
	end, {})
	local v83 = React.useCallback(function() -- line: 312
		-- upvalues: GetImmersiveChromeStore (copy), v73 (copy)
		GetImmersiveChromeStore(false).setOverlayCovering(false)

		local onTabFocused = v73.current.onTabFocused

		if onTabFocused then
			onTabFocused()
		end
	end, {})

	React.useEffect(function() -- line: 325
		-- upvalues: t2 (copy), v81 (copy), v83 (copy), v82 (copy), RoactNavigation (copy), v33 (copy), getDeepLinkRequest (copy), GetDeepLinkStore (copy), u77 (ref), RobloxAppEvents (copy), AppPage (copy)
		local navigation = t2.navigation

		if not navigation or not navigation.addListener then
			v81()
			v83()

			return function() -- line: 330
				-- upvalues: v82 (copy)
				v82()
			end
		end

		v81()
		v83()

		local v101 = navigation.addListener(RoactNavigation.Events.DidFocus, function() -- line: 338
			-- upvalues: v33 (copy), getDeepLinkRequest (copy), navigation (copy), GetDeepLinkStore (copy), u77 (ref), RobloxAppEvents (copy), AppPage (copy), v81 (copy), v83 (copy)
			if v33 then
				local v105 = getDeepLinkRequest(navigation)

				if v105 ~= nil then
					GetDeepLinkStore().setDeepLinkedMomentId(v105.momentId)
					u77.current = v105.key
					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end
			else
				local v106 = navigation.getParam("extraProps")

				if type(v106) == "table" and type(v106.postId) == "string" then
					GetDeepLinkStore().setDeepLinkedMomentId(v106.postId)
					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end
			end

			v81()
			v83()
		end)
		local v102 = navigation.addListener(RoactNavigation.Events.WillBlur, function() -- line: 357
			-- upvalues: v82 (copy)
			v82()
		end)

		return function() -- line: 361
			-- upvalues: v82 (copy), v101 (copy), v102 (copy)
			v82()
			v101.remove()
			v102.remove()
		end
	end, {
		v81,
		v82,
		v83
	})

	local v84 = useMomentsTabIsVisible()

	React.useEffect(function() -- line: 376
		-- upvalues: GetFFlagMomentsFixPeekReturnChrome (copy), v84 (copy), v83 (copy)
		if GetFFlagMomentsFixPeekReturnChrome() and v84 then
			v83()
		end
	end, {
		v84,
		v83
	})

	local v85 = React.useMemo(function() -- line: 386
		-- upvalues: t2 (copy), GetImmersiveChromeStore (copy)
		local openProfile = t2.openProfile
		local openOwnMoments = t2.openOwnMoments

		return {
			openProfile = if not openProfile then nil else function(n2: number) -- line: 391
				-- upvalues: GetImmersiveChromeStore (copy), openProfile (copy)
				GetImmersiveChromeStore(false).setOverlayCovering(true)
				openProfile(n2)
			end,
			openOwnMoments = if not openOwnMoments then nil else function() -- line: 397
				-- upvalues: GetImmersiveChromeStore (copy), openOwnMoments (copy)
				GetImmersiveChromeStore(false).setOverlayCovering(true)
				openOwnMoments()
			end
		}
	end, {
		t2.openProfile,
		t2.openOwnMoments
	})
	local v86 = useMomentsGating()

	if not v86.isTabEnabled and (not v86.isFlyoutEntryEnabled or not v86.platformIntegrationEnabled) then
		return nil
	end

	local v87 = if not t2.useRootOwnedNavigation then React.createElement(v31) else React.createElement(InnerNavigator, {
		navigation = t2.navigation
	})

	return React.createElement(MomentsHostShell, {
		sessionStore = v76.current,
		openProfile = v85.openProfile,
		openOwnMoments = v85.openOwnMoments
	}, v87)
end
local function MomentsTabEntrySessionized(t3: {[any]: any}) -- line: 433
	-- upvalues: React (copy), MomentsTabEntry (copy)
	return React.createElement(MomentsTabEntry, {
		useRootOwnedNavigation = true,
		navigation = t3.navigation,
		openProfile = t3.openProfile,
		openOwnMoments = t3.openOwnMoments,
		onTabFocused = t3.onTabFocused
	})
end

local v43 = React.Component:extend("MomentsTabEntryScreen")

function v43.render(p8) -- line: 448
	-- upvalues: React (copy), MomentsTabEntrySessionized (copy)
	return React.createElement(MomentsTabEntrySessionized, p8.props)
end

v43.router = InnerNavigator.router

if FFlagMomentsWatchSessionalization then
	return v43
end

return MomentsTabEntry
