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
local RecommendationSource = MomentsCommon.Analytics.RecommendationSource
local reportModalCovering = MomentsCommon.Media.reportModalCovering
local accountSettingsCovering = require(Moments.Components.Feed.accountSettingsCovering)
local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
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

local FFlagMomentsPersonalizedRecommendationsEntryPoint = require(Moments.Flags.FFlagMomentsPersonalizedRecommendationsEntryPoint)
local FFlagMomentsCreatorAnalytics = require(Moments.Flags.FFlagMomentsCreatorAnalytics)
local FFlagMomentsRecommendationContentType = require(Moments.Flags.FFlagMomentsRecommendationContentType)
local getPostInsightsPageStore = require(Moments.Components.PostInsights.getPostInsightsPageStore)
local postInsightsStrings = require(Moments.Components.PostInsights.postInsightsStrings)
local PostInsightsCoachmark = require(Moments.Components.PostInsights.PostInsightsCoachmark)
local dismissPostInsightsCoachmark = require(Moments.Components.PostInsights.dismissPostInsightsCoachmark)
local FFlagMomentsOverflowButtonAnalytics = require(Moments.Flags.FFlagMomentsOverflowButtonAnalytics)
local GetFFlagMomentsCoachmarkPersistence = MomentsCommon.Flags.GetFFlagMomentsCoachmarkPersistence
require(Moments.Components.Feed.Items.Moment.createMomentStore)
local ReportMomentDialog = require(Moments.Components.Feed.ReportMomentDialog)
local IpReportConfirmationDialog = require(Moments.Components.Feed.IpReportConfirmationDialog)

local MomentsHostContext = require(Moments.MomentsHostContext)
local useMomentsHost = MomentsHostContext.useMomentsHost

local LocalPlayer = Players.LocalPlayer

local function isOwnMoment(moment): boolean -- 2 equivalent calls inferred from this helper
	local creatorId = moment.creatorId
	local v

	if LocalPlayer then
		v = LocalPlayer.UserId
	end

	return creatorId == v
end

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

local frozen = table.freeze({
	label = "Feature.AccountSettings.Heading.Tab.PersonalizedRecommendations"
})

