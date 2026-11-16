local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local module2 = require("@luauforge/deferred/hvH")
local useMomentsGating = require("@luauforge/bundled/huY").Hooks.useMomentsGating
local momentsImmersivePresentation = module2.MomentsImmersivePresentation
local reportEdpVideo = module2.reportEdpVideo
local immersiveFeedKind = module2.Constants.ImmersiveFeedKind
local module3 = require("@luauforge/bundled/hwa")
local module4 = require("@luauforge/bundled/hvI")
local module5 = require("@luauforge/bundled/eed")
local module6 = require("@luauforge/bundled/dHo")
local module7 = require("@luauforge/deferred/hvW")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local module9 = require("@luauforge/bundled/hvX")
local abuseVector = module9.Enums.AbuseVector
local openDynamicAbuseReport = module9.Thunks.OpenDynamicAbuseReport
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local module10 = require("@luauforge/deferred/hvY")

local reportMoment = module2.reportMoment

local momentsFeed = module4.Sources.MomentsFeed

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
local shareLinkTargetIdType = module3.Enums.ShareLinkTargetIdType
local v5 = fFlagAppChatMomentShareCardNavigation and fFlagEnableArgus and fFlagEnableArgusImmersiveNav

local function isSupportedTargetIdType(p2): boolean
	return p2 == nil or p2 == shareLinkTargetIdType.FeedItemId
end

local function MomentsImmersiveRouteContainer(p2)
	local v6 = useDispatch()

	local v7 = if v5 then useMomentsGating().isAmpPolicyEnabled else nil
	local v8 = not v5 or v7 == true
	local v9 = useSelector(function(p3)
		return p3.LocalUserId
	end)

	local navigation = p2.navigation

	local v10 = React.useCallback(function(p3)
		v6(module5(tostring(p3), { source = momentsFeed }))
	end, { v6 })

	local v11 = React.useCallback(function()
		if v9 == nil then
			return
		end

		v6(module5(tostring(v9), { source = momentsFeed }))
	end, { v6, v9 })
	local v12

	if fFlagMomentsAvatarLookTryOn then
		v12 = React.useCallback(function(p3, p4)
			if fFlagAXEnableUnifiedLoggingAvatarMoment or fFlagMomentsRenderAvatarPostsInFeed then
				v6(module7(p3, p4))
			else
				v6(module7(p3))
			end
		end, { v6 })
	end

	local v13 = React.useCallback(function(data)
		if fFlagMomentsServeEDPVideos and data.isEdpVideo then
			local flag = false
			local function openEdpVideoIpReportDialog(p3)
				flag = true
				data.onClose()
				v6(closeCentralOverlay())

				if data.onEdpVideoIpReport then
					data.onEdpVideoIpReport(function()
						v6(module6(data.universeId, {
							mountAsFullView = true,
							showBackButton = true
						}))
					end)
				end

				return {}
			end

			local v16 = {
				abuseVector = abuseVector.MomentsFeed,
				targetId = 0,
				attributes = 0,
				analyticsTargetId = 0,
				onSubmit = 0,
				onClose = 0,
				clientActionHandlers = 0
			}
			local v17 = if not fFlagAbuseReportAttributes then data.feedItemId else nil
			v16.targetId = v17
			v16.attributes = fFlagAbuseReportAttributes
				and { targetId = data.feedItemId, isEdpVideo = true }
				or nil

			local v18 = if fFlagAbuseReportAttributes then data.feedItemId else nil
			v16.analyticsTargetId = v18
			function v16.onSubmit()
				if flag then
					return
				end

				data.onSubmit()
			end
			function v16.onClose()
				data.onClose()
				v6(closeCentralOverlay())
			end
			v16.clientActionHandlers = {
				["moments-edp-video"] = reportEdpVideo,
				["moments-edp-video-ip"] = openEdpVideoIpReportDialog
			}
			v6(openDynamicAbuseReport(v16))
		else
			local flag = false
			local function submitMomentsIp(p3)
				flag = true

				local function showConfirmation(p4)
					data.onClose()
					v6(closeCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(p4)
					end
				end
				return reportMoment(data.feedItemId, "IntellectualProperty"):andThen(function(p4)
					local reportCode = p4.reportCode
					data.onClose()
					v6(closeCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(reportCode)
					end

					return p4
				end, function()
					data.onClose()
					v6(closeCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(nil)
					end
				end)
			end

			v6(openDynamicAbuseReport({
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
					v6(closeCentralOverlay())
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
	end, { v6 })
	local v14

	if fFlagEnableMomentsCommentReporting then
		v14 = React.useCallback(function(data)
			local v15 = {
				targetId = data.commentId,
				channelId = data.channelId,
				reportedUserId = data.reportedUserId
			}

			v6(openDynamicAbuseReport({
				abuseVector = abuseVector.MomentComment,
				attributes = v15,
				analyticsTargetId = data.commentId,
				onClose = function()
					v6(closeCentralOverlay())
				end
			}))
		end, { v6 })
	end

	local v15 = if fFlagEnableMomentsCommentBlocking then module10(navigation) else nil

	local v16 = React.useCallback(function()
		if navigation ~= nil and navigation.goBack ~= nil then
			navigation.goBack()
		end
	end, { navigation })

	if v5 then
		React.useEffect(function()
			if not v8 then
				v16()
			end
		end, { v8, v16 })
	end

	local v17

	if not (navigation == nil or navigation.getParam == nil) then
		v17 = navigation.getParam("extraProps")
	end

	local postId = nil
	local v18 = nil

	if type(v17) == "table" and type(v17.postId) == "string" then
		local targetIdType = v17.targetIdType

		if
			not fFlagEnableArgusImmersiveNav
			or targetIdType == nil
			or targetIdType == shareLinkTargetIdType.FeedItemId
		then
			postId = v17.postId
			v18 = targetIdType
		end
	end

	local v19 = "flyout_menu"

	if type(v17) == "table" and type(v17.source) == "string" then
		v19 = v17.source
	elseif navigation ~= nil and navigation.getParam ~= nil then
		local param = navigation.getParam("source")

		if type(param) == "string" then
			v19 = param
		end
	end

	if not v8 then
		return nil
	end

	local createElement = React.createElement
	local v21 = {
		feedKind = immersiveFeedKind.Trending,
		onBack = v16,
		sessionSource = v19,
		deepLinkedMomentId = postId,
		deepLinkedMomentTargetIdType = v18,
		openProfile = v10,
		openOwnMoments = v11,
		openMomentsFeedReport = v13,
		openAvatarLookTryOn = 0,
		openMomentCommentReport = 0,
		openBlockUser = 0
	}

	if not fFlagMomentsAvatarLookTryOn then
		v12 = nil
	end

	v21.openAvatarLookTryOn = v12

	if not fFlagEnableMomentsCommentReporting then
		v14 = nil
	end

	v21.openMomentCommentReport = v14
	v21.openBlockUser = v15
	return (createElement(momentsImmersivePresentation, v21))
end

return MomentsImmersiveRouteContainer
