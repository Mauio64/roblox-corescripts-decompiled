local HttpService = game:GetService("HttpService")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RoactNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RobloxAppEnums").AppPage
local RobloxAppEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RobloxAppEvents")

local GetDeepLinkStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetDeepLinkStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetDeepLinkStore/createDeepLinkStore")
local createMomentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/createMomentsStore")
local GetImmersiveChromeStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetImmersiveChromeStore")
local FFlagMomentsEmojiSetsApi = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsEmojiSetsApi")

local FStringMomentsExperienceJoinActionTextIxpLayer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FStringMomentsExperienceJoinActionTextIxpLayer")
local useMomentsTabIsVisible = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useMomentsTabIsVisible")
local consumeEntrySource = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/consumeEntrySource")
local logMomentsLayerExposure = MomentsCommon.Utils.logMomentsLayerExposure
local InnerNavigator = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Navigation/InnerNavigator")
local MomentsHostShell = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsHostShell")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext")

local useResetTeleportingOnGameLeave = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useResetTeleportingOnGameLeave")
local getExperienceDetailsSheetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Sheet/getExperienceDetailsSheetStore")
local MomentsGetMomentsReactionsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsReactionsStore")

local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames
local funnelEventNames = analytics.FunnelEventNames
local sessionManager = analytics.SessionManager
local fireAnalyticsEvent = analytics.fireAnalyticsEvent
local fireFunnelAnalyticsEvent = analytics.fireFunnelAnalyticsEvent

local momentsSurfaceLoadManager = MomentsCommon.Performance.MomentsSurfaceLoadManager

local useMomentsGating = MomentsCommon.Hooks.useMomentsGating
local canRenderNativeMoments = MomentsCommon.canRenderNativeMoments

local v5 = {}
local fFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local fFlagMomentsCommentDeepLinks = SharedFlags.FFlagMomentsCommentDeepLinks
local shareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType
local getActiveRoutes = Navigation.getActiveRoutes

local function normalizeDeepLinkedMomentId(value)
	if type(value) == "string" and value ~= "" then
		return value
	end

	if type(value) == "number" then
		return (tostring(value))
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

	local postId = result.postId

	if type(postId) == "string" and postId ~= "" then
		return postId
	end

	if type(postId) == "number" then
		return (tostring(postId))
	end

	return nil
end

local function normalizeTargetIdType(p2)
	if p2 == shareLinkTargetIdType.FeedItemId then
		return shareLinkTargetIdType.FeedItemId
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

	if result.targetIdType == shareLinkTargetIdType.FeedItemId then
		return shareLinkTargetIdType.FeedItemId
	end

	return nil
end

local function getDeepLinkedMomentIdFromParams(data)
	if type(data) ~= "table" then
		return nil
	end

	local extraProps = data.extraProps

	if type(extraProps) == "table" then
		local postId = extraProps.postId

		if type(postId) ~= "string" or postId == "" then
			postId = if type(postId) == "number" then tostring(postId) else nil
		end

		if postId ~= nil then
			return postId
		end

		local momentIdFromLaunchData = getMomentIdFromLaunchData(extraProps.launchData)

		if momentIdFromLaunchData ~= nil then
			return momentIdFromLaunchData
		end
	end

	local postId = data.postId

	if type(postId) ~= "string" or postId == "" then
		postId = if type(postId) == "number" then tostring(postId) else nil
	end

	if postId == nil then
		return getMomentIdFromLaunchData(data.launchData)
	end

	return postId
end

local function getDeepLinkedMomentTargetIdTypeFromParams(data)
	if type(data) ~= "table" then
		return nil
	end

	local extraProps = data.extraProps

	if type(extraProps) == "table" then
		local postId = extraProps.postId

		if type(postId) ~= "string" or postId == "" then
			postId = if type(postId) == "number" then tostring(postId) else nil
		end

		if postId == nil then
			if getMomentIdFromLaunchData(extraProps.launchData) ~= nil then
				return getTargetIdTypeFromLaunchData(extraProps.launchData)
			end
		elseif extraProps.targetIdType == shareLinkTargetIdType.FeedItemId then
			return shareLinkTargetIdType.FeedItemId
		else
			return nil
		end
	end

	local postId = data.postId

	if type(postId) ~= "string" or postId == "" then
		postId = if type(postId) == "number" then tostring(postId) else nil
	end

	if postId == nil then
		return getTargetIdTypeFromLaunchData(data.launchData)
	end

	if data.targetIdType == shareLinkTargetIdType.FeedItemId then
		return shareLinkTargetIdType.FeedItemId
	end

	return nil
