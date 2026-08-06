local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local HttpService = game:GetService("HttpService")
local MomentsCommon = require(MomentsParent.MomentsCommon)
local MomentsTypes = require(MomentsParent.MomentsTypes)
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
local GetFFlagMomentsShareDeeplinkReliableOpen = require(Moments.Flags.GetFFlagMomentsShareDeeplinkReliableOpen)
local GetFFlagMomentsFixPeekReturnChrome = require(Moments.Flags.GetFFlagMomentsFixPeekReturnChrome)
local FFlagMomentsEmojiSetsApi = require(Moments.Flags.FFlagMomentsEmojiSetsApi)
local useMomentsTabIsVisible = require(Moments.Hooks.useMomentsTabIsVisible)
local InnerNavigator = require(Moments.Navigation.InnerNavigator)
local MomentsHostShell = require(Moments.Components.MomentsHostShell)
local useResetTeleportingOnGameLeave = require(Moments.Hooks.useResetTeleportingOnGameLeave)
local getExperienceDetailsSheetStore = require(Moments.ExperienceDetailsSheet.Sheet.getExperienceDetailsSheetStore)
local MomentsGetMomentsReactionsStore = require(MomentsParent.DataHydration.MomentsGetMomentsReactionsStore)
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local FunnelEventNames = Analytics.FunnelEventNames
local SessionManager = Analytics.SessionManager
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local fireFunnelAnalyticsEvent = Analytics.fireFunnelAnalyticsEvent
local MomentsSurfaceLoadManager = MomentsCommon.Performance.MomentsSurfaceLoadManager
local useMomentsGating = MomentsCommon.Hooks.useMomentsGating
local canRenderNativeMoments = MomentsCommon.canRenderNativeMoments
local FFlagMomentsWatchSessionalization = SharedFlags.FFlagMomentsWatchSessionalization
local FFlagMomentsSurfaceLoadTTI = SharedFlags.FFlagMomentsSurfaceLoadTTI
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis
local ShareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType
local v38 = RoactNavigation.createAppContainer(InnerNavigator)
local getActiveRoutes = Navigation.getActiveRoutes
local v40 = GetFFlagMomentsFixShareDeeplink()

local function normalizeDeepLinkedMomentId(p1) -- line: 78
	if type(p1) == "string" and p1 ~= "" then
		return p1
	end

	if type(p1) == "number" then
		return (tostring(p1))
	end

	return nil
end
local function getMomentIdFromLaunchData(p2) -- line: 87
	-- upvalues: HttpService (copy)
	if type(p2) ~= "string" or p2 == "" then
		return nil
	end

	local ok, result = pcall(function() -- line: 92
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
local function normalizeTargetIdType(p3) -- line: 102
	-- upvalues: ShareLinkTargetIdType (copy)
	if p3 == ShareLinkTargetIdType.FeedItemId then
		return ShareLinkTargetIdType.FeedItemId
	end

	return nil
end
local function getTargetIdTypeFromLaunchData(p4) -- line: 106
	-- upvalues: HttpService (copy), ShareLinkTargetIdType (copy)
	if type(p4) ~= "string" or p4 == "" then
		return nil
	end

	local ok, result = pcall(function() -- line: 111
		-- upvalues: HttpService (copy), p4 (copy)
		return HttpService:JSONDecode(p4)
	end)

	if ok and type(result) == "table" then
		if result.targetIdType == ShareLinkTargetIdType.FeedItemId then
			return ShareLinkTargetIdType.FeedItemId
		end

		return nil
	end

	return nil
end
local function getDeepLinkedMomentIdFromParams(p5) -- line: 121
	-- upvalues: getMomentIdFromLaunchData (copy)
	if type(p5) ~= "table" then
		return nil
	end

	local extraProps = p5.extraProps

	if type(extraProps) == "table" then
		local postId = extraProps.postId
		local v67 = if type(postId) ~= "string" or postId == "" then if type(postId) ~= "number" then nil else tostring(postId) else postId

		if v67 ~= nil then
			return v67
		end

		local v68 = getMomentIdFromLaunchData(extraProps.launchData)

		if v68 ~= nil then
			return v68
		end
	end

	local postId = p5.postId
	local v70 = if type(postId) ~= "string" or postId == "" then if type(postId) ~= "number" then nil else tostring(postId) else postId

	if v70 ~= nil then
		return v70
	end

	return (getMomentIdFromLaunchData(p5.launchData))
end
local function getDeepLinkedMomentTargetIdTypeFromParams(p6) -- line: 147
	-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy), ShareLinkTargetIdType (copy), getMomentIdFromLaunchData (copy), getTargetIdTypeFromLaunchData (copy)
	if not FFlagMomentsPassFeedItemIdToBackendApis or type(p6) ~= "table" then
		return nil
	end

	local extraProps = p6.extraProps

	if type(extraProps) == "table" then
		local postId = extraProps.postId

		if ((if type(postId) ~= "string" or postId == "" then (if type(postId) ~= "number" then nil else tostring(postId)) else postId)) ~= nil then
			if extraProps.targetIdType == ShareLinkTargetIdType.FeedItemId then
				return ShareLinkTargetIdType.FeedItemId
			end

			return nil
		end

		if getMomentIdFromLaunchData(extraProps.launchData) ~= nil then
			return (getTargetIdTypeFromLaunchData(extraProps.launchData))
		end
	end

	local postId = p6.postId

	if ((if type(postId) ~= "string" or postId == "" then (if type(postId) ~= "number" then nil else tostring(postId)) else postId)) ~= nil then
		if p6.targetIdType == ShareLinkTargetIdType.FeedItemId then
			return ShareLinkTargetIdType.FeedItemId
		end

		return nil
	end

	return (getTargetIdTypeFromLaunchData(p6.launchData))
