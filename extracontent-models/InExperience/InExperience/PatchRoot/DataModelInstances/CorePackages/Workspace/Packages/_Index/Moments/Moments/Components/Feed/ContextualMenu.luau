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

return function(t2: {[any]: any}) -- line: 76
	-- upvalues: useLocalization (copy), t1 (copy), useFeed (copy), useToggleState (copy), FFlagMomentsIPReporting (copy), React (copy), useMomentsSession (copy), GetMomentsPreferencesStore (copy), GetModeratedItemsStore (copy), GetToastStore (copy), SignalsReact (copy), fireAnalyticsEvent (copy), EventNames (copy), checkDebugAccess (copy), reportMoment (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), makeRecommendationAttribution (copy), SignalActionType (copy), makeFeedActionFields (copy), MomentsCommon (copy), LocalPlayer (copy), Menu (copy), Foundation (copy), IconButton (copy), ThreeDotsVertical (copy), ReportMomentDialog (copy), View (copy), SpeakerSlash (copy), Speaker (copy)
	local v37 = useLocalization(t1)
	local v38 = useFeed()
	local v39 = useToggleState()
	local v40 = nil
	local u41 = nil

	if FFlagMomentsIPReporting then
		local v42

		v40, v42 = React.useState(false)
		u41 = v42
	end

	local v43 = React.useCallback(function() -- line: 88
		-- upvalues: v39 (copy)
		if v39.enabled then
			v39.disable()

			return
		end

		v39.enable()
	end, {
		v39.enabled,
		v39.enable,
		v39.disable
	})
	local v44 = useMomentsSession()
	local v45 = GetMomentsPreferencesStore(false)
	local v46 = GetModeratedItemsStore(false)
	local v47 = GetToastStore(false)
	local v48 = SignalsReact.useSignalState(v44.getHideDetails)
	local v49 = SignalsReact.useSignalState(v45.getMinimized)
	local v50 = React.useCallback(function() -- line: 104
		-- upvalues: v39 (copy), v44 (copy), fireAnalyticsEvent (copy), EventNames (copy), t2 (copy)
		v39.disable()
		v44.toggleFeedDetailVisibility()
		fireAnalyticsEvent(EventNames.FeedHideDetailsButtonPressed, {
			momentId = t2.moment.momentId
		})
	end, {
		t2.moment,
		v39.disable,
		v44.toggleFeedDetailVisibility
	})
	local v51 = React.useCallback(function() -- line: 112
		-- upvalues: v39 (copy), v45 (copy), fireAnalyticsEvent (copy), EventNames (copy), t2 (copy)
		v39.disable()
		v45.toggleFeedScaleType()
		fireAnalyticsEvent(EventNames.FeedMinimizeButtonPressed, {
			momentId = t2.moment.momentId
		})
	end, {
		t2.moment,
		v39.disable,
		v45.toggleFeedScaleType
	})
	local v52 = React.useCallback(function() -- line: 120
		-- upvalues: checkDebugAccess (copy), v45 (copy), v39 (copy)
		if checkDebugAccess() then
			v45.toggleFeedDebugMode()
		end

		v39.disable()
	end, {
		v39.disable,
		v45.toggleFeedDebugMode
	})
	local v53 = React.useCallback(function(s1: string?, b1: boolean?) -- line: 128
		-- upvalues: t2 (copy), FFlagMomentsIPReporting (copy), reportMoment (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), makeRecommendationAttribution (copy), v38 (copy), SignalActionType (copy), makeFeedActionFields (copy), MomentsCommon (copy), fireAnalyticsEvent (copy), EventNames (copy), v46 (copy), v47 (copy), v37 (copy)
		if not t2.moment then
			return nil
		end

		local ok, result, v67 = pcall(function() -- line: 133
			-- upvalues: FFlagMomentsIPReporting (copy), reportMoment (copy), t2 (copy), s1 (copy)
			if FFlagMomentsIPReporting then
				return reportMoment(t2.moment.momentId, s1):await()
			end

			return reportMoment(t2.moment.momentId):await()
		end)
		local recommendationMetadata = t2.moment.recommendationMetadata

		if GetFFlagMomentsAnalyticsSchemaIdentity() then
			local v69 = makeRecommendationAttribution(recommendationMetadata)

			if v69 then
				local ok2, result2 = pcall(function() -- line: 153
					-- upvalues: v38 (copy), SignalActionType (copy), v69 (copy)
					v38.logAction(SignalActionType.Report, v69, {})
				end)

				if not ok2 then
					warn("Failed to log action event", result2)
				end
			end
		elseif recommendationMetadata then
			local ok3, result3 = pcall(function() -- line: 163
				-- upvalues: v38 (copy), SignalActionType (copy), recommendationMetadata (copy)
				v38.logAction(SignalActionType.Report, {
					itemId = recommendationMetadata.itemId,
					tracingId = recommendationMetadata.tracingId
				}, {})
			end)

			if not ok3 then
				warn("Failed to log action event", result3)
			end
		end

		local v74 = makeFeedActionFields(t2.moment.momentId, recommendationMetadata and recommendationMetadata.feedItemId, recommendationMetadata and recommendationMetadata.tracingId, if not MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity() then nil else "report")

		if v74 then
			fireAnalyticsEvent(EventNames.FeedAbuseReported, v74)
		end

		if not b1 then
			v46.markReported(t2.moment.momentId)
			v38.removeCurrentItem()
			v47.triggerToast({
				title = v37.reportSubmittedTitle,
				text = v37.reportSubmittedBody
			})
		end

		if ok and result and type(v67) == "table" then
			return v67.reportCode
		end

		return nil
	end, {
		t2.moment,
		v38.logAction,
		v38.removeCurrentItem,
		v46.markReported,
		v47.triggerToast,
		v37
	})
	local v54 = React.useCallback(function() -- line: 213
		-- upvalues: v39 (copy), FFlagMomentsIPReporting (copy), u41 (ref), v53 (copy)
		v39.disable()

		if FFlagMomentsIPReporting then
			u41(true)

			return
		end

		task.spawn(function() -- line: 218
			-- upvalues: v53 (copy)
			v53(nil, false)
		end)
	end, {
		v39.disable,
		v53
	})
	local v55 = if not FFlagMomentsIPReporting then nil else React.useCallback(function() -- line: 225
		-- upvalues: u41 (ref)
		u41(false)
	end, {})
	local v56 = React.useCallback(function() -- line: 230
		-- upvalues: v39 (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), v44 (copy), t2 (copy)
		v39.disable()

		if GetFFlagMomentsAnalyticsSchemaIdentity() then
			v44.requestDeletion(t2.moment.momentId, t2.moment.recommendationMetadata and t2.moment.recommendationMetadata.feedItemId, t2.moment.recommendationMetadata and t2.moment.recommendationMetadata.tracingId)

			return
		end

		v44.requestDeletion(t2.moment.momentId)
	end, {
		t2.moment,
		v39.disable,
		v44.requestDeletion
	})
	local v57 = React.useCallback(function() -- line: 246
		-- upvalues: t2 (copy)
		if t2.isDisabled then
			return
		end

		t2.playbackVolume.toggle()
	end, {
		t2.isDisabled,
		t2.playbackVolume
	})
	local v58 = React.useCallback(function() -- line: 259
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
	local v59 = if not t2.isFeedMuteButtonAnalyticsEnabled then v57 else v58
	local v60 = React.useMemo(function() -- line: 285
		-- upvalues: v48 (copy), v37 (copy), v50 (copy), v49 (copy), v51 (copy), t2 (copy), LocalPlayer (copy), v54 (copy), v56 (copy), checkDebugAccess (copy), v52 (copy)
		local t3 = {
			{
				id = "details",
				icon = not v48 and "icons/actions/viewOff" or "icons/actions/viewOn",
				text = if not v48 then v37.hideDetails else v37.showDetails,
				onActivated = v50
			},
			{
				id = "minimize",
				icon = not v49 and "icons/actions/previewShrink" or "icons/actions/previewExpand",
				text = if not v49 then v37.minimize else v37.expand,
				onActivated = v51
			}
		}

		if t2.moment.creatorId ~= if not LocalPlayer then nil else LocalPlayer.UserId then
			table.insert(t3, {
				id = "reportAbuse",
				icon = "icons/actions/feedback",
				text = v37.report,
				onActivated = v54
			})
		else
			table.insert(t3, {
				id = "delete",
				icon = "icons/actions/delete",
				text = v37.delete,
				onActivated = v56
			})
		end

		if checkDebugAccess() then
			table.insert(t3, {
				id = "debug",
				icon = "icons/logo/block",
				text = "Toggle Debug Mode",
				onActivated = v52
			})
		end

		return t3
	end, {
		t2.moment,
		v48,
		v49,
		v37,
		v52,
		v50,
		v51,
		v54,
		v56
	})
	local v61 = React.createElement(Menu, {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = v39.enabled,
		items = v60,
		onPressedOutside = v39.disable,
		side = Foundation.Enums.PopoverSide.Left
	}, {
		ContextualMenuButton = React.createElement(IconButton, {
			testId = "FeedContextualMenuButton",
			icon = ThreeDotsVertical,
			isDisabled = t2.isDisabled,
			onActivated = v43,
			size = Foundation.Enums.InputSize.Large
		})
	})
	local v62 = if not FFlagMomentsIPReporting then nil else React.createElement(ReportMomentDialog, {
		isOpen = v40,
		onClose = v55,
		onSubmitReport = v53
	})

	if not t2.isFeedMuteEnabled then
		return React.createElement(View, {
			tag = "col align-x-center auto-xy",
			LayoutOrder = t2.layoutOrder
		}, {
			ContextMenuPopover = v61,
			ReportDialog = v62
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
				onActivated = v59,
				size = Foundation.Enums.InputSize.Medium
			}),
			ContextMenuPopover = v61
		}),
		ReportDialog = v62
	})
end
