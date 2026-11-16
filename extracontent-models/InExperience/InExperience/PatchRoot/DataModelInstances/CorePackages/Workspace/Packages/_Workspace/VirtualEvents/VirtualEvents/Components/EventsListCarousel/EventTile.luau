local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local parent = VirtualEvents.Parent
local React = require(parent.React)
local GameTile = require(parent.GameTile)
require(parent.GraphQLServer)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local Impressions = require(parent.Impressions)
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local GamePlayButton = require(parent.GamePlayButton)
local NotificationModalsManager = require(parent.NotificationModalsManager)
local Style = require(parent.Style)
local UIBlox = require(parent.UIBlox)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local useDesignTokens = Style.useDesignTokens
local HoldToPlay = require(parent.HoldToPlay)
local HoldDetector = HoldToPlay.HoldDetector
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

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

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSduiEventDetailsEnabled = SharedFlags2.FFlagLuaAppSduiEventDetailsEnabled

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppGameViewTileBackgroundColorOverride = SharedFlags3.FFlagLuaAppGameViewTileBackgroundColorOverride

local function fn() end

return function(props)
	local v = useDesignTokens()
	local textSizeOffset = useTextSizeOffset()
	local event = props.Event
	local virtualEventDates = getVirtualEventDates(event)

	local v2 = DateTime.now().UnixTimestamp >= virtualEventDates.startDate.UnixTimestamp
	local v3 = event.userRsvpStatus == "going"
	local buttonStyle = useMemo(function()
		if v2 then
			return FooterCornerButtonStyle.Play
		end

		if v3 then
			return FooterCornerButtonStyle.Following
		end

		return FooterCornerButtonStyle.Follow
	end, { v2, v3 })

	local v4 = useRoactService(RoactNetworking)
	local v5 = usePlayButtonState(v4, props.Event.universeId or "")
	local v6 = v5.playButtonState == PlayButtonStates.Playable
		or GetFFlagIsSquadEnabled() and v5.playButtonState == PlayButtonStates.PlayableWithParty

	local v7 = useLocalization({
		HappeningNow = "Feature.Home.Label.HappeningNow",
		DateAtTime = "Feature.VirtualEvents.Label.DateAtTime",
		ToastText = "Feature.VirtualEvents.Label.ReminderSetForEventTime"
	})

	local v8 = useCallback(function()
		if not v6 then
			return
		end

		if v2 then
			props.onJoinEvent(event)
			return
		end

		local v8 = event.userRsvpStatus == "going" and "notGoing" or "going"

		if props.onRsvpChanged then
			props.onRsvpChanged(event, v8)
		end
	end, { v2, props.onJoinEvent, props.onRsvpChanged, event.userRsvpStatus, event, v6 })

	local ref = React.useRef(event.userRsvpStatus)

	local function fn2()
		if
			not (FFlagLuaAppSduiEventDetailsEnabled and props.suppressRsvpReminderToastBecauseEventDetailsFocused)
			and ref.current
			and ref.current ~= "going"
			and event.userRsvpStatus == "going"
		then
			local eventTime = formatDateLocalized(v7.DateAtTime, virtualEventDates.startDate)
			local toastTitle = v7.ToastText:gsub("{(.-)}", {
				eventName = event.displayTitle,
				eventTime = eventTime
			})

			NotificationModalsManager.SetUIBloxToast({
				toastTitle = toastTitle,
				sequenceNumber = DateTime.now().UnixTimestamp
			})
		end

		ref.current = event.userRsvpStatus
	end

	local userRsvpStatus = event.userRsvpStatus
	local displayTitle = event.displayTitle
	local startDate = virtualEventDates.startDate
	local dateAtTime = v7.DateAtTime
	local toastText = v7.ToastText
	local v9

	if FFlagLuaAppSduiEventDetailsEnabled then
		v9 = props.suppressRsvpReminderToastBecauseEventDetailsFocused
	end

	useEffect(fn2, { userRsvpStatus, displayTitle, startDate, dateAtTime, toastText, v9 })

	local state, setState = useState(nil)

	useEffect(function()
		local flag = true
		fetchEventThumbnail(v4, event.id, props.DefaultThumbnail):andThen(function(p)
			if flag then
				setState(p)
			end
		end)
		return function()
			flag = false
		end
	end, { event.id, props.DefaultThumbnail })

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		ImpressionsTagUtility.AddTag(ref2, props.impressionsTag, props.layoutOrder)
		return function()
			ImpressionsTagUtility.RemoveTag(ref2, props.impressionsTag, props.layoutOrder)
		end
	end, { ref2, props.impressionsTag, props.layoutOrder })

	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(false)
	local setDisabledForHold = React.useCallback(function(current: boolean)
		ref4.current = current
	end, {})

	local eventCtaButtonState = getEventCtaButtonState(v5)
	local isJoinEventDisabled = eventCtaButtonState.isJoinEventDisabled
	local disabled = eventCtaButtonState.isRsvpDisabled
	local focusNavigationEventName

	if buttonStyle == FooterCornerButtonStyle.Follow then
		focusNavigationEventName = FocusNavigationEventNameEnum.HoldToNotifyMe
	elseif buttonStyle == FooterCornerButtonStyle.Following then
		focusNavigationEventName = FocusNavigationEventNameEnum.HoldToUnfollowEvent
	else
		focusNavigationEventName = FocusNavigationEventNameEnum.HoldToJoinEvent
		disabled = isJoinEventDisabled
	end

	if disabled then
		v8 = fn
	end

	local onActivated = useCallback(function()
		if ref4.current then
			return
		end

		props.onTileActivated(props.Event)
	end, { props.onTileActivated, props.Event })

	local createElement = React.createElement
	local v10 = {
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Size = props.size,
		ref = ref2
	}

	local createElement2 = React.createElement
	local backgroundStyle

	if FFlagLuaAppGameViewTileBackgroundColorOverride then
		backgroundStyle = props.backgroundStyle
	end

	local children = {
		forwardRef = ref3,
		imageAspectRatio = 16 / 9,
		image = state,
		backgroundStyle = backgroundStyle,
		isContained = true,
		Size = UDim2.fromScale(1, 1),
		title = event.displayTitle or "",
		onActivated = onActivated,
		footerMetadata = React.createElement(GridTileTextFooter, {
			text = event.displaySubtitle or event.displayDescription or "",
			useLargerFont = true
		}),
		thumbnailOverlay = 0,
		hidePlayButton = true,
		isHovered = false,
		extraFooterSpace = 0,
		extraFooterContent = 0,
		textSizeOffset = 0
	}

	local createElement3 = React.createElement
	local text

	if v2 then
		text = v7.HappeningNow
	else
		text = formatDateLocalized(v7.DateAtTime, virtualEventDates.startDate)
	end

	children.thumbnailOverlay = createElement3(GameTileThumbnailBadges, {
		tileBadgesByPosition = {
			ImageTopLeft = {
				{ tileBadgeType = "Text", text = text }
			}
		}
	})
	local extraFooterSpace

	if not props.disableButtons then
		extraFooterSpace = v.Size.Size_700 + v.Size.Size_200
	end

	children.extraFooterSpace = extraFooterSpace
	local extraFooterContent

	if not props.disableButtons then
		extraFooterContent = React.createElement(EventWideFooterButton, {
			buttonStyle = buttonStyle,
			disabled = disabled,
			onActivated = v8,
			key = "WideFooterButton"
		})
	end

	children.extraFooterContent = extraFooterContent

	children.textSizeOffset = textSizeOffset
	local v11 = {
		GameTile = createElement2(GameTileView, children),
		HoldDetector = 0
	}
	local holdDetector

	if ref3 and ref3.current then
		holdDetector = React.createElement(HoldDetector, {
			guiObject = ref3.current,
			onHoldDetected = v8,
			setDisabledForHold = setDisabledForHold,
			keyCode = Enum.KeyCode.ButtonA,
			focusNavigationEventName = focusNavigationEventName
		})
	end

	v11.HoldDetector = holdDetector
	return createElement("Frame", v10, v11)
end