end

local function getCommentsTargetFromTable(p2)
	if type(p2) ~= "table" then
		return nil
	end

	local commentId = if type(p2.commentId) == "string" and p2.commentId ~= "" then p2.commentId else nil

	if commentId == nil and p2.openComments ~= true then
		return nil
	end

	return { commentId = commentId }
end

local function getCommentsTargetFromLaunchData(json)
	if type(json) ~= "string" or json == "" then
		return nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(json)
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
		local postId = extraProps.postId

		if type(postId) ~= "string" or postId == "" then
			postId = if type(postId) == "number" then tostring(postId) else nil
		end

		if postId ~= nil then
			return getCommentsTargetFromTable(extraProps)
		end

		if getMomentIdFromLaunchData(extraProps.launchData) ~= nil then
			local launchData = extraProps.launchData

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
	end

	local postId = data.postId

	if type(postId) ~= "string" or postId == "" then
		postId = if type(postId) == "number" then tostring(postId) else nil
	end

	if postId ~= nil then
		return getCommentsTargetFromTable(data)
	end

	local launchData = data.launchData

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

local function getCommentsTargetKey(p2)
	if p2 == nil then
		return ""
	end

	return `:comments:{p2.commentId or ""}`
end

local function getDeepLinkRequestFromNavigationParams(p2, p3)
	if not (p2 and p2.getParam) then
		return nil
	end

	local v6 = {
		extraProps = p2.getParam("extraProps"),
		postId = p2.getParam("postId"),
		targetIdType = p2.getParam("targetIdType"),
		launchData = p2.getParam("launchData"),
		commentId = 0,
		openComments = 0
	}
	local v7 = if fFlagMomentsCommentDeepLinks then p2.getParam("commentId") else nil
	v6.commentId = v7
	local v8 = if fFlagMomentsCommentDeepLinks then p2.getParam("openComments") else nil
	v6.openComments = v8

	local deepLinkedMomentIdFromParams = getDeepLinkedMomentIdFromParams(v6)

	if deepLinkedMomentIdFromParams == nil then
		return nil
	end

	local deepLinkedMomentTargetIdTypeFromParams = getDeepLinkedMomentTargetIdTypeFromParams(v6)
	local v9 = if fFlagMomentsCommentDeepLinks then getDeepLinkedCommentsTargetFromParams(v6) else nil
	return {
		momentId = deepLinkedMomentIdFromParams,
		targetIdType = deepLinkedMomentTargetIdTypeFromParams,
		commentsTarget = v9,
		key = `{p3}:params:{tostring(v6.extraProps)}:{tostring(v6.postId)}:{tostring(v6.launchData)}:{deepLinkedMomentIdFromParams}:{tostring(deepLinkedMomentTargetIdTypeFromParams)}{v9 == nil and "" or `:comments:{v9.commentId or ""}`}`
	}
end

local function getDeepLinkRequestFromNavigationState(state, p2)
	local activeRoutes = getActiveRoutes(state)

	for i = #activeRoutes, 1, -1 do
		local activeRoute = activeRoutes[i]
		local deepLinkedMomentIdFromParams = getDeepLinkedMomentIdFromParams(activeRoute.params)

		if deepLinkedMomentIdFromParams ~= nil then
			local deepLinkedMomentTargetIdTypeFromParams = getDeepLinkedMomentTargetIdTypeFromParams(activeRoute.params)
			local v6

			if fFlagMomentsCommentDeepLinks then
				v6 = getDeepLinkedCommentsTargetFromParams(activeRoute.params)
			end

			return {
				momentId = deepLinkedMomentIdFromParams,
				targetIdType = deepLinkedMomentTargetIdTypeFromParams,
				commentsTarget = v6,
				key = `{p2}:state:{tostring(activeRoute.key)}:{tostring(activeRoute.params)}:{deepLinkedMomentIdFromParams}:{tostring(deepLinkedMomentTargetIdTypeFromParams)}{v6 == nil and "" or `:comments:{v6.commentId or ""}`}`
			}
		end
	end

	return nil
