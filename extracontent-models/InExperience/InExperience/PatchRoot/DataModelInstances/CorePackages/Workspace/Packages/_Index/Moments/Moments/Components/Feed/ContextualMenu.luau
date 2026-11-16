local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Players = game:GetService("Players")

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local SignalsReact = require(parent.SignalsReact)
local Speaker = BuilderIcons.Icon.Speaker
local SpeakerSlash = BuilderIcons.Icon.SpeakerSlash
local ThreeDotsVertical = BuilderIcons.Icon.ThreeDotsVertical

local IconButton = Foundation.IconButton
local Menu = Foundation.Menu
local View = Foundation.View

local useLocalization = Localization.Hooks.useLocalization
local useToggleState = MomentsCommon.Hooks.useToggleState

local checkDebugAccess = require(Moments.Utils.checkDebugAccess)
local getPostFeedItemId = require(Moments.Utils.getPostFeedItemId)
local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local reportMomentsEngagement = MomentsCommon.Analytics.reportMomentsEngagement
local EventNames = MomentsCommon.Analytics.EventNames
local reportModalCovering = MomentsCommon.Media.reportModalCovering
local makeFeedActionFields = require(Moments.Analytics.makeFeedActionFields)
local makeRecommendationAttribution = require(Moments.Analytics.makeRecommendationAttribution)
require(Moments.Analytics.RecommendationContentType)
local reportMoment = require(Moments.Moderation.reportMoment)
local FeedContext = require(Moments.Components.Feed.FeedContext)
local useFeed = FeedContext.useFeed

local MomentsSessionContext = require(Moments.Stores.GetMomentsStore.MomentsSessionContext)
local useMomentsSession = MomentsSessionContext.useMomentsSession
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local GetModeratedItemsStore = require(Moments.Stores.GetModeratedItemsStore)
local GetToastStore = require(Moments.Stores.GetToastStore)

local SignalActionType = require(Moments.Enums.SignalActionType)
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local defineFastFlag = game:DefineFastFlag("MomentsUseSmallOverflowMenu", false)
local defineFastFlag2 = game:DefineFastFlag("MomentsReportButtonAnalytics", false)
local FFlagMomentsCreatorAnalytics = require(Moments.Flags.FFlagMomentsCreatorAnalytics)
local FFlagMomentsRecommendationContentType = require(Moments.Flags.FFlagMomentsRecommendationContentType)
local getPostInsightsPageStore = require(Moments.Components.PostInsights.getPostInsightsPageStore)
local postInsightsStrings = require(Moments.Components.PostInsights.postInsightsStrings)
local PostInsightsCoachmark = require(Moments.Components.PostInsights.PostInsightsCoachmark)
local dismissPostInsightsCoachmark = require(Moments.Components.PostInsights.dismissPostInsightsCoachmark)
local GetFFlagMomentsCoachmarkPersistence = MomentsCommon.Flags.GetFFlagMomentsCoachmarkPersistence
require(Moments.Components.Feed.Items.Moment.createMomentStore)
local ReportMomentDialog = require(Moments.Components.Feed.ReportMomentDialog)
local IpReportConfirmationDialog = require(Moments.Components.Feed.IpReportConfirmationDialog)

local MomentsHostContext = require(Moments.MomentsHostContext)
local useMomentsHost = MomentsHostContext.useMomentsHost

local LocalPlayer = Players.LocalPlayer

