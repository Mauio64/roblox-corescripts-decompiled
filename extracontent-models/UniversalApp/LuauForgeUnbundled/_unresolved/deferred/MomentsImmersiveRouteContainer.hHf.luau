local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXAvatarMomentsCreation = AvatarExperienceFlags.FFlagAXAvatarMomentsCreation
local fFlagAXPhotoboothMomentsPage = AvatarExperienceFlags.FFlagAXPhotoboothMomentsPage
local v5 = fFlagAXAvatarMomentsCreation and fFlagAXPhotoboothMomentsPage
local module4 = require("@luauforge/deferred/hGN")
local module5 = require("@luauforge/bundled/fIP")
local useMomentsGating = module5.Hooks.useMomentsGating
local getMomentsCapabilities = module5.Stores.GetMomentsCapabilities
local momentsImmersivePresentation = module4.MomentsImmersivePresentation
local reportEdpVideo = module4.reportEdpVideo
local immersiveFeedKind = module4.Constants.ImmersiveFeedKind
local module6 = require("@luauforge/bundled/fIQ")
local module7 = require("@luauforge/bundled/hGO")
local module8 = require("@luauforge/bundled/ehA")
local module9 = require("@luauforge/bundled/dKt")
local module10 = require("@luauforge/deferred/hHc")
local module11 = require("@luauforge/bundled/hHd")
local abuseVector = module11.Enums.AbuseVector
local openDynamicAbuseReport = module11.Thunks.OpenDynamicAbuseReport
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local module12 = require("@luauforge/deferred/hHe")

local reportMoment = module4.reportMoment

local fFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local momentsFeed = module7.Sources.MomentsFeed

local fireAnalyticsEvent = if fFlagProfileRenderAvatarMoments then module5.Analytics.fireAnalyticsEvent else nil
local eventNames = if fFlagProfileRenderAvatarMoments then module5.Analytics.EventNames else nil
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local fFlagAppChatMomentShareCardNavigation = SharedFlags.FFlagAppChatMomentShareCardNavigation
local fFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local fFlagAXEnableUnifiedLoggingAvatarMoment = SharedFlags.FFlagAXEnableUnifiedLoggingAvatarMoment
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local fFlagEnableMomentsCommentReporting = SharedFlags.FFlagEnableMomentsCommentReporting
local fFlagEnableMomentsCommentBlocking = SharedFlags.FFlagEnableMomentsCommentBlocking
local fFlagAbuseReportSubmissionTargetV4 = SharedFlags.FFlagAbuseReportSubmissionTargetV4
local fFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local fFlagAbuseReportAttributes = SharedFlags.FFlagAbuseReportAttributes
local shareLinkTargetIdType = module6.Enums.ShareLinkTargetIdType
local v6 = fFlagAppChatMomentShareCardNavigation and fFlagEnableArgus and fFlagEnableArgusImmersiveNav

local function isSupportedTargetIdType(p2): boolean
	return p2 == nil or p2 == shareLinkTargetIdType.FeedItemId
end

