local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Players = game:GetService("Players")
local BuilderIcons = require(MomentsParent.BuilderIcons)
local Foundation = require(MomentsParent.Foundation)
local Localization = require(MomentsParent.Localization)
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)

local React = require(MomentsParent.React)
local SharedFlags = require(MomentsParent.SharedFlags)
local SignalsReact = require(MomentsParent.SignalsReact)
local Speaker = BuilderIcons.Icon.Speaker
local SpeakerSlash = BuilderIcons.Icon.SpeakerSlash
local ThreeDotsVertical = BuilderIcons.Icon.ThreeDotsVertical
local IconButton = Foundation.IconButton
local Menu = Foundation.Menu
local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization
local useToggleState = MomentsCommon.Hooks.useToggleState
local checkDebugAccess = require(Moments.Utils.checkDebugAccess)
local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local EventNames = MomentsCommon.Analytics.EventNames
local GetFFlagMomentsAnalyticsSchemaIdentity = MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity
local makeFeedActionFields = require(Moments.Analytics.makeFeedActionFields)
local makeRecommendationAttribution = require(Moments.Analytics.makeRecommendationAttribution)
local reportMoment = require(Moments.Moderation.reportMoment)
local useFeed = require(Moments.Components.Feed.FeedContext).useFeed
local useMomentsSession = require(Moments.Stores.GetMomentsStore.MomentsSessionContext).useMomentsSession
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local GetModeratedItemsStore = require(Moments.Stores.GetModeratedItemsStore)
local GetToastStore = require(Moments.Stores.GetToastStore)
local SignalActionType = require(Moments.Enums.SignalActionType)
local FFlagMomentsIPReporting = SharedFlags.FFlagMomentsIPReporting
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis
local FFlagEnableReportingFlowForMomentsFeed = SharedFlags.FFlagEnableReportingFlowForMomentsFeed
local FFlagMomentsReportWithFeedId = SharedFlags.FFlagMomentsReportWithFeedId
local ReportMomentDialog = require(Moments.Components.Feed.ReportMomentDialog)
local useMomentsHost = require(Moments.MomentsHostContext).useMomentsHost
local LocalPlayer = Players.LocalPlayer
local t1 = {
	showDetails = "Feature.Moments.Action.ShowDetails",
	hideDetails = "Feature.Moments.Action.Hide",
	expand = "Feature.Moments.Action.Expand",
	minimize = "Feature.Moments.Action.Minimize",
	report = "Feature.Moments.Action.Report",
	delete = "Feature.Moments.Action.Delete",
	reportSubmittedTitle = "Feature.Moments.Label.ReportSubmittedTitle",
	reportSubmittedBody = "Feature.Moments.Label.ReportSubmittedBody"
}

