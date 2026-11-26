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
local recommendationSource = MomentsCommon.Analytics.RecommendationSource
local reportModalCovering = MomentsCommon.Media.reportModalCovering
local accountSettingsCovering = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/accountSettingsCovering")
local getMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
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

local FFlagMomentsPersonalizedRecommendationsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsPersonalizedRecommendationsEntryPoint")
local FFlagMomentsCreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCreatorAnalytics")
local FFlagMomentsRecommendationContentType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationContentType")
local getPostInsightsPageStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/getPostInsightsPageStore")
local postInsightsStrings = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/postInsightsStrings")
local PostInsightsCoachmark = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/PostInsightsCoachmark")
local dismissPostInsightsCoachmark = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/dismissPostInsightsCoachmark")
local FFlagMomentsOverflowButtonAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsOverflowButtonAnalytics")
local getFFlagMomentsCoachmarkPersistence = MomentsCommon.Flags.GetFFlagMomentsCoachmarkPersistence
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/createMomentStore")
local ReportMomentDialog = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/ReportMomentDialog")
local IpReportConfirmationDialog = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/IpReportConfirmationDialog")

local useMomentsHost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext").useMomentsHost

local localPlayer = Players.LocalPlayer

local function isOwnMoment(p2): boolean
	local creatorId = p2.creatorId
	local v5 = if localPlayer then localPlayer.UserId else nil
	return creatorId == v5
end

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

local frozen = table.freeze({
	label = "Feature.AccountSettings.Heading.Tab.PersonalizedRecommendations"
})

