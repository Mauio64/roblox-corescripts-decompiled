local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GameTile")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactServiceTags").RoactNetworking
local impressionsTagUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Impressions").ImpressionsTagUtility
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppHooks").useRoactService
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization
local GamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GamePlayButton")
local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/NotificationModalsManager")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Style")
local useTextSizeOffset = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox").Core.Style.useTextSizeOffset
local useDesignTokens = Style.useDesignTokens
local holdDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/HoldToPlay").HoldDetector
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/FocusNavigationUtils").FocusNavigationEventNameEnum

local gameTileView = module2.GameTileView
local gridTileTextFooter = module2.GridTileTextFooter
local gameTileThumbnailBadges = module2.GameTileThumbnailBadges
local footerCornerButtonStyle = module2.FooterCornerButtonStyle

local usePlayButtonState = GamePlayButton.usePlayButtonState
local playButtonStates = GamePlayButton.PlayButtonStates

local formatDateLocalized = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/formatDateLocalized")
local getVirtualEventDates = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/getVirtualEventDates")
local fetchEventThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/fetchEventThumbnail")
local getEventCtaButtonState = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/getEventCtaButtonState")
local EventWideFooterButton = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventsListCarousel/EventWideFooterButton")

local useEffect = React.useEffect
local useState = React.useState
local useMemo = React.useMemo
local useCallback = React.useCallback

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").GetFFlagIsSquadEnabled
local fFlagLuaAppSduiEventDetailsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagLuaAppSduiEventDetailsEnabled

local fFlagLuaAppGameViewTileBackgroundColorOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagLuaAppGameViewTileBackgroundColorOverride

local function fn() end

