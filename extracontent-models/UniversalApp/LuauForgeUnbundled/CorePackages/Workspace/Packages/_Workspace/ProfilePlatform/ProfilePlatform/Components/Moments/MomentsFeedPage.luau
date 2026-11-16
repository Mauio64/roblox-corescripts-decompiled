local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/MomentsCommon")
local Moments = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Moments")
local GenericAbuseReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GenericAbuseReporting")
local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CentralOverlay")
local openGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GameDetail").OpenGameDetails
local useOpenBlockingModal = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/MomentsCommon/useOpenBlockingModal")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local fFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local fFlagEnableMomentsCommentReporting = SharedFlags.FFlagEnableMomentsCommentReporting
local fFlagEnableMomentsCommentBlocking = SharedFlags.FFlagEnableMomentsCommentBlocking
local fFlagAbuseReportSubmissionTargetV4 = SharedFlags.FFlagAbuseReportSubmissionTargetV4
local fFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local fFlagAbuseReportAttributes = SharedFlags.FFlagAbuseReportAttributes
local fFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments

local view = Foundation.View
local iconButton = Foundation.IconButton
local buttonSize = Foundation.Enums.ButtonSize
local foundationProvider = Foundation.FoundationProvider
local colorMode = Foundation.Enums.ColorMode

local useScreenSize = RobloxAppHooks.useScreenSize
local useStatusBarHeight = RobloxAppHooks.useStatusBarHeight
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local abuseVector = GenericAbuseReporting.Enums.AbuseVector
local openDynamicAbuseReport = GenericAbuseReporting.Thunks.OpenDynamicAbuseReport
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local eventNames = MomentsCommon.Analytics.EventNames

local useNavigation = Navigation.useNavigation
local feed = Moments.Feed
local reportEdpVideo = Moments.reportEdpVideo

local momentsImmersivePresentation = Moments.MomentsImmersivePresentation
local immersiveFeedKind = Moments.Constants.ImmersiveFeedKind

local CreateUserMomentsFeedSource = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Moments/CreateUserMomentsFeedSource")

local reportMoment = Moments.reportMoment