return function(props)
	local v6 = useLocalization(v5)

	local v7 = not FFlagMomentsCreatorAnalytics and "" or useLocalization(postInsightsStrings.MENU_KEYS).analytics

	local v8 = not FFlagMomentsPersonalizedRecommendationsEntryPoint and "" or useLocalization(frozen).label

	local v9 = useFeed()
	local v10

	if FFlagMomentsPersonalizedRecommendationsEntryPoint then
		v10 = SignalsReact.useSignalState(getMomentsCapabilities(false).getCanShowPersonalizedRecommendationsEntryPoint)
	else
		v10 = false
	end

	local v11 = fFlagMomentsServeEDPVideos and props.moment.entityType == "edpVideo"

	local openMomentsFeedReport = useMomentsHost().openMomentsFeedReport
	local v12 = useToggleState()
	local state, setState = React.useState(false)
	local state2 = nil
	local v13 = nil
	local v14, v15, v16

	if fFlagMomentsServeEDPVideos then
		local setState2
		state2, setState2 = React.useState(false)
		v13 = setState2

		local ref = React.useRef(nil)

		v14 = React.useCallback(function(current)
			ref.current = current
			v13(true)
		end, {})

		v15 = React.useCallback(function()
			ref.current = nil
			v13(false)
		end, {})

		v16 = React.useCallback(function()
			local current = ref.current
			v15()

			if current then
				current()
			end
		end, { v15 })
	else
		v14 = nil
		v15 = nil
	end

	local state3, setState2 = React.useState(false)
	local state4, setState3 = React.useState("------")

	local useCallback = React.useCallback
	local function fn()
		if v12.enabled then
			v12.disable()
			return
		end

		v12.enable()

		if FFlagMomentsOverflowButtonAnalytics then
			local recommendationMetadata = props.moment.recommendationMetadata

			local momentId = props.moment.momentId
			local feedItemId = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil
			local v18 = if recommendationMetadata ~= nil then recommendationMetadata.tracingId else nil
			local v19 = makeFeedActionFields(momentId, feedItemId, v18, "overflow")

			if v19 ~= nil then
				local creatorId = props.moment.creatorId
				local v20 = if localPlayer then localPlayer.UserId else nil

				v19.isOwnMoment = tostring(creatorId == v20)
				fireAnalyticsEvent(eventNames.FeedOverflowButtonPressed, v19)
			end
		end
	end

	local enabled = v12.enabled
	local enable = v12.enable
	local disable = v12.disable
	local v18 = if FFlagMomentsOverflowButtonAnalytics then props.moment else false
	local v19 = useCallback(fn, { enabled, enable, disable, v18 })

	local v20 = useMomentsSession()
	local v21 = GetMomentsPreferencesStore(false)
	local v22 = GetModeratedItemsStore(false)
	local v23 = GetToastStore(false)

	local v24 = SignalsReact.useSignalState(v20.getHideDetails)
	local v25 = SignalsReact.useSignalState(v21.getMinimized)

	local v26 = React.useCallback(function()
		v12.disable()
		v20.toggleFeedDetailVisibility()
		fireAnalyticsEvent(eventNames.FeedHideDetailsButtonPressed, {
			momentId = props.moment.momentId
		})
	end, { props.moment, v12.disable, v20.toggleFeedDetailVisibility })

	local v27 = React.useCallback(function()
		v12.disable()
		v21.toggleFeedScaleType()
		fireAnalyticsEvent(eventNames.FeedMinimizeButtonPressed, {
			momentId = props.moment.momentId
		})
	end, { props.moment, v12.disable, v21.toggleFeedScaleType })

	local v28 = React.useCallback(function()
		if checkDebugAccess() then
			v21.toggleFeedDebugMode()
		end

		v12.disable()
	end, { v12.disable, v21.toggleFeedDebugMode })

	local v29 = React.useCallback(function(p2, p3, p4)
		if not props.moment then
			return nil
		end

		local success, result, v30

		if p4 then
			success = true
			result = true
		else
			success, result, v30 = pcall(function()
				return reportMoment(props.moment.recommendationMetadata.feedItemId, p2):await()
			end)
		end

		local recommendationMetadata = props.moment.recommendationMetadata

		local v33 = if FFlagMomentsRecommendationContentType then props.contentType else nil
		local v34 = makeRecommendationAttribution(recommendationMetadata, nil, v33)

		if v34 then
			local success2, result2 = pcall(function()
				v9.logAction(SignalActionType.Report, v34, {})
			end)

			if not success2 then
				warn("Failed to log action event", result2)
			end
		end

		local v35 = makeFeedActionFields(
			props.moment.momentId,
			recommendationMetadata and recommendationMetadata.feedItemId,
			recommendationMetadata and recommendationMetadata.tracingId,
			"report"
		)

		if v35 then
			fireAnalyticsEvent(eventNames.FeedAbuseReported, v35)
		end

		if not p3 then
			v22.markReported(props.moment.momentId)
			v9.removeCurrentItem()

			v23.triggerToast({
				title = v6.reportSubmittedTitle,
				text = v6.reportSubmittedBody
			})
		end

		if success and result and type(v30) == "table" then
			return v30.reportCode
		end

		return nil
	end, {
		props.moment,
		v9.logAction,
		v9.removeCurrentItem,
		v22.markReported,
		v23.triggerToast,
		v6
	})

	local useCallback2 = React.useCallback
	local function fn2()
		v12.disable()

		if defineFastFlag2 then
			reportMomentsEngagement("report_click")
		end

		local v30 = getPostFeedItemId(props.moment)

		if fFlagMomentsServeEDPVideos and v11 then
			v30 = props.moment.recommendationMetadata.feedItemId
		end

		if v30 and openMomentsFeedReport then
			reportModalCovering.setCovering(true)
			openMomentsFeedReport({
				feedItemId = v30,
				momentId = props.moment.momentId,
				universeId = fFlagMomentsServeEDPVideos and (props.moment.metadata.universeId or 0) or nil,
				onSubmit = function()
					v29(nil, false, true)
				end,
				onClose = function()
					reportModalCovering.setCovering(false)
				end,
				onIpReportCode = function(p2)
					v29(nil, true, true)
					setState3((not p2 or p2 == "") and "------" or p2)
					setState2(true)
				end,
				isEdpVideo = if fFlagMomentsServeEDPVideos then v11 else nil,
				onEdpVideoIpReport = if fFlagMomentsServeEDPVideos then v14 else nil
			})
		else
			if fFlagMomentsServeEDPVideos and v11 then
				return
			end

			setState(true)
		end
	end

	local disable2 = v12.disable
	local v31 = if fFlagMomentsServeEDPVideos then v14 else nil
	local v33 = useCallback2(fn2, {
		disable2,
		v29,
		openMomentsFeedReport,
		v31,
		props.moment,
		if fFlagMomentsServeEDPVideos then v11 else false
	})

	local v34 = React.useCallback(function()
		setState(false)
	end, {})

	local v35 = React.useCallback(function()
		if setState2 then
			setState2(false)
		end
	end, {})

	local v36 = React.useCallback(function()
		v12.disable()

		local requestDeletion = v20.requestDeletion
		local momentId = props.moment.momentId
		local feedItemId = props.moment.recommendationMetadata
			and props.moment.recommendationMetadata.feedItemId
		local v37 = if props.moment.recommendationMetadata then props.moment.recommendationMetadata.tracingId else nil
		requestDeletion(momentId, feedItemId, v37)
	end, { props.moment, v12.disable, v20.requestDeletion })
	local v37

	if FFlagMomentsCreatorAnalytics then
		v37 = React.useCallback(function()
			v12.disable()

			local recommendationMetadata = props.moment.recommendationMetadata

			local momentId = props.moment.momentId
			local feedItemId = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil
			local v39 = if recommendationMetadata ~= nil then recommendationMetadata.tracingId else nil
			local v40 = makeFeedActionFields(momentId, feedItemId, v39, "analytics")

			if v40 ~= nil then
				fireAnalyticsEvent(eventNames.FeedAnalyticsButtonPressed, v40)
			end

			if getFFlagMomentsCoachmarkPersistence() then
				dismissPostInsightsCoachmark()
			end

			if props.momentStore ~= nil then
				getPostInsightsPageStore(false).open({
					moment = props.moment,
					momentStore = props.momentStore
				})
			end
		end, { props.moment, props.momentStore or false, v12.disable })
	else
		v37 = nil
	end

	local v38

	if FFlagMomentsPersonalizedRecommendationsEntryPoint then
		v38 = React.useCallback(function()
			v12.disable()
			local recommendationMetadata = props.moment.recommendationMetadata

			local momentId = props.moment.momentId
			local feedItemId = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil
			local v40 = if recommendationMetadata ~= nil then recommendationMetadata.tracingId else nil
			local v41 = makeFeedActionFields(momentId, feedItemId, v40, "personalized_recommendations")

			if v41 ~= nil then
				fireAnalyticsEvent(eventNames.FeedPersonalizedRecommendationsButtonPressed, v41)
			end

			local AccountSettingsEntryPoints = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AccountSettingsEntryPoints")
			AccountSettingsEntryPoints.openAccountSettings(AccountSettingsEntryPoints.Page.PersonalizedRecommendations, {
				surfaceKey = "Client_Moments_Feed",
				onClosed = function()
					accountSettingsCovering.setCovering(false)
				end
			})

			accountSettingsCovering.setCovering(true)
		end, { props.moment, v12.disable })
	else
		v38 = nil
	end

	local v39 = React.useCallback(function()
		if props.isDisabled then
			return
		end

		props.playbackVolume.toggle()
	end, { props.isDisabled, props.playbackVolume })

	local v40 = React.useCallback(function()
		if props.isDisabled then
			return
		end

		local v42 = if props.playbackVolume.isMuted then eventNames.FeedUnmuteButtonPressed else eventNames.FeedMuteButtonPressed
		fireAnalyticsEvent(v42, { momentId = props.moment.momentId })

		props.playbackVolume.toggle()
	end, { props.isDisabled, props.playbackVolume, props.moment })

	if props.isFeedMuteButtonAnalyticsEnabled then
		v39 = v40
	end

	local v41 = FFlagMomentsPersonalizedRecommendationsEntryPoint and v10 and v9.recommendationSource == recommendationSource.Trending

	local useMemo = React.useMemo
	local function fn3()
		local v43 = {
			id = "details",
			icon = v24 and "icons/actions/viewOn" or "icons/actions/viewOff",
			text = 0,
			onActivated = 0
		}

		local v44 = if v24 then v6.showDetails else v6.hideDetails
		v43.text = v44
		v43.onActivated = v26

		local v45 = {
			id = "minimize",
			icon = v25 and "icons/actions/previewExpand" or "icons/actions/previewShrink",
			text = 0,
			onActivated = 0
		}

		local v46 = if v25 then v6.expand else v6.minimize
		v45.text = v46
		v45.onActivated = v27
		local v42 = { v43, v45 }
		local v47

		if
			props.moment.recommendationMetadata == nil
			or props.moment.recommendationMetadata.feedItemId == nil
		then
			v47 = false
		else
			v47 = props.moment.recommendationMetadata.feedItemId ~= ""
		end

		if fFlagMomentsServeEDPVideos and v11 then
			table.insert(v42, {
				id = "reportAbuse",
				icon = Foundation.Enums.IconName.Flag,
				text = v6.report,
				onActivated = v33
			})
		else
			local creatorId = props.moment.creatorId
			local v48 = if localPlayer then localPlayer.UserId else nil

			if creatorId == v48 or not v47 then
				if
					v47
					and (not fFlagMomentsOptimisticProfilePending or props.moment.status ~= "Pending")
				then
					table.insert(v42, {
						id = "delete",
						icon = "icons/actions/delete",
						text = v6.delete,
						onActivated = v36
					})
				end
			else
				table.insert(v42, {
					id = "reportAbuse",
					icon = Foundation.Enums.IconName.Flag,
					text = v6.report,
					onActivated = v33
				})
			end
		end

		if FFlagMomentsCreatorAnalytics and props.momentStore ~= nil then
			local creatorId = props.moment.creatorId
			local v48 = if localPlayer then localPlayer.UserId else nil

			if creatorId == v48 and v9.recommendationSource == recommendationSource.Profile then
				table.insert(v42, {
					id = "postInsights",
					icon = Foundation.Enums.IconName.ChartThreeVerticalBars,
					text = v7,
					onActivated = v37
				})
			end
		end

		if checkDebugAccess() then
			table.insert(v42, {
				id = "debug",
				icon = "icons/logo/block",
				text = "Toggle Debug Mode",
				onActivated = v28
			})
		end

		local v48 = v38

		if v41 and v48 ~= nil then
			return {
				{ items = v42 },
				{
					items = {
						{
							id = "personalizedRecommendations",
							icon = Foundation.Enums.IconName.Gear,
							text = v8,
							onActivated = v48
						}
					}
				}
			}
		end

		return v42
	end

	local moment2 = props.moment
	local v43 = if fFlagMomentsServeEDPVideos then v11 else false
	local v44 = if FFlagMomentsCreatorAnalytics then props.momentStore or false else false
	local v45 = if FFlagMomentsCreatorAnalytics then v37 or false else false
	local v47 = useMemo(fn3, {
		moment2,
		v24,
		v25,
		v6,
		v28,
		v26,
		v27,
		v33,
		v36,
		v43,
		v44,
		v45,
		if FFlagMomentsCreatorAnalytics then v7 else false,
		v41,
		v38 or false,
		v8
	})

	local createElement = React.createElement
	local v49 = {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = v12.enabled,
		items = v47,
		onPressedOutside = v12.disable,
		side = Foundation.Enums.PopoverSide.Left,
		size = 0
	}
	local v50 = if defineFastFlag then Foundation.Enums.InputSize.Small else nil
	v49.size = v50
	local element = createElement(menu, v49, {
		ContextualMenuButton = React.createElement(iconButton, {
			icon = threeDotsVertical,
			isDisabled = props.isDisabled,
			onActivated = v19,
			size = Foundation.Enums.InputSize.Large,
			testId = "FeedContextualMenuButton"
		})
	})

	if FFlagMomentsCreatorAnalytics and getFFlagMomentsCoachmarkPersistence() and props.momentStore ~= nil then
		local creatorId = props.moment.creatorId
		local v51 = if localPlayer then localPlayer.UserId else nil

		if creatorId == v51 then
			element = React.createElement(
				PostInsightsCoachmark,
				{
					moment = props.moment,
					momentStore = props.momentStore,
					isDisabled = props.isDisabled,
					isMenuOpen = v12.enabled
				},
				element
			)
		end
	end

	local element2 = React.createElement(ReportMomentDialog, {
		isOpen = state,
		onClose = v34,
		onSubmitReport = v29
	})
	local v51

	if state3 then
		v51 = React.createElement(IpReportConfirmationDialog, { reportCode = state4, onClose = v35 })
	end

	local v52

	if fFlagMomentsServeEDPVideos and state2 then
		v52 = React.createElement(require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/EdpVideoIpReportDialog"), {
			onCancel = v15,
			onContinue = v16
		})
	end

	if props.isFeedMuteEnabled then
		local createElement2 = React.createElement
		local v54 = {
			LayoutOrder = props.layoutOrder,
			tag = "col align-x-right auto-xy"
		}

		local createElement3 = React.createElement

		local createElement4 = React.createElement
		local v61 = if props.playbackVolume.isMuted then speakerSlash else speaker
		local v55 = {
			MuteAndMenuRow = createElement3(
				view,
				{
					LayoutOrder = 1,
					tag = "row align-x-right align-y-center gap-xsmall auto-xy"
				},
				{
					FeedMuteButton = createElement4(iconButton, {
						icon = v61,
						isDisabled = props.isDisabled,
						onActivated = v39,
						size = Foundation.Enums.InputSize.Medium,
						testId = "FeedMuteButton"
					}),
					ContextMenuPopover = element
				}
			),
			ReportDialog = element2,
			IpConfirmationDialog = v51,
			EdpVideoIpReportDialog = 0
		}

		if not fFlagMomentsServeEDPVideos then
			v52 = nil
		end

		v55.EdpVideoIpReportDialog = v52
		return createElement2(view, v54, v55)
	else
		local createElement2 = React.createElement
		local v54 = {
			LayoutOrder = props.layoutOrder,
			tag = "col align-x-center auto-xy"
		}

		if not fFlagMomentsServeEDPVideos then
			v52 = nil
		end

		return createElement2(view, v54, {
			ContextMenuPopover = element,
			ReportDialog = element2,
			IpConfirmationDialog = v51,
			EdpVideoIpReportDialog = v52
		})
	end
end