end

local function getDeepLinkRequest(navigation)
	local count = 0

	while navigation ~= nil do
		local v6 = tostring(count)
		local v7 = getDeepLinkRequestFromNavigationParams(navigation, v6)
			or getDeepLinkRequestFromNavigationState(navigation.state, v6)

		if v7 ~= nil then
			return v7
		end

		if not navigation._dangerouslyGetParent then
			break
		end

		navigation = navigation._dangerouslyGetParent()
		count += 1
	end

	return nil
end

local function seedDeepLinkedMoment(p2, p3, p4, p5)
	p2.setDeepLinkedMoment(p3, p4, p5)
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
	local momentId = if deepLinkRequest ~= nil then deepLinkRequest.momentId else nil
	local key = if deepLinkRequest ~= nil then deepLinkRequest.key else nil

	if momentId ~= nil and ref5.current ~= key then
		local v6 = GetDeepLinkStore()

		local targetIdType = if deepLinkRequest ~= nil then deepLinkRequest.targetIdType else nil
		local v7 = if fFlagMomentsCommentDeepLinks and deepLinkRequest ~= nil then deepLinkRequest.commentsTarget else nil
		v6.setDeepLinkedMoment(momentId, targetIdType, v7)

		ref5.current = key
	end

	React.useEffect(function()
		if momentId ~= nil and ref3.current then
			RobloxAppEvents.ReloadPage:fire(appPage.Moments)
		end

		ref3.current = true
	end, { key, momentId, props.navigation })

	local v6 = React.useCallback(function()
		if ref2.current then
			return
		end

		ref2.current = true

		local current = ref4.current

		local v7 = consumeEntrySource(ref.current.navigation, ref6.current)

		current.resetSession()
		current.setSessionSource(v7)

		logMomentsLayerExposure(FStringMomentsExperienceJoinActionTextIxpLayer)

		if require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCreatorAttributionIxpEnabled") then
			logMomentsLayerExposure(require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FStringMomentsCreatorAttributionIxpLayer"))
		end

		if require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFeedIxpEnabled") then
			logMomentsLayerExposure(require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FStringMomentsFeedIxpLayer"))
		end

		if FFlagMomentsEmojiSetsApi then
			local getAndFetchEmojiSets = MomentsGetMomentsReactionsStore(false).getAndFetchEmojiSets
			assert(
				getAndFetchEmojiSets ~= nil,
				"expected getAndFetchEmojiSets when FFlagMomentsEmojiSetsApi is on"
			)
			getAndFetchEmojiSets()
		end

		fireAnalyticsEvent(eventNames.TapMomentsTab, {
			moments_session_id = current.getMomentsSessionId(false),
			source = v7
		})

		analytics.reportMomentsSessionStarted(v7)

		local momentsSessionHeartbeat = analytics.createMomentsSessionHeartbeat()
		v5[current.getMomentsSessionId(false)] = momentsSessionHeartbeat
		momentsSessionHeartbeat.start(v7)

		local v8 = sessionManager.startSession(funnelEventNames.FunnelTypes.AppNavigation)
		fireFunnelAnalyticsEvent(
			funnelEventNames.FunnelTypes.AppNavigation,
			funnelEventNames.AppNavigationSteps.AppLaunched,
			v8
		)
	end, {})

	local v7 = React.useCallback(function()
		if not ref2.current then
			return
		end

		ref2.current = false
		momentsSurfaceLoadManager.abort("blur")

		getExperienceDetailsSheetStore(false).close()

		local current = ref4.current
		local v8 = os.clock() - current.getSessionStartTime(false)

		fireAnalyticsEvent(eventNames.MomentsSessionEnded, {
			moments_session_id = current.getMomentsSessionId(false),
			source = current.getSessionSource(false),
			duration_seconds = tostring((math.floor(v8)))
		})

		local momentsSessionId = current.getMomentsSessionId(false)
		local v9 = v5[momentsSessionId]

		if v9 then
			v9.stop()
			v5[momentsSessionId] = nil
		end

		analytics.reportMomentsSessionEnded(current.getSessionSource(false))

		sessionManager.endSession(funnelEventNames.FunnelTypes.AppNavigation)
	end, {})

	local v8 = React.useCallback(function()
		GetImmersiveChromeStore(false).setOverlayCovering(false)
		local onTabFocused = ref.current.onTabFocused

		if onTabFocused then
			onTabFocused()
		end
	end, {})

	React.useEffect(function()
		local navigation = props.navigation

		if navigation and navigation.addListener then
			v6()
			v8()

			local v9 = navigation.addListener(RoactNavigation.Events.DidFocus, function()
				local deepLinkRequest2 = getDeepLinkRequest(navigation)

				local v10 = not (deepLinkRequest2 == nil) and ref5.current == deepLinkRequest2.key

				if deepLinkRequest2 ~= nil and not v10 then
					local v11 = GetDeepLinkStore()
					local momentId2 = deepLinkRequest2.momentId
					local targetIdType = deepLinkRequest2.targetIdType
					local v12 = if fFlagMomentsCommentDeepLinks then deepLinkRequest2.commentsTarget else nil
					v11.setDeepLinkedMoment(momentId2, targetIdType, v12)

					ref5.current = deepLinkRequest2.key
					RobloxAppEvents.ReloadPage:fire(appPage.Moments)
				end

				v6()
				v8()
			end)
			local v10 = navigation.addListener(RoactNavigation.Events.WillBlur, function()
				v7()
			end)

			return function()
				v7()
				v9.remove()
				v10.remove()
			end
		end

		v6()
		v8()
		return function()
			v7()
		end
	end, { v6, v7, v8 })

	local v9 = useMomentsTabIsVisible()
	React.useEffect(function()
		if v9 then
			v8()
		end
	end, { v9, v8 })

	local useMemo = React.useMemo
	local function fn()
		local openProfile = props.openProfile
		local openOwnMoments = props.openOwnMoments
		local v10 = {
			openProfile = openProfile and function(p2)
				GetImmersiveChromeStore(false).setOverlayCovering(true)
				openProfile(p2)
			end or nil,
			openOwnMoments = openOwnMoments and function()
				GetImmersiveChromeStore(false).setOverlayCovering(true)
				openOwnMoments()
			end or nil,
			openMomentsFeedReport = props.openMomentsFeedReport,
			openAvatarLookTryOn = 0,
			openMomentCommentReport = 0,
			openBlockUser = 0
		}
		local v11 = if fFlagMomentsAvatarLookTryOn then props.openAvatarLookTryOn else nil
		v10.openAvatarLookTryOn = v11
		v10.openMomentCommentReport = props.openMomentCommentReport
		v10.openBlockUser = props.openBlockUser
		return v10
	end

	local openProfile = props.openProfile
	local openOwnMoments = props.openOwnMoments
	local openMomentsFeedReport = props.openMomentsFeedReport
	local openMomentCommentReport = props.openMomentCommentReport
	local openBlockUser = props.openBlockUser
	local v11 = if fFlagMomentsAvatarLookTryOn then props.openAvatarLookTryOn else nil
	local v12 = useMemo(fn, {
		openProfile,
		openOwnMoments,
		openMomentsFeedReport,
		openMomentCommentReport,
		openBlockUser,
		v11
	})

	if not canRenderNativeMoments((useMomentsGating())) then
		return nil
	end

	local createElement = React.createElement

	local v15 = {
		sessionStore = ref4.current,
		openProfile = v12.openProfile,
		openOwnMoments = v12.openOwnMoments,
		openMomentsFeedReport = v12.openMomentsFeedReport,
		openAvatarLookTryOn = 0,
		openMomentCommentReport = 0,
		openBlockUser = 0
	}
	local v16 = if fFlagMomentsAvatarLookTryOn then v12.openAvatarLookTryOn else nil
	v15.openAvatarLookTryOn = v16
	v15.openMomentCommentReport = v12.openMomentCommentReport
	v15.openBlockUser = v12.openBlockUser
	return createElement(MomentsHostShell, v15, React.createElement(InnerNavigator, {
		navigation = props.navigation
	}))
end

local extended = React.Component:extend("MomentsTabEntryScreen")

function extended.render(p2)
	return React.createElement(MomentsTabEntry, p2.props)
end

extended.router = InnerNavigator.router

return extended
