local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local Input = Responsive.Input

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local Foundation = require(parent.Foundation)
local getRbxThumb = Foundation.Utility.getRbxThumb
local ControlState = Foundation.Enums.ControlState
local InputSize = Foundation.Enums.InputSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local Image = Foundation.Image
local View = Foundation.View

local PeopleService = require(parent.PeopleService)

local PersonButtonConfigs = require(PeopleReactView.Configs.PersonButtonConfigs)
local useGetPeopleService = require(PeopleReactView.Hooks.useGetPeopleService)
local useIsComponentInputEnded = require(PeopleReactView.Hooks.useIsComponentInputEnded)

local CardMenu = require(PeopleReactView.Components.Card.CardMenu)
local ConnectButton = require(PeopleReactView.Components.Card.ConnectButton)

local SharedFlags = require(parent.SharedFlags)
local FFlagSideSheetOpenPeoplePage = SharedFlags.FFlagSideSheetOpenPeoplePage
local FFlagPeoplePageAvatarBackground = require(PeopleReactView.Flags.FFlagPeoplePageAvatarBackground)
local useAvatarBackgroundImage

if FFlagPeoplePageAvatarBackground then
	useAvatarBackgroundImage = require(PeopleReactView.Hooks.useAvatarBackgroundImage)
else
	useAvatarBackgroundImage = nil
end

local getFFlagPeoplePageLazyRenderCards = PeopleService.getService("Flags").GetFFlagPeoplePageLazyRenderCards
local defineFastFlag = game:DefineFastFlag("PeoplePageCardMenuUseVisibleProperty", false)
local defineFastFlag2 = game:DefineFastFlag("PeoplePageFixCardMenuZIndex", false)

local function CardThumbnail(props)
	local ref = React.useRef(nil)
	local v

	if getFFlagPeoplePageLazyRenderCards() then
		v = nil
	else
		v = usePreferredInput()
	end

	local v2

	if getFFlagPeoplePageLazyRenderCards() then
		v2 = nil
	else
		v2 = useLastInputMode()
	end

	local v3 = useGetPeopleService("Constants")
	local v4 = useGetPeopleService("PeopleVoiceChatStore")

	local personButtonConfigs = PersonButtonConfigs(props.person.UserId)
	local image

	if FFlagPeoplePageAvatarBackground then
		image = useAvatarBackgroundImage(props.person.UserId)
	end

	local v5 = React.useMemo(function()
		return personButtonConfigs[v3.PERSON_BUTTONS.INSPECT]
	end, { personButtonConfigs })

	local v6 = SignalsReact.useSignalState(v4.getPlayerIsTalking(props.person.UserId))

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3

	if FFlagSideSheetOpenPeoplePage then
		state3, setState3 = React.useState(false)
	else
		setState3 = nil
		state3 = nil
	end

	local state4, setState4 = React.useState(false)
	local v7 = useIsComponentInputEnded(ref)

	local onStateChanged = React.useCallback(function(p)
		setState(p == ControlState.Hover)
	end, {})

	local onStateChanged2 = React.useCallback(function(p)
		setState2(p == ControlState.Hover)
	end, {})
	local onStateChanged3

	if FFlagSideSheetOpenPeoplePage then
		onStateChanged3 = React.useCallback(function(p)
			setState3(p == ControlState.Hover or p == ControlState.Pressed)
		end, {})
	end

	local visible = React.useMemo(function()
		local v8

		if getFFlagPeoplePageLazyRenderCards() then
			v8 = props.shouldShowMenu
		else
			v8 = v2 == "Focus" or v ~= Input.Pointer
		end

		return state or state4 or v6 or v8
	end, { state, state4, v6, v, v2, props.shouldShowMenu })

	local v8 = React.useMemo(function()
		if FFlagSideSheetOpenPeoplePage then
			return state2 or state3 or state4 or v7
		end

		return state2 or state4 or v7
	end, FFlagSideSheetOpenPeoplePage and { state2, state3, state4, v7 } or { state2, state4, v7 })

	local onActivated = React.useCallback(function()
		v5.onActivated(v3.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
	end, { v5.onActivated })

	local createElement = React.createElement
	local v9 = {
		tag = "size-full aspect-1-1 radius-medium",
		selection = { Selectable = v5.shouldShow() },
		LayoutOrder = props.layoutOrder,
		stateLayer = 0,
		onActivated = 0,
		onStateChanged = 0,
		ref = 0
	}
	local affordance

	if v8 then
		affordance = StateLayerAffordance.None
	else
		affordance = StateLayerAffordance.Background
	end

	v9.stateLayer = { affordance = affordance }

	if not v5.shouldShow() then
		onActivated = nil
	end

	v9.onActivated = onActivated
	v9.onStateChanged = onStateChanged
	v9.ref = ref
	local avatarBackground

	if image then
		avatarBackground = React.createElement(Image, {
			tag = "size-full radius-top-medium",
			Image = image,
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 0,
			testId = "person-card-avatar-background"
		})
	end

	local children = {
		AvatarBackground = avatarBackground,
		AvatarThumbnailContainer = React.createElement(View, { tag = "size-full padding-medium" }, {
			AvatarThumbnail = React.createElement(Image, {
				tag = "size-full",
				Image = getRbxThumb(ThumbnailType.Avatar, props.person.UserId, ThumbnailSize.Medium)
			})
		}),
		ThumbnailHeaderBar = 0,
		ConnectButtonAnchor = 0
	}

	local createElement2 = React.createElement
	local cardMenuBackground

	if defineFastFlag or visible then
		local createElement3 = React.createElement
		local v10 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			selection = { Selectable = false },
			stateLayer = { affordance = StateLayerAffordance.None },
			onStateChanged = onStateChanged2,
			Visible = 0
		}

		if not defineFastFlag then
			visible = nil
		end

		v10.Visible = visible
		cardMenuBackground = createElement3(View, v10, {
			CardMenu = React.createElement(CardMenu, {
				person = props.person,
				onIsOpenChanged = setState4
			})
		})
	end

	children.ThumbnailHeaderBar = createElement2(View, {
		tag = "row size-full-0 auto-y align-x-right padding-small",
		ZIndex = defineFastFlag2 and 2 or nil
	}, { CardMenuBackground = cardMenuBackground })
	local connectButtonAnchor

	if FFlagSideSheetOpenPeoplePage and props.isCompactCardLayout then
		connectButtonAnchor = React.createElement(
			View,
			{ tag = "position-bottom-left anchor-bottom-left auto-xy padding-small", ZIndex = 2 },
			{
				ConnectButtonBackground = React.createElement(ConnectButton, {
					person = props.person,
					size = InputSize.Small,
					onStateChanged = onStateChanged3
				})
			}
		)
	end

	children.ConnectButtonAnchor = connectButtonAnchor
	return createElement(View, v9, children)
end

return React.memo(CardThumbnail)
