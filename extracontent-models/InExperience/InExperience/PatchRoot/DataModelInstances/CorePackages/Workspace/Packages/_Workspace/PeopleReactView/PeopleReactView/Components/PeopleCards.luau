local Players = game:GetService("Players")

local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local Input = Responsive.Input

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local PeopleService = require(parent.PeopleService)

require(PeopleReactView.Stores.GetScrollingFrameStore)

local useCardWidth = require(PeopleReactView.Hooks.useCardWidth)
local useCardLayoutValues = require(PeopleReactView.Hooks.useCardLayoutValues)
local useGetPeopleService = require(PeopleReactView.Hooks.useGetPeopleService)

local PersonCard = require(PeopleReactView.Components.Card.PersonCard)
local LazyPersonCard = require(PeopleReactView.Components.Card.LazyPersonCard)
local VirtualizedGrid = require(PeopleReactView.Components.Common.VirtualizedGrid)

local Constants = require(PeopleReactView.Constants)

local LocalPlayer = Players.LocalPlayer

local SharedFlags = require(parent.SharedFlags)
local FFlagSideSheetOpenPeoplePage = SharedFlags.FFlagSideSheetOpenPeoplePage

local service = PeopleService.getService("Flags")
local getFFlagPeoplePageEnablePersonSignalStore = service.GetFFlagPeoplePageEnablePersonSignalStore
local getFFlagPeoplePageLazyRenderCards = service.GetFFlagPeoplePageLazyRenderCards
local fFlagPeoplePageRemoveUseMemoElements = service.FFlagPeoplePageRemoveUseMemoElements
local fFlagPeopleCardsEnableVirtualizedGrid = service.FFlagPeopleCardsEnableVirtualizedGrid
local defineFastInt = game:DefineFastInt("MaxNumUniversesExposedToCardTooltip", 3)

local v = false

