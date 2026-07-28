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
local ReportMomentDialog = require(Moments.Components.Feed.ReportMomentDialog)
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

return function(t2: {[any]: any}) -- line: 77
	-- upvalues: useLocalization (copy), t1 (copy), useFeed (copy), useToggleState (copy), FFlagMomentsIPReporting (copy), React (copy), useMomentsSession (copy), GetMomentsPreferencesStore (copy), GetModeratedItemsStore (copy), GetToastStore (copy), SignalsReact (copy), fireAnalyticsEvent (copy), EventNames (copy), checkDebugAccess (copy), reportMoment (copy), makeRecommendationAttribution (copy), SignalActionType (copy), makeFeedActionFields (copy), MomentsCommon (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), LocalPlayer (copy), Menu (copy), Foundation (copy), IconButton (copy), ThreeDotsVertical (copy), ReportMomentDialog (copy), View (copy), SpeakerSlash (copy), Speaker (copy)
	local v38 = useLocalization(t1)
	local v39 = useFeed()
	local v40 = useToggleState()
	local v41 = nil
	local u42 = nil

	if FFlagMomentsIPReporting then
		local v43

		v41, v43 = React.useState(false)
		u42 = v43
	end

	local v44 = React.useCallback(function() -- line: 89
		-- upvalues: v40 (copy)
		if v40.enabled then
			v40.disable()

			return
		end

		v40.enable()
	end, {
		v40.enabled,
		v40.enable,
		v40.disable
	})
	local v45 = useMomentsSession()
	local v46 = GetMomentsPreferencesStore(false)
	local v47 = GetModeratedItemsStore(false)
	local v48 = GetToastStore(false)
	local v49 = SignalsReact.useSignalState(v45.getHideDetails)
	local v50 = SignalsReact.useSignalState(v46.getMinimized)
	local v51 = React.useCallback(function() -- line: 105
		-- upvalues: v40 (copy), v45 (copy), fireAnalyticsEvent (copy), EventNames (copy), t2 (copy)
		v40.disable()
		v45.toggleFeedDetailVisibility()
		fireAnalyticsEvent(EventNames.FeedHideDetailsButtonPressed, {
			momentId = t2.moment.momentId
		})
	end, {
		t2.moment,
		v40.disable,
		v45.toggleFeedDetailVisibility
	})
	local v52 = React.useCallback(function() -- line: 113
		-- upvalues: v40 (copy), v46 (copy), fireAnalyticsEvent (copy), EventNames (copy), t2 (copy)
		v40.disable()
		v46.toggleFeedScaleType()
		fireAnalyticsEvent(EventNames.FeedMinimizeButtonPressed, {
			momentId = t2.moment.momentId
		})
	end, {
		t2.moment,
		v40.disable,
		v46.toggleFeedScaleType
	})
	local v53 = React.useCallback(function() -- line: 121
		-- upvalues: checkDebugAccess (copy), v46 (copy), v40 (copy)
		if checkDebugAccess() then
			v46.toggleFeedDebugMode()
		end

		v40.disable()
	end, {
		v40.disable,
		v46.toggleFeedDebugMode
	})
	local v54 = React.useCallback(function(s1: string?, b1: boolean?) -- line: 129
		-- upvalues: t2 (copy), FFlagMomentsIPReporting (copy), reportMoment (copy), makeRecommendationAttribution (copy), v39 (copy), SignalActionType (copy), makeFeedActionFields (copy), MomentsCommon (copy), fireAnalyticsEvent (copy), EventNames (copy), v47 (copy), v48 (copy), v38 (copy)
		if not t2.moment then
			return nil
		end

		local ok, result, v68 = pcall(function() -- line: 134
			-- upvalues: FFlagMomentsIPReporting (copy), reportMoment (copy), t2 (copy), s1 (copy)
			if FFlagMomentsIPReporting then
				return reportMoment(t2.moment.momentId, s1):await()
			end

			return reportMoment(t2.moment.momentId):await()
		end)
		local recommendationMetadata = t2.moment.recommendationMetadata
		local v70 = makeRecommendationAttribution(recommendationMetadata)

		if v70 then
			local ok2, result2 = pcall(function() -- line: 150
				-- upvalues: v39 (copy), SignalActionType (copy), v70 (copy)
				v39.logAction(SignalActionType.Report, v70, {})
			end)

			if not ok2 then
				warn("Failed to log action event", result2)
			end
		end

		local v73 = makeFeedActionFields(t2.moment.momentId, recommendationMetadata and recommendationMetadata.feedItemId, recommendationMetadata and recommendationMetadata.tracingId, if not MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity() then nil else "report")

		if v73 then
			fireAnalyticsEvent(EventNames.FeedAbuseReported, v73)
		end

		if not b1 then
			v47.markReported(t2.moment.momentId)
			v39.removeCurrentItem()
			v48.triggerToast({
				title = v38.reportSubmittedTitle,
				text = v38.reportSubmittedBody
			})
		end

		if ok and result and type(v68) == "table" then
			return v68.reportCode
		end

		return nil
	end, {
		t2.moment,
		v39.logAction,
		v39.removeCurrentItem,
		v47.markReported,
		v48.triggerToast,
		v38
	})
	local v55 = React.useCallback(function() -- line: 197
		-- upvalues: v40 (copy), FFlagMomentsIPReporting (copy), u42 (ref), v54 (copy)
		v40.disable()

		if FFlagMomentsIPReporting then
			u42(true)

			return
		end

		task.spawn(function() -- line: 202
			-- upvalues: v54 (copy)
			v54(nil, false)
		end)
	end, {
		v40.disable,
		v54
	})
	local v56 = if not FFlagMomentsIPReporting then nil else React.useCallback(function() -- line: 209
		-- upvalues: u42 (ref)
		u42(false)
	end, {})
	local v57 = React.useCallback(function() -- line: 214
		-- upvalues: v40 (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), v45 (copy), t2 (copy)
		v40.disable()

		local v74 = GetFFlagMomentsAnalyticsSchemaIdentity()

		if FFlagMomentsPassFeedItemIdToBackendApis or v74 then
			v45.requestDeletion(t2.moment.momentId, t2.moment.recommendationMetadata and t2.moment.recommendationMetadata.feedItemId, if not v74 or not t2.moment.recommendationMetadata then nil else t2.moment.recommendationMetadata.tracingId)

			return
		end

		v45.requestDeletion(t2.moment.momentId)
	end, {
		t2.moment,
		v40.disable,
		v45.requestDeletion
	})
	local v58 = React.useCallback(function() -- line: 233
		-- upvalues: t2 (copy)
		if t2.isDisabled then
			return
		end

		t2.playbackVolume.toggle()
	end, {
		t2.isDisabled,
		t2.playbackVolume
	})
	local v59 = React.useCallback(function() -- line: 246
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
	local v60 = if not t2.isFeedMuteButtonAnalyticsEnabled then v58 else v59
	local v61 = React.useMemo(function() -- line: 272
		-- upvalues: v49 (copy), v38 (copy), v51 (copy), v50 (copy), v52 (copy), t2 (copy), LocalPlayer (copy), v55 (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), v57 (copy), checkDebugAccess (copy), v53 (copy)
		local t3 = {
			{
				id = "details",
				icon = not v49 and "icons/actions/viewOff" or "icons/actions/viewOn",
				text = if not v49 then v38.hideDetails else v38.showDetails,
				onActivated = v51
			},
			{
				id = "minimize",
				icon = not v50 and "icons/actions/previewShrink" or "icons/actions/previewExpand",
				text = if not v50 then v38.minimize else v38.expand,
				onActivated = v52
			}
		}

		if t2.moment.creatorId ~= if not LocalPlayer then nil else LocalPlayer.UserId then
			table.insert(t3, {
				id = "reportAbuse",
				icon = "icons/actions/feedback",
				text = v38.report,
				onActivated = v55
			})
		elseif not FFlagMomentsPassFeedItemIdToBackendApis or t2.moment.recommendationMetadata ~= nil and t2.moment.recommendationMetadata.feedItemId ~= nil and t2.moment.recommendationMetadata.feedItemId ~= "" then
			table.insert(t3, {
				id = "delete",
				icon = "icons/actions/delete",
				text = v38.delete,
				onActivated = v57
			})
		end

		if checkDebugAccess() then
			table.insert(t3, {
				id = "debug",
				icon = "icons/logo/block",
				text = "Toggle Debug Mode",
				onActivated = v53
			})
		end

		return t3
	end, {
		t2.moment,
		v49,
		v50,
		v38,
		v53,
		v51,
		v52,
		v55,
		v57
	})
	local v62 = React.createElement(Menu, {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = v40.enabled,
		items = v61,
		onPressedOutside = v40.disable,
		side = Foundation.Enums.PopoverSide.Left
	}, {
		ContextualMenuButton = React.createElement(IconButton, {
			testId = "FeedContextualMenuButton",
			icon = ThreeDotsVertical,
			isDisabled = t2.isDisabled,
			onActivated = v44,
			size = Foundation.Enums.InputSize.Large
		})
	})
	local v63 = if not FFlagMomentsIPReporting then nil else React.createElement(ReportMomentDialog, {
		isOpen = v41,
		onClose = v56,
		onSubmitReport = v54
	})

	if not t2.isFeedMuteEnabled then
		return React.createElement(View, {
			tag = "col align-x-center auto-xy",
			LayoutOrder = t2.layoutOrder
		}, {
			ContextMenuPopover = v62,
			ReportDialog = v63
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
				onActivated = v60,
				size = Foundation.Enums.InputSize.Medium
			}),
			ContextMenuPopover = v62
		}),
		ReportDialog = v63
	})
end
