local Players = game:GetService("Players")

local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local speaker = BuilderIcons.Icon.Speaker
local speakerSlash = BuilderIcons.Icon.SpeakerSlash
local threeDotsVertical = BuilderIcons.Icon.ThreeDotsVertical

local iconButton = Foundation.IconButton
local menu = Foundation.Menu
local view = Foundation.View

local useLocalization = Localization.Hooks.useLocalization
local useToggleState = MomentsCommon.Hooks.useToggleState

local checkDebugAccess = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/checkDebugAccess")
local getPostFeedItemId = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getPostFeedItemId")
local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local reportMomentsEngagement = MomentsCommon.Analytics.reportMomentsEngagement
local eventNames = MomentsCommon.Analytics.EventNames
local reportModalCovering = MomentsCommon.Media.reportModalCovering
local makeFeedActionFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeFeedActionFields")
local makeRecommendationAttribution = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeRecommendationAttribution")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/RecommendationContentType")
local reportMoment = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Moderation/reportMoment")
local useFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext").useFeed

local useMomentsSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/MomentsSessionContext").useMomentsSession
local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")
local GetModeratedItemsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetModeratedItemsStore")
local GetToastStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore")

local SignalActionType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/SignalActionType")
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local fFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local defineFastFlag = game:DefineFastFlag("MomentsUseSmallOverflowMenu", false)
local defineFastFlag2 = game:DefineFastFlag("MomentsReportButtonAnalytics", false)
local FFlagMomentsCreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCreatorAnalytics")
local FFlagMomentsRecommendationContentType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationContentType")
local getPostInsightsPageStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/getPostInsightsPageStore")
local postInsightsStrings = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/postInsightsStrings")
local PostInsightsCoachmark = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/PostInsightsCoachmark")
local dismissPostInsightsCoachmark = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/dismissPostInsightsCoachmark")
local getFFlagMomentsCoachmarkPersistence = MomentsCommon.Flags.GetFFlagMomentsCoachmarkPersistence
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/createMomentStore")
local ReportMomentDialog = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/ReportMomentDialog")
local IpReportConfirmationDialog = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/IpReportConfirmationDialog")

local useMomentsHost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext").useMomentsHost

local localPlayer = Players.LocalPlayer

local v5 = {
	showDetails = "Feature.Moments.Action.ShowDetails",
	hideDetails = "Feature.Moments.Action.Hide",
	expand = "Feature.Moments.Action.Expand",
	minimize = "Feature.Moments.Action.Minimize",
	report = "Feature.Moments.Action.Report",
	delete = "Feature.Moments.Action.Delete",
	reportSubmittedTitle = "Feature.Moments.Label.ReportSubmittedTitle",
	reportSubmittedBody = "Feature.Moments.Label.ReportSubmittedBody"
}