return function(props)
	local v5 = useDesignTokens()
	local v6 = useTextSizeOffset()
	local event = props.Event
	local v7 = getVirtualEventDates(event)

	local v8 = DateTime.now().UnixTimestamp >= v7.startDate.UnixTimestamp
	local v9 = event.userRsvpStatus == "going"
	local v10 = useMemo(function()
		if v8 then
			return footerCornerButtonStyle.Play
		end

		if v9 then
			return footerCornerButtonStyle.Following
		end

		return footerCornerButtonStyle.Follow
	end, { v8, v9 })

	local v11 = useRoactService(roactNetworking)
	local v12 = usePlayButtonState(v11, props.Event.universeId or "")
	local v13 = v12.playButtonState == playButtonStates.Playable
		or getFFlagIsSquadEnabled() and v12.playButtonState == playButtonStates.PlayableWithParty

	local v14 = useLocalization({
		HappeningNow = "Feature.Home.Label.HappeningNow",
		DateAtTime = "Feature.VirtualEvents.Label.DateAtTime",
		ToastText = "Feature.VirtualEvents.Label.ReminderSetForEventTime"
	})

	local v15 = useCallback(function()
		if not v13 then
			return
		end

		if v8 then
			props.onJoinEvent(event)
			return
		end

		local v16 = event.userRsvpStatus == "going" and "notGoing" or "going"

		if props.onRsvpChanged then
			props.onRsvpChanged(event, v16)
		end
	end, {
		v8,
		props.onJoinEvent,
		props.onRsvpChanged,
		event.userRsvpStatus,
		event,
		v13
	})

	local ref = React.useRef(event.userRsvpStatus)

	local function fn2()
		if
			not (fFlagLuaAppSduiEventDetailsEnabled and props.suppressRsvpReminderToastBecauseEventDetailsFocused)
			and ref.current
			and ref.current ~= "going"
			and event.userRsvpStatus == "going"
		then
			local v17 = formatDateLocalized(v14.DateAtTime, v7.startDate)
			local v18 = v14.ToastText:gsub("{(.-)}", {
				eventName = event.displayTitle,
				eventTime = v17
			})

			NotificationModalsManager.SetUIBloxToast({
				toastTitle = v18,
				sequenceNumber = DateTime.now().UnixTimestamp
			})
		end

		ref.current = event.userRsvpStatus
	end

	local userRsvpStatus = event.userRsvpStatus
	local displayTitle = event.displayTitle
	local startDate = v7.startDate
	local dateAtTime = v14.DateAtTime
	local toastText = v14.ToastText

	local v18 = if fFlagLuaAppSduiEventDetailsEnabled then props.suppressRsvpReminderToastBecauseEventDetailsFocused else nil
	useEffect(fn2, {
		userRsvpStatus,
		displayTitle,
		startDate,
		dateAtTime,
		toastText,
		v18
	})

	local state, setState = useState(nil)

	useEffect(function()
		local flag = true
		fetchEventThumbnail(v11, event.id, props.DefaultThumbnail):andThen(function(p2)
			if flag then
				setState(p2)
			end
		end)
		return function()
			flag = false
		end
	end, { event.id, props.DefaultThumbnail })

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		impressionsTagUtility.AddTag(ref2, props.impressionsTag, props.layoutOrder)
		return function()
			impressionsTagUtility.RemoveTag(ref2, props.impressionsTag, props.layoutOrder)
		end
	end, { ref2, props.impressionsTag, props.layoutOrder })

	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(false)
	local v19 = React.useCallback(function(current)
		ref4.current = current
	end, {})

	local v20 = getEventCtaButtonState(v12)
	local isJoinEventDisabled = v20.isJoinEventDisabled
	local v21 = v20.isRsvpDisabled
	local v22

	if v10 == footerCornerButtonStyle.Follow then
		v22 = focusNavigationEventNameEnum.HoldToNotifyMe
	elseif v10 == footerCornerButtonStyle.Following then
		v22 = focusNavigationEventNameEnum.HoldToUnfollowEvent
	else
		v22 = focusNavigationEventNameEnum.HoldToJoinEvent
		v21 = isJoinEventDisabled
	end

	if v21 then
		v15 = fn
	end

	local v23 = useCallback(function()
		if ref4.current then
			return
		end

		props.onTileActivated(props.Event)
	end, { props.onTileActivated, props.Event })

	local createElement = React.createElement
	local v25 = {
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Size = props.size,
		ref = ref2
	}

	local createElement2 = React.createElement

	local v28 = if fFlagLuaAppGameViewTileBackgroundColorOverride then props.backgroundStyle else nil
	local children = {
		forwardRef = ref3,
		imageAspectRatio = 16 / 9,
		image = state,
		backgroundStyle = v28,
		isContained = true,
		Size = UDim2.fromScale(1, 1),
		title = event.displayTitle or "",
		onActivated = v23,
		footerMetadata = React.createElement(gridTileTextFooter, {
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

	local v34 = if v8 then v14.HappeningNow else formatDateLocalized(v14.DateAtTime, v7.startDate)
	children.thumbnailOverlay = createElement3(gameTileThumbnailBadges, {
		tileBadgesByPosition = {
			ImageTopLeft = {
				{ tileBadgeType = "Text", text = v34 }
			}
		}
	})

	local v35 = if not props.disableButtons then v5.Size.Size_700 + v5.Size.Size_200 else nil
	children.extraFooterSpace = v35

	local v36 = if not props.disableButtons then React.createElement(EventWideFooterButton, {
		buttonStyle = v10,
		disabled = v21,
		onActivated = v15,
		key = "WideFooterButton"
	}) else nil
	children.extraFooterContent = v36

	children.textSizeOffset = v6
	local v26 = {
		GameTile = createElement2(gameTileView, children),
		HoldDetector = 0
	}

	local v37 = if ref3 and ref3.current then React.createElement(holdDetector, {
		guiObject = ref3.current,
		onHoldDetected = v15,
		setDisabledForHold = v19,
		keyCode = Enum.KeyCode.ButtonA,
		focusNavigationEventName = v22
	}) else nil
	v26.HoldDetector = v37
	return createElement("Frame", v25, v26)
end