end
local function getDeepLinkRequestFromNavigationParams(p7, s1: string) -- line: 176
	-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy), getDeepLinkedMomentIdFromParams (copy), getDeepLinkedMomentTargetIdTypeFromParams (copy)
	if not p7 or not p7.getParam then
		return nil
	end

	local t1 = {
		extraProps = p7.getParam("extraProps"),
		postId = p7.getParam("postId"),
		targetIdType = if not FFlagMomentsPassFeedItemIdToBackendApis then nil else p7.getParam("targetIdType"),
		launchData = p7.getParam("launchData")
	}
	local v78 = getDeepLinkedMomentIdFromParams(t1)

	if v78 == nil then
		return nil
	end

	local v79 = getDeepLinkedMomentTargetIdTypeFromParams(t1)

	return {
		momentId = v78,
		targetIdType = v79,
		key = if not FFlagMomentsPassFeedItemIdToBackendApis then `{ s1 }:params:{ tostring(t1.extraProps) }:{ tostring(t1.postId) }:{ tostring(t1.launchData) }:{ v78 }` else `{ s1 }:params:{ tostring(t1.extraProps) }:{ tostring(t1.postId) }:{ tostring(t1.launchData) }:{ v78 }:{ tostring(v79) }`
	}
end
local function getDeepLinkRequestFromNavigationState(p8, s2: string) -- line: 206
	-- upvalues: getActiveRoutes (copy), getDeepLinkedMomentIdFromParams (copy), getDeepLinkedMomentTargetIdTypeFromParams (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy)
	local v82 = getActiveRoutes(p8)

	for i = #v82, 1, -1 do
		local v84 = v82[i]
		local v85 = getDeepLinkedMomentIdFromParams(v84.params)

		if v85 ~= nil then
			local v86 = getDeepLinkedMomentTargetIdTypeFromParams(v84.params)

			return {
				momentId = v85,
				targetIdType = v86,
				key = if not FFlagMomentsPassFeedItemIdToBackendApis then `{ s2 }:state:{ tostring(v84.key) }:{ tostring(v84.params) }:{ v85 }` else `{ s2 }:state:{ tostring(v84.key) }:{ tostring(v84.params) }:{ v85 }:{ tostring(v86) }`
			}
		end
	end

	return nil