local function MomentsImmersiveRouteContainer(p2)
	local v7 = useDispatch()
	local v8

	if v5 then
		v8 = useSignalState(getMomentsCapabilities(false).getCanCreateAvatarMoments)
	else
		v8 = false
	end

	local isAmpPolicyEnabled = if v6 then useMomentsGating().isAmpPolicyEnabled else nil

	local v9 = useSelector(function(p3)
		return p3.LocalUserId
	end)

	local navigation = p2.navigation
	local v10

	if not (navigation == nil or navigation.getParam == nil) then
		v10 = navigation.getParam("extraProps")
	end

	local targetUserId

	if fFlagProfileRenderAvatarMoments and type(v10) == "table" and type(v10.targetUserId) == "number" then
		targetUserId = v10.targetUserId
	else
		targetUserId = nil
	end

	local initialIndex

	if fFlagProfileRenderAvatarMoments and type(v10) == "table" and type(v10.initialIndex) == "number" then
		initialIndex = v10.initialIndex
	end

	local initialMomentId

	if
		fFlagProfileRenderAvatarMoments
		and type(v10) == "table"
		and type(v10.initialMomentId) == "string"
	then
		initialMomentId = v10.initialMomentId
	end

	local v11 = targetUserId ~= nil
	local v12 = not v6 or v11 or isAmpPolicyEnabled == true
	local v13 = React.useCallback(function(p3)
		v7(module8(tostring(p3), { source = momentsFeed }))
	end, { v7 })

	local v14 = React.useCallback(function()
		if v9 == nil then
			return
		end

		v7(module8(tostring(v9), { source = momentsFeed }))
	end, { v7, v9 })
	local v15

	if v5 then
		v15 = React.useCallback(function()
			local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

			v7(require("@luauforge/bundled/gOQ")(AvatarExperienceNavigation.Enums.AvatarScreen.PhotoboothMomentsPage))
		end, { v7 })
	end

	local v16

	if fFlagMomentsAvatarLookTryOn then
		v16 = React.useCallback(function(p3, p4)
			if fFlagAXEnableUnifiedLoggingAvatarMoment or fFlagMomentsRenderAvatarPostsInFeed then
				v7(module10(p3, p4))
			else
				v7(module10(p3))
			end
		end, { v7 })
	end

	local v17 = React.useCallback(function(data)
		if fFlagMomentsServeEDPVideos and data.isEdpVideo then
			local flag = false
			local function openEdpVideoIpReportDialog(p3)
				flag = true
				data.onClose()
				v7(closeCentralOverlay())

				if data.onEdpVideoIpReport then
					data.onEdpVideoIpReport(function()
						v7(module9(data.universeId, {
							mountAsFullView = true,
							showBackButton = true
						}))
					end)
				end

				return {}
			end

			local v20 = {
				abuseVector = abuseVector.MomentsFeed,
				targetId = 0,
				attributes = 0,
				analyticsTargetId = 0,
				onSubmit = 0,
				onClose = 0,
				clientActionHandlers = 0
			}
			local v21 = if not fFlagAbuseReportAttributes then data.feedItemId else nil
			v20.targetId = v21
			v20.attributes = fFlagAbuseReportAttributes
				and { targetId = data.feedItemId, isEdpVideo = true }
				or nil

			local v22 = if fFlagAbuseReportAttributes then data.feedItemId else nil
			v20.analyticsTargetId = v22
			function v20.onSubmit()
				if flag then
					return
				end

				data.onSubmit()
			end
			function v20.onClose()
				data.onClose()
				v7(closeCentralOverlay())
			end
			v20.clientActionHandlers = {
				["moments-edp-video"] = reportEdpVideo,
				["moments-edp-video-ip"] = openEdpVideoIpReportDialog
			}
			v7(openDynamicAbuseReport(v20))
		else
			local flag = false
			local function submitMomentsIp(p3)
				flag = true

				local function showConfirmation(p4)
					data.onClose()
					v7(closeCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(p4)
					end
				end
				return reportMoment(data.feedItemId, "IntellectualProperty"):andThen(function(p4)
					local reportCode = p4.reportCode
					data.onClose()
					v7(closeCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(reportCode)
					end

					return p4
				end, function()
					data.onClose()
					v7(closeCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(nil)
					end
				end)
			end

			v7(openDynamicAbuseReport({
				abuseVector = abuseVector.MomentsFeed,
				targetId = data.feedItemId,
				onSubmit = function()
					if flag then
						return
					end

					data.onSubmit()
				end,
				onClose = function()
					data.onClose()
					v7(closeCentralOverlay())
				end,
				onCustomSubmit = not fFlagAbuseReportSubmissionTargetV4 and function(p3)
					if p3.endpoint == "moments-ip" then
						return submitMomentsIp(p3)
					end

					return nil
				end or nil,
				clientActionHandlers = fFlagAbuseReportSubmissionTargetV4 and {
					["moments-ip"] = submitMomentsIp
				} or nil
			}))
		end
	end, { v7 })
	local v18

	if fFlagEnableMomentsCommentReporting then
		v18 = React.useCallback(function(data)
			local v19 = {
				targetId = data.commentId,
				channelId = data.channelId,
				reportedUserId = data.reportedUserId
			}

			v7(openDynamicAbuseReport({
				abuseVector = abuseVector.MomentComment,
				attributes = v19,
				analyticsTargetId = data.commentId,
				onClose = function()
					v7(closeCentralOverlay())
				end
			}))
		end, { v7 })
	end

	local v19 = if fFlagEnableMomentsCommentBlocking then module12(navigation) else nil

	local v20 = React.useCallback(function()
		if targetUserId ~= nil and fireAnalyticsEvent ~= nil and eventNames ~= nil then
			fireAnalyticsEvent(eventNames.ProfileClosePressed, {
				userId = tostring(targetUserId)
			})
		end

		if navigation ~= nil and navigation.goBack ~= nil then
			navigation.goBack()
		end
	end, { navigation, targetUserId })

	if v6 then
		React.useEffect(function()
			if not v12 then
				v20()
			end
		end, { v12, v20 })
	end

	local postId = nil
	local v21 = nil

	if type(v10) == "table" and type(v10.postId) == "string" then
		local targetIdType = v10.targetIdType

		if
			not fFlagEnableArgusImmersiveNav
			or targetIdType == nil
			or targetIdType == shareLinkTargetIdType.FeedItemId
		then
			postId = v10.postId
			v21 = targetIdType
		end
	end

	local v22 = "flyout_menu"

	if type(v10) == "table" and type(v10.source) == "string" then
		v22 = v10.source
	elseif targetUserId == nil then
		if navigation ~= nil and navigation.getParam ~= nil then
			local param = navigation.getParam("source")

			if type(param) == "string" then
				v22 = param
			end
		end
	else
		v22 = "profile"
	end

	if not v12 then
		return nil
	end

	local createElement = React.createElement
	local v25 = if targetUserId == nil then immersiveFeedKind.Trending else immersiveFeedKind.User
	local v24 = {
		feedKind = v25,
		targetUserId = targetUserId,
		initialIndex = initialIndex,
		initialMomentId = initialMomentId,
		onBack = v20,
		sessionSource = v22,
		deepLinkedMomentId = postId,
		deepLinkedMomentTargetIdType = v21,
		openProfile = v13,
		openOwnMoments = v14,
		openAvatarMomentsCreation = nil,
		openMomentsFeedReport = nil,
		openAvatarLookTryOn = nil,
		openMomentCommentReport = nil,
		openBlockUser = nil
	}

	if not (v5 and v8) then
		v15 = nil
	end

	v24.openAvatarMomentsCreation = v15

	v24.openMomentsFeedReport = v17

	if not fFlagMomentsAvatarLookTryOn then
		v16 = nil
	end

	v24.openAvatarLookTryOn = v16

	if not fFlagEnableMomentsCommentReporting then
		v18 = nil
	end

	v24.openMomentCommentReport = v18
	v24.openBlockUser = v19
	return (createElement(momentsImmersivePresentation, v24))
end

return MomentsImmersiveRouteContainer
