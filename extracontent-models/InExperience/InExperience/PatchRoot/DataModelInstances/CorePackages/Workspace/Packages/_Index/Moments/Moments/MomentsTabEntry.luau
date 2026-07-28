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
local FFlagMomentsWatchSessionalization = SharedFlags.FFlagMomentsWatchSessionalization
local FFlagMomentsSurfaceLoadTTI = SharedFlags.FFlagMomentsSurfaceLoadTTI
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis
local ShareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType
local v36 = RoactNavigation.createAppContainer(InnerNavigator)
local getActiveRoutes = Navigation.getActiveRoutes
local v38 = GetFFlagMomentsFixShareDeeplink()

local function normalizeDeepLinkedMomentId(p1) -- line: 74
	if type(p1) == "string" and p1 ~= "" then
		return p1
	end

	if type(p1) == "number" then
		return (tostring(p1))
	end

	return nil
end
local function getMomentIdFromLaunchData(p2) -- line: 83
	-- upvalues: HttpService (copy)
	if type(p2) ~= "string" or p2 == "" then
		return nil
	end

	local ok, result = pcall(function() -- line: 88
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
local function normalizeTargetIdType(p3) -- line: 98
	-- upvalues: ShareLinkTargetIdType (copy)
	if p3 == ShareLinkTargetIdType.FeedItemId then
		return ShareLinkTargetIdType.FeedItemId
	end

	return nil
end
local function getTargetIdTypeFromLaunchData(p4) -- line: 102
	-- upvalues: HttpService (copy), ShareLinkTargetIdType (copy)
	if type(p4) ~= "string" or p4 == "" then
		return nil
	end

	local ok, result = pcall(function() -- line: 107
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
local function getDeepLinkedMomentIdFromParams(p5) -- line: 117
	-- upvalues: getMomentIdFromLaunchData (copy)
	if type(p5) ~= "table" then
		return nil
	end

	local extraProps = p5.extraProps

	if type(extraProps) == "table" then
		local postId = extraProps.postId
		local v65 = if type(postId) ~= "string" or postId == "" then if type(postId) ~= "number" then nil else tostring(postId) else postId

		if v65 ~= nil then
			return v65
		end

		local v66 = getMomentIdFromLaunchData(extraProps.launchData)

		if v66 ~= nil then
			return v66
		end
	end

	local postId = p5.postId
	local v68 = if type(postId) ~= "string" or postId == "" then if type(postId) ~= "number" then nil else tostring(postId) else postId

	if v68 ~= nil then
		return v68
	end

	return (getMomentIdFromLaunchData(p5.launchData))
end
local function getDeepLinkedMomentTargetIdTypeFromParams(p6) -- line: 143
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
local function getDeepLinkRequestFromNavigationParams(p7, s1: string) -- line: 172
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
	local v76 = getDeepLinkedMomentIdFromParams(t1)

	if v76 == nil then
		return nil
	end

	local v77 = getDeepLinkedMomentTargetIdTypeFromParams(t1)

	return {
		momentId = v76,
		targetIdType = v77,
		key = if not FFlagMomentsPassFeedItemIdToBackendApis then `{ s1 }:params:{ tostring(t1.extraProps) }:{ tostring(t1.postId) }:{ tostring(t1.launchData) }:{ v76 }` else `{ s1 }:params:{ tostring(t1.extraProps) }:{ tostring(t1.postId) }:{ tostring(t1.launchData) }:{ v76 }:{ tostring(v77) }`
	}
end
local function getDeepLinkRequestFromNavigationState(p8, s2: string) -- line: 202
	-- upvalues: getActiveRoutes (copy), getDeepLinkedMomentIdFromParams (copy), getDeepLinkedMomentTargetIdTypeFromParams (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy)
	local v80 = getActiveRoutes(p8)

	for i = #v80, 1, -1 do
		local v82 = v80[i]
		local v83 = getDeepLinkedMomentIdFromParams(v82.params)

		if v83 ~= nil then
			local v84 = getDeepLinkedMomentTargetIdTypeFromParams(v82.params)

			return {
				momentId = v83,
				targetIdType = v84,
				key = if not FFlagMomentsPassFeedItemIdToBackendApis then `{ s2 }:state:{ tostring(v82.key) }:{ tostring(v82.params) }:{ v83 }` else `{ s2 }:state:{ tostring(v82.key) }:{ tostring(v82.params) }:{ v83 }:{ tostring(v84) }`
			}
		end
	end

	return nil
end
local function getDeepLinkRequest(p9) -- line: 224
	-- upvalues: getDeepLinkRequestFromNavigationParams (copy), getDeepLinkRequestFromNavigationState (copy)
	local n1 = 0

	while p9 ~= nil do
		local str = tostring(n1)
		local v88 = getDeepLinkRequestFromNavigationParams(p9, str) or getDeepLinkRequestFromNavigationState(p9.state, str)

		if v88 ~= nil then
			return v88
		end

		if not p9._dangerouslyGetParent then
			return nil
		end

		p9 = p9._dangerouslyGetParent()
		n1 += 1
	end

	return nil
end
local function getEntrySource(p10) -- line: 245
	if not p10 or not p10.getParam then
		return "watch_tab"
	end

	local v90 = p10.getParam("extraProps")

	if type(v90) == "table" and type(v90.source) == "string" then
		return v90.source
	end

	return p10.getParam("source", "watch_tab")
end
local function seedDeepLinkedMoment(p11, s3: string, s4: string?) -- line: 256
	-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy)
	if FFlagMomentsPassFeedItemIdToBackendApis then
		p11.setDeepLinkedMoment(s3, s4)

		return
	end

	p11.setDeepLinkedMomentId(s3)
end
local function MomentsTabEntry(t2: {[any]: any}) -- line: 264
	-- upvalues: React (copy), createMomentsStore (copy), useResetTeleportingOnGameLeave (copy), v38 (copy), getDeepLinkRequest (copy), GetDeepLinkStore (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), RobloxAppEvents (copy), AppPage (copy), ShareLinkTargetIdType (copy), FFlagMomentsEmojiSetsApi (copy), MomentsGetMomentsReactionsStore (copy), fireAnalyticsEvent (copy), EventNames (copy), SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy), FFlagMomentsSurfaceLoadTTI (copy), MomentsSurfaceLoadManager (copy), getExperienceDetailsSheetStore (copy), GetImmersiveChromeStore (copy), RoactNavigation (copy), useMomentsTabIsVisible (copy), GetFFlagMomentsFixPeekReturnChrome (copy), useMomentsGating (copy), InnerNavigator (copy), v36 (copy), MomentsHostShell (copy)
	local v95 = React.useRef(t2)

	v95.current = t2

	local v96 = React.useRef(false)
	local v97 = React.useRef(false)
	local v98 = React.useRef(nil)

	if v98.current == nil then
		v98.current = createMomentsStore()
	end

	useResetTeleportingOnGameLeave()

	local u99 = nil

	if v38 then
		local v100 = getDeepLinkRequest(t2.navigation)
		local v101 = if v100 == nil then nil else v100.momentId
		local v102 = if v100 == nil then nil else v100.key

		u99 = React.useRef(nil)

		if v101 ~= nil and v102 ~= u99.current then
			local v103 = GetDeepLinkStore()
			local v104 = if v100 == nil then nil else v100.targetIdType

			if FFlagMomentsPassFeedItemIdToBackendApis then
				v103.setDeepLinkedMoment(v101, v104)
			else
				v103.setDeepLinkedMomentId(v101)
			end

			u99.current = v102
		end

		React.useEffect(function() -- line: 304
			-- upvalues: v101 (copy), v97 (copy), RobloxAppEvents (copy), AppPage (copy)
			if v101 ~= nil and v97.current then
				RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
			end

			v97.current = true
		end, {
			v102,
			v101,
			t2.navigation
		})
	else
		React.useEffect(function() -- line: 315
			-- upvalues: t2 (copy), GetDeepLinkStore (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), ShareLinkTargetIdType (copy), v97 (copy), RobloxAppEvents (copy), AppPage (copy)
			local navigation = t2.navigation

			if not navigation or not navigation.getParam then
				return
			end

			local v115 = navigation.getParam("extraProps")

			if type(v115) == "table" and type(v115.postId) == "string" then
				local v116 = GetDeepLinkStore()
				local postId = v115.postId
				local v118 = if not FFlagMomentsPassFeedItemIdToBackendApis then nil else if v115.targetIdType ~= ShareLinkTargetIdType.FeedItemId then nil else ShareLinkTargetIdType.FeedItemId

				if FFlagMomentsPassFeedItemIdToBackendApis then
					v116.setDeepLinkedMoment(postId, v118)
				else
					v116.setDeepLinkedMomentId(postId)
				end

				if v97.current then
					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end
			end

			v97.current = true
		end, { t2.navigation })
	end

	local v105 = React.useCallback(function() -- line: 338
		-- upvalues: v96 (copy), v98 (copy), v95 (copy), FFlagMomentsEmojiSetsApi (copy), MomentsGetMomentsReactionsStore (copy), fireAnalyticsEvent (copy), EventNames (copy), SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy)
		if v96.current then
			return
		end

		v96.current = true

		local current = v98.current
		local navigation = v95.current.navigation
		local s5

		if not navigation or not navigation.getParam then
			s5 = "watch_tab"
		else
			local v122 = navigation.getParam("extraProps")

			s5 = if type(v122) ~= "table" or type(v122.source) ~= "string" then navigation.getParam("source", "watch_tab") else v122.source
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

		local v124 = SessionManager.startSession(FunnelEventNames.FunnelTypes.AppNavigation)

		fireFunnelAnalyticsEvent(FunnelEventNames.FunnelTypes.AppNavigation, FunnelEventNames.AppNavigationSteps.AppLaunched, v124)
	end, {})
	local v106 = React.useCallback(function() -- line: 371
		-- upvalues: v96 (copy), FFlagMomentsSurfaceLoadTTI (copy), MomentsSurfaceLoadManager (copy), getExperienceDetailsSheetStore (copy), v98 (copy), fireAnalyticsEvent (copy), EventNames (copy), SessionManager (copy), FunnelEventNames (copy)
		if not v96.current then
			return
		end

		v96.current = false

		if FFlagMomentsSurfaceLoadTTI then
			MomentsSurfaceLoadManager.abort()
		end

		getExperienceDetailsSheetStore(false).close()

		local current = v98.current
		local v126 = os.clock() - current.getSessionStartTime(false)

		fireAnalyticsEvent(EventNames.MomentsSessionEnded, {
			moments_session_id = current.getMomentsSessionId(false),
			source = current.getSessionSource(false),
			duration_seconds = tostring((math.floor(v126)))
		})
		SessionManager.endSession(FunnelEventNames.FunnelTypes.AppNavigation)
	end, {})
	local v107 = React.useCallback(function() -- line: 401
		-- upvalues: GetImmersiveChromeStore (copy), v95 (copy)
		GetImmersiveChromeStore(false).setOverlayCovering(false)

		local onTabFocused = v95.current.onTabFocused

		if onTabFocused then
			onTabFocused()
		end
	end, {})

	React.useEffect(function() -- line: 414
		-- upvalues: t2 (copy), v105 (copy), v107 (copy), v106 (copy), RoactNavigation (copy), v38 (copy), getDeepLinkRequest (copy), GetDeepLinkStore (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), u99 (ref), RobloxAppEvents (copy), AppPage (copy), ShareLinkTargetIdType (copy)
		local navigation = t2.navigation

		if not navigation or not navigation.addListener then
			v105()
			v107()

			return function() -- line: 419
				-- upvalues: v106 (copy)
				v106()
			end
		end

		v105()
		v107()

		local v129 = navigation.addListener(RoactNavigation.Events.DidFocus, function() -- line: 427
			-- upvalues: v38 (copy), getDeepLinkRequest (copy), navigation (copy), GetDeepLinkStore (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), u99 (ref), RobloxAppEvents (copy), AppPage (copy), ShareLinkTargetIdType (copy), v105 (copy), v107 (copy)
			if v38 then
				local v133 = getDeepLinkRequest(navigation)

				if v133 ~= nil then
					local v134 = GetDeepLinkStore()
					local momentId = v133.momentId
					local targetIdType = v133.targetIdType

					if FFlagMomentsPassFeedItemIdToBackendApis then
						v134.setDeepLinkedMoment(momentId, targetIdType)
					else
						v134.setDeepLinkedMomentId(momentId)
					end

					u99.current = v133.key
					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end
			else
				local v137 = navigation.getParam("extraProps")

				if type(v137) == "table" and type(v137.postId) == "string" then
					local v138 = GetDeepLinkStore()
					local postId = v137.postId
					local v140 = if not FFlagMomentsPassFeedItemIdToBackendApis then nil else if v137.targetIdType ~= ShareLinkTargetIdType.FeedItemId then nil else ShareLinkTargetIdType.FeedItemId

					if FFlagMomentsPassFeedItemIdToBackendApis then
						v138.setDeepLinkedMoment(postId, v140)
					else
						v138.setDeepLinkedMomentId(postId)
					end

					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end
			end

			v105()
			v107()
		end)
		local v130 = navigation.addListener(RoactNavigation.Events.WillBlur, function() -- line: 456
			-- upvalues: v106 (copy)
			v106()
		end)

		return function() -- line: 460
			-- upvalues: v106 (copy), v129 (copy), v130 (copy)
			v106()
			v129.remove()
			v130.remove()
		end
	end, {
		v105,
		v106,
		v107
	})

	local v108 = useMomentsTabIsVisible()

	React.useEffect(function() -- line: 475
		-- upvalues: GetFFlagMomentsFixPeekReturnChrome (copy), v108 (copy), v107 (copy)
		if GetFFlagMomentsFixPeekReturnChrome() and v108 then
			v107()
		end
	end, {
		v108,
		v107
	})

	local v109 = React.useMemo(function() -- line: 484
		-- upvalues: t2 (copy), GetImmersiveChromeStore (copy)
		local openProfile = t2.openProfile
		local openOwnMoments = t2.openOwnMoments

		return {
			openProfile = if not openProfile then nil else function(n2: number) -- line: 489
				-- upvalues: GetImmersiveChromeStore (copy), openProfile (copy)
				GetImmersiveChromeStore(false).setOverlayCovering(true)
				openProfile(n2)
			end,
			openOwnMoments = if not openOwnMoments then nil else function() -- line: 495
				-- upvalues: GetImmersiveChromeStore (copy), openOwnMoments (copy)
				GetImmersiveChromeStore(false).setOverlayCovering(true)
				openOwnMoments()
			end
		}
	end, {
		t2.openProfile,
		t2.openOwnMoments
	})
	local v110 = useMomentsGating()

	if not v110.isTabEnabled and (not v110.isFlyoutEntryEnabled or not v110.platformIntegrationEnabled) then
		return nil
	end

	local v111 = if not t2.useRootOwnedNavigation then React.createElement(v36) else React.createElement(InnerNavigator, {
		navigation = t2.navigation
	})

	return React.createElement(MomentsHostShell, {
		sessionStore = v98.current,
		openProfile = v109.openProfile,
		openOwnMoments = v109.openOwnMoments
	}, v111)
end
local function MomentsTabEntrySessionized(t3: {[any]: any}) -- line: 531
	-- upvalues: React (copy), MomentsTabEntry (copy)
	return React.createElement(MomentsTabEntry, {
		useRootOwnedNavigation = true,
		navigation = t3.navigation,
		openProfile = t3.openProfile,
		openOwnMoments = t3.openOwnMoments,
		onTabFocused = t3.onTabFocused
	})
end

local v52 = React.Component:extend("MomentsTabEntryScreen")

function v52.render(p12) -- line: 546
	-- upvalues: React (copy), MomentsTabEntrySessionized (copy)
	return React.createElement(MomentsTabEntrySessionized, p12.props)
end

v52.router = InnerNavigator.router

if FFlagMomentsWatchSessionalization then
	return v52
end

return MomentsTabEntry
