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
local FFlagLuaAppGameViewTileBackgroundColorOverride = require(VirtualEventsParent.SharedFlags).FFlagLuaAppGameViewTileBackgroundColorOverride

local function v35() -- line: 67
end

return function(t1: {[any]: any}) -- line: 71
	-- upvalues: useDesignTokens (copy), useTextSizeOffset (copy), getVirtualEventDates (copy), useMemo (copy), FooterCornerButtonStyle (copy), useRoactService (copy), RoactNetworking (copy), usePlayButtonState (copy), PlayButtonStates (copy), GetFFlagIsSquadEnabled (copy), useLocalization (copy), useCallback (copy), React (copy), useEffect (copy), FFlagLuaAppSduiEventDetailsEnabled (copy), formatDateLocalized (copy), NotificationModalsManager (copy), useState (copy), fetchEventThumbnail (copy), ImpressionsTagUtility (copy), FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable (copy), getEventCtaButtonState (copy), FocusNavigationEventNameEnum (copy), v35 (copy), GameTileView (copy), FFlagLuaAppGameViewTileBackgroundColorOverride (copy), GridTileTextFooter (copy), GameTileThumbnailBadges (copy), EventWideFooterButton (copy), HoldDetector (copy)
	local v37 = useDesignTokens()
	local v38 = useTextSizeOffset()
	local Event = t1.Event
	local v40 = getVirtualEventDates(Event)
	local v41 = DateTime.now().UnixTimestamp >= v40.startDate.UnixTimestamp
	local v42 = Event.userRsvpStatus == "going"
	local v43 = useMemo(function() -- line: 79
		-- upvalues: v41 (copy), FooterCornerButtonStyle (copy), v42 (copy)
		if v41 then
			return FooterCornerButtonStyle.Play
		end

		if v42 then
			return FooterCornerButtonStyle.Following
		end

		return FooterCornerButtonStyle.Follow
	end, {
		v41,
		v42
	})
	local v44 = useRoactService(RoactNetworking)
	local v45 = usePlayButtonState(v44, t1.Event.universeId or "")
	local v46 = v45.playButtonState == PlayButtonStates.Playable or GetFFlagIsSquadEnabled() and v45.playButtonState == PlayButtonStates.PlayableWithParty
	local v47 = useLocalization({
		HappeningNow = "Feature.Home.Label.HappeningNow",
		DateAtTime = "Feature.VirtualEvents.Label.DateAtTime",
		ToastText = "Feature.VirtualEvents.Label.ReminderSetForEventTime"
	})
	local v48 = useCallback(function() -- line: 100
		-- upvalues: v46 (copy), v41 (copy), t1 (copy), Event (copy)
		if not v46 then
			return
		end

		if v41 then
			t1.onJoinEvent(Event)

			return
		end

		local v63 = Event.userRsvpStatus == "going" and "notGoing" or "going"

		if t1.onRsvpChanged then
			t1.onRsvpChanged(Event, v63)
		end
	end, {
		v41,
		t1.onJoinEvent,
		t1.onRsvpChanged,
		Event.userRsvpStatus,
		Event,
		v46
	})
	local v49 = React.useRef(Event.userRsvpStatus)

	useEffect(function() -- line: 122
		-- upvalues: FFlagLuaAppSduiEventDetailsEnabled (copy), t1 (copy), v49 (copy), Event (copy), formatDateLocalized (copy), v47 (copy), v40 (copy), NotificationModalsManager (copy)
		if (not FFlagLuaAppSduiEventDetailsEnabled or not t1.suppressRsvpReminderToastBecauseEventDetailsFocused) and (v49.current and v49.current ~= "going" and Event.userRsvpStatus == "going") then
			local v64 = formatDateLocalized(v47.DateAtTime, v40.startDate)
			local v65 = v47.ToastText:gsub("{(.-)}", {
				eventName = Event.displayTitle,
				eventTime = v64
			})

			NotificationModalsManager.SetUIBloxToast({
				toastTitle = v65,
				sequenceNumber = DateTime.now().UnixTimestamp
			})
		end

		v49.current = Event.userRsvpStatus
	end, {
		Event.userRsvpStatus,
		Event.displayTitle,
		v40.startDate,
		v47.DateAtTime,
		v47.ToastText,
		if not FFlagLuaAppSduiEventDetailsEnabled then nil else t1.suppressRsvpReminderToastBecauseEventDetailsFocused
	})

	local v50, v51 = useState(nil)

	useEffect(function() -- line: 156
		-- upvalues: fetchEventThumbnail (copy), v44 (copy), Event (copy), t1 (copy), v51 (copy)
		local u66 = true

		fetchEventThumbnail(v44, Event.id, t1.DefaultThumbnail):andThen(function(p1) -- line: 158
			-- upvalues: u66 (ref), v51 (copy)
			if u66 then
				v51(p1)
			end
		end)

		return function() -- line: 163
			-- upvalues: u66 (ref)
			u66 = false
		end
	end, {
		Event.id,
		t1.DefaultThumbnail
	})

	local v52 = React.useRef(nil)

	React.useEffect(function() -- line: 169
		-- upvalues: ImpressionsTagUtility (copy), v52 (copy), t1 (copy)
		ImpressionsTagUtility.AddTag(v52, t1.impressionsTag, t1.layoutOrder)

		return function() -- line: 171
			-- upvalues: ImpressionsTagUtility (copy), v52 (copy), t1 (copy)
			ImpressionsTagUtility.RemoveTag(v52, t1.impressionsTag, t1.layoutOrder)
		end
	end, {
		v52,
		t1.impressionsTag,
		t1.layoutOrder
	})

	local v53 = React.useRef(nil)
	local v54 = React.useRef(false)
	local v55 = React.useCallback(function(b1: boolean) -- line: 180
		-- upvalues: v54 (copy)
		v54.current = b1
	end, {})
	local isRsvpDisabled = nil
	local isJoinEventDisabled = nil

	if FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then
		local v58 = getEventCtaButtonState(v45)

		isJoinEventDisabled = v58.isJoinEventDisabled
		isRsvpDisabled = v58.isRsvpDisabled
	end

	local v59 = nil
	local HoldToNotifyMe

	if v43 == FooterCornerButtonStyle.Follow then
		HoldToNotifyMe = FocusNavigationEventNameEnum.HoldToNotifyMe

		if FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then
			v59 = isRsvpDisabled
		end
	elseif v43 == FooterCornerButtonStyle.Following then
		HoldToNotifyMe = FocusNavigationEventNameEnum.HoldToUnfollowEvent

		if FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then
			v59 = isRsvpDisabled
		end
	else
		HoldToNotifyMe = FocusNavigationEventNameEnum.HoldToJoinEvent

		if FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then
			v59 = isJoinEventDisabled
		end
	end

	local v61 = if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable or not v59 then v48 else v35
	local v62 = useCallback(function() -- line: 217
		-- upvalues: v54 (copy), t1 (copy)
		if v54.current then
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
		ref = v52
	}, {
		GameTile = React.createElement(GameTileView, {
			imageAspectRatio = 1.7777777777777777,
			isContained = true,
			hidePlayButton = true,
			isHovered = false,
			forwardRef = v53,
			image = v50,
			backgroundStyle = if not FFlagLuaAppGameViewTileBackgroundColorOverride then nil else t1.backgroundStyle,
			Size = UDim2.fromScale(1, 1),
			title = Event.displayTitle or "",
			onActivated = v62,
			footerMetadata = React.createElement(GridTileTextFooter, {
				useLargerFont = true,
				text = Event.displaySubtitle or (Event.displayDescription or "")
			}),
			thumbnailOverlay = React.createElement(GameTileThumbnailBadges, {
				tileBadgesByPosition = {
					ImageTopLeft = {{
						tileBadgeType = "Text",
						text = if not v41 then formatDateLocalized(v47.DateAtTime, v40.startDate) else v47.HappeningNow
					}}
				}
			}),
			extraFooterSpace = if t1.disableButtons then nil else v37.Size.Size_700 + v37.Size.Size_200,
			extraFooterContent = if t1.disableButtons then nil else React.createElement(EventWideFooterButton, {
				key = "WideFooterButton",
				buttonStyle = v43,
				disabled = if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then not v46 else v59,
				onActivated = if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then v48 else v61
			}),
			textSizeOffset = v38
		}),
		HoldDetector = if not v53 or not v53.current then nil else React.createElement(HoldDetector, {
			guiObject = v53.current,
			onHoldDetected = if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then v48 else v61,
			setDisabledForHold = v55,
			keyCode = Enum.KeyCode.ButtonA,
			focusNavigationEventName = HoldToNotifyMe
		})
	})
end