local function MomentsFeedPageImmersive()
	local v5 = useNavigation()
	local param = v5.getParam("extraProps")

	local v6 = not (param and param.targetUserId) and 0 or param.targetUserId
	local v7 = not (param and param.initialIndex) and 1 or param.initialIndex
	local initialMomentId

	if fFlagMomentsOptimisticProfilePending and param ~= nil then
		initialMomentId = param.initialMomentId
	end

	local v8 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.ProfileClosePressed, { userId = tostring(v6) })

		v5.goBack()
	end, { v5.goBack, v6 })

	local v9 = useDispatch()
	local function fn(data)
		if fFlagMomentsServeEDPVideos and data.isEdpVideo then
			local flag = false
			local function openEdpVideoIpReportDialog(p2)
				flag = true
				data.onClose()
				v9(closeCentralOverlay())

				if data.onEdpVideoIpReport then
					data.onEdpVideoIpReport(function()
						v9(openGameDetails(data.universeId, v5, {
							mountAsFullView = true,
							showBackButton = true
						}))
					end)
				end

				return {}
			end

			local v12 = {
				abuseVector = abuseVector.MomentsFeed,
				targetId = 0,
				attributes = 0,
				analyticsTargetId = 0,
				onSubmit = 0,
				onClose = 0,
				clientActionHandlers = 0
			}
			local v13 = if not fFlagAbuseReportAttributes then data.feedItemId else nil
			v12.targetId = v13
			v12.attributes = fFlagAbuseReportAttributes
				and { targetId = data.feedItemId, isEdpVideo = true }
				or nil

			local v14 = if fFlagAbuseReportAttributes then data.feedItemId else nil
			v12.analyticsTargetId = v14
			function v12.onSubmit()
				if flag then
					return
				end

				data.onSubmit()
			end
			function v12.onClose()
				data.onClose()
				v9(closeCentralOverlay())
			end
			v12.clientActionHandlers = {
				["moments-edp-video"] = reportEdpVideo,
				["moments-edp-video-ip"] = openEdpVideoIpReportDialog
			}
			v9(openDynamicAbuseReport(v12))
		else
			local flag = false
			local function submitMomentsIp(p2)
				flag = true

				local function showConfirmation(p3)
					data.onClose()
					v9(closeCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(p3)
					end
				end
				return reportMoment(data.feedItemId, "IntellectualProperty"):andThen(function(p3)
					local reportCode = p3.reportCode
					data.onClose()
					v9(closeCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(reportCode)
					end

					return p3
				end, function()
					data.onClose()
					v9(closeCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(nil)
					end
				end)
			end

			v9(openDynamicAbuseReport({
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
					v9(closeCentralOverlay())
				end,
				onCustomSubmit = not fFlagAbuseReportSubmissionTargetV4 and function(p2)
					if p2.endpoint == "moments-ip" then
						return submitMomentsIp(p2)
					end

					return nil
				end or nil,
				clientActionHandlers = fFlagAbuseReportSubmissionTargetV4 and {
					["moments-ip"] = submitMomentsIp
				} or nil
			}))
		end
	end

	local v12 = React.useCallback(fn, { v9, if fFlagMomentsServeEDPVideos then v5 else false })
	local v13

	if fFlagEnableMomentsCommentReporting then
		v13 = React.useCallback(function(data)
			local v14 = {
				targetId = data.commentId,
				channelId = data.channelId,
				reportedUserId = data.reportedUserId
			}

			v9(openDynamicAbuseReport({
				abuseVector = abuseVector.MomentComment,
				attributes = v14,
				analyticsTargetId = data.commentId,
				onClose = function()
					v9(closeCentralOverlay())
				end
			}))
		end, { v9 })
	end

	local v14 = if fFlagEnableMomentsCommentBlocking then useOpenBlockingModal(v5) else nil

	local v15 = useScreenSize()

	return React.createElement(view, {
		Size = UDim2.fromOffset(v15.X, v15.Y),
		backgroundStyle = fFlagProfileRenderAvatarMoments and { Transparency = 1 } or nil,
		tag = {
			["bg-surface-0"] = not fFlagProfileRenderAvatarMoments
		}
	}, {
		Presentation = React.createElement(momentsImmersivePresentation, {
			feedKind = immersiveFeedKind.User,
			targetUserId = v6,
			initialIndex = v7,
			initialMomentId = initialMomentId,
			onBack = v8,
			sessionSource = "profile",
			openMomentsFeedReport = v12,
			openMomentCommentReport = v13,
			openBlockUser = v14
		})
	})
end

local function MomentsFeedPageLegacy()
	local v5 = useNavigation()
	local param = v5.getParam("extraProps")

	local v6 = not (param and param.targetUserId) and 0 or param.targetUserId
	local v7 = not (param and param.initialIndex) and 1 or param.initialIndex
	local initialMomentId

	if fFlagMomentsOptimisticProfilePending and param ~= nil then
		initialMomentId = param.initialMomentId
	else
		initialMomentId = nil
	end

	local v8 = React.useMemo(function()
		return CreateUserMomentsFeedSource(v6, { initialIndex = v7, initialMomentId = initialMomentId })
	end, { v6, v7, initialMomentId })

	local v9 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.ProfileClosePressed, { userId = tostring(v6) })

		v5.goBack()
	end, { v5.goBack, v6 })

	local v10 = useScreenSize()
	local v11 = useSelector(function(p2)
		return p2.GlobalGuiInset
	end)

	local v12 = useStatusBarHeight()

	return React.createElement(view, {
		Size = UDim2.fromOffset(v10.X, v10.Y),
		padding = {
			top = UDim.new(0, v11.top + v12),
			bottom = UDim.new(0, v11.bottom),
			left = UDim.new(0, v11.left),
			right = UDim.new(0, v11.right)
		},
		backgroundStyle = fFlagProfileRenderAvatarMoments and { Transparency = 1 } or nil,
		tag = {
			["bg-surface-0"] = not fFlagProfileRenderAvatarMoments
		}
	}, {
		OnVideoUI = React.createElement(foundationProvider, {
			colorMode = colorMode.Dark
		}, {
			Feed = React.createElement(feed, {
				source = v8,
				active = true,
				playbackActive = true,
				initialIndex = v7
			}),
			CloseButtonContainer = React.createElement(
				view,
				{
					tag = "position-top-left anchor-top-left auto-xy padding-large",
					ZIndex = 100000
				},
				{
					CloseButton = React.createElement(iconButton, {
						icon = "icons/navigation/close",
						size = buttonSize.Medium,
						onActivated = v9
					})
				}
			)
		})
	})
end

if fFlagEnableArgusImmersiveNav then
	return MomentsFeedPageImmersive
end

return MomentsFeedPageLegacy
