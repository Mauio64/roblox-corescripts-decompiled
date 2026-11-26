local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXAvatarMomentsCreation = AvatarExperienceFlags.FFlagAXAvatarMomentsCreation
local fFlagAXPhotoboothMomentsPage = AvatarExperienceFlags.FFlagAXPhotoboothMomentsPage
local v5 = fFlagAXAvatarMomentsCreation and fFlagAXPhotoboothMomentsPage
local module4 = require("@luauforge/deferred/hGN")
local momentsTabEntry = module4.MomentsTabEntry
local reportEdpVideo = module4.reportEdpVideo
local module5 = require("@luauforge/bundled/hGO")
local module6 = require("@luauforge/bundled/ehA")
local module7 = require("@luauforge/bundled/dKt")
local module8 = require("@luauforge/deferred/hHc")

local setTabBarVisibleFromMoments = require("@luauforge/bundled/dzQ").Thunks.SetTabBarVisibleFromMoments
local module9 = require("@luauforge/bundled/hHd")
local abuseVector = module9.Enums.AbuseVector
local openDynamicAbuseReport = module9.Thunks.OpenDynamicAbuseReport
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local module10 = require("@luauforge/deferred/hHe")
local module11 = require("@luauforge/bundled/dXk")

local reportMoment = require("@luauforge/deferred/hGN").reportMoment

local momentsFeed = module5.Sources.MomentsFeed
local fFlagEnableMomentsCommentReporting = SharedFlags.FFlagEnableMomentsCommentReporting
local fFlagEnableMomentsCommentBlocking = SharedFlags.FFlagEnableMomentsCommentBlocking
local fFlagAbuseReportSubmissionTargetV4 = SharedFlags.FFlagAbuseReportSubmissionTargetV4
local fFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local fFlagAXEnableUnifiedLoggingAvatarMoment = SharedFlags.FFlagAXEnableUnifiedLoggingAvatarMoment
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local fFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local fFlagAbuseReportAttributes = SharedFlags.FFlagAbuseReportAttributes

local function MomentsTabEntryContainer(p2)
	local v6 = useDispatch()
	local v7 = useSelector(function(p3)
		return p3.LocalUserId
	end)

	local v8 = if v5 then useSignalState(module11(false).getCanCreateAvatarMoments) else false

	local v9 = React.useCallback(function(p3)
		v6(module6(tostring(p3), { source = momentsFeed }))
	end, { v6 })

	local v10 = React.useCallback(function()
		if v7 == nil then
			return
		end

		v6(module6(tostring(v7), { source = momentsFeed }))
	end, { v6, v7 })
	local v11

	if v5 then
		v11 = React.useCallback(function()
			local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

			v6(require("@luauforge/bundled/gOQ")(AvatarExperienceNavigation.Enums.AvatarScreen.PhotoboothMomentsPage))
		end, { v6 })
	end

	local v12

	if fFlagMomentsAvatarLookTryOn then
		v12 = React.useCallback(function(p3, p4)
			if fFlagAXEnableUnifiedLoggingAvatarMoment or fFlagMomentsRenderAvatarPostsInFeed then
				v6(module8(p3, p4))
			else
				v6(module8(p3))
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
						v6(module7(data.universeId, {
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

	local v15 = if fFlagEnableMomentsCommentBlocking then module10(p2.navigation) else nil

	local v16 = React.useCallback(function()
		v6(setTabBarVisibleFromMoments(true))
	end, { v6 })

	local createElement = React.createElement
	local v18 = {
		navigation = p2.navigation,
		openProfile = v9,
		openOwnMoments = 0,
		openAvatarMomentsCreation = 0,
		openMomentsFeedReport = 0,
		openAvatarLookTryOn = 0,
		openMomentCommentReport = 0,
		openBlockUser = 0,
		onTabFocused = 0
	}

	if v7 == nil then
		v10 = nil
	end

	v18.openOwnMoments = v10

	if not (v5 and v8) then
		v11 = nil
	end

	v18.openAvatarMomentsCreation = v11

	v18.openMomentsFeedReport = v13

	if not fFlagMomentsAvatarLookTryOn then
		v12 = nil
	end

	v18.openAvatarLookTryOn = v12
	v18.openMomentCommentReport = v14
	v18.openBlockUser = v15
	v18.onTabFocused = v16
	return createElement(momentsTabEntry, v18)
end

local extended = React.Component:extend("MomentsTabEntryContainerScreen")

function extended.render(p2)
	return React.createElement(MomentsTabEntryContainer, p2.props)
end

extended.router = momentsTabEntry.router

return extended