return function(props)
	local v2 = useLocalization(v)

	local text = not FFlagMomentsCreatorAnalytics and "" or useLocalization(postInsightsStrings.MENU_KEYS).analytics

	local text2 = not FFlagMomentsPersonalizedRecommendationsEntryPoint and "" or useLocalization(frozen).label

	local v3 = useFeed()
	local v4

	if FFlagMomentsPersonalizedRecommendationsEntryPoint then
		v4 = SignalsReact.useSignalState(GetMomentsCapabilities(false).getCanShowPersonalizedRecommendationsEntryPoint)
	else
		v4 = false
	end

	local v5 = FFlagMomentsServeEDPVideos and props.moment.entityType == "edpVideo"

	local openMomentsFeedReport = useMomentsHost().openMomentsFeedReport
	local v6 = useToggleState()
	local state, setState = React.useState(false)
	local state2 = nil
	local v7 = nil
	local v8, onCancel, onContinue

	if FFlagMomentsServeEDPVideos then
		local setState2
		state2, setState2 = React.useState(false)
		v7 = setState2

		local ref = React.useRef(nil)

		v8 = React.useCallback(function(current)
			ref.current = current
			v7(true)
		end, {})

		onCancel = React.useCallback(function()
			ref.current = nil
			v7(false)
		end, {})

		onContinue = React.useCallback(function()
			local current = ref.current
			onCancel()

			if current then
				current()
			end
		end, { onCancel })
	else
		v8 = nil
		onCancel = nil
	end

	local state3, setState2 = React.useState(false)
	local state4, setState3 = React.useState("------")

	local useCallback = React.useCallback
	local function fn()
		if v6.enabled then
			v6.disable()
			return
		end

		v6.enable()

		if FFlagMomentsOverflowButtonAnalytics then
			local recommendationMetadata = props.moment.recommendationMetadata

			local momentId = props.moment.momentId
			local feedItemId

			if recommendationMetadata ~= nil then
				feedItemId = recommendationMetadata.feedItemId
			end

			local v9

			if recommendationMetadata ~= nil then
				v9 = recommendationMetadata.tracingId
			end

			local feedActionFields = makeFeedActionFields(momentId, feedItemId, v9, "overflow")

			if feedActionFields ~= nil then
				feedActionFields.isOwnMoment = tostring(isOwnMoment(props.moment)) -- inferred equivalent call
				fireAnalyticsEvent(EventNames.FeedOverflowButtonPressed, feedActionFields)
			end
		end
	end

	local enabled = v6.enabled
	local enable = v6.enable
	local disable = v6.disable
	local v9

	if FFlagMomentsOverflowButtonAnalytics then
		v9 = props.moment
	else
		v9 = false
	end

	local onActivated = useCallback(fn, { enabled, enable, disable, v9 })

	local v10 = useMomentsSession()
	local momentsPreferencesStore = GetMomentsPreferencesStore(false)
	local moderatedItemsStore = GetModeratedItemsStore(false)
	local toastStore = GetToastStore(false)

	local v11 = SignalsReact.useSignalState(v10.getHideDetails)
	local v12 = SignalsReact.useSignalState(momentsPreferencesStore.getMinimized)

	local onActivated2 = React.useCallback(function()
		v6.disable()
		v10.toggleFeedDetailVisibility()
		fireAnalyticsEvent(EventNames.FeedHideDetailsButtonPressed, {
			momentId = props.moment.momentId
		})
	end, { props.moment, v6.disable, v10.toggleFeedDetailVisibility })

	local onActivated3 = React.useCallback(function()
		v6.disable()
		momentsPreferencesStore.toggleFeedScaleType()
		fireAnalyticsEvent(EventNames.FeedMinimizeButtonPressed, {
			momentId = props.moment.momentId
		})
	end, { props.moment, v6.disable, momentsPreferencesStore.toggleFeedScaleType })

	local onActivated4 = React.useCallback(function()
		if checkDebugAccess() then
			momentsPreferencesStore.toggleFeedDebugMode()
		end

		v6.disable()
	end, { v6.disable, momentsPreferencesStore.toggleFeedDebugMode })

	local onSubmitReport = React.useCallback(function(p: string?, flag: boolean?, flag2: boolean?)
		if not props.moment then
			return nil
		end

		local success, result, v13

		if flag2 then
			success = true
			result = true
		else
			success, result, v13 = pcall(function()
				return reportMoment(props.moment.recommendationMetadata.feedItemId, p):await()
			end)
		end

		local recommendationMetadata = props.moment.recommendationMetadata
		local v14

		if FFlagMomentsRecommendationContentType then
			v14 = props.contentType
		end

		local recommendationAttribution = makeRecommendationAttribution(recommendationMetadata, nil, v14)

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

		if success and result and type(v13) == "table" then
			return v13.reportCode
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

	local useCallback2 = React.useCallback
	local function fn2()
		v6.disable()

		if defineFastFlag2 then
			reportMomentsEngagement("report_click")
		end

		local feedItemId = getPostFeedItemId(props.moment)

		if FFlagMomentsServeEDPVideos and v5 then
			feedItemId = props.moment.recommendationMetadata.feedItemId
		end

		if feedItemId and openMomentsFeedReport then
			reportModalCovering.setCovering(true)
			local v13 = {
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
				isEdpVideo = v5
			end

			v13.isEdpVideo = isEdpVideo
			local onEdpVideoIpReport

			if FFlagMomentsServeEDPVideos then
				onEdpVideoIpReport = v8
			end

			v13.onEdpVideoIpReport = onEdpVideoIpReport
			openMomentsFeedReport(v13)
		else
			if FFlagMomentsServeEDPVideos and v5 then
				return
			end

			setState(true)
		end
	end

	local disable2 = v6.disable
	local v13

	if FFlagMomentsServeEDPVideos then
		v13 = v8
	end

	local moment = props.moment
	local v14 = if FFlagMomentsServeEDPVideos then v5 else false
	local onActivated5 = useCallback2(fn2, {
		disable2,
		onSubmitReport,
		openMomentsFeedReport,
		v13,
		moment,
		v14
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
		v6.disable()

		local requestDeletion = v10.requestDeletion
		local momentId = props.moment.momentId
		local feedItemId = props.moment.recommendationMetadata and props.moment.recommendationMetadata.feedItemId
		local v15

		if props.moment.recommendationMetadata then
			v15 = props.moment.recommendationMetadata.tracingId
		end

		requestDeletion(momentId, feedItemId, v15)
	end, { props.moment, v6.disable, v10.requestDeletion })
	local onActivated7

	if FFlagMomentsCreatorAnalytics then
		onActivated7 = React.useCallback(function()
			v6.disable()

			local recommendationMetadata = props.moment.recommendationMetadata

			local momentId = props.moment.momentId
			local feedItemId

			if recommendationMetadata ~= nil then
				feedItemId = recommendationMetadata.feedItemId
			end

			local v15

			if recommendationMetadata ~= nil then
				v15 = recommendationMetadata.tracingId
			end

			local feedActionFields = makeFeedActionFields(momentId, feedItemId, v15, "analytics")

			if feedActionFields ~= nil then
				fireAnalyticsEvent(EventNames.FeedAnalyticsButtonPressed, feedActionFields)
			end

			if GetFFlagMomentsCoachmarkPersistence() then
				dismissPostInsightsCoachmark()
			end

			if props.momentStore ~= nil then
				getPostInsightsPageStore(false).open({
					moment = props.moment,
					momentStore = props.momentStore
				})
			end
		end, { props.moment, props.momentStore or false, v6.disable })
	else
		onActivated7 = nil
	end

	local v15

	if FFlagMomentsPersonalizedRecommendationsEntryPoint then
		v15 = React.useCallback(function()
			v6.disable()
			local recommendationMetadata = props.moment.recommendationMetadata

			local momentId = props.moment.momentId
			local feedItemId

			if recommendationMetadata ~= nil then
				feedItemId = recommendationMetadata.feedItemId
			end

			local v16

			if recommendationMetadata ~= nil then
				v16 = recommendationMetadata.tracingId
			end

			local feedActionFields = makeFeedActionFields(momentId, feedItemId, v16, "personalized_recommendations")

			if feedActionFields ~= nil then
				fireAnalyticsEvent(EventNames.FeedPersonalizedRecommendationsButtonPressed, feedActionFields)
			end

			local AccountSettingsEntryPoints = require(parent.AccountSettingsEntryPoints)
			AccountSettingsEntryPoints.openAccountSettings(
				AccountSettingsEntryPoints.Page.PersonalizedRecommendations,
				{
					surfaceKey = "Client_Moments_Feed",
					onClosed = function()
						accountSettingsCovering.setCovering(false)
					end
				}
			)

			accountSettingsCovering.setCovering(true)
		end, { props.moment, v6.disable })
	else
		v15 = nil
	end

	local onActivated8 = React.useCallback(function()
		if props.isDisabled then
			return
		end

		props.playbackVolume.toggle()
	end, { props.isDisabled, props.playbackVolume })

	local v16 = React.useCallback(function()
		if props.isDisabled then
			return
		end

		local v16

		if props.playbackVolume.isMuted then
			v16 = EventNames.FeedUnmuteButtonPressed
		else
			v16 = EventNames.FeedMuteButtonPressed
		end

		fireAnalyticsEvent(v16, { momentId = props.moment.momentId })

		props.playbackVolume.toggle()
	end, { props.isDisabled, props.playbackVolume, props.moment })

	if props.isFeedMuteButtonAnalyticsEnabled then
		onActivated8 = v16
	end

	local v17 = FFlagMomentsPersonalizedRecommendationsEntryPoint
		and v4
		and v3.recommendationSource == RecommendationSource.Trending

	local useMemo = React.useMemo
	local function fn3()
		local v18 = {
			id = "details",
			icon = v11 and "icons/actions/viewOn" or "icons/actions/viewOff",
			text = 0,
			onActivated = 0
		}

		local text3 = if v11 then v2.showDetails else v2.hideDetails
		v18.text = text3
		v18.onActivated = onActivated2

		local v19 = {
			id = "minimize",
			icon = v12 and "icons/actions/previewExpand" or "icons/actions/previewShrink",
			text = 0,
			onActivated = 0
		}

		local text4 = if v12 then v2.expand else v2.minimize
		v19.text = text4
		v19.onActivated = onActivated3
		local items = { v18, v19 }
		local v20

		if props.moment.recommendationMetadata == nil or props.moment.recommendationMetadata.feedItemId == nil then
			v20 = false
		else
			v20 = props.moment.recommendationMetadata.feedItemId ~= ""
		end

		if FFlagMomentsServeEDPVideos and v5 then
			table.insert(items, {
				id = "reportAbuse",
				icon = Foundation.Enums.IconName.Flag,
				text = v2.report,
				onActivated = onActivated5
			})
		else
			local creatorId = props.moment.creatorId
			local v21

			if LocalPlayer then
				v21 = LocalPlayer.UserId
			end

			if creatorId == v21 or not v20 then
				if v20 and (not FFlagMomentsOptimisticProfilePending or props.moment.status ~= "Pending") then
					table.insert(items, {
						id = "delete",
						icon = "icons/actions/delete",
						text = v2.delete,
						onActivated = onActivated6
					})
				end
			else
				table.insert(items, {
					id = "reportAbuse",
					icon = Foundation.Enums.IconName.Flag,
					text = v2.report,
					onActivated = onActivated5
				})
			end
		end

		if
			FFlagMomentsCreatorAnalytics
			and props.momentStore ~= nil
			and isOwnMoment(props.moment) -- inferred equivalent call
			and v3.recommendationSource == RecommendationSource.Profile
		then
			table.insert(items, {
				id = "postInsights",
				icon = Foundation.Enums.IconName.ChartThreeVerticalBars,
				text = text,
				onActivated = onActivated7
			})
		end

		if checkDebugAccess() then
			table.insert(items, {
				id = "debug",
				icon = "icons/logo/block",
				text = "Toggle Debug Mode",
				onActivated = onActivated4
			})
		end

		local onActivated9 = v15

		if v17 and onActivated9 ~= nil then
			return {
				{ items = items },
				{
					items = {
						{
							id = "personalizedRecommendations",
							icon = Foundation.Enums.IconName.Gear,
							text = text2,
							onActivated = onActivated9
						}
					}
				}
			}
		end

		return items
	end

	local moment2 = props.moment
	local v18 = if FFlagMomentsServeEDPVideos then v5 else false
	local v19

	if FFlagMomentsCreatorAnalytics then
		v19 = props.momentStore or false
	else
		v19 = false
	end

	local v20

	if FFlagMomentsCreatorAnalytics then
		v20 = onActivated7 or false
	else
		v20 = false
	end

	local v21 = if FFlagMomentsCreatorAnalytics then text else false
	local items = useMemo(fn3, {
		moment2,
		v11,
		v12,
		v2,
		onActivated4,
		onActivated2,
		onActivated3,
		onActivated5,
		onActivated6,
		v18,
		v19,
		v20,
		v21,
		v17,
		v15 or false,
		text2
	})

	local createElement = React.createElement
	local v22 = {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = v6.enabled,
		items = items,
		onPressedOutside = v6.disable,
		side = Foundation.Enums.PopoverSide.Left,
		size = 0
	}
	local size

	if defineFastFlag then
		size = Foundation.Enums.InputSize.Small
	end

	v22.size = size
	local element = createElement(Menu, v22, {
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
		local v23

		if LocalPlayer then
			v23 = LocalPlayer.UserId
		end

		if creatorId == v23 then
			element = React.createElement(
				PostInsightsCoachmark,
				{
					moment = props.moment,
					momentStore = props.momentStore,
					isDisabled = props.isDisabled,
					isMenuOpen = v6.enabled
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
		local v23 = { LayoutOrder = props.layoutOrder, tag = "col align-x-right auto-xy" }

		local createElement3 = React.createElement

		local createElement4 = React.createElement
		local icon

		if props.playbackVolume.isMuted then
			icon = SpeakerSlash
		else
			icon = Speaker
		end

		local v24 = {
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

		v24.EdpVideoIpReportDialog = edpVideoIpReportDialog
		return createElement2(View, v23, v24)
	else
		local createElement2 = React.createElement
		local v23 = { LayoutOrder = props.layoutOrder, tag = "col align-x-center auto-xy" }

		if not FFlagMomentsServeEDPVideos then
			edpVideoIpReportDialog = nil
		end

		return createElement2(View, v23, {
			ContextMenuPopover = element,
			ReportDialog = element2,
			IpConfirmationDialog = ipConfirmationDialog,
			EdpVideoIpReportDialog = edpVideoIpReportDialog
		})
	end
end
