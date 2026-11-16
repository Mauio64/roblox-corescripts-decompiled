local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Navigation = require(parent.Navigation)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RoactUtils = require(parent.RoactUtils)
local MomentsCommon = require(parent.MomentsCommon)
local Moments = require(parent.Moments)
local GenericAbuseReporting = require(parent.GenericAbuseReporting)
local CentralOverlay = require(parent.CentralOverlay)
local GameDetail = require(parent.GameDetail)
local OpenGameDetails = GameDetail.OpenGameDetails
local useOpenBlockingModal = require(parent.MomentsCommon.useOpenBlockingModal)

local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local FFlagEnableMomentsCommentReporting = SharedFlags.FFlagEnableMomentsCommentReporting
local FFlagEnableMomentsCommentBlocking = SharedFlags.FFlagEnableMomentsCommentBlocking
local FFlagAbuseReportSubmissionTargetV4 = SharedFlags.FFlagAbuseReportSubmissionTargetV4
local FFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local FFlagAbuseReportAttributes = SharedFlags.FFlagAbuseReportAttributes
local FFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments

local View = Foundation.View
local IconButton = Foundation.IconButton
local ButtonSize = Foundation.Enums.ButtonSize
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode

local useScreenSize = RobloxAppHooks.useScreenSize
local useStatusBarHeight = RobloxAppHooks.useStatusBarHeight
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AbuseVector = GenericAbuseReporting.Enums.AbuseVector
local OpenDynamicAbuseReport = GenericAbuseReporting.Thunks.OpenDynamicAbuseReport
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local EventNames = MomentsCommon.Analytics.EventNames

local useNavigation = Navigation.useNavigation
local Feed = Moments.Feed
local reportEdpVideo = Moments.reportEdpVideo

local MomentsImmersivePresentation = Moments.MomentsImmersivePresentation
local ImmersiveFeedKind = Moments.Constants.ImmersiveFeedKind

local CreateUserMomentsFeedSource = require(parent.Moments.CreateUserMomentsFeedSource)

local reportMoment = Moments.reportMoment

local function MomentsFeedPageImmersive()
	local v = useNavigation()
	local param = v.getParam("extraProps")

	local targetUserId = not (param and param.targetUserId) and 0 or param.targetUserId
	local initialIndex = not (param and param.initialIndex) and 1 or param.initialIndex
	local initialMomentId

	if FFlagMomentsOptimisticProfilePending and param ~= nil then
		initialMomentId = param.initialMomentId
	end

	local onBack = React.useCallback(function()
		fireAnalyticsEvent(EventNames.ProfileClosePressed, { userId = tostring(targetUserId) })

		v.goBack()
	end, { v.goBack, targetUserId })

	local v2 = useDispatch()
	local useCallback = React.useCallback
	local function fn(data)
		if FFlagMomentsServeEDPVideos and data.isEdpVideo then
			local flag = false
			local function openEdpVideoIpReportDialog(_)
				flag = true
				data.onClose()
				v2(CloseCentralOverlay())

				if data.onEdpVideoIpReport then
					data.onEdpVideoIpReport(function()
						v2(OpenGameDetails(data.universeId, v, {
							mountAsFullView = true,
							showBackButton = true
						}))
					end)
				end

				return {}
			end

			local v3 = {
				abuseVector = AbuseVector.MomentsFeed,
				targetId = 0,
				attributes = 0,
				analyticsTargetId = 0,
				onSubmit = 0,
				onClose = 0,
				clientActionHandlers = 0
			}
			local targetId

			if not FFlagAbuseReportAttributes then
				targetId = data.feedItemId
			end

			v3.targetId = targetId
			v3.attributes = FFlagAbuseReportAttributes and {
				targetId = data.feedItemId,
				isEdpVideo = true
			} or nil
			local analyticsTargetId

			if FFlagAbuseReportAttributes then
				analyticsTargetId = data.feedItemId
			end

			v3.analyticsTargetId = analyticsTargetId
			function v3.onSubmit()
				if flag then
					return
				end

				data.onSubmit()
			end
			function v3.onClose()
				data.onClose()
				v2(CloseCentralOverlay())
			end
			v3.clientActionHandlers = {
				["moments-edp-video"] = reportEdpVideo,
				["moments-edp-video-ip"] = openEdpVideoIpReportDialog
			}
			v2(OpenDynamicAbuseReport(v3))
		else
			local flag = false
			local function submitMomentsIp(_)
				flag = true

				local function showConfirmation(reportCode: string?) -- 2 equivalent calls inferred from this helper
					data.onClose()
					v2(CloseCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(reportCode)
					end
				end
				return reportMoment(data.feedItemId, "IntellectualProperty"):andThen(function(p)
					showConfirmation(p.reportCode) -- inferred equivalent call
					return p
				end, function()
					showConfirmation(nil) -- inferred equivalent call
				end)
			end

			v2(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.MomentsFeed,
				targetId = data.feedItemId,
				onSubmit = function()
					if flag then
						return
					end

					data.onSubmit()
				end,
				onClose = function()
					data.onClose()
					v2(CloseCentralOverlay())
				end,
				onCustomSubmit = not FFlagAbuseReportSubmissionTargetV4 and function(p)
					if p.endpoint == "moments-ip" then
						return submitMomentsIp(p)
					end

					return nil
				end or nil,
				clientActionHandlers = FFlagAbuseReportSubmissionTargetV4 and {
					["moments-ip"] = submitMomentsIp
				} or nil
			}))
		end
	end

	local v3 = if FFlagMomentsServeEDPVideos then v else false
	local openMomentsFeedReport = useCallback(fn, { v2, v3 })
	local openMomentCommentReport

	if FFlagEnableMomentsCommentReporting then
		openMomentCommentReport = React.useCallback(function(data)
			local attributes = {
				targetId = data.commentId,
				channelId = data.channelId,
				reportedUserId = data.reportedUserId
			}

			v2(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.MomentComment,
				attributes = attributes,
				analyticsTargetId = data.commentId,
				onClose = function()
					v2(CloseCentralOverlay())
				end
			}))
		end, { v2 })
	end

	local openBlockUser

	if FFlagEnableMomentsCommentBlocking then
		openBlockUser = useOpenBlockingModal(v)
	end

	local v4 = useScreenSize()

	return React.createElement(View, {
		Size = UDim2.fromOffset(v4.X, v4.Y),
		backgroundStyle = FFlagProfileRenderAvatarMoments and { Transparency = 1 } or nil,
		tag = {
			["bg-surface-0"] = not FFlagProfileRenderAvatarMoments
		}
	}, {
		Presentation = React.createElement(MomentsImmersivePresentation, {
			feedKind = ImmersiveFeedKind.User,
			targetUserId = targetUserId,
			initialIndex = initialIndex,
			initialMomentId = initialMomentId,
			onBack = onBack,
			sessionSource = "profile",
			openMomentsFeedReport = openMomentsFeedReport,
			openMomentCommentReport = openMomentCommentReport,
			openBlockUser = openBlockUser
		})
	})
