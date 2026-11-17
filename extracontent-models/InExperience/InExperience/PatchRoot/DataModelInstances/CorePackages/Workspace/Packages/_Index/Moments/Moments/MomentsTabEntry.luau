local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local HttpService = game:GetService("HttpService")
local MomentsCommon = require(parent.MomentsCommon)
local MomentsTypes = require(parent.MomentsTypes)
local Navigation = require(parent.Navigation)
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local SharedFlags = require(parent.SharedFlags)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local RobloxAppEvents = require(parent.RobloxAppEvents)

local GetDeepLinkStore = require(Moments.Stores.GetDeepLinkStore)
require(Moments.Stores.GetDeepLinkStore.createDeepLinkStore)
local createMomentsStore = require(Moments.Stores.GetMomentsStore.createMomentsStore)
local GetImmersiveChromeStore = require(Moments.Stores.GetImmersiveChromeStore)
local FFlagMomentsEmojiSetsApi = require(Moments.Flags.FFlagMomentsEmojiSetsApi)

local FFlagMomentsFixDeepLinkRefocusStaleNavigation = require(Moments.Flags.FFlagMomentsFixDeepLinkRefocusStaleNavigation)

local FStringMomentsExperienceJoinActionTextIxpLayer = require(Moments.Flags.FStringMomentsExperienceJoinActionTextIxpLayer)
local useMomentsTabIsVisible = require(Moments.Hooks.useMomentsTabIsVisible)
local consumeEntrySource = require(Moments.Utils.consumeEntrySource)
local logMomentsLayerExposure = MomentsCommon.Utils.logMomentsLayerExposure
local InnerNavigator = require(Moments.Navigation.InnerNavigator)
local MomentsHostShell = require(Moments.Components.MomentsHostShell)
require(Moments.MomentsHostContext)

local useResetTeleportingOnGameLeave = require(Moments.Hooks.useResetTeleportingOnGameLeave)
local getExperienceDetailsSheetStore = require(Moments.ExperienceDetailsSheet.Sheet.getExperienceDetailsSheetStore)
local MomentsGetMomentsReactionsStore = require(parent.DataHydration.MomentsGetMomentsReactionsStore)

local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local FunnelEventNames = Analytics.FunnelEventNames
local SessionManager = Analytics.SessionManager
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local fireFunnelAnalyticsEvent = Analytics.fireFunnelAnalyticsEvent

local MomentsSurfaceLoadManager = MomentsCommon.Performance.MomentsSurfaceLoadManager

local useMomentsGating = MomentsCommon.Hooks.useMomentsGating
local canRenderNativeMoments = MomentsCommon.canRenderNativeMoments

local v = {}
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts
local FFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local FFlagMomentsCommentDeepLinks = SharedFlags.FFlagMomentsCommentDeepLinks
local ShareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType
local getActiveRoutes = Navigation.getActiveRoutes

local function normalizeDeepLinkedMomentId(postId) -- 7 equivalent calls inferred from this helper
	if type(postId) == "string" and postId ~= "" then
		return postId
	end

	if type(postId) == "number" then
		return (tostring(postId))
	end

	return nil
end

local function getMomentIdFromLaunchData(launchData)
	if type(launchData) ~= "string" or launchData == "" then
		return nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(launchData)
	end)

	if not success or type(result) ~= "table" then
		return nil
	end

	return normalizeDeepLinkedMomentId(result.postId) -- inferred equivalent call
end

local function normalizeTargetIdType(targetIdType) -- 3 equivalent calls inferred from this helper
	if targetIdType == ShareLinkTargetIdType.FeedItemId then
		return ShareLinkTargetIdType.FeedItemId
	end

	return nil
end

local function getTargetIdTypeFromLaunchData(launchData)
	if type(launchData) ~= "string" or launchData == "" then
		return nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(launchData)
	end)

	if not success or type(result) ~= "table" then
		return nil
	end

	return normalizeTargetIdType(result.targetIdType) -- inferred equivalent call
end

