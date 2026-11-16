local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local module3 = require("@luauforge/deferred/hvH")
local momentsTabEntry = module3.MomentsTabEntry
local reportEdpVideo = module3.reportEdpVideo
local module4 = require("@luauforge/bundled/hvI")
local module5 = require("@luauforge/bundled/eed")
local module6 = require("@luauforge/bundled/dHo")
local module7 = require("@luauforge/deferred/hvW")

local setTabBarVisibleFromMoments = require("@luauforge/bundled/dwN").Thunks.SetTabBarVisibleFromMoments
local module8 = require("@luauforge/bundled/hvX")
local abuseVector = module8.Enums.AbuseVector
local openDynamicAbuseReport = module8.Thunks.OpenDynamicAbuseReport
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local module9 = require("@luauforge/deferred/hvY")

local reportMoment = require("@luauforge/deferred/hvH").reportMoment

local momentsFeed = module4.Sources.MomentsFeed
local fFlagEnableMomentsCommentReporting = SharedFlags.FFlagEnableMomentsCommentReporting
local fFlagEnableMomentsCommentBlocking = SharedFlags.FFlagEnableMomentsCommentBlocking
local fFlagAbuseReportSubmissionTargetV4 = SharedFlags.FFlagAbuseReportSubmissionTargetV4
local fFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local fFlagAXEnableUnifiedLoggingAvatarMoment = SharedFlags.FFlagAXEnableUnifiedLoggingAvatarMoment
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local fFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local fFlagAbuseReportAttributes = SharedFlags.FFlagAbuseReportAttributes

local function MomentsTabEntryContainer(p2)
	local v5 = useDispatch()
	local v6 = useSelector(function(p3)
		return p3.LocalUserId
	end)

	local v7 = React.useCallback(function(p3)
		v5(module5(tostring(p3), { source = momentsFeed }))
	end, { v5 })

	local v8 = React.useCallback(function()
		if v6 == nil then
			return
		end

		v5(module5(tostring(v6), { source = momentsFeed }))
	end, { v5, v6 })
	local v9

	if fFlagMomentsAvatarLookTryOn then
		v9 = React.useCallback(function(p3, p4)
			if fFlagAXEnableUnifiedLoggingAvatarMoment or fFlagMomentsRenderAvatarPostsInFeed then
				v5(module7(p3, p4))
			else
				v5(module7(p3))
			end
		end, { v5 })
	end

	local v10 = React.useCallback(function(data)
		if fFlagMomentsServeEDPVideos and data.isEdpVideo then
			local flag = false
			local function openEdpVideoIpReportDialog(p3)
				flag = true
				data.onClose()
				v5(closeCentralOverlay())

				if data.onEdpVideoIpReport then
					data.onEdpVideoIpReport(function()
						v5(module6(data.universeId, {
							mountAsFullView = true,
							showBackButton = true
						}))
					end)
				end

				return {}
			end

			local v13 = {
				abuseVector = abuseVector.MomentsFeed,
				targetId = 0,
				attributes = 0,
				analyticsTargetId = 0,
				onSubmit = 0,
				onClose = 0,
				clientActionHandlers = 0
			}
			local v14 = if not fFlagAbuseReportAttributes then data.feedItemId else nil
			v13.targetId = v14
			v13.attributes = fFlagAbuseReportAttributes
				and { targetId = data.feedItemId, isEdpVideo = true }
				or nil

			local v15 = if fFlagAbuseReportAttributes then data.feedItemId else nil
			v13.analyticsTargetId = v15
			function v13.onSubmit()
				if flag then
					return
				end

				data.onSubmit()
			end
			function v13.onClose()
				data.onClose()
				v5(closeCentralOverlay())
			end
			v13.clientActionHandlers = {
				["moments-edp-video"] = reportEdpVideo,
				["moments-edp-video-ip"] = openEdpVideoIpReportDialog
			}
			v5(openDynamicAbuseReport(v13))
		else
			local flag = false
			local function submitMomentsIp(p3)
				flag = true

				local function showConfirmation(p4)
					data.onClose()
					v5(closeCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(p4)
					end
				end
				return reportMoment(data.feedItemId, "IntellectualProperty"):andThen(function(p4)
					local reportCode = p4.reportCode
					data.onClose()
					v5(closeCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(reportCode)
					end

					return p4
				end, function()
					data.onClose()
					v5(closeCentralOverlay())

					if data.onIpReportCode then
						data.onIpReportCode(nil)
					end
				end)
			end

			v5(openDynamicAbuseReport({
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
					v5(closeCentralOverlay())
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
	end, { v5 })
	local v11

	if fFlagEnableMomentsCommentReporting then
		v11 = React.useCallback(function(data)
			local v12 = {
				targetId = data.commentId,
				channelId = data.channelId,
				reportedUserId = data.reportedUserId
			}

			v5(openDynamicAbuseReport({
				abuseVector = abuseVector.MomentComment,
				attributes = v12,
				analyticsTargetId = data.commentId,
				onClose = function()
					v5(closeCentralOverlay())
				end
			}))
		end, { v5 })
	end

	local v12 = if fFlagEnableMomentsCommentBlocking then module9(p2.navigation) else nil

	local v13 = React.useCallback(function()
		v5(setTabBarVisibleFromMoments(true))
	end, { v5 })

	local createElement = React.createElement
	local v15 = {
		navigation = p2.navigation,
		openProfile = v7,
		openOwnMoments = 0,
		openMomentsFeedReport = 0,
		openAvatarLookTryOn = 0,
		openMomentCommentReport = 0,
		openBlockUser = 0,
		onTabFocused = 0
	}

	if v6 == nil then
		v8 = nil
	end

	v15.openOwnMoments = v8
	v15.openMomentsFeedReport = v10

	if not fFlagMomentsAvatarLookTryOn then
		v9 = nil
	end

	v15.openAvatarLookTryOn = v9
	v15.openMomentCommentReport = v11
	v15.openBlockUser = v12
	v15.onTabFocused = v13
	return createElement(momentsTabEntry, v15)
end

local extended = React.Component:extend("MomentsTabEntryContainerScreen")

function extended.render(p2)
	return React.createElement(MomentsTabEntryContainer, p2.props)
end

extended.router = momentsTabEntry.router

return extended
