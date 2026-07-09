local Players = game:GetService("Players")
local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local Foundation = require(PeopleReactViewParent.Foundation)
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local Responsive = require(PeopleReactViewParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local Input = Responsive.Input
local useLastInputMode = require(PeopleReactViewParent.FocusNavigationUtils).useLastInputMode
local PeopleService = require(PeopleReactViewParent.PeopleService)

require(PeopleReactView.Stores.GetScrollingFrameStore)

local useCardWidth = require(PeopleReactView.Hooks.useCardWidth)
local useCardLayoutValues = require(PeopleReactView.Hooks.useCardLayoutValues)
local useGetPeopleService = require(PeopleReactView.Hooks.useGetPeopleService)
local PersonCard = require(PeopleReactView.Components.Card.PersonCard)
local LazyPersonCard = require(PeopleReactView.Components.Card.LazyPersonCard)
local VirtualizedGrid = require(PeopleReactView.Components.Common.VirtualizedGrid)
local Constants = require(PeopleReactView.Constants)
local LocalPlayer = Players.LocalPlayer
local v23 = PeopleService.getService("Flags")
local GetFFlagPeoplePageEnablePersonSignalStore = v23.GetFFlagPeoplePageEnablePersonSignalStore
local GetFFlagPeoplePageLazyRenderCards = v23.GetFFlagPeoplePageLazyRenderCards
local FFlagPeoplePageRemoveUseMemoElements = v23.FFlagPeoplePageRemoveUseMemoElements
local FFlagPeopleCardsEnableVirtualizedGrid = v23.FFlagPeopleCardsEnableVirtualizedGrid
local v28 = game:DefineFastInt("MaxNumUniversesExposedToCardTooltip", 3)
local u29 = false

local function PeopleCards(t1: {[any]: any}) -- line: 59
	-- upvalues: useTokens (copy), useScaledValue (copy), Constants (copy), FFlagPeopleCardsEnableVirtualizedGrid (copy), useCardLayoutValues (copy), useCardWidth (copy), React (copy), useGetPeopleService (copy), GetFFlagPeoplePageEnablePersonSignalStore (copy), SignalsReact (copy), GetFFlagPeoplePageLazyRenderCards (copy), useLastInputMode (copy), usePreferredInput (copy), Input (copy), u29 (ref), v28 (copy), FFlagPeoplePageRemoveUseMemoElements (copy), LazyPersonCard (copy), PersonCard (copy), LocalPlayer (copy), VirtualizedGrid (copy), View (copy)
	local Medium = useTokens().Gap.Medium
	local v33 = useScaledValue(Constants.PEOPLEPAGE.PEOPLE_CARDS.MINIMUM_CARD_WIDTH)
	local u34 = nil
	local v35 = nil
	local v36 = nil
	local u37 = nil
	local u40

	if FFlagPeopleCardsEnableVirtualizedGrid then
		local v38, v39

		v38, v35, v36, v39 = useCardLayoutValues()
		u40 = v38
		u37 = v39
	else
		local v41, v42 = useCardWidth()

		u40 = v41
		u34 = v42
	end

	local u43 = nil
	local u44 = nil

	if FFlagPeopleCardsEnableVirtualizedGrid then
		local v45, v46 = React.useState(false)

		u43 = v45
		u44 = v46
	end

	local v47 = useGetPeopleService("PeopleListStore")
	local v48 = if GetFFlagPeoplePageEnablePersonSignalStore() then nil else SignalsReact.useSignalState(v47.people)
	local v49 = if not GetFFlagPeoplePageEnablePersonSignalStore() then nil else SignalsReact.useSignalState(v47.peopleSignalMap.getCount)
	local v50 = if not GetFFlagPeoplePageLazyRenderCards() then nil else useLastInputMode()
	local v51 = if not GetFFlagPeoplePageLazyRenderCards() then nil else usePreferredInput()
	local v52 = if not GetFFlagPeoplePageLazyRenderCards() then nil else React.useMemo(function() -- line: 92
		-- upvalues: v50 (copy), v51 (copy), Input (copy)
		return v50 == "Focus" or v51 ~= Input.Pointer
	end, {
		v50,
		v51
	})
	local v53 = React.useMemo(function() -- line: 98
		-- upvalues: FFlagPeopleCardsEnableVirtualizedGrid (copy), u43 (ref), u29 (ref), t1 (copy), Constants (copy), v28 (copy)
		if FFlagPeopleCardsEnableVirtualizedGrid and u43 or (u29 or not t1.getUniversesExposedTo or not t1.addUniverseToExposureList) then
			return false
		end

		local n1 = 0

		for _, v63 in (t1.getUniversesExposedTo(Constants.PEOPLEPAGE.CARD_TOOLTIP.UNIVERSES_EXPOSED_TO_CARD_TOOLTIP)) do
			if v63 == game.GameId then
				return false
			end

			n1 += 1
		end

		if n1 >= v28 then
			return false
		end

		t1.addUniverseToExposureList(Constants.PEOPLEPAGE.CARD_TOOLTIP.UNIVERSES_EXPOSED_TO_CARD_TOOLTIP, game.GameId)

		return true
	end, if not FFlagPeopleCardsEnableVirtualizedGrid then {
		t1.getUniversesExposedTo,
		t1.addUniverseToExposureList
	} else {
		u43,
		t1.getUniversesExposedTo,
		t1.addUniverseToExposureList
	})
	local v54 = React.useCallback(function() -- line: 133
		-- upvalues: u29 (ref), FFlagPeopleCardsEnableVirtualizedGrid (copy), u44 (ref)
		u29 = true

		if FFlagPeopleCardsEnableVirtualizedGrid then
			u44(true)
		end
	end, {})

	React.useEffect(function() -- line: 140
		-- upvalues: v54 (copy)
		return function() -- line: 141
			-- upvalues: v54 (copy)
			v54()
		end
	end, {})

	local v55 = React.useCallback(function(p1) -- line: 146
		-- upvalues: u34 (ref), v33 (copy), Medium (copy)
		u34(v33, p1.AbsoluteSize.X, Medium)
	end, {
		u34,
		v33,
		Medium
	})
	local t2 = {}

	if not FFlagPeopleCardsEnableVirtualizedGrid then
		if FFlagPeoplePageRemoveUseMemoElements then
			if GetFFlagPeoplePageEnablePersonSignalStore() then
				t2 = {}
				v47.peopleSignalMap.iterateData(function(n2: number, p2) -- line: 156
					-- upvalues: t2 (ref), React (copy), GetFFlagPeoplePageLazyRenderCards (copy), LazyPersonCard (copy), PersonCard (copy), u40 (ref), v53 (copy), LocalPlayer (copy), v54 (copy), t1 (copy), v52 (copy)
					t2["PersonCard_" .. n2] = React.createElement(if not GetFFlagPeoplePageLazyRenderCards() then PersonCard else LazyPersonCard, {
						width = u40,
						person = p2.getPerson(),
						showTooltip = v53 and (LocalPlayer ~= nil and n2 == LocalPlayer.UserId),
						onDismissTooltip = v54,
						layoutOrder = p2.getOrder,
						scrollingFrameStore = if not GetFFlagPeoplePageLazyRenderCards() then nil else t1.scrollingFrameStore,
						shouldShowMenu = if not GetFFlagPeoplePageLazyRenderCards() then nil else v52
					})
				end, false)
			else
				t2 = {}

				for v57, v58 in v48 do
					t2["PersonCard_" .. v58.UserId] = React.createElement(if not GetFFlagPeoplePageLazyRenderCards() then PersonCard else LazyPersonCard, {
						width = u40,
						person = v58,
						showTooltip = v53 and v57 == 1,
						onDismissTooltip = v54,
						layoutOrder = v57,
						scrollingFrameStore = if not GetFFlagPeoplePageLazyRenderCards() then nil else t1.scrollingFrameStore,
						shouldShowMenu = if not GetFFlagPeoplePageLazyRenderCards() then nil else v52
					})
				end
			end
		else
			t2 = if not GetFFlagPeoplePageEnablePersonSignalStore() then React.useMemo(function() -- line: 219
				-- upvalues: v48 (copy), React (copy), GetFFlagPeoplePageLazyRenderCards (copy), LazyPersonCard (copy), PersonCard (copy), u40 (ref), v53 (copy), v54 (copy), t1 (copy), v52 (copy)
				local t3 = {}

				for v69, v70 in v48 do
					t3["PersonCard_" .. v70.UserId] = React.createElement(if not GetFFlagPeoplePageLazyRenderCards() then PersonCard else LazyPersonCard, {
						width = u40,
						person = v70,
						showTooltip = v53 and v69 == 1,
						onDismissTooltip = v54,
						layoutOrder = v69,
						scrollingFrameStore = if not GetFFlagPeoplePageLazyRenderCards() then nil else t1.scrollingFrameStore,
						shouldShowMenu = if not GetFFlagPeoplePageLazyRenderCards() then nil else v52
					})
				end

				return t3
			end, {
				v48,
				v53,
				t1.scrollingFrameStore,
				v52
			}) else React.useMemo(function() -- line: 194
				-- upvalues: v47 (copy), React (copy), GetFFlagPeoplePageLazyRenderCards (copy), LazyPersonCard (copy), PersonCard (copy), u40 (ref), v53 (copy), LocalPlayer (copy), v54 (copy), t1 (copy), v52 (copy)
				local t4 = {}

				v47.peopleSignalMap.iterateData(function(n3: number, p3) -- line: 197
					-- upvalues: t4 (copy), React (copy), GetFFlagPeoplePageLazyRenderCards (copy), LazyPersonCard (copy), PersonCard (copy), u40 (ref), v53 (copy), LocalPlayer (copy), v54 (copy), t1 (copy), v52 (copy)
					t4["PersonCard_" .. n3] = React.createElement(if not GetFFlagPeoplePageLazyRenderCards() then PersonCard else LazyPersonCard, {
						width = u40,
						person = p3.getPerson(),
						showTooltip = v53 and (LocalPlayer ~= nil and n3 == LocalPlayer.UserId),
						onDismissTooltip = v54,
						layoutOrder = p3.getOrder,
						scrollingFrameStore = if not GetFFlagPeoplePageLazyRenderCards() then nil else t1.scrollingFrameStore,
						shouldShowMenu = if not GetFFlagPeoplePageLazyRenderCards() then nil else v52
					})
				end, false)

				return t4
			end, {
				v49,
				v53,
				t1.scrollingFrameStore,
				v52
			})
		end
	end

	if FFlagPeopleCardsEnableVirtualizedGrid then
		local v59 = React.useCallback(function(n4: number) -- line: 246
			-- upvalues: u37 (ref), v33 (copy), Medium (copy)
			u37(v33, n4, Medium)
		end, {
			v33,
			Medium
		})
		local v60 = React.useCallback(function(n5: number) -- line: 250
			-- upvalues: v48 (copy), React (copy), PersonCard (copy), u40 (ref), v53 (copy), v54 (copy), v52 (copy)
			local v73 = if not (n5 > 0) or not (n5 <= #v48) then nil else v48[n5]

			if not v73 then
				return nil
			end

			return React.createElement(PersonCard, {
				width = u40,
				person = v73,
				showTooltip = v53,
				onDismissTooltip = v54,
				shouldShowMenu = v52
			})
		end, {
			v48,
			v53,
			v52,
			v54
		})

		return (React.createElement(VirtualizedGrid, {
			scrollingFrameStore = t1.scrollingFrameStore,
			itemWidth = u40,
			itemHeight = v35,
			numColumns = v36,
			gapSize = Medium,
			numItems = #v48,
			layoutOrder = t1.LayoutOrder,
			onContainerWidthChanged = v59,
			getElement = v60
		}))
	end

	return (React.createElement(View, {
		tag = "size-full-0 auto-y",
		layout = {
			Wraps = true,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, Medium)
		},
		LayoutOrder = t1.LayoutOrder,
		onAbsoluteSizeChanged = v55
	}, t2))
end

return React.memo(PeopleCards)