local v = {
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
	local v2 = useLocalization(v)

	local text = not FFlagMomentsCreatorAnalytics and "" or useLocalization(postInsightsStrings.MENU_KEYS).analytics

	local v3 = useFeed()
	local v4 = FFlagMomentsServeEDPVideos and props.moment.entityType == "edpVideo"

	local openMomentsFeedReport = useMomentsHost().openMomentsFeedReport
	local v5 = useToggleState()
	local state, setState = React.useState(false)
	local state2 = nil
	local v6 = nil
	local v7, onCancel, onContinue

	if FFlagMomentsServeEDPVideos then
		local setState2
		state2, setState2 = React.useState(false)
		v6 = setState2

		local ref = React.useRef(nil)

		v7 = React.useCallback(function(current)
			ref.current = current
			v6(true)
		end, {})

		onCancel = React.useCallback(function()
			ref.current = nil
			v6(false)
		end, {})

		onContinue = React.useCallback(function()
			local current = ref.current
			onCancel()

			if current then
				current()
			end
		end, { onCancel })
	else
		v7 = nil
		onCancel = nil
	end

	local state3, setState2 = React.useState(false)
	local state4, setState3 = React.useState("------")

	local onActivated = React.useCallback(function()
		if v5.enabled then
			v5.disable()
		else
			v5.enable()
		end
	end, { v5.enabled, v5.enable, v5.disable })

	local v8 = useMomentsSession()
	local momentsPreferencesStore = GetMomentsPreferencesStore(false)
	local moderatedItemsStore = GetModeratedItemsStore(false)
	local toastStore = GetToastStore(false)

	local v9 = SignalsReact.useSignalState(v8.getHideDetails)
	local v10 = SignalsReact.useSignalState(momentsPreferencesStore.getMinimized)

	local onActivated2 = React.useCallback(function()
		v5.disable()
		v8.toggleFeedDetailVisibility()
		fireAnalyticsEvent(EventNames.FeedHideDetailsButtonPressed, {
			momentId = props.moment.momentId
		})
	end, { props.moment, v5.disable, v8.toggleFeedDetailVisibility })

	local onActivated3 = React.useCallback(function()
		v5.disable()
		momentsPreferencesStore.toggleFeedScaleType()
		fireAnalyticsEvent(EventNames.FeedMinimizeButtonPressed, {
			momentId = props.moment.momentId
		})
	end, { props.moment, v5.disable, momentsPreferencesStore.toggleFeedScaleType })

	local onActivated4 = React.useCallback(function()
		if checkDebugAccess() then
			momentsPreferencesStore.toggleFeedDebugMode()
		end

		v5.disable()
	end, { v5.disable, momentsPreferencesStore.toggleFeedDebugMode })

	local onSubmitReport = React.useCallback(function(p: string?, flag: boolean?, flag2: boolean?)
		if not props.moment then
			return nil
		end

		local success, result, v11

		if flag2 then
			success = true
			result = true
		else
			success, result, v11 = pcall(function()
				return reportMoment(props.moment.recommendationMetadata.feedItemId, p):await()
			end)
		end

		local recommendationMetadata = props.moment.recommendationMetadata
		local v12

		if FFlagMomentsRecommendationContentType then
			v12 = props.contentType
		end

		local recommendationAttribution = makeRecommendationAttribution(recommendationMetadata, nil, v12)

		if recommendationAttribution then
			local success2, result2 = pcall(function()
				v3.logAction(SignalActionType.Report, recommendationAttribution, {})
			end)

			if not success2 then
				warn("Failed to log action event", result2)
			end
		end

		local feedActionFields = makeFeedActionFields(
			props.moment.momentId,
			recommendationMetadata and recommendationMetadata.feedItemId,
			recommendationMetadata and recommendationMetadata.tracingId,
			"report"
		)

		if feedActionFields then
			fireAnalyticsEvent(EventNames.FeedAbuseReported, feedActionFields)
		end

		if not flag then
			moderatedItemsStore.markReported(props.moment.momentId)
			v3.removeCurrentItem()

			toastStore.triggerToast({
				title = v2.reportSubmittedTitle,
				text = v2.reportSubmittedBody
			})
		end

		if success and result and type(v11) == "table" then
			return v11.reportCode
		end

		return nil
	end, {
		props.moment,
		v3.logAction,
		v3.removeCurrentItem,
		moderatedItemsStore.markReported,
		toastStore.triggerToast,
		v2
	})

	local useCallback = React.useCallback
	local function fn()
		v5.disable()

		if defineFastFlag2 then
			reportMomentsEngagement("report_click")
		end

		local feedItemId = getPostFeedItemId(props.moment)

		if FFlagMomentsServeEDPVideos and v4 then
			feedItemId = props.moment.recommendationMetadata.feedItemId
		end

		if feedItemId and openMomentsFeedReport then
			reportModalCovering.setCovering(true)
			local v11 = {
				feedItemId = feedItemId,
				momentId = props.moment.momentId,
				universeId = FFlagMomentsServeEDPVideos and (props.moment.metadata.universeId or 0) or nil,
				onSubmit = function()
					onSubmitReport(nil, false, true)
				end,
				onClose = function()
					reportModalCovering.setCovering(false)
				end,
				onIpReportCode = function(p)
					onSubmitReport(nil, true, true)
					setState3((not p or p == "") and "------" or p)
					setState2(true)
				end,
				isEdpVideo = 0,
				onEdpVideoIpReport = 0
			}
			local isEdpVideo

			if FFlagMomentsServeEDPVideos then
				isEdpVideo = v4
			end

			v11.isEdpVideo = isEdpVideo
			local onEdpVideoIpReport

			if FFlagMomentsServeEDPVideos then
				onEdpVideoIpReport = v7
			end

			v11.onEdpVideoIpReport = onEdpVideoIpReport
			openMomentsFeedReport(v11)
		else
			if FFlagMomentsServeEDPVideos and v4 then
				return
			end

			setState(true)
		end
	end

	local disable = v5.disable
	local v11

	if FFlagMomentsServeEDPVideos then
		v11 = v7
	end

	local moment = props.moment
	local v12 = if FFlagMomentsServeEDPVideos then v4 else false
	local onActivated5 = useCallback(fn, {
		disable,
		onSubmitReport,
		openMomentsFeedReport,
		v11,
		moment,
		v12
	})

	local onClose = React.useCallback(function()
		setState(false)
	end, {})

	local onClose2 = React.useCallback(function()
		if setState2 then
			setState2(false)
		end
	end, {})

	local onActivated6 = React.useCallback(function()
		v5.disable()

		local requestDeletion = v8.requestDeletion
		local momentId = props.moment.momentId
		local feedItemId = props.moment.recommendationMetadata and props.moment.recommendationMetadata.feedItemId
		local v13

		if props.moment.recommendationMetadata then
			v13 = props.moment.recommendationMetadata.tracingId
		end

		requestDeletion(momentId, feedItemId, v13)
	end, { props.moment, v5.disable, v8.requestDeletion })
	local onActivated7

	if FFlagMomentsCreatorAnalytics then
		onActivated7 = React.useCallback(function()
			v5.disable()

			if GetFFlagMomentsCoachmarkPersistence() then
				dismissPostInsightsCoachmark()
			end

			if props.momentStore ~= nil then
				getPostInsightsPageStore(false).open({
					moment = props.moment,
					momentStore = props.momentStore
				})
			end
		end, { props.moment, props.momentStore or false, v5.disable })
	else
		onActivated7 = nil
	end

	local onActivated8 = React.useCallback(function()
		if props.isDisabled then
			return
		end

		props.playbackVolume.toggle()
	end, { props.isDisabled, props.playbackVolume })

	local v13 = React.useCallback(function()
		if props.isDisabled then
			return
		end

		local v13

		if props.playbackVolume.isMuted then
			v13 = EventNames.FeedUnmuteButtonPressed
		else
			v13 = EventNames.FeedMuteButtonPressed
		end

		fireAnalyticsEvent(v13, { momentId = props.moment.momentId })

		props.playbackVolume.toggle()
	end, { props.isDisabled, props.playbackVolume, props.moment })

	if props.isFeedMuteButtonAnalyticsEnabled then
		onActivated8 = v13
	end

	local useMemo = React.useMemo
	local function fn2()
		local v14 = {
			id = "details",
			icon = v9 and "icons/actions/viewOn" or "icons/actions/viewOff",
			text = 0,
			onActivated = 0
		}

		local text2 = if v9 then v2.showDetails else v2.hideDetails
		v14.text = text2
		v14.onActivated = onActivated2

		local v15 = {
			id = "minimize",
			icon = v10 and "icons/actions/previewExpand" or "icons/actions/previewShrink",
			text = 0,
			onActivated = 0
		}

		local text3 = if v10 then v2.expand else v2.minimize
		v15.text = text3
		v15.onActivated = onActivated3
		local v16 = { v14, v15 }
		local v17

		if props.moment.recommendationMetadata == nil or props.moment.recommendationMetadata.feedItemId == nil then
			v17 = false
		else
			v17 = props.moment.recommendationMetadata.feedItemId ~= ""
		end

		if FFlagMomentsServeEDPVideos and v4 then
			table.insert(v16, {
				id = "reportAbuse",
				icon = Foundation.Enums.IconName.Flag,
				text = v2.report,
				onActivated = onActivated5
			})
		else
			local creatorId = props.moment.creatorId
			local v18

			if LocalPlayer then
				v18 = LocalPlayer.UserId
			end

			if creatorId == v18 or not v17 then
				if v17 and (not FFlagMomentsOptimisticProfilePending or props.moment.status ~= "Pending") then
					table.insert(v16, {
						id = "delete",
						icon = "icons/actions/delete",
						text = v2.delete,
						onActivated = onActivated6
					})
				end
			else
				table.insert(v16, {
					id = "reportAbuse",
					icon = Foundation.Enums.IconName.Flag,
					text = v2.report,
					onActivated = onActivated5
				})
			end
		end

		if FFlagMomentsCreatorAnalytics and props.momentStore ~= nil then
			local creatorId = props.moment.creatorId
			local v18

			if LocalPlayer then
				v18 = LocalPlayer.UserId
			end

			if creatorId == v18 then
				table.insert(v16, {
					id = "postInsights",
					icon = Foundation.Enums.IconName.ChartThreeVerticalBars,
					text = text,
					onActivated = onActivated7
				})
			end
		end

		if checkDebugAccess() then
			table.insert(v16, {
				id = "debug",
				icon = "icons/logo/block",
				text = "Toggle Debug Mode",
				onActivated = onActivated4
			})
		end

		return v16
	end

	local moment2 = props.moment
	local v14 = if FFlagMomentsServeEDPVideos then v4 else false
	local v15

	if FFlagMomentsCreatorAnalytics then
		v15 = props.momentStore or false
	else
		v15 = false
	end

	local v16

	if FFlagMomentsCreatorAnalytics then
		v16 = onActivated7 or false
	else
		v16 = false
	end

	local v17 = if FFlagMomentsCreatorAnalytics then text else false
	local items = useMemo(fn2, {
		moment2,
		v9,
		v10,
		v2,
		onActivated4,
		onActivated2,
		onActivated3,
		onActivated5,
		onActivated6,
		v14,
		v15,
		v16,
		v17
	})

	local createElement = React.createElement
	local v18 = {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = v5.enabled,
		items = items,
		onPressedOutside = v5.disable,
		side = Foundation.Enums.PopoverSide.Left,
		size = 0
	}
	local size

	if defineFastFlag then
		size = Foundation.Enums.InputSize.Small
	end

	v18.size = size
	local element = createElement(Menu, v18, {
		ContextualMenuButton = React.createElement(IconButton, {
			icon = ThreeDotsVertical,
			isDisabled = props.isDisabled,
			onActivated = onActivated,
			size = Foundation.Enums.InputSize.Large,
			testId = "FeedContextualMenuButton"
		})
	})

	if FFlagMomentsCreatorAnalytics and GetFFlagMomentsCoachmarkPersistence() and props.momentStore ~= nil then
		local creatorId = props.moment.creatorId
		local v19

		if LocalPlayer then
			v19 = LocalPlayer.UserId
		end

		if creatorId == v19 then
			element = React.createElement(
				PostInsightsCoachmark,
				{
					moment = props.moment,
					momentStore = props.momentStore,
					isDisabled = props.isDisabled,
					isMenuOpen = v5.enabled
				},
				element
			)
		end
	end

	local element2 = React.createElement(ReportMomentDialog, {
		isOpen = state,
		onClose = onClose,
		onSubmitReport = onSubmitReport
	})
	local ipConfirmationDialog

	if state3 then
		ipConfirmationDialog = React.createElement(IpReportConfirmationDialog, {
			reportCode = state4,
			onClose = onClose2
		})
	end

	local edpVideoIpReportDialog

	if FFlagMomentsServeEDPVideos and state2 then
		local createElement2 = React.createElement
		local EdpVideoIpReportDialog = require(Moments.Components.Feed.EdpVideoIpReportDialog)
		edpVideoIpReportDialog = createElement2(EdpVideoIpReportDialog, {
			onCancel = onCancel,
			onContinue = onContinue
		})
	end

	if props.isFeedMuteEnabled then
		local createElement2 = React.createElement
		local v19 = { LayoutOrder = props.layoutOrder, tag = "col align-x-right auto-xy" }

		local createElement3 = React.createElement

		local createElement4 = React.createElement
		local icon

		if props.playbackVolume.isMuted then
			icon = SpeakerSlash
		else
			icon = Speaker
		end

		local v20 = {
			MuteAndMenuRow = createElement3(
				View,
				{ LayoutOrder = 1, tag = "row align-x-right align-y-center gap-xsmall auto-xy" },
				{
					FeedMuteButton = createElement4(IconButton, {
						icon = icon,
						isDisabled = props.isDisabled,
						onActivated = onActivated8,
						size = Foundation.Enums.InputSize.Medium,
						testId = "FeedMuteButton"
					}),
					ContextMenuPopover = element
				}
			),
			ReportDialog = element2,
			IpConfirmationDialog = ipConfirmationDialog,
			EdpVideoIpReportDialog = 0
		}

		if not FFlagMomentsServeEDPVideos then
			edpVideoIpReportDialog = nil
		end

		v20.EdpVideoIpReportDialog = edpVideoIpReportDialog
		return createElement2(View, v19, v20)
	else
		local createElement2 = React.createElement
		local v19 = { LayoutOrder = props.layoutOrder, tag = "col align-x-center auto-xy" }

		if not FFlagMomentsServeEDPVideos then
			edpVideoIpReportDialog = nil
		end

		return createElement2(View, v19, {
			ContextMenuPopover = element,
			ReportDialog = element2,
			IpConfirmationDialog = ipConfirmationDialog,
			EdpVideoIpReportDialog = edpVideoIpReportDialog
		})
	end
end
