local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local VirtualEventsParent = VirtualEvents.Parent
local React = require(VirtualEventsParent.React)
local GameTile = require(VirtualEventsParent.GameTile)

require(VirtualEventsParent.GraphQLServer)

local RoactNetworking = require(VirtualEventsParent.RoactServiceTags).RoactNetworking
local ImpressionsTagUtility = require(VirtualEventsParent.Impressions).ImpressionsTagUtility
local useRoactService = require(VirtualEventsParent.RobloxAppHooks).useRoactService
local useLocalization = require(VirtualEventsParent.Localization).Hooks.useLocalization
local GamePlayButton = require(VirtualEventsParent.GamePlayButton)
local NotificationModalsManager = require(VirtualEventsParent.NotificationModalsManager)
local Style = require(VirtualEventsParent.Style)
local useTextSizeOffset = require(VirtualEventsParent.UIBlox).Core.Style.useTextSizeOffset
local useDesignTokens = Style.useDesignTokens
local HoldDetector = require(VirtualEventsParent.HoldToPlay).HoldDetector
local FocusNavigationEventNameEnum = require(VirtualEventsParent.FocusNavigationUtils).FocusNavigationEventNameEnum
local GameTileView = GameTile.GameTileView
local GridTileTextFooter = GameTile.GridTileTextFooter
local GameTileThumbnailBadges = GameTile.GameTileThumbnailBadges
local FooterCornerButtonStyle = GameTile.FooterCornerButtonStyle
local usePlayButtonState = GamePlayButton.usePlayButtonState
local PlayButtonStates = GamePlayButton.PlayButtonStates
local formatDateLocalized = require(VirtualEvents.Common.formatDateLocalized)
local getVirtualEventDates = require(VirtualEvents.Common.getVirtualEventDates)
local fetchEventThumbnail = require(VirtualEvents.Common.fetchEventThumbnail)
local getEventCtaButtonState = require(VirtualEvents.Common.getEventCtaButtonState)
local EventWideFooterButton = require(VirtualEvents.Components.EventsListCarousel.EventWideFooterButton)
local useEffect = React.useEffect
local useState = React.useState
local useMemo = React.useMemo
local useCallback = React.useCallback
local GetFFlagIsSquadEnabled = require(VirtualEventsParent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagLuaAppSduiEventDetailsEnabled = require(VirtualEventsParent.SharedFlags).FFlagLuaAppSduiEventDetailsEnabled
local FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable = require(VirtualEventsParent.SharedFlags).FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable

local function v34() -- line: 63
end

return function(t1: {[any]: any}) -- line: 67
	-- upvalues: useDesignTokens (copy), useTextSizeOffset (copy), getVirtualEventDates (copy), useMemo (copy), FooterCornerButtonStyle (copy), useRoactService (copy), RoactNetworking (copy), usePlayButtonState (copy), PlayButtonStates (copy), GetFFlagIsSquadEnabled (copy), useLocalization (copy), useCallback (copy), React (copy), useEffect (copy), FFlagLuaAppSduiEventDetailsEnabled (copy), formatDateLocalized (copy), NotificationModalsManager (copy), useState (copy), fetchEventThumbnail (copy), ImpressionsTagUtility (copy), FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable (copy), getEventCtaButtonState (copy), FocusNavigationEventNameEnum (copy), v34 (copy), GameTileView (copy), GridTileTextFooter (copy), GameTileThumbnailBadges (copy), EventWideFooterButton (copy), HoldDetector (copy)
	local v36 = useDesignTokens()
	local v37 = useTextSizeOffset()
	local Event = t1.Event
	local v39 = getVirtualEventDates(Event)
	local v40 = DateTime.now().UnixTimestamp >= v39.startDate.UnixTimestamp
	local v41 = Event.userRsvpStatus == "going"
	local v42 = useMemo(function() -- line: 75
		-- upvalues: v40 (copy), FooterCornerButtonStyle (copy), v41 (copy)
		if v40 then
			return FooterCornerButtonStyle.Play
		end

		if v41 then
			return FooterCornerButtonStyle.Following
		end

		return FooterCornerButtonStyle.Follow
	end, {
		v40,
		v41
	})
	local v43 = useRoactService(RoactNetworking)
	local v44 = usePlayButtonState(v43, t1.Event.universeId or "")
	local v45 = v44.playButtonState == PlayButtonStates.Playable or GetFFlagIsSquadEnabled() and v44.playButtonState == PlayButtonStates.PlayableWithParty
	local v46 = useLocalization({
		HappeningNow = "Feature.Home.Label.HappeningNow",
		DateAtTime = "Feature.VirtualEvents.Label.DateAtTime",
		ToastText = "Feature.VirtualEvents.Label.ReminderSetForEventTime"
	})
	local v47 = useCallback(function() -- line: 96
		-- upvalues: v45 (copy), v40 (copy), t1 (copy), Event (copy)
		if not v45 then
			return
		end

		if v40 then
			t1.onJoinEvent(Event)

			return
		end

		local v62 = Event.userRsvpStatus == "going" and "notGoing" or "going"

		if t1.onRsvpChanged then
			t1.onRsvpChanged(Event, v62)
		end
	end, {
		v40,
		t1.onJoinEvent,
		t1.onRsvpChanged,
		Event.userRsvpStatus,
		Event,
		v45
	})
	local v48 = React.useRef(Event.userRsvpStatus)

	useEffect(function() -- line: 118
		-- upvalues: FFlagLuaAppSduiEventDetailsEnabled (copy), t1 (copy), v48 (copy), Event (copy), formatDateLocalized (copy), v46 (copy), v39 (copy), NotificationModalsManager (copy)
		if (not FFlagLuaAppSduiEventDetailsEnabled or not t1.suppressRsvpReminderToastBecauseEventDetailsFocused) and (v48.current and v48.current ~= "going" and Event.userRsvpStatus == "going") then
			local v63 = formatDateLocalized(v46.DateAtTime, v39.startDate)
			local v64 = v46.ToastText:gsub("{(.-)}", {
				eventName = Event.displayTitle,
				eventTime = v63
			})

			NotificationModalsManager.SetUIBloxToast({
				toastTitle = v64,
				sequenceNumber = DateTime.now().UnixTimestamp
			})
		end

		v48.current = Event.userRsvpStatus
	end, {
		Event.userRsvpStatus,
		Event.displayTitle,
		v39.startDate,
		v46.DateAtTime,
		v46.ToastText,
		if not FFlagLuaAppSduiEventDetailsEnabled then nil else t1.suppressRsvpReminderToastBecauseEventDetailsFocused
	})

	local v49, v50 = useState(nil)

	useEffect(function() -- line: 152
		-- upvalues: fetchEventThumbnail (copy), v43 (copy), Event (copy), t1 (copy), v50 (copy)
		local u65 = true

		fetchEventThumbnail(v43, Event.id, t1.DefaultThumbnail):andThen(function(p1) -- line: 154
			-- upvalues: u65 (ref), v50 (copy)
			if u65 then
				v50(p1)
			end
		end)

		return function() -- line: 159
			-- upvalues: u65 (ref)
			u65 = false
		end
	end, {
		Event.id,
		t1.DefaultThumbnail
	})

	local v51 = React.useRef(nil)

	React.useEffect(function() -- line: 165
		-- upvalues: ImpressionsTagUtility (copy), v51 (copy), t1 (copy)
		ImpressionsTagUtility.AddTag(v51, t1.impressionsTag, t1.layoutOrder)

		return function() -- line: 167
			-- upvalues: ImpressionsTagUtility (copy), v51 (copy), t1 (copy)
			ImpressionsTagUtility.RemoveTag(v51, t1.impressionsTag, t1.layoutOrder)
		end
	end, {
		v51,
		t1.impressionsTag,
		t1.layoutOrder
	})

	local v52 = React.useRef(nil)
	local v53 = React.useRef(false)
	local v54 = React.useCallback(function(b1: boolean) -- line: 176
		-- upvalues: v53 (copy)
		v53.current = b1
	end, {})
	local isRsvpDisabled = nil
	local isJoinEventDisabled = nil

	if FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then
		local v57 = getEventCtaButtonState(v44)

		isJoinEventDisabled = v57.isJoinEventDisabled
		isRsvpDisabled = v57.isRsvpDisabled
	end

	local v58 = nil
	local HoldToNotifyMe

	if v42 == FooterCornerButtonStyle.Follow then
		HoldToNotifyMe = FocusNavigationEventNameEnum.HoldToNotifyMe

		if FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then
			v58 = isRsvpDisabled
		end
	elseif v42 == FooterCornerButtonStyle.Following then
		HoldToNotifyMe = FocusNavigationEventNameEnum.HoldToUnfollowEvent

		if FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then
			v58 = isRsvpDisabled
		end
	else
		HoldToNotifyMe = FocusNavigationEventNameEnum.HoldToJoinEvent

		if FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then
			v58 = isJoinEventDisabled
		end
	end

	local v60 = if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable or not v58 then v47 else v34
	local v61 = useCallback(function() -- line: 213
		-- upvalues: v53 (copy), t1 (copy)
		if v53.current then
			return
		end

		t1.onTileActivated(t1.Event)
	end, {
		t1.onTileActivated,
		t1.Event
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = t1.size,
		ref = v51
	}, {
		GameTile = React.createElement(GameTileView, {
			imageAspectRatio = 1.7777777777777777,
			isContained = true,
			hidePlayButton = true,
			isHovered = false,
			forwardRef = v52,
			image = v49,
			Size = UDim2.fromScale(1, 1),
			title = Event.displayTitle or "",
			onActivated = v61,
			footerMetadata = React.createElement(GridTileTextFooter, {
				useLargerFont = true,
				text = Event.displaySubtitle or (Event.displayDescription or "")
			}),
			thumbnailOverlay = React.createElement(GameTileThumbnailBadges, {
				tileBadgesByPosition = {
					ImageTopLeft = {{
						tileBadgeType = "Text",
						text = if not v40 then formatDateLocalized(v46.DateAtTime, v39.startDate) else v46.HappeningNow
					}}
				}
			}),
			extraFooterSpace = if t1.disableButtons then nil else v36.Size.Size_700 + v36.Size.Size_200,
			extraFooterContent = if t1.disableButtons then nil else React.createElement(EventWideFooterButton, {
				key = "WideFooterButton",
				buttonStyle = v42,
				disabled = if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then not v45 else v58,
				onActivated = if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then v47 else v60
			}),
			textSizeOffset = v37
		}),
		HoldDetector = if not v52 or not v52.current then nil else React.createElement(HoldDetector, {
			guiObject = v52.current,
			onHoldDetected = if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then v47 else v60,
			setDisabledForHold = v54,
			keyCode = Enum.KeyCode.ButtonA,
			focusNavigationEventName = HoldToNotifyMe
		})
	})
end