return function(props)
	local v6 = useLocalization(v5)

	local v7 = not FFlagMomentsCreatorAnalytics and "" or useLocalization(postInsightsStrings.MENU_KEYS).analytics

	local v8 = useFeed()
	local v9 = fFlagMomentsServeEDPVideos and props.moment.entityType == "edpVideo"

	local openMomentsFeedReport = useMomentsHost().openMomentsFeedReport
	local v10 = useToggleState()
	local state, setState = React.useState(false)
	local state2 = nil
	local v11 = nil
	local v12, v13, v14

	if fFlagMomentsServeEDPVideos then
		local setState2
		state2, setState2 = React.useState(false)
		v11 = setState2

		local ref = React.useRef(nil)

		v12 = React.useCallback(function(current)
			ref.current = current
			v11(true)
		end, {})

		v13 = React.useCallback(function()
			ref.current = nil
			v11(false)
		end, {})

		v14 = React.useCallback(function()
			local current = ref.current
			v13()

			if current then
				current()
			end
		end, { v13 })
	else
		v12 = nil
		v13 = nil
	end

	local state3, setState2 = React.useState(false)
	local state4, setState3 = React.useState("------")

	local v15 = React.useCallback(function()
		if v10.enabled then
			v10.disable()
		else
			v10.enable()
		end
	end, { v10.enabled, v10.enable, v10.disable })

	local v16 = useMomentsSession()
	local v17 = GetMomentsPreferencesStore(false)
	local v18 = GetModeratedItemsStore(false)
	local v19 = GetToastStore(false)

	local v20 = SignalsReact.useSignalState(v16.getHideDetails)
	local v21 = SignalsReact.useSignalState(v17.getMinimized)

	local v22 = React.useCallback(function()
		v10.disable()
		v16.toggleFeedDetailVisibility()
		fireAnalyticsEvent(eventNames.FeedHideDetailsButtonPressed, {
			momentId = props.moment.momentId
		})
	end, { props.moment, v10.disable, v16.toggleFeedDetailVisibility })

	local v23 = React.useCallback(function()
		v10.disable()
		v17.toggleFeedScaleType()
		fireAnalyticsEvent(eventNames.FeedMinimizeButtonPressed, {
			momentId = props.moment.momentId
		})
	end, { props.moment, v10.disable, v17.toggleFeedScaleType })

	local v24 = React.useCallback(function()
		if checkDebugAccess() then
			v17.toggleFeedDebugMode()
		end

		v10.disable()
	end, { v10.disable, v17.toggleFeedDebugMode })

	local v25 = React.useCallback(function(p2, p3, p4)
		if not props.moment then
			return nil
		end

		local success, result, v26

		if p4 then
			success = true
			result = true
		else
			success, result, v26 = pcall(function()
				return reportMoment(props.moment.recommendationMetadata.feedItemId, p2):await()
			end)
		end

		local recommendationMetadata = props.moment.recommendationMetadata

		local v29 = if FFlagMomentsRecommendationContentType then props.contentType else nil
		local v30 = makeRecommendationAttribution(recommendationMetadata, nil, v29)

		if v30 then
			local success2, result2 = pcall(function()
				v8.logAction(SignalActionType.Report, v30, {})
			end)

			if not success2 then
				warn("Failed to log action event", result2)
			end
		end

		local v31 = makeFeedActionFields(
			props.moment.momentId,
			recommendationMetadata and recommendationMetadata.feedItemId,
			recommendationMetadata and recommendationMetadata.tracingId,
			"report"
		)

		if v31 then
			fireAnalyticsEvent(eventNames.FeedAbuseReported, v31)
		end

		if not p3 then
			v18.markReported(props.moment.momentId)
			v8.removeCurrentItem()

			v19.triggerToast({
				title = v6.reportSubmittedTitle,
				text = v6.reportSubmittedBody
			})
		end

		if success and result and type(v26) == "table" then
			return v26.reportCode
		end

		return nil
	end, {
		props.moment,
		v8.logAction,
		v8.removeCurrentItem,
		v18.markReported,
		v19.triggerToast,
		v6
	})

	local useCallback = React.useCallback
	local function fn()
		v10.disable()

		if defineFastFlag2 then
			reportMomentsEngagement("report_click")
		end

		local v26 = getPostFeedItemId(props.moment)

		if fFlagMomentsServeEDPVideos and v9 then
			v26 = props.moment.recommendationMetadata.feedItemId
		end

		if v26 and openMomentsFeedReport then
			reportModalCovering.setCovering(true)
			openMomentsFeedReport({
				feedItemId = v26,
				momentId = props.moment.momentId,
				universeId = fFlagMomentsServeEDPVideos and (props.moment.metadata.universeId or 0) or nil,
				onSubmit = function()
					v25(nil, false, true)
				end,
				onClose = function()
					reportModalCovering.setCovering(false)
				end,
				onIpReportCode = function(p2)
					v25(nil, true, true)
					setState3((not p2 or p2 == "") and "------" or p2)
					setState2(true)
				end,
				isEdpVideo = if fFlagMomentsServeEDPVideos then v9 else nil,
				onEdpVideoIpReport = if fFlagMomentsServeEDPVideos then v12 else nil
			})
		else
			if fFlagMomentsServeEDPVideos and v9 then
				return
			end

			setState(true)
		end
	end

	local disable = v10.disable
	local v27 = if fFlagMomentsServeEDPVideos then v12 else nil
	local v29 = useCallback(fn, {
		disable,
		v25,
		openMomentsFeedReport,
		v27,
		props.moment,
		if fFlagMomentsServeEDPVideos then v9 else false
	})

	local v30 = React.useCallback(function()
		setState(false)
	end, {})

	local v31 = React.useCallback(function()
		if setState2 then
			setState2(false)
		end
	end, {})

	local v32 = React.useCallback(function()
		v10.disable()

		local requestDeletion = v16.requestDeletion
		local momentId = props.moment.momentId
		local feedItemId = props.moment.recommendationMetadata
			and props.moment.recommendationMetadata.feedItemId
		local v33 = if props.moment.recommendationMetadata then props.moment.recommendationMetadata.tracingId else nil
		requestDeletion(momentId, feedItemId, v33)
	end, { props.moment, v10.disable, v16.requestDeletion })
	local v33

	if FFlagMomentsCreatorAnalytics then
		v33 = React.useCallback(function()
			v10.disable()

			if getFFlagMomentsCoachmarkPersistence() then
				dismissPostInsightsCoachmark()
			end

			if props.momentStore ~= nil then
				getPostInsightsPageStore(false).open({
					moment = props.moment,
					momentStore = props.momentStore
				})
			end
		end, { props.moment, props.momentStore or false, v10.disable })
	else
		v33 = nil
	end

	local v34 = React.useCallback(function()
		if props.isDisabled then
			return
		end

		props.playbackVolume.toggle()
	end, { props.isDisabled, props.playbackVolume })

	local v35 = React.useCallback(function()
		if props.isDisabled then
			return
		end

		local v37 = if props.playbackVolume.isMuted then eventNames.FeedUnmuteButtonPressed else eventNames.FeedMuteButtonPressed
		fireAnalyticsEvent(v37, { momentId = props.moment.momentId })

		props.playbackVolume.toggle()
	end, { props.isDisabled, props.playbackVolume, props.moment })

	if props.isFeedMuteButtonAnalyticsEnabled then
		v34 = v35
	end

	local useMemo = React.useMemo
	local function fn2()
		local v37 = {
			id = "details",
			icon = v20 and "icons/actions/viewOn" or "icons/actions/viewOff",
			text = 0,
			onActivated = 0
		}

		local v38 = if v20 then v6.showDetails else v6.hideDetails
		v37.text = v38
		v37.onActivated = v22

		local v39 = {
			id = "minimize",
			icon = v21 and "icons/actions/previewExpand" or "icons/actions/previewShrink",
			text = 0,
			onActivated = 0
		}

		local v40 = if v21 then v6.expand else v6.minimize
		v39.text = v40
		v39.onActivated = v23
		local v36 = { v37, v39 }
		local v41

		if
			props.moment.recommendationMetadata == nil
			or props.moment.recommendationMetadata.feedItemId == nil
		then
			v41 = false
		else
			v41 = props.moment.recommendationMetadata.feedItemId ~= ""
		end

		if fFlagMomentsServeEDPVideos and v9 then
			table.insert(v36, {
				id = "reportAbuse",
				icon = Foundation.Enums.IconName.Flag,
				text = v6.report,
				onActivated = v29
			})
		else
			local creatorId = props.moment.creatorId
			local v42 = if localPlayer then localPlayer.UserId else nil

			if creatorId == v42 or not v41 then
				if
					v41
					and (not fFlagMomentsOptimisticProfilePending or props.moment.status ~= "Pending")
				then
					table.insert(v36, {
						id = "delete",
						icon = "icons/actions/delete",
						text = v6.delete,
						onActivated = v32
					})
				end
			else
				table.insert(v36, {
					id = "reportAbuse",
					icon = Foundation.Enums.IconName.Flag,
					text = v6.report,
					onActivated = v29
				})
			end
		end

		if FFlagMomentsCreatorAnalytics and props.momentStore ~= nil then
			local creatorId = props.moment.creatorId
			local v42 = if localPlayer then localPlayer.UserId else nil

			if creatorId == v42 then
				table.insert(v36, {
					id = "postInsights",
					icon = Foundation.Enums.IconName.ChartThreeVerticalBars,
					text = v7,
					onActivated = v33
				})
			end
		end

		if checkDebugAccess() then
			table.insert(v36, {
				id = "debug",
				icon = "icons/logo/block",
				text = "Toggle Debug Mode",
				onActivated = v24
			})
		end

		return v36
	end

	local moment2 = props.moment
	local v37 = if fFlagMomentsServeEDPVideos then v9 else false
	local v38 = if FFlagMomentsCreatorAnalytics then props.momentStore or false else false
	local v39 = if FFlagMomentsCreatorAnalytics then v33 or false else false
	local v41 = useMemo(fn2, {
		moment2,
		v20,
		v21,
		v6,
		v24,
		v22,
		v23,
		v29,
		v32,
		v37,
		v38,
		v39,
		if FFlagMomentsCreatorAnalytics then v7 else false
	})

	local createElement = React.createElement
	local v43 = {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = v10.enabled,
		items = v41,
		onPressedOutside = v10.disable,
		side = Foundation.Enums.PopoverSide.Left,
		size = 0
	}
	local v44 = if defineFastFlag then Foundation.Enums.InputSize.Small else nil
	v43.size = v44
	local element = createElement(menu, v43, {
		ContextualMenuButton = React.createElement(iconButton, {
			icon = threeDotsVertical,
			isDisabled = props.isDisabled,
			onActivated = v15,
			size = Foundation.Enums.InputSize.Large,
			testId = "FeedContextualMenuButton"
		})
	})

	if FFlagMomentsCreatorAnalytics and getFFlagMomentsCoachmarkPersistence() and props.momentStore ~= nil then
		local creatorId = props.moment.creatorId
		local v45 = if localPlayer then localPlayer.UserId else nil

		if creatorId == v45 then
			element = React.createElement(
				PostInsightsCoachmark,
				{
					moment = props.moment,
					momentStore = props.momentStore,
					isDisabled = props.isDisabled,
					isMenuOpen = v10.enabled
				},
				element
			)
		end
	end

	local element2 = React.createElement(ReportMomentDialog, {
		isOpen = state,
		onClose = v30,
		onSubmitReport = v25
	})
	local v45

	if state3 then
		v45 = React.createElement(IpReportConfirmationDialog, { reportCode = state4, onClose = v31 })
	end

	local v46

	if fFlagMomentsServeEDPVideos and state2 then
		v46 = React.createElement(require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/EdpVideoIpReportDialog"), {
			onCancel = v13,
			onContinue = v14
		})
	end

	if props.isFeedMuteEnabled then
		local createElement2 = React.createElement
		local v48 = {
			LayoutOrder = props.layoutOrder,
			tag = "col align-x-right auto-xy"
		}

		local createElement3 = React.createElement

		local createElement4 = React.createElement
		local v55 = if props.playbackVolume.isMuted then speakerSlash else speaker
		local v49 = {
			MuteAndMenuRow = createElement3(
				view,
				{
					LayoutOrder = 1,
					tag = "row align-x-right align-y-center gap-xsmall auto-xy"
				},
				{
					FeedMuteButton = createElement4(iconButton, {
						icon = v55,
						isDisabled = props.isDisabled,
						onActivated = v34,
						size = Foundation.Enums.InputSize.Medium,
						testId = "FeedMuteButton"
					}),
					ContextMenuPopover = element
				}
			),
			ReportDialog = element2,
			IpConfirmationDialog = v45,
			EdpVideoIpReportDialog = 0
		}

		if not fFlagMomentsServeEDPVideos then
			v46 = nil
		end

		v49.EdpVideoIpReportDialog = v46
		return createElement2(view, v48, v49)
	else
		local createElement2 = React.createElement
		local v48 = {
			LayoutOrder = props.layoutOrder,
			tag = "col align-x-center auto-xy"
		}

		if not fFlagMomentsServeEDPVideos then
			v46 = nil
		end

		return createElement2(view, v48, {
			ContextMenuPopover = element,
			ReportDialog = element2,
			IpConfirmationDialog = v45,
			EdpVideoIpReportDialog = v46
		})
	end
end
