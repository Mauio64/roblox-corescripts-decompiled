local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local ReactIs = require(parent.ReactIs)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local View = Foundation.View

local PeopleService = require(parent.PeopleService)

local CardDetails = require(PeopleReactView.Components.Card.CardDetails)
local CardThumbnail = require(PeopleReactView.Components.Card.CardThumbnail)
local CardTooltip = require(PeopleReactView.Components.Card.CardTooltip)

local service = PeopleService.getService("Flags")
local getFFlagPeoplePageEnablePersonSignalStore = service.GetFFlagPeoplePageEnablePersonSignalStore
local getFFlagPeoplePageLazyRenderCards = service.GetFFlagPeoplePageLazyRenderCards
local getFFlagFixPeoplePageCardTooltip = service.GetFFlagFixPeoplePageCardTooltip
local fFlagPeopleCardsEnableVirtualizedGrid = service.FFlagPeopleCardsEnableVirtualizedGrid

local function PersonCard(props)
	local layoutOrder

	if getFFlagPeoplePageEnablePersonSignalStore() then
		layoutOrder = SignalsReact.useSignalBinding(Signals.createComputed(function(p)
			if type(props.layoutOrder) == "function" then
				return props.layoutOrder(p)
			end

			return props.layoutOrder or 0
		end))
	end

	local size

	if ReactIs.isBinding(props.width) then
		size = props.width:map(function(p: number)
			return UDim2.new(0, p, 0, 0)
		end)
	else
		size = UDim2.new(0, props.width, 0, 0)
	end

	local useState = React.useState
	local v

	if fFlagPeopleCardsEnableVirtualizedGrid then
		v = false
	else
		v = props.showTooltip
	end

	local state, setState = useState(v)

	if fFlagPeopleCardsEnableVirtualizedGrid then
		React.useEffect(function()
			local v2 = props.showTooltip

			if v2 then
				if LocalPlayer == nil then
					v2 = false
				else
					v2 = props.person.UserId == LocalPlayer.UserId
				end
			end

			setState(v2)
		end, { props.showTooltip, props.person })
	end

	local action = React.useCallback(function()
		setState(false)
		props.onDismissTooltip()
	end, {})

	local createElement = React.createElement
	local v2 = {
		tag = "auto-y",
		Size = size,
		ZIndex = state and 2 or 1,
		LayoutOrder = 0
	}

	if not getFFlagPeoplePageEnablePersonSignalStore() then
		layoutOrder = props.layoutOrder
	end

	v2.LayoutOrder = layoutOrder

	local createElement2 = React.createElement
	local v3 = {
		tag = getFFlagFixPeoplePageCardTooltip() and "size-full-0 auto-y col bg-surface-100 radius-medium" or "size-full col bg-surface-100 radius-medium"
	}

	local createElement3 = React.createElement
	local v4 = {
		person = props.person,
		shouldShowMenu = 0,
		layoutOrder = 1,
		isCompactCardLayout = 0
	}
	local shouldShowMenu

	if getFFlagPeoplePageLazyRenderCards() then
		shouldShowMenu = props.shouldShowMenu
	end

	v4.shouldShowMenu = shouldShowMenu

	v4.isCompactCardLayout = props.isCompactCardLayout
	local v5 = {
		CardContent = createElement2(View, v3, {
			CardThumbnail = createElement3(CardThumbnail, v4),
			CardDetails = React.createElement(CardDetails, {
				person = props.person,
				layoutOrder = 2,
				isCompactCardLayout = props.isCompactCardLayout
			})
		}),
		CardTooltip = 0
	}
	local cardTooltip

	if state then
		cardTooltip = React.createElement(CardTooltip, { action = action })
	end

	v5.CardTooltip = cardTooltip
	return createElement(View, v2, v5)
end

return React.memo(PersonCard)