local function getDeepLinkedMomentIdFromParams(data)
	if type(data) ~= "table" then
		return nil
	end

	local extraProps = data.extraProps

	if type(extraProps) == "table" then
		local deepLinkedMomentId = normalizeDeepLinkedMomentId(extraProps.postId) -- inferred equivalent call

		if deepLinkedMomentId ~= nil then
			return deepLinkedMomentId
		end

		local momentIdFromLaunchData = getMomentIdFromLaunchData(extraProps.launchData)

		if momentIdFromLaunchData ~= nil then
			return momentIdFromLaunchData
		end
	end

	local deepLinkedMomentId = normalizeDeepLinkedMomentId(data.postId) -- inferred equivalent call

	if deepLinkedMomentId == nil then
		return (getMomentIdFromLaunchData(data.launchData))
	end

	return deepLinkedMomentId
end

local function getDeepLinkedMomentTargetIdTypeFromParams(data)
	if type(data) ~= "table" then
		return nil
	end

	local extraProps = data.extraProps

	if type(extraProps) == "table" then
		if normalizeDeepLinkedMomentId(extraProps.postId) == nil then -- inferred equivalent call
			if getMomentIdFromLaunchData(extraProps.launchData) ~= nil then
				return (getTargetIdTypeFromLaunchData(extraProps.launchData))
			end
		else
			return normalizeTargetIdType(extraProps.targetIdType) -- inferred equivalent call
		end
	end

	if normalizeDeepLinkedMomentId(data.postId) == nil then -- inferred equivalent call
		return (getTargetIdTypeFromLaunchData(data.launchData))
	end

	return normalizeTargetIdType(data.targetIdType) -- inferred equivalent call
end

local function getCommentsTargetFromTable(p)
	if type(p) ~= "table" then
		return nil
	end

	local commentId

	if type(p.commentId) == "string" and p.commentId ~= "" then
		commentId = p.commentId
	end

	if commentId == nil and p.openComments ~= true then
		return nil
	end

	return { commentId = commentId }
end

local function getCommentsTargetFromLaunchData(launchData) -- 2 equivalent calls inferred from this helper
	if type(launchData) ~= "string" or launchData == "" then
		return nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(launchData)
	end)

	if success then
		return getCommentsTargetFromTable(result)
	end

	return nil
end

local function getDeepLinkedCommentsTargetFromParams(data)
	if type(data) ~= "table" then
		return nil
	end

	local extraProps = data.extraProps

	if type(extraProps) == "table" then
		if normalizeDeepLinkedMomentId(extraProps.postId) ~= nil then -- inferred equivalent call
			return getCommentsTargetFromTable(extraProps)
		end

		if getMomentIdFromLaunchData(extraProps.launchData) ~= nil then
			return getCommentsTargetFromLaunchData(extraProps.launchData) -- inferred equivalent call
		end
	end

	if normalizeDeepLinkedMomentId(data.postId) ~= nil then -- inferred equivalent call
		return getCommentsTargetFromTable(data)
	end

	return getCommentsTargetFromLaunchData(data.launchData) -- inferred equivalent call
end

local function getCommentsTargetKey(p) -- 2 equivalent calls inferred from this helper
	if p == nil then
		return ""
	end

	return `:comments:{p.commentId or ""}`
end

local function getDeepLinkRequestFromNavigationParams(p, p2: string)
	if not (p and p.getParam) then
		return nil
	end

	local v2 = {
		extraProps = p.getParam("extraProps"),
		postId = p.getParam("postId"),
		targetIdType = p.getParam("targetIdType"),
		launchData = p.getParam("launchData"),
		commentId = 0,
		openComments = 0
	}
	local commentId

	if FFlagMomentsCommentDeepLinks then
		commentId = p.getParam("commentId")
	end

	v2.commentId = commentId
	local openComments

	if FFlagMomentsCommentDeepLinks then
		openComments = p.getParam("openComments")
	end

	v2.openComments = openComments

	local deepLinkedMomentIdFromParams = getDeepLinkedMomentIdFromParams(v2)

	if deepLinkedMomentIdFromParams == nil then
		return nil
	end

	local deepLinkedMomentTargetIdTypeFromParams = getDeepLinkedMomentTargetIdTypeFromParams(v2)
	local commentsTarget

	if FFlagMomentsCommentDeepLinks then
		commentsTarget = getDeepLinkedCommentsTargetFromParams(v2)
	end

	return {
		momentId = deepLinkedMomentIdFromParams,
		targetIdType = deepLinkedMomentTargetIdTypeFromParams,
		commentsTarget = commentsTarget,
		key = `{p2}:params:{tostring(v2.extraProps)}:{tostring(v2.postId)}:{tostring(v2.launchData)}:{deepLinkedMomentIdFromParams}:{tostring(deepLinkedMomentTargetIdTypeFromParams)}{getCommentsTargetKey(commentsTarget)}`
	} -- inferred equivalent call
