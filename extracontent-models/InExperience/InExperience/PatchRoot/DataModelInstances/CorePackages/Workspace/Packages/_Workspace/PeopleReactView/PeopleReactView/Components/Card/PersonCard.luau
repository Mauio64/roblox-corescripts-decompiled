local LocalPlayer = game:GetService("Players").LocalPlayer
local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local ReactIs = require(PeopleReactViewParent.ReactIs)
local Signals = require(PeopleReactViewParent.Signals)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local View = require(PeopleReactViewParent.Foundation).View
local PeopleService = require(PeopleReactViewParent.PeopleService)
local CardDetails = require(PeopleReactView.Components.Card.CardDetails)
local CardThumbnail = require(PeopleReactView.Components.Card.CardThumbnail)
local CardTooltip = require(PeopleReactView.Components.Card.CardTooltip)
local v13 = PeopleService.getService("Flags")
local GetFFlagPeoplePageEnablePersonSignalStore = v13.GetFFlagPeoplePageEnablePersonSignalStore
local GetFFlagPeoplePageLazyRenderCards = v13.GetFFlagPeoplePageLazyRenderCards
local GetFFlagFixPeoplePageCardTooltip = v13.GetFFlagFixPeoplePageCardTooltip
local FFlagPeopleCardsEnableVirtualizedGrid = v13.FFlagPeopleCardsEnableVirtualizedGrid

local function PersonCard(t1: {[any]: any}) -- line: 36
	-- upvalues: GetFFlagPeoplePageEnablePersonSignalStore (copy), SignalsReact (copy), Signals (copy), ReactIs (copy), React (copy), FFlagPeopleCardsEnableVirtualizedGrid (copy), LocalPlayer (copy), View (copy), GetFFlagFixPeoplePageCardTooltip (copy), CardThumbnail (copy), GetFFlagPeoplePageLazyRenderCards (copy), CardDetails (copy), CardTooltip (copy)
	local v20 = if not GetFFlagPeoplePageEnablePersonSignalStore() then nil else SignalsReact.useSignalBinding(Signals.createComputed(function(p1) -- line: 38
		-- upvalues: t1 (copy)
		if type(t1.layoutOrder) == "function" then
			return t1.layoutOrder(p1)
		end

		return t1.layoutOrder or 0
	end))
	local v21 = if not ReactIs.isBinding(t1.width) then UDim2.new(0, t1.width, 0, 0) else t1.width:map(function(n1: number) -- line: 48
		return UDim2.new(0, n1, 0, 0)
	end)
	local v22, v23 = React.useState(not FFlagPeopleCardsEnableVirtualizedGrid and t1.showTooltip)

	if FFlagPeopleCardsEnableVirtualizedGrid then
		React.useEffect(function() -- line: 60
			-- upvalues: v23 (copy), t1 (copy), LocalPlayer (copy)
			v23(t1.showTooltip and (LocalPlayer ~= nil and t1.person.UserId == LocalPlayer.UserId))
		end, {
			t1.showTooltip,
			t1.person
		})
	end

	local v24 = React.useCallback(function() -- line: 65
		-- upvalues: v23 (copy), t1 (copy)
		v23(false)
		t1.onDismissTooltip()
	end, {})

	return React.createElement(View, {
		tag = "auto-y",
		Size = v21,
		ZIndex = not v22 and 1 or 2,
		LayoutOrder = if not GetFFlagPeoplePageEnablePersonSignalStore() then t1.layoutOrder else v20
	}, {
		CardContent = React.createElement(View, {
			tag = not GetFFlagFixPeoplePageCardTooltip() and "size-full col bg-surface-100 radius-medium" or "size-full-0 auto-y col bg-surface-100 radius-medium"
		}, {
			CardThumbnail = React.createElement(CardThumbnail, {
				layoutOrder = 1,
				person = t1.person,
				shouldShowMenu = if not GetFFlagPeoplePageLazyRenderCards() then nil else t1.shouldShowMenu
			}),
			CardDetails = React.createElement(CardDetails, {
				layoutOrder = 2,
				person = t1.person
			})
		}),
		CardTooltip = if not v22 then nil else React.createElement(CardTooltip, {
			action = v24
		})
	})
end

return React.memo(PersonCard)
