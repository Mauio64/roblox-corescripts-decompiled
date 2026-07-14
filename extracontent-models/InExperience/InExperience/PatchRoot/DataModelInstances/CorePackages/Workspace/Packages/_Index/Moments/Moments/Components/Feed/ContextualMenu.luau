local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Players = game:GetService("Players")
local BuilderIcons = require(MomentsParent.BuilderIcons)
local Foundation = require(MomentsParent.Foundation)
local Localization = require(MomentsParent.Localization)
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)

local React = require(MomentsParent.React)
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

return function(t2: {[any]: any}) -- line: 72
	-- upvalues: useLocalization (copy), t1 (copy), useFeed (copy), useToggleState (copy), React (copy), useMomentsSession (copy), GetMomentsPreferencesStore (copy), GetModeratedItemsStore (copy), GetToastStore (copy), SignalsReact (copy), fireAnalyticsEvent (copy), EventNames (copy), checkDebugAccess (copy), reportMoment (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), makeRecommendationAttribution (copy), SignalActionType (copy), makeFeedActionFields (copy), MomentsCommon (copy), LocalPlayer (copy), Menu (copy), Foundation (copy), IconButton (copy), ThreeDotsVertical (copy), View (copy), SpeakerSlash (copy), Speaker (copy)
	local v34 = useLocalization(t1)
	local v35 = useFeed()
	local v36 = useToggleState()
	local v37 = React.useCallback(function() -- line: 80
		-- upvalues: v36 (copy)
		if v36.enabled then
			v36.disable()

			return
		end

		v36.enable()
	end, {
		v36.enabled,
		v36.enable,
		v36.disable
	})
	local v38 = useMomentsSession()
	local v39 = GetMomentsPreferencesStore(false)
	local v40 = GetModeratedItemsStore(false)
	local v41 = GetToastStore(false)
	local v42 = SignalsReact.useSignalState(v38.getHideDetails)
	local v43 = SignalsReact.useSignalState(v39.getMinimized)
	local v44 = React.useCallback(function() -- line: 96
		-- upvalues: v36 (copy), v38 (copy), fireAnalyticsEvent (copy), EventNames (copy), t2 (copy)
		v36.disable()
		v38.toggleFeedDetailVisibility()
		fireAnalyticsEvent(EventNames.FeedHideDetailsButtonPressed, {
			momentId = t2.moment.momentId
		})
	end, {
		t2.moment,
		v36.disable,
		v38.toggleFeedDetailVisibility
	})
	local v45 = React.useCallback(function() -- line: 104
		-- upvalues: v36 (copy), v39 (copy), fireAnalyticsEvent (copy), EventNames (copy), t2 (copy)
		v36.disable()
		v39.toggleFeedScaleType()
		fireAnalyticsEvent(EventNames.FeedMinimizeButtonPressed, {
			momentId = t2.moment.momentId
		})
	end, {
		t2.moment,
		v36.disable,
		v39.toggleFeedScaleType
	})
	local v46 = React.useCallback(function() -- line: 112
		-- upvalues: checkDebugAccess (copy), v39 (copy), v36 (copy)
		if checkDebugAccess() then
			v39.toggleFeedDebugMode()
		end

		v36.disable()
	end, {
		v36.disable,
		v39.toggleFeedDebugMode
	})
	local v47 = React.useCallback(function() -- line: 120
		-- upvalues: v36 (copy), t2 (copy), reportMoment (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), makeRecommendationAttribution (copy), v35 (copy), SignalActionType (copy), makeFeedActionFields (copy), MomentsCommon (copy), fireAnalyticsEvent (copy), EventNames (copy), v40 (copy), v41 (copy), v34 (copy)
		v36.disable()
		task.spawn(function() -- line: 122
			-- upvalues: t2 (copy), reportMoment (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), makeRecommendationAttribution (copy), v35 (copy), SignalActionType (copy), makeFeedActionFields (copy), MomentsCommon (copy), fireAnalyticsEvent (copy), EventNames (copy), v40 (copy), v41 (copy), v34 (copy)
			if not t2.moment then
				return
			end

			local _, _ = pcall(function() -- line: 127
				-- upvalues: reportMoment (copy), t2 (copy)
				return reportMoment(t2.moment.momentId):await()
			end)
			local recommendationMetadata = t2.moment.recommendationMetadata

			if GetFFlagMomentsAnalyticsSchemaIdentity() then
				local v58 = makeRecommendationAttribution(recommendationMetadata)

				if v58 then
					local ok, result = pcall(function() -- line: 143
						-- upvalues: v35 (copy), SignalActionType (copy), v58 (copy)
						v35.logAction(SignalActionType.Report, v58, {})
					end)

					if not ok then
						warn("Failed to log action event", result)
					end
				end
			elseif recommendationMetadata then
				local ok, result = pcall(function() -- line: 153
					-- upvalues: v35 (copy), SignalActionType (copy), recommendationMetadata (copy)
					v35.logAction(SignalActionType.Report, {
						itemId = recommendationMetadata.itemId,
						tracingId = recommendationMetadata.tracingId
					}, {})
				end)

				if not ok then
					warn("Failed to log action event", result)
				end
			end

			local v63 = makeFeedActionFields(t2.moment.momentId, recommendationMetadata and recommendationMetadata.feedItemId, recommendationMetadata and recommendationMetadata.tracingId, if not MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity() then nil else "report")

			if v63 then
				fireAnalyticsEvent(EventNames.FeedAbuseReported, v63)
			end

			v40.markReported(t2.moment.momentId)
			v35.removeCurrentItem()
			v41.triggerToast({
				title = v34.reportSubmittedTitle,
				text = v34.reportSubmittedBody
			})
		end)
	end, {
		t2.moment,
		v35.logAction,
		v35.removeCurrentItem,
		v36.disable,
		v40.markReported,
		v41.triggerToast,
		v34
	})
	local v48 = React.useCallback(function() -- line: 198
		-- upvalues: v36 (copy), v38 (copy), t2 (copy)
		v36.disable()
		v38.requestDeletion(t2.moment.momentId, t2.moment.recommendationMetadata and t2.moment.recommendationMetadata.feedItemId, t2.moment.recommendationMetadata and t2.moment.recommendationMetadata.tracingId)
	end, {
		t2.moment,
		v36.disable,
		v38.requestDeletion
	})
	local v49 = React.useCallback(function() -- line: 211
		-- upvalues: t2 (copy)
		if t2.isDisabled then
			return
		end

		t2.playbackVolume.toggle()
	end, {
		t2.isDisabled,
		t2.playbackVolume
	})
	local v50 = React.useCallback(function() -- line: 224
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
	local v51 = if not t2.isFeedMuteButtonAnalyticsEnabled then v49 else v50
	local v52 = React.useMemo(function() -- line: 250
		-- upvalues: v42 (copy), v34 (copy), v44 (copy), v43 (copy), v45 (copy), t2 (copy), LocalPlayer (copy), v47 (copy), v48 (copy), checkDebugAccess (copy), v46 (copy)
		local t3 = {
			{
				id = "details",
				icon = not v42 and "icons/actions/viewOff" or "icons/actions/viewOn",
				text = if not v42 then v34.hideDetails else v34.showDetails,
				onActivated = v44
			},
			{
				id = "minimize",
				icon = not v43 and "icons/actions/previewShrink" or "icons/actions/previewExpand",
				text = if not v43 then v34.minimize else v34.expand,
				onActivated = v45
			}
		}

		if t2.moment.creatorId ~= if not LocalPlayer then nil else LocalPlayer.UserId then
			table.insert(t3, {
				id = "reportAbuse",
				icon = "icons/actions/feedback",
				text = v34.report,
				onActivated = v47
			})
		else
			table.insert(t3, {
				id = "delete",
				icon = "icons/actions/delete",
				text = v34.delete,
				onActivated = v48
			})
		end

		if checkDebugAccess() then
			table.insert(t3, {
				id = "debug",
				icon = "icons/logo/block",
				text = "Toggle Debug Mode",
				onActivated = v46
			})
		end

		return t3
	end, {
		t2.moment,
		v42,
		v43,
		v34,
		v46,
		v44,
		v45,
		v47,
		v48
	})
	local v53 = React.createElement(Menu, {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = v36.enabled,
		items = v52,
		onPressedOutside = v36.disable,
		side = Foundation.Enums.PopoverSide.Left
	}, {
		ContextualMenuButton = React.createElement(IconButton, {
			testId = "FeedContextualMenuButton",
			icon = ThreeDotsVertical,
			isDisabled = t2.isDisabled,
			onActivated = v37,
			size = Foundation.Enums.InputSize.Large
		})
	})

	if not t2.isFeedMuteEnabled then
		return React.createElement(View, {
			tag = "col align-x-center auto-xy",
			LayoutOrder = t2.layoutOrder
		}, {
			ContextMenuPopover = v53
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
				onActivated = v51,
				size = Foundation.Enums.InputSize.Medium
			}),
			ContextMenuPopover = v53
		})
	})
end