end
local function getDeepLinkRequest(p9) -- line: 228
	-- upvalues: getDeepLinkRequestFromNavigationParams (copy), getDeepLinkRequestFromNavigationState (copy)
	local n1 = 0

	while p9 ~= nil do
		local str = tostring(n1)
		local v90 = getDeepLinkRequestFromNavigationParams(p9, str) or getDeepLinkRequestFromNavigationState(p9.state, str)

		if v90 ~= nil then
			return v90
		end

		if not p9._dangerouslyGetParent then
			return nil
		end

		p9 = p9._dangerouslyGetParent()
		n1 += 1
	end

	return nil
end
local function getEntrySource(p10) -- line: 249
	if not p10 or not p10.getParam then
		return "watch_tab"
	end

	local v92 = p10.getParam("extraProps")

	if type(v92) == "table" and type(v92.source) == "string" then
		return v92.source
	end

	return p10.getParam("source", "watch_tab")
end
local function seedDeepLinkedMoment(p11, s3: string, s4: string?) -- line: 260
	-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy)
	if FFlagMomentsPassFeedItemIdToBackendApis then
		p11.setDeepLinkedMoment(s3, s4)

		return
	end

	p11.setDeepLinkedMomentId(s3)
end
local function MomentsTabEntry(t2: {[any]: any}) -- line: 268
	-- upvalues: React (copy), createMomentsStore (copy), useResetTeleportingOnGameLeave (copy), v40 (copy), GetFFlagMomentsShareDeeplinkReliableOpen (copy), getDeepLinkRequest (copy), GetDeepLinkStore (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), RobloxAppEvents (copy), AppPage (copy), ShareLinkTargetIdType (copy), FFlagMomentsEmojiSetsApi (copy), MomentsGetMomentsReactionsStore (copy), fireAnalyticsEvent (copy), EventNames (copy), SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy), FFlagMomentsSurfaceLoadTTI (copy), MomentsSurfaceLoadManager (copy), getExperienceDetailsSheetStore (copy), GetImmersiveChromeStore (copy), RoactNavigation (copy), useMomentsTabIsVisible (copy), GetFFlagMomentsFixPeekReturnChrome (copy), useMomentsGating (copy), canRenderNativeMoments (copy), InnerNavigator (copy), v38 (copy), MomentsHostShell (copy)
	local v97 = React.useRef(t2)

	v97.current = t2

	local v98 = React.useRef(false)
	local v99 = React.useRef(false)
	local v100 = React.useRef(nil)

	if v100.current == nil then
		v100.current = createMomentsStore()
	end

	useResetTeleportingOnGameLeave()

	local v101 = v40 or GetFFlagMomentsShareDeeplinkReliableOpen()
	local u102 = nil

	if v101 then
		local v103 = getDeepLinkRequest(t2.navigation)
		local v104 = if v103 == nil then nil else v103.momentId
		local v105 = if v103 == nil then nil else v103.key

		u102 = React.useRef(nil)

		if v104 ~= nil and v105 ~= u102.current then
			local v106 = GetDeepLinkStore()
			local v107 = if v103 == nil then nil else v103.targetIdType

			if FFlagMomentsPassFeedItemIdToBackendApis then
				v106.setDeepLinkedMoment(v104, v107)
			else
				v106.setDeepLinkedMomentId(v104)
			end

			u102.current = v105
		end

		React.useEffect(function() -- line: 313
			-- upvalues: v104 (copy), v99 (copy), RobloxAppEvents (copy), AppPage (copy)
			if v104 ~= nil and v99.current then
				RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
			end

			v99.current = true
		end, {
			v105,
			v104,
			t2.navigation
		})
	else
		React.useEffect(function() -- line: 324
			-- upvalues: t2 (copy), GetDeepLinkStore (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), ShareLinkTargetIdType (copy), v99 (copy), RobloxAppEvents (copy), AppPage (copy)
			local navigation = t2.navigation

			if not navigation or not navigation.getParam then
				return
			end

			local v118 = navigation.getParam("extraProps")

			if type(v118) == "table" and type(v118.postId) == "string" then
				local v119 = GetDeepLinkStore()
				local postId = v118.postId
				local v121 = if not FFlagMomentsPassFeedItemIdToBackendApis then nil else if v118.targetIdType ~= ShareLinkTargetIdType.FeedItemId then nil else ShareLinkTargetIdType.FeedItemId

				if FFlagMomentsPassFeedItemIdToBackendApis then
					v119.setDeepLinkedMoment(postId, v121)
				else
					v119.setDeepLinkedMomentId(postId)
				end

				if v99.current then
					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end
			end

			v99.current = true
		end, { t2.navigation })
	end

	local v108 = React.useCallback(function() -- line: 347
		-- upvalues: v98 (copy), v100 (copy), v97 (copy), FFlagMomentsEmojiSetsApi (copy), MomentsGetMomentsReactionsStore (copy), fireAnalyticsEvent (copy), EventNames (copy), SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy)
		if v98.current then
			return
		end

		v98.current = true

		local current = v100.current
		local navigation = v97.current.navigation
		local s5

		if not navigation or not navigation.getParam then
			s5 = "watch_tab"
		else
			local v125 = navigation.getParam("extraProps")

			s5 = if type(v125) ~= "table" or type(v125.source) ~= "string" then navigation.getParam("source", "watch_tab") else v125.source
		end

		current.resetSession()
		current.setSessionSource(s5)

		if FFlagMomentsEmojiSetsApi then
			local getAndFetchEmojiSets = MomentsGetMomentsReactionsStore(false).getAndFetchEmojiSets

			assert(getAndFetchEmojiSets ~= nil, "expected getAndFetchEmojiSets when FFlagMomentsEmojiSetsApi is on")
			getAndFetchEmojiSets()
		end

		fireAnalyticsEvent(EventNames.TapMomentsTab, {
			moments_session_id = current.getMomentsSessionId(false),
			source = s5
		})

		local v127 = SessionManager.startSession(FunnelEventNames.FunnelTypes.AppNavigation)

		fireFunnelAnalyticsEvent(FunnelEventNames.FunnelTypes.AppNavigation, FunnelEventNames.AppNavigationSteps.AppLaunched, v127)
	end, {})
	local v109 = React.useCallback(function() -- line: 380
		-- upvalues: v98 (copy), FFlagMomentsSurfaceLoadTTI (copy), MomentsSurfaceLoadManager (copy), getExperienceDetailsSheetStore (copy), v100 (copy), fireAnalyticsEvent (copy), EventNames (copy), SessionManager (copy), FunnelEventNames (copy)
		if not v98.current then
			return
		end

		v98.current = false

		if FFlagMomentsSurfaceLoadTTI then
			MomentsSurfaceLoadManager.abort()
		end

		getExperienceDetailsSheetStore(false).close()

		local current = v100.current
		local v129 = os.clock() - current.getSessionStartTime(false)

		fireAnalyticsEvent(EventNames.MomentsSessionEnded, {
			moments_session_id = current.getMomentsSessionId(false),
			source = current.getSessionSource(false),
			duration_seconds = tostring((math.floor(v129)))
		})
		SessionManager.endSession(FunnelEventNames.FunnelTypes.AppNavigation)
	end, {})
	local v110 = React.useCallback(function() -- line: 410
		-- upvalues: GetImmersiveChromeStore (copy), v97 (copy)
		GetImmersiveChromeStore(false).setOverlayCovering(false)

		local onTabFocused = v97.current.onTabFocused

		if onTabFocused then
			onTabFocused()
		end
	end, {})

	React.useEffect(function() -- line: 423
		-- upvalues: t2 (copy), v108 (copy), v110 (copy), v109 (copy), RoactNavigation (copy), v101 (copy), getDeepLinkRequest (copy), GetDeepLinkStore (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), u102 (ref), RobloxAppEvents (copy), AppPage (copy), ShareLinkTargetIdType (copy)
		local navigation = t2.navigation

		if not navigation or not navigation.addListener then
			v108()
			v110()

			return function() -- line: 428
				-- upvalues: v109 (copy)
				v109()
			end
		end

		v108()
		v110()

		local v132 = navigation.addListener(RoactNavigation.Events.DidFocus, function() -- line: 436
			-- upvalues: v101 (copy), getDeepLinkRequest (copy), navigation (copy), GetDeepLinkStore (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), u102 (ref), RobloxAppEvents (copy), AppPage (copy), ShareLinkTargetIdType (copy), v108 (copy), v110 (copy)
			if v101 then
				local v136 = getDeepLinkRequest(navigation)

				if v136 ~= nil then
					local v137 = GetDeepLinkStore()
					local momentId = v136.momentId
					local targetIdType = v136.targetIdType

					if FFlagMomentsPassFeedItemIdToBackendApis then
						v137.setDeepLinkedMoment(momentId, targetIdType)
					else
						v137.setDeepLinkedMomentId(momentId)
					end

					u102.current = v136.key
					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end
			else
				local v140 = navigation.getParam("extraProps")

				if type(v140) == "table" and type(v140.postId) == "string" then
					local v141 = GetDeepLinkStore()
					local postId = v140.postId
					local v143 = if not FFlagMomentsPassFeedItemIdToBackendApis then nil else if v140.targetIdType ~= ShareLinkTargetIdType.FeedItemId then nil else ShareLinkTargetIdType.FeedItemId

					if FFlagMomentsPassFeedItemIdToBackendApis then
						v141.setDeepLinkedMoment(postId, v143)
					else
						v141.setDeepLinkedMomentId(postId)
					end

					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end
			end

			v108()
			v110()
		end)
		local v133 = navigation.addListener(RoactNavigation.Events.WillBlur, function() -- line: 465
			-- upvalues: v109 (copy)
			v109()
		end)

		return function() -- line: 469
			-- upvalues: v109 (copy), v132 (copy), v133 (copy)
			v109()
			v132.remove()
			v133.remove()
		end
	end, {
		v108,
		v109,
		v110
	})

	local v111 = useMomentsTabIsVisible()

	React.useEffect(function() -- line: 484
		-- upvalues: GetFFlagMomentsFixPeekReturnChrome (copy), v111 (copy), v110 (copy)
		if GetFFlagMomentsFixPeekReturnChrome() and v111 then
			v110()
		end
	end, {
		v111,
		v110
	})

	local v112 = React.useMemo(function() -- line: 493
		-- upvalues: t2 (copy), GetImmersiveChromeStore (copy)
		local openProfile = t2.openProfile
		local openOwnMoments = t2.openOwnMoments

		return {
			openProfile = if not openProfile then nil else function(n2: number) -- line: 498
				-- upvalues: GetImmersiveChromeStore (copy), openProfile (copy)
				GetImmersiveChromeStore(false).setOverlayCovering(true)
				openProfile(n2)
			end,
			openOwnMoments = if not openOwnMoments then nil else function() -- line: 504
				-- upvalues: GetImmersiveChromeStore (copy), openOwnMoments (copy)
				GetImmersiveChromeStore(false).setOverlayCovering(true)
				openOwnMoments()
			end,
			openMomentsFeedReport = t2.openMomentsFeedReport
		}
	end, {
		t2.openProfile,
		t2.openOwnMoments,
		t2.openMomentsFeedReport
	})
	local v113 = useMomentsGating()

	if not canRenderNativeMoments(v113) then
		return nil
	end

	local v114 = if not t2.useRootOwnedNavigation then React.createElement(v38) else React.createElement(InnerNavigator, {
		navigation = t2.navigation
	})

	return React.createElement(MomentsHostShell, {
		sessionStore = v100.current,
		openProfile = v112.openProfile,
		openOwnMoments = v112.openOwnMoments,
		openMomentsFeedReport = v112.openMomentsFeedReport
	}, v114)
end
local function MomentsTabEntrySessionized(t3: {[any]: any}) -- line: 541
	-- upvalues: React (copy), MomentsTabEntry (copy)
	return React.createElement(MomentsTabEntry, {
		useRootOwnedNavigation = true,
		navigation = t3.navigation,
		openProfile = t3.openProfile,
		openOwnMoments = t3.openOwnMoments,
		openMomentsFeedReport = t3.openMomentsFeedReport,
		onTabFocused = t3.onTabFocused
	})
end

local v54 = React.Component:extend("MomentsTabEntryScreen")

function v54.render(p12) -- line: 557
	-- upvalues: React (copy), MomentsTabEntrySessionized (copy)
	return React.createElement(MomentsTabEntrySessionized, p12.props)
end

v54.router = InnerNavigator.router

if FFlagMomentsWatchSessionalization then
	return v54
end

return MomentsTabEntry