end

local function MomentsFeedPageLegacy()
	local v = useNavigation()
	local param = v.getParam("extraProps")

	local v2 = not (param and param.targetUserId) and 0 or param.targetUserId
	local initialIndex = not (param and param.initialIndex) and 1 or param.initialIndex
	local initialMomentId

	if FFlagMomentsOptimisticProfilePending and param ~= nil then
		initialMomentId = param.initialMomentId
	else
		initialMomentId = nil
	end

	local source = React.useMemo(function()
		return CreateUserMomentsFeedSource(v2, {
			initialIndex = initialIndex,
			initialMomentId = initialMomentId
		})
	end, { v2, initialIndex, initialMomentId })

	local onActivated = React.useCallback(function()
		fireAnalyticsEvent(EventNames.ProfileClosePressed, { userId = tostring(v2) })

		v.goBack()
	end, { v.goBack, v2 })

	local v3 = useScreenSize()
	local v4 = useSelector(function(p)
		return p.GlobalGuiInset
	end)

	local v5 = useStatusBarHeight()

	return React.createElement(View, {
		Size = UDim2.fromOffset(v3.X, v3.Y),
		padding = {
			top = UDim.new(0, v4.top + v5),
			bottom = UDim.new(0, v4.bottom),
			left = UDim.new(0, v4.left),
			right = UDim.new(0, v4.right)
		},
		backgroundStyle = FFlagProfileRenderAvatarMoments and { Transparency = 1 } or nil,
		tag = {
			["bg-surface-0"] = not FFlagProfileRenderAvatarMoments
		}
	}, {
		OnVideoUI = React.createElement(FoundationProvider, { colorMode = ColorMode.Dark }, {
			Feed = React.createElement(Feed, {
				source = source,
				active = true,
				playbackActive = true,
				initialIndex = initialIndex
			}),
			CloseButtonContainer = React.createElement(
				View,
				{ tag = "position-top-left anchor-top-left auto-xy padding-large", ZIndex = 100000 },
				{
					CloseButton = React.createElement(IconButton, {
						icon = "icons/navigation/close",
						size = ButtonSize.Medium,
						onActivated = onActivated
					})
				}
			)
		})
	})
end

if FFlagEnableArgusImmersiveNav then
	return MomentsFeedPageImmersive
end

return MomentsFeedPageLegacy