end

local function getDeepLinkRequestFromNavigationState(state, p: string)
	local activeRoutes = getActiveRoutes(state)

	for i = #activeRoutes, 1, -1 do
		local activeRoute = activeRoutes[i]
		local deepLinkedMomentIdFromParams = getDeepLinkedMomentIdFromParams(activeRoute.params)

		if deepLinkedMomentIdFromParams ~= nil then
			local deepLinkedMomentTargetIdTypeFromParams = getDeepLinkedMomentTargetIdTypeFromParams(activeRoute.params)
			local commentsTarget

			if FFlagMomentsCommentDeepLinks then
				commentsTarget = getDeepLinkedCommentsTargetFromParams(activeRoute.params)
			end

			return {
				momentId = deepLinkedMomentIdFromParams,
				targetIdType = deepLinkedMomentTargetIdTypeFromParams,
				commentsTarget = commentsTarget,
				key = `{p}:state:{tostring(activeRoute.key)}:{tostring(activeRoute.params)}:{deepLinkedMomentIdFromParams}:{tostring(deepLinkedMomentTargetIdTypeFromParams)}{getCommentsTargetKey(commentsTarget)}`
			} -- inferred equivalent call
		end
	end

	return nil
end

local function getDeepLinkRequest(p)
	local count = 0

	while p ~= nil do
		local v2 = tostring(count)
		local selected = getDeepLinkRequestFromNavigationParams(p, v2)
			or getDeepLinkRequestFromNavigationState(p.state, v2)

		if selected ~= nil then
			return selected
		end

		if not p._dangerouslyGetParent then
			break
		end

		p = p._dangerouslyGetParent()
		count += 1
	end

	return nil
end

local function seedDeepLinkedMoment(p, momentId: string, targetIdType: string?, p2) -- 2 equivalent calls inferred from this helper
	p.setDeepLinkedMoment(momentId, targetIdType, p2)
end

