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

return function(t2: {[any]: any}) -- line: 69
	-- upvalues: useLocalization (copy), t1 (copy), useFeed (copy), useToggleState (copy), React (copy), useMomentsSession (copy), GetMomentsPreferencesStore (copy), GetModeratedItemsStore (copy), GetToastStore (copy), SignalsReact (copy), fireAnalyticsEvent (copy), EventNames (copy), checkDebugAccess (copy), reportMoment (copy), SignalActionType (copy), LocalPlayer (copy), Menu (copy), Foundation (copy), IconButton (copy), ThreeDotsVertical (copy), View (copy), SpeakerSlash (copy), Speaker (copy)
	local v31 = useLocalization(t1)
	local v32 = useFeed()
	local v33 = useToggleState()
	local v34 = React.useCallback(function() -- line: 77
		-- upvalues: v33 (copy)
		if v33.enabled then
			v33.disable()

			return
		end

		v33.enable()
	end, {
		v33.enabled,
		v33.enable,
		v33.disable
	})
	local v35 = useMomentsSession()
	local v36 = GetMomentsPreferencesStore(false)
	local v37 = GetModeratedItemsStore(false)
	local v38 = GetToastStore(false)
	local v39 = SignalsReact.useSignalState(v35.getHideDetails)
	local v40 = SignalsReact.useSignalState(v36.getMinimized)
	local v41 = React.useCallback(function() -- line: 93
		-- upvalues: v33 (copy), v35 (copy), fireAnalyticsEvent (copy), EventNames (copy), t2 (copy)
		v33.disable()
		v35.toggleFeedDetailVisibility()
		fireAnalyticsEvent(EventNames.FeedHideDetailsButtonPressed, {
			momentId = t2.moment.momentId
		})
	end, {
		t2.moment,
		v33.disable,
		v35.toggleFeedDetailVisibility
	})
	local v42 = React.useCallback(function() -- line: 101
		-- upvalues: v33 (copy), v36 (copy), fireAnalyticsEvent (copy), EventNames (copy), t2 (copy)
		v33.disable()
		v36.toggleFeedScaleType()
		fireAnalyticsEvent(EventNames.FeedMinimizeButtonPressed, {
			momentId = t2.moment.momentId
		})
	end, {
		t2.moment,
		v33.disable,
		v36.toggleFeedScaleType
	})
	local v43 = React.useCallback(function() -- line: 109
		-- upvalues: checkDebugAccess (copy), v36 (copy), v33 (copy)
		if checkDebugAccess() then
			v36.toggleFeedDebugMode()
		end

		v33.disable()
	end, {
		v33.disable,
		v36.toggleFeedDebugMode
	})
	local v44 = React.useCallback(function() -- line: 117
		-- upvalues: v33 (copy), t2 (copy), reportMoment (copy), v32 (copy), SignalActionType (copy), fireAnalyticsEvent (copy), EventNames (copy), v37 (copy), v38 (copy), v31 (copy)
		v33.disable()
		task.spawn(function() -- line: 119
			-- upvalues: t2 (copy), reportMoment (copy), v32 (copy), SignalActionType (copy), fireAnalyticsEvent (copy), EventNames (copy), v37 (copy), v38 (copy), v31 (copy)
			if not t2.moment then
				return
			end

			local _, _ = pcall(function() -- line: 124
				-- upvalues: reportMoment (copy), t2 (copy)
				return reportMoment(t2.moment.momentId):await()
			end)
			local recommendationMetadata = t2.moment.recommendationMetadata

			if recommendationMetadata then
				local ok, result = pcall(function() -- line: 134
					-- upvalues: v32 (copy), SignalActionType (copy), recommendationMetadata (copy)
					v32.logAction(SignalActionType.Report, {
						itemId = recommendationMetadata.itemId,
						tracingId = recommendationMetadata.tracingId
					}, {})
				end)

				if not ok then
					warn("Failed to log action event", result)
				end
			end

			fireAnalyticsEvent(EventNames.FeedAbuseReported, {
				momentId = t2.moment.momentId
			})
			v37.markReported(t2.moment.momentId)
			v32.removeCurrentItem()
			v38.triggerToast({
				title = v31.reportSubmittedTitle,
				text = v31.reportSubmittedBody
			})
		end)
	end, {
		t2.moment,
		v32.logAction,
		v32.removeCurrentItem,
		v33.disable,
		v37.markReported,
		v38.triggerToast,
		v31
	})
	local v45 = React.useCallback(function() -- line: 170
		-- upvalues: v33 (copy), v35 (copy), t2 (copy)
		v33.disable()
		v35.requestDeletion(t2.moment.momentId)
	end, {
		t2.moment,
		v33.disable,
		v35.requestDeletion
	})
	local v46 = React.useCallback(function() -- line: 176
		-- upvalues: t2 (copy)
		if t2.isDisabled then
			return
		end

		t2.playbackVolume.toggle()
	end, {
		t2.isDisabled,
		t2.playbackVolume
	})
	local v47 = React.useCallback(function() -- line: 189
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
	local v48 = if not t2.isFeedMuteButtonAnalyticsEnabled then v46 else v47
	local v49 = React.useMemo(function() -- line: 215
		-- upvalues: v39 (copy), v31 (copy), v41 (copy), v40 (copy), v42 (copy), t2 (copy), LocalPlayer (copy), v44 (copy), v45 (copy), checkDebugAccess (copy), v43 (copy)
		local t3 = {
			{
				id = "details",
				icon = not v39 and "icons/actions/viewOff" or "icons/actions/viewOn",
				text = if not v39 then v31.hideDetails else v31.showDetails,
				onActivated = v41
			},
			{
				id = "minimize",
				icon = not v40 and "icons/actions/previewShrink" or "icons/actions/previewExpand",
				text = if not v40 then v31.minimize else v31.expand,
				onActivated = v42
			}
		}

		if t2.moment.creatorId ~= if not LocalPlayer then nil else LocalPlayer.UserId then
			table.insert(t3, {
				id = "reportAbuse",
				icon = "icons/actions/feedback",
				text = v31.report,
				onActivated = v44
			})
		else
			table.insert(t3, {
				id = "delete",
				icon = "icons/actions/delete",
				text = v31.delete,
				onActivated = v45
			})
		end

		if checkDebugAccess() then
			table.insert(t3, {
				id = "debug",
				icon = "icons/logo/block",
				text = "Toggle Debug Mode",
				onActivated = v43
			})
		end

		return t3
	end, {
		t2.moment,
		v39,
		v40,
		v31,
		v43,
		v41,
		v42,
		v44,
		v45
	})
	local v50 = React.createElement(Menu, {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = v33.enabled,
		items = v49,
		onPressedOutside = v33.disable,
		side = Foundation.Enums.PopoverSide.Left
	}, {
		ContextualMenuButton = React.createElement(IconButton, {
			testId = "FeedContextualMenuButton",
			icon = ThreeDotsVertical,
			isDisabled = t2.isDisabled,
			onActivated = v34,
			size = Foundation.Enums.InputSize.Large
		})
	})

	if not t2.isFeedMuteEnabled then
		return React.createElement(View, {
			tag = "col align-x-center auto-xy",
			LayoutOrder = t2.layoutOrder
		}, {
			ContextMenuPopover = v50
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
				onActivated = v48,
				size = Foundation.Enums.InputSize.Medium
			}),
			ContextMenuPopover = v50
		})
	})
end