return function(t2: {[any]: any}) -- line: 80
	-- upvalues: useLocalization (copy), t1 (copy), useFeed (copy), useMomentsHost (copy), useToggleState (copy), FFlagMomentsIPReporting (copy), React (copy), useMomentsSession (copy), GetMomentsPreferencesStore (copy), GetModeratedItemsStore (copy), GetToastStore (copy), SignalsReact (copy), fireAnalyticsEvent (copy), EventNames (copy), checkDebugAccess (copy), reportMoment (copy), FFlagMomentsReportWithFeedId (copy), makeRecommendationAttribution (copy), SignalActionType (copy), makeFeedActionFields (copy), MomentsCommon (copy), FFlagEnableReportingFlowForMomentsFeed (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), LocalPlayer (copy), Foundation (copy), Menu (copy), IconButton (copy), ThreeDotsVertical (copy), ReportMomentDialog (copy), View (copy), SpeakerSlash (copy), Speaker (copy)
	local v41 = useLocalization(t1)
	local v42 = useFeed()
	local openMomentsFeedReport = useMomentsHost().openMomentsFeedReport
	local v44 = useToggleState()
	local v45 = nil
	local u46 = nil

	if FFlagMomentsIPReporting then
		local v47

		v45, v47 = React.useState(false)
		u46 = v47
	end

	local v48 = React.useCallback(function() -- line: 95
		-- upvalues: v44 (copy)
		if v44.enabled then
			v44.disable()

			return
		end

		v44.enable()
	end, {
		v44.enabled,
		v44.enable,
		v44.disable
	})
	local v49 = useMomentsSession()
	local v50 = GetMomentsPreferencesStore(false)
	local v51 = GetModeratedItemsStore(false)
	local v52 = GetToastStore(false)
	local v53 = SignalsReact.useSignalState(v49.getHideDetails)
	local v54 = SignalsReact.useSignalState(v50.getMinimized)
	local v55 = React.useCallback(function() -- line: 111
		-- upvalues: v44 (copy), v49 (copy), fireAnalyticsEvent (copy), EventNames (copy), t2 (copy)
		v44.disable()
		v49.toggleFeedDetailVisibility()
		fireAnalyticsEvent(EventNames.FeedHideDetailsButtonPressed, {
			momentId = t2.moment.momentId
		})
	end, {
		t2.moment,
		v44.disable,
		v49.toggleFeedDetailVisibility
	})
	local v56 = React.useCallback(function() -- line: 119
		-- upvalues: v44 (copy), v50 (copy), fireAnalyticsEvent (copy), EventNames (copy), t2 (copy)
		v44.disable()
		v50.toggleFeedScaleType()
		fireAnalyticsEvent(EventNames.FeedMinimizeButtonPressed, {
			momentId = t2.moment.momentId
		})
	end, {
		t2.moment,
		v44.disable,
		v50.toggleFeedScaleType
	})
	local v57 = React.useCallback(function() -- line: 127
		-- upvalues: checkDebugAccess (copy), v50 (copy), v44 (copy)
		if checkDebugAccess() then
			v50.toggleFeedDebugMode()
		end

		v44.disable()
	end, {
		v44.disable,
		v50.toggleFeedDebugMode
	})
	local v58 = React.useCallback(function(s1: string?, b1: boolean?, b2: boolean?) -- line: 135
		-- upvalues: t2 (copy), FFlagMomentsIPReporting (copy), reportMoment (copy), FFlagMomentsReportWithFeedId (copy), makeRecommendationAttribution (copy), v42 (copy), SignalActionType (copy), makeFeedActionFields (copy), MomentsCommon (copy), fireAnalyticsEvent (copy), EventNames (copy), v51 (copy), v52 (copy), v41 (copy)
		if not t2.moment then
			return nil
		end

		local v71 = true
		local v72 = true
		local v73 = nil

		if not b2 then
			v71, v72, v73 = pcall(function() -- line: 144
				-- upvalues: FFlagMomentsIPReporting (copy), reportMoment (copy), FFlagMomentsReportWithFeedId (copy), t2 (copy), s1 (copy)
				if FFlagMomentsIPReporting then
					return reportMoment((if not FFlagMomentsReportWithFeedId then t2.moment.momentId else t2.moment.recommendationMetadata.feedItemId), s1):await()
				end

				return reportMoment((if not FFlagMomentsReportWithFeedId then t2.moment.momentId else t2.moment.recommendationMetadata.feedItemId)):await()
			end)
		end

		local recommendationMetadata = t2.moment.recommendationMetadata
		local v75 = makeRecommendationAttribution(recommendationMetadata)

		if v75 then
			local ok, result = pcall(function() -- line: 170
				-- upvalues: v42 (copy), SignalActionType (copy), v75 (copy)
				v42.logAction(SignalActionType.Report, v75, {})
			end)

			if not ok then
				warn("Failed to log action event", result)
			end
		end

		local v78 = makeFeedActionFields(t2.moment.momentId, recommendationMetadata and recommendationMetadata.feedItemId, recommendationMetadata and recommendationMetadata.tracingId, if not MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity() then nil else "report")

		if v78 then
			fireAnalyticsEvent(EventNames.FeedAbuseReported, v78)
		end

		if not b1 then
			v51.markReported(t2.moment.momentId)
			v42.removeCurrentItem()
			v52.triggerToast({
				title = v41.reportSubmittedTitle,
				text = v41.reportSubmittedBody
			})
		end

		if v71 and v72 and type(v73) == "table" then
			return v73.reportCode
		end

		return nil
	end, {
		t2.moment,
		v42.logAction,
		v42.removeCurrentItem,
		v51.markReported,
		v52.triggerToast,
		v41
	})
	local v59 = React.useCallback(function() -- line: 217
		-- upvalues: v44 (copy), t2 (copy), FFlagEnableReportingFlowForMomentsFeed (copy), openMomentsFeedReport (copy), v58 (copy), FFlagMomentsIPReporting (copy), u46 (ref)
		v44.disable()

		local v79 = t2.moment.recommendationMetadata and t2.moment.recommendationMetadata.feedItemId

		if FFlagEnableReportingFlowForMomentsFeed and (v79 and v79 ~= "" and openMomentsFeedReport) then
			openMomentsFeedReport({
				feedItemId = v79,
				onSubmit = function() -- line: 226
					-- upvalues: v58 (copy)
					v58(nil, false, true)
				end
			})

			return
		end

		if FFlagMomentsIPReporting then
			u46(true)

			return
		end

		task.spawn(function() -- line: 233
			-- upvalues: v58 (copy)
			v58(nil, false)
		end)
	end, {
		v44.disable,
		v58,
		openMomentsFeedReport,
		t2.moment
	})
	local v60 = if not FFlagMomentsIPReporting then nil else React.useCallback(function() -- line: 240
		-- upvalues: u46 (ref)
		u46(false)
	end, {})
	local v61 = React.useCallback(function() -- line: 245
		-- upvalues: v44 (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), v49 (copy), t2 (copy)
		v44.disable()

		local v80 = GetFFlagMomentsAnalyticsSchemaIdentity()

		if FFlagMomentsPassFeedItemIdToBackendApis or v80 then
			v49.requestDeletion(t2.moment.momentId, t2.moment.recommendationMetadata and t2.moment.recommendationMetadata.feedItemId, if not v80 or not t2.moment.recommendationMetadata then nil else t2.moment.recommendationMetadata.tracingId)

			return
		end

		v49.requestDeletion(t2.moment.momentId)
	end, {
		t2.moment,
		v44.disable,
		v49.requestDeletion
	})
	local v62 = React.useCallback(function() -- line: 264
		-- upvalues: t2 (copy)
		if t2.isDisabled then
			return
		end

		t2.playbackVolume.toggle()
	end, {
		t2.isDisabled,
		t2.playbackVolume
	})
	local v63 = React.useCallback(function() -- line: 277
		-- upvalues: t2 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if t2.isDisabled then
			return
		end

		fireAnalyticsEvent(if not t2.playbackVolume.isMuted then EventNames.FeedMuteButtonPressed else EventNames.FeedUnmuteButtonPressed, {
			momentId = t2.moment.momentId
		})
		t2.playbackVolume.toggle()
	end, {
		t2.isDisabled,
		t2.playbackVolume,
		t2.moment
	})
	local v64 = if not t2.isFeedMuteButtonAnalyticsEnabled then v62 else v63
	local v65 = React.useMemo(function() -- line: 303
		-- upvalues: v53 (copy), v41 (copy), v55 (copy), v54 (copy), v56 (copy), t2 (copy), LocalPlayer (copy), FFlagMomentsReportWithFeedId (copy), Foundation (copy), v59 (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), v61 (copy), checkDebugAccess (copy), v57 (copy)
		local t3 = {
			{
				id = "details",
				icon = not v53 and "icons/actions/viewOff" or "icons/actions/viewOn",
				text = if not v53 then v41.hideDetails else v41.showDetails,
				onActivated = v55
			},
			{
				id = "minimize",
				icon = not v54 and "icons/actions/previewShrink" or "icons/actions/previewExpand",
				text = if not v54 then v41.minimize else v41.expand,
				onActivated = v56
			}
		}
		local v82 = t2.moment.recommendationMetadata ~= nil and (t2.moment.recommendationMetadata.feedItemId ~= nil and t2.moment.recommendationMetadata.feedItemId ~= "")

		if t2.moment.creatorId ~= (if not LocalPlayer then nil else LocalPlayer.UserId) and (not FFlagMomentsReportWithFeedId or v82) then
			table.insert(t3, {
				id = "reportAbuse",
				icon = Foundation.Enums.IconName.Flag,
				text = v41.report,
				onActivated = v59
			})
		elseif not FFlagMomentsPassFeedItemIdToBackendApis or v82 then
			table.insert(t3, {
				id = "delete",
				icon = "icons/actions/delete",
				text = v41.delete,
				onActivated = v61
			})
		end

		if checkDebugAccess() then
			table.insert(t3, {
				id = "debug",
				icon = "icons/logo/block",
				text = "Toggle Debug Mode",
				onActivated = v57
			})
		end

		return t3
	end, {
		t2.moment,
		v53,
		v54,
		v41,
		v57,
		v55,
		v56,
		v59,
		v61
	})
	local v66 = React.createElement(Menu, {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = v44.enabled,
		items = v65,
		onPressedOutside = v44.disable,
		side = Foundation.Enums.PopoverSide.Left
	}, {
		ContextualMenuButton = React.createElement(IconButton, {
			testId = "FeedContextualMenuButton",
			icon = ThreeDotsVertical,
			isDisabled = t2.isDisabled,
			onActivated = v48,
			size = Foundation.Enums.InputSize.Large
		})
	})
	local v67 = if not FFlagMomentsIPReporting then nil else React.createElement(ReportMomentDialog, {
		isOpen = v45,
		onClose = v60,
		onSubmitReport = v58
	})

	if not t2.isFeedMuteEnabled then
		return React.createElement(View, {
			tag = "col align-x-center auto-xy",
			LayoutOrder = t2.layoutOrder
		}, {
			ContextMenuPopover = v66,
			ReportDialog = v67
		})
	end

	return React.createElement(View, {
		tag = "col align-x-right auto-xy",
		LayoutOrder = t2.layoutOrder
	}, {
		MuteAndMenuRow = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-x-right align-y-center gap-xsmall auto-xy"
		}, {
			FeedMuteButton = React.createElement(IconButton, {
				testId = "FeedMuteButton",
				icon = if not t2.playbackVolume.isMuted then Speaker else SpeakerSlash,
				isDisabled = t2.isDisabled,
				onActivated = v64,
				size = Foundation.Enums.InputSize.Medium
			}),
			ContextMenuPopover = v66
		}),
		ReportDialog = v67
	})
end