local function PeopleCards(props)
	local v2 = useTokens()
	local medium = v2.Gap.Medium

	local v3 = useScaledValue(Constants.PEOPLEPAGE.PEOPLE_CARDS.MINIMUM_CARD_WIDTH)
	local v4

	if FFlagSideSheetOpenPeoplePage and props.minimumCardWidth then
		v4 = props.minimumCardWidth * v2.Config.UI.Scale
	else
		v4 = v3
	end

	local state = nil
	local v5 = nil
	local v6

	if FFlagSideSheetOpenPeoplePage then
		local setState
		state, setState = React.useState(false)
		v5 = setState

		v6 = React.useCallback(function(p: number)
			v5(p < v3)
		end, { v3 })
	else
		v6 = nil
	end

	local v7 = nil
	local itemHeight = nil
	local numColumns = nil
	local v8 = nil
	local v9

	if fFlagPeopleCardsEnableVirtualizedGrid then
		v9, itemHeight, numColumns, v8 = useCardLayoutValues()
	else
		v9, v7 = useCardWidth()
	end

	local state2, setState

	if fFlagPeopleCardsEnableVirtualizedGrid then
		state2, setState = React.useState(false)
	else
		state2 = nil
		setState = nil
	end

	local v10 = useGetPeopleService("PeopleListStore")
	local v11

	if getFFlagPeoplePageEnablePersonSignalStore() then
		v11 = nil
	else
		v11 = SignalsReact.useSignalState(v10.people)
	end

	local v12

	if getFFlagPeoplePageEnablePersonSignalStore() then
		v12 = SignalsReact.useSignalState(v10.peopleSignalMap.getCount)
	end

	local v13

	if getFFlagPeoplePageLazyRenderCards() then
		v13 = useLastInputMode()
	else
		v13 = nil
	end

	local v14

	if getFFlagPeoplePageLazyRenderCards() then
		v14 = usePreferredInput()
	else
		v14 = nil
	end

	local shouldShowMenu

	if getFFlagPeoplePageLazyRenderCards() then
		shouldShowMenu = React.useMemo(function(): boolean
			return v13 == "Focus" or v14 ~= Input.Pointer
		end, { v13, v14 })
	else
		shouldShowMenu = nil
	end

	local useMemo = React.useMemo
	local function fn(): boolean
		if
			fFlagPeopleCardsEnableVirtualizedGrid and state2
			or v
			or not (props.getUniversesExposedTo and props.addUniverseToExposureList)
		then
			return false
		end

		local universesExposedTo = props.getUniversesExposedTo(Constants.PEOPLEPAGE.CARD_TOOLTIP.UNIVERSES_EXPOSED_TO_CARD_TOOLTIP)
		local count = 0

		for _, v15 in universesExposedTo do
			if v15 == game.GameId then
				return false
			end

			count += 1
		end

		if defineFastInt <= count then
			return false
		end

		props.addUniverseToExposureList(
			Constants.PEOPLEPAGE.CARD_TOOLTIP.UNIVERSES_EXPOSED_TO_CARD_TOOLTIP,
			game.GameId
		)

		return true
	end

	local v15

	if fFlagPeopleCardsEnableVirtualizedGrid then
		v15 = { state2, props.getUniversesExposedTo, props.addUniverseToExposureList }
	else
		v15 = { props.getUniversesExposedTo, props.addUniverseToExposureList }
	end

	local showTooltip = useMemo(fn, v15)

	local onDismissTooltip = React.useCallback(function()
		v = true

		if fFlagPeopleCardsEnableVirtualizedGrid then
			setState(true)
		end
	end, {})

	React.useEffect(function()
		return function()
			onDismissTooltip()
		end
	end, {})

	local useCallback = React.useCallback
	local function fn2(p)
		local v16 = v7(v4, p.AbsoluteSize.X, medium)

		if FFlagSideSheetOpenPeoplePage then
			v6(v16)
		end
	end

	local v16

	if FFlagSideSheetOpenPeoplePage then
		v16 = { v7, v6, v4, medium }
	else
		v16 = { v7, v4, medium }
	end

	local onAbsoluteSizeChanged = useCallback(fn2, v16)
	local children

	if fFlagPeopleCardsEnableVirtualizedGrid then
		children = {}
	elseif fFlagPeoplePageRemoveUseMemoElements then
		if getFFlagPeoplePageEnablePersonSignalStore() then
			children = {}

			v10.peopleSignalMap.iterateData(function(p: number, p2)
				local v17 = children
				local v18 = "PersonCard_" .. p
				local createElement = React.createElement
				local v19

				if getFFlagPeoplePageLazyRenderCards() then
					v19 = LazyPersonCard
				else
					v19 = PersonCard
				end

				local v20 = {
					width = v9,
					person = p2.getPerson(),
					showTooltip = 0,
					onDismissTooltip = 0,
					layoutOrder = 0,
					scrollingFrameStore = 0,
					shouldShowMenu = 0,
					isCompactCardLayout = 0
				}
				local showTooltip2 = showTooltip

				if showTooltip2 then
					if LocalPlayer == nil then
						showTooltip2 = false
					else
						showTooltip2 = p == LocalPlayer.UserId
					end
				end

				v20.showTooltip = showTooltip2
				v20.onDismissTooltip = onDismissTooltip
				v20.layoutOrder = p2.getOrder
				local scrollingFrameStore

				if getFFlagPeoplePageLazyRenderCards() then
					scrollingFrameStore = props.scrollingFrameStore
				end

				v20.scrollingFrameStore = scrollingFrameStore
				local shouldShowMenu2

				if getFFlagPeoplePageLazyRenderCards() then
					shouldShowMenu2 = shouldShowMenu
				end

				v20.shouldShowMenu = shouldShowMenu2
				v20.isCompactCardLayout = state
				v17[v18] = createElement(v19, v20)
			end, false)
		else
			children = {}

			for k, person in v11 do
				local v17 = "PersonCard_" .. person.UserId
				local createElement = React.createElement
				local v18

				if getFFlagPeoplePageLazyRenderCards() then
					v18 = LazyPersonCard
				else
					v18 = PersonCard
				end

				local v19 = {
					width = v9,
					person = person,
					showTooltip = showTooltip and k == 1,
					onDismissTooltip = onDismissTooltip,
					layoutOrder = k,
					scrollingFrameStore = 0,
					shouldShowMenu = 0,
					isCompactCardLayout = 0
				}
				local scrollingFrameStore

				if getFFlagPeoplePageLazyRenderCards() then
					scrollingFrameStore = props.scrollingFrameStore
				end

				v19.scrollingFrameStore = scrollingFrameStore
				local shouldShowMenu2

				if getFFlagPeoplePageLazyRenderCards() then
					shouldShowMenu2 = shouldShowMenu
				end

				v19.shouldShowMenu = shouldShowMenu2
				v19.isCompactCardLayout = state
				children[v17] = createElement(v18, v19)
			end
		end
	elseif getFFlagPeoplePageEnablePersonSignalStore() then
		children = React.useMemo(function()
			local v17 = {}

			v10.peopleSignalMap.iterateData(function(p: number, p2)
				local v18 = "PersonCard_" .. p
				local createElement = React.createElement
				local v19

				if getFFlagPeoplePageLazyRenderCards() then
					v19 = LazyPersonCard
				else
					v19 = PersonCard
				end

				local v20 = {
					width = v9,
					person = p2.getPerson(),
					showTooltip = 0,
					onDismissTooltip = 0,
					layoutOrder = 0,
					scrollingFrameStore = 0,
					shouldShowMenu = 0,
					isCompactCardLayout = 0
				}
				local showTooltip2 = showTooltip

				if showTooltip2 then
					if LocalPlayer == nil then
						showTooltip2 = false
					else
						showTooltip2 = p == LocalPlayer.UserId
					end
				end

				v20.showTooltip = showTooltip2

				v20.onDismissTooltip = onDismissTooltip
				v20.layoutOrder = p2.getOrder
				local scrollingFrameStore

				if getFFlagPeoplePageLazyRenderCards() then
					scrollingFrameStore = props.scrollingFrameStore
				end

				v20.scrollingFrameStore = scrollingFrameStore
				local shouldShowMenu2

				if getFFlagPeoplePageLazyRenderCards() then
					shouldShowMenu2 = shouldShowMenu
				end

				v20.shouldShowMenu = shouldShowMenu2

				v20.isCompactCardLayout = state
				v17[v18] = createElement(v19, v20)
			end, false)

			return v17
		end, { v12, showTooltip, props.scrollingFrameStore, shouldShowMenu, state })
	else
		children = React.useMemo(function()
			local children2 = {}

			for k, person in v11 do
				local v17 = "PersonCard_" .. person.UserId
				local createElement = React.createElement
				local v18

				if getFFlagPeoplePageLazyRenderCards() then
					v18 = LazyPersonCard
				else
					v18 = PersonCard
				end

				local v19 = {
					width = v9,
					person = person,
					showTooltip = showTooltip and k == 1,
					onDismissTooltip = onDismissTooltip,
					layoutOrder = k,
					scrollingFrameStore = 0,
					shouldShowMenu = 0,
					isCompactCardLayout = 0
				}
				local scrollingFrameStore

				if getFFlagPeoplePageLazyRenderCards() then
					scrollingFrameStore = props.scrollingFrameStore
				end

				v19.scrollingFrameStore = scrollingFrameStore
				local shouldShowMenu2

				if getFFlagPeoplePageLazyRenderCards() then
					shouldShowMenu2 = shouldShowMenu
				end

				v19.shouldShowMenu = shouldShowMenu2

				v19.isCompactCardLayout = state
				children2[v17] = createElement(v18, v19)
			end

			return children2
		end, { v11, showTooltip, props.scrollingFrameStore, shouldShowMenu, state })
	end

	if not fFlagPeopleCardsEnableVirtualizedGrid then
		return (React.createElement(View, {
			tag = "size-full-0 auto-y",
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, medium),
				Wraps = true
			},
			LayoutOrder = props.LayoutOrder,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged
		}, children))
	end

	local onContainerWidthChanged = React.useCallback(function(p: number)
		local v17 = v8(v4, p, medium)

		if FFlagSideSheetOpenPeoplePage then
			v6(v17)
		end
	end, FFlagSideSheetOpenPeoplePage and { v8, v6, v4, medium } or { v4, medium })

	local getElement = React.useCallback(function(p: number)
		local person

		if p > 0 and p <= #v11 then
			person = v11[p]
		end

		if person then
			return React.createElement(PersonCard, {
				width = v9,
				person = person,
				showTooltip = showTooltip,
				onDismissTooltip = onDismissTooltip,
				shouldShowMenu = shouldShowMenu,
				isCompactCardLayout = state
			})
		end

		return nil
	end, { v11, showTooltip, shouldShowMenu, onDismissTooltip, state })

	return (React.createElement(VirtualizedGrid, {
		scrollingFrameStore = props.scrollingFrameStore,
		itemWidth = v9,
		itemHeight = itemHeight,
		numColumns = numColumns,
		gapSize = medium,
		numItems = #v11,
		layoutOrder = props.LayoutOrder,
		onContainerWidthChanged = onContainerWidthChanged,
		getElement = getElement
	}))
end

return React.memo(PeopleCards)