local function MomentsTabEntry(props)
	local ref = React.useRef(props)
	ref.current = props

	local ref2 = React.useRef(false)
	local ref3 = React.useRef(false)

	local ref4 = React.useRef(nil)

	if ref4.current == nil then
		ref4.current = createMomentsStore()
	end

	useResetTeleportingOnGameLeave()
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef({})
	local deepLinkRequest = getDeepLinkRequest(props.navigation)
	local momentId

	if deepLinkRequest == nil then
		momentId = nil
	else
		momentId = deepLinkRequest.momentId
	end

	local key

	if deepLinkRequest ~= nil then
		key = deepLinkRequest.key
	end

	if momentId ~= nil and ref5.current ~= key then
		local deepLinkStore = GetDeepLinkStore()
		local targetIdType

		if deepLinkRequest ~= nil then
			targetIdType = deepLinkRequest.targetIdType
		end

		local v2

		if FFlagMomentsCommentDeepLinks and deepLinkRequest ~= nil then
			v2 = deepLinkRequest.commentsTarget
		end

		seedDeepLinkedMoment(deepLinkStore, momentId, targetIdType, v2) -- inferred equivalent call
		ref5.current = key
	end

	React.useEffect(function()
		if momentId ~= nil and ref3.current then
			RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
		end

		ref3.current = true
	end, { key, momentId, props.navigation })

	local v2 = React.useCallback(function()
		if ref2.current then
			return
		end

		ref2.current = true

		local current = ref4.current

		local source = consumeEntrySource(ref.current.navigation, ref6.current)

		current.resetSession()
		current.setSessionSource(source)

		logMomentsLayerExposure(FStringMomentsExperienceJoinActionTextIxpLayer)
		local FFlagMomentsCreatorAttributionIxpEnabled = require(Moments.Flags.FFlagMomentsCreatorAttributionIxpEnabled)

		if FFlagMomentsCreatorAttributionIxpEnabled then
			logMomentsLayerExposure(require(Moments.Flags.FStringMomentsCreatorAttributionIxpLayer))
		end

		local FFlagMomentsFeedIxpEnabled = require(Moments.Flags.FFlagMomentsFeedIxpEnabled)

		if FFlagMomentsFeedIxpEnabled then
			logMomentsLayerExposure(require(Moments.Flags.FStringMomentsFeedIxpLayer))
		end

		if FFlagMomentsEmojiSetsApi then
			local getAndFetchEmojiSets = MomentsGetMomentsReactionsStore(false).getAndFetchEmojiSets
			assert(getAndFetchEmojiSets ~= nil, "expected getAndFetchEmojiSets when FFlagMomentsEmojiSetsApi is on")
			getAndFetchEmojiSets()
		end

		fireAnalyticsEvent(EventNames.TapMomentsTab, {
			moments_session_id = current.getMomentsSessionId(false),
			source = source
		})

		Analytics.reportMomentsSessionStarted(source)

		local momentsSessionHeartbeat = Analytics.createMomentsSessionHeartbeat()
		v[current.getMomentsSessionId(false)] = momentsSessionHeartbeat
		momentsSessionHeartbeat.start(source)

		local v2 = SessionManager.startSession(FunnelEventNames.FunnelTypes.AppNavigation)
		fireFunnelAnalyticsEvent(
			FunnelEventNames.FunnelTypes.AppNavigation,
			FunnelEventNames.AppNavigationSteps.AppLaunched,
			v2
		)
	end, {})

	local v3 = React.useCallback(function()
		if not ref2.current then
			return
		end

		ref2.current = false
		MomentsSurfaceLoadManager.abort("blur")

		getExperienceDetailsSheetStore(false).close()

		local current = ref4.current
		local v3 = os.clock() - current.getSessionStartTime(false)

		fireAnalyticsEvent(EventNames.MomentsSessionEnded, {
			moments_session_id = current.getMomentsSessionId(false),
			source = current.getSessionSource(false),
			duration_seconds = tostring((math.floor(v3)))
		})

		local momentsSessionId = current.getMomentsSessionId(false)
		local v4 = v[momentsSessionId]

		if v4 then
			v4.stop()
			v[momentsSessionId] = nil
		end

		Analytics.reportMomentsSessionEnded(current.getSessionSource(false))

		SessionManager.endSession(FunnelEventNames.FunnelTypes.AppNavigation)
	end, {})

	local v4 = React.useCallback(function()
		GetImmersiveChromeStore(false).setOverlayCovering(false)
		local onTabFocused = ref.current.onTabFocused

		if onTabFocused then
			onTabFocused()
		end
	end, {})

	React.useEffect(function()
		local navigation = props.navigation

		if navigation and navigation.addListener then
			v2()
			v4()

			local v5 = navigation.addListener(RoactNavigation.Events.DidFocus, function()
				local v5

				if FFlagMomentsFixDeepLinkRefocusStaleNavigation then
					v5 = ref.current.navigation
				else
					v5 = navigation
				end

				local deepLinkRequest2 = getDeepLinkRequest(v5)
				local v6

				if deepLinkRequest2 == nil then
					v6 = false
				else
					v6 = ref5.current == deepLinkRequest2.key
				end

				if deepLinkRequest2 ~= nil and not v6 then
					local deepLinkStore = GetDeepLinkStore()
					local momentId2 = deepLinkRequest2.momentId
					local targetIdType = deepLinkRequest2.targetIdType
					local v7

					if FFlagMomentsCommentDeepLinks then
						v7 = deepLinkRequest2.commentsTarget
					end

					seedDeepLinkedMoment(deepLinkStore, momentId2, targetIdType, v7) -- inferred equivalent call
					ref5.current = deepLinkRequest2.key
					RobloxAppEvents.ReloadPage:fire(AppPage.Moments)
				end

				v2()
				v4()
			end)
			local v6 = navigation.addListener(RoactNavigation.Events.WillBlur, function()
				v3()
			end)

			return function()
				v3()
				v5.remove()
				v6.remove()
			end
		end

		v2()
		v4()
		return function()
			v3()
		end
	end, { v2, v3, v4 })

	local v5 = useMomentsTabIsVisible()
	React.useEffect(function()
		if v5 then
			v4()
		end
	end, { v5, v4 })

	local useMemo = React.useMemo
	local function fn()
		local openProfile = props.openProfile
		local openOwnMoments = props.openOwnMoments
		local v6 = {
			openProfile = openProfile and function(p: number)
				GetImmersiveChromeStore(false).setOverlayCovering(true)
				openProfile(p)
			end or nil,
			openOwnMoments = openOwnMoments and function()
				GetImmersiveChromeStore(false).setOverlayCovering(true)
				openOwnMoments()
			end or nil,
			openAvatarMomentsCreation = 0,
			openMomentsFeedReport = 0,
			openAvatarLookTryOn = 0,
			openMomentCommentReport = 0,
			openBlockUser = 0
		}
		local openAvatarMomentsCreation

		if FFlagMomentsCreateAvatarPosts then
			openAvatarMomentsCreation = props.openAvatarMomentsCreation
		end

		v6.openAvatarMomentsCreation = openAvatarMomentsCreation

		v6.openMomentsFeedReport = props.openMomentsFeedReport
		local openAvatarLookTryOn

		if FFlagMomentsAvatarLookTryOn then
			openAvatarLookTryOn = props.openAvatarLookTryOn
		end

		v6.openAvatarLookTryOn = openAvatarLookTryOn
		v6.openMomentCommentReport = props.openMomentCommentReport
		v6.openBlockUser = props.openBlockUser
		return v6
	end

	local openProfile = props.openProfile
	local openOwnMoments = props.openOwnMoments
	local openAvatarMomentsCreation

	if FFlagMomentsCreateAvatarPosts then
		openAvatarMomentsCreation = props.openAvatarMomentsCreation
	end

	local openMomentsFeedReport = props.openMomentsFeedReport
	local openMomentCommentReport = props.openMomentCommentReport
	local openBlockUser = props.openBlockUser
	local v6

	if FFlagMomentsAvatarLookTryOn then
		v6 = props.openAvatarLookTryOn
	end

	local v7 = useMemo(fn, {
		openProfile,
		openOwnMoments,
		openAvatarMomentsCreation,
		openMomentsFeedReport,
		openMomentCommentReport,
		openBlockUser,
		v6
	})

	if not canRenderNativeMoments((useMomentsGating())) then
		return nil
	end

	local createElement = React.createElement

	local v8 = {
		sessionStore = ref4.current,
		openProfile = v7.openProfile,
		openOwnMoments = v7.openOwnMoments,
		openAvatarMomentsCreation = 0,
		openMomentsFeedReport = 0,
		openAvatarLookTryOn = 0,
		openMomentCommentReport = 0,
		openBlockUser = 0
	}
	local openAvatarMomentsCreation2

	if FFlagMomentsCreateAvatarPosts then
		openAvatarMomentsCreation2 = v7.openAvatarMomentsCreation
	end

	v8.openAvatarMomentsCreation = openAvatarMomentsCreation2

	v8.openMomentsFeedReport = v7.openMomentsFeedReport
	local openAvatarLookTryOn

	if FFlagMomentsAvatarLookTryOn then
		openAvatarLookTryOn = v7.openAvatarLookTryOn
	end

	v8.openAvatarLookTryOn = openAvatarLookTryOn
	v8.openMomentCommentReport = v7.openMomentCommentReport
	v8.openBlockUser = v7.openBlockUser
	return createElement(MomentsHostShell, v8, React.createElement(InnerNavigator, {
		navigation = props.navigation
	}))
end

local extended = React.Component:extend("MomentsTabEntryScreen")

function extended.render(p)
	return React.createElement(MomentsTabEntry, p.props)
end

extended.router = InnerNavigator.router

return extended
