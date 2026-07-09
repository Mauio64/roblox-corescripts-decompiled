local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local Responsive = require(PeopleReactViewParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local Input = Responsive.Input
local useLastInputMode = require(PeopleReactViewParent.FocusNavigationUtils).useLastInputMode
local Foundation = require(PeopleReactViewParent.Foundation)
local getRbxThumb = Foundation.Utility.getRbxThumb
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local FoundationImage = Foundation.Image
local View = Foundation.View
local PeopleService = require(PeopleReactViewParent.PeopleService)
local PersonButtonConfigs = require(PeopleReactView.Configs.PersonButtonConfigs)
local useGetPeopleService = require(PeopleReactView.Hooks.useGetPeopleService)
local useIsComponentInputEnded = require(PeopleReactView.Hooks.useIsComponentInputEnded)
local CardMenu = require(PeopleReactView.Components.Card.CardMenu)
local GetFFlagPeoplePageLazyRenderCards = PeopleService.getService("Flags").GetFFlagPeoplePageLazyRenderCards
local v23 = game:DefineFastFlag("PeoplePageCardMenuUseVisibleProperty", false)

local function CardThumbnail(t1: {[any]: any}) -- line: 43
	-- upvalues: React (copy), GetFFlagPeoplePageLazyRenderCards (copy), usePreferredInput (copy), useLastInputMode (copy), useGetPeopleService (copy), PersonButtonConfigs (copy), SignalsReact (copy), useIsComponentInputEnded (copy), ControlState (copy), Input (copy), View (copy), StateLayerAffordance (copy), FoundationImage (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy), v23 (copy), CardMenu (copy)
	local v26 = React.useRef(nil)
	local v27 = if GetFFlagPeoplePageLazyRenderCards() then nil else usePreferredInput()
	local v28 = if GetFFlagPeoplePageLazyRenderCards() then nil else useLastInputMode()
	local v29 = useGetPeopleService("Constants")
	local v30 = useGetPeopleService("PeopleVoiceChatStore")
	local v31 = PersonButtonConfigs(t1.person.UserId)
	local v32 = React.useMemo(function() -- line: 54
		-- upvalues: v31 (copy), v29 (copy)
		return v31[v29.PERSON_BUTTONS.INSPECT]
	end, { v31 })
	local v33 = SignalsReact.useSignalState(v30.getPlayerIsTalking(t1.person.UserId))
	local v34, v35 = React.useState(false)
	local v36, v37 = React.useState(false)
	local v38, v39 = React.useState(false)
	local v40 = useIsComponentInputEnded(v26)
	local v41 = React.useCallback(function(p1) -- line: 65
		-- upvalues: v35 (copy), ControlState (copy)
		v35(p1 == ControlState.Hover)
	end, {})
	local v42 = React.useCallback(function(p2) -- line: 69
		-- upvalues: v37 (copy), ControlState (copy)
		v37(p2 == ControlState.Hover)
	end, {})
	local v43 = React.useMemo(function() -- line: 73
		-- upvalues: GetFFlagPeoplePageLazyRenderCards (copy), t1 (copy), v28 (copy), v27 (copy), Input (copy), v34 (copy), v38 (copy), v33 (copy)
		local v48 = if not GetFFlagPeoplePageLazyRenderCards() then v28 == "Focus" or v27 ~= Input.Pointer else t1.shouldShowMenu

		return v34 or (v38 or (v33 or v48))
	end, {
		v34,
		v38,
		v33,
		v27,
		v28,
		t1.shouldShowMenu
	})
	local v44 = React.useMemo(function() -- line: 81
		-- upvalues: v36 (copy), v38 (copy), v40 (copy)
		return v36 or (v38 or v40)
	end, {
		v36,
		v38,
		v40
	})
	local v45 = React.useCallback(function() -- line: 85
		-- upvalues: v32 (copy), v29 (copy)
		v32.onActivated(v29.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
	end, { v32.onActivated })

	return React.createElement(View, {
		tag = "size-full aspect-1-1 radius-medium",
		selection = {
			Selectable = v32.shouldShow()
		},
		LayoutOrder = t1.layoutOrder,
		stateLayer = {
			affordance = if not v44 then StateLayerAffordance.Background else StateLayerAffordance.None
		},
		onActivated = if not v32.shouldShow() then nil else v45,
		onStateChanged = v41,
		ref = v26
	}, {
		AvatarThumbnailContainer = React.createElement(View, {
			tag = "size-full padding-medium"
		}, {
			AvatarThumbnail = React.createElement(FoundationImage, {
				tag = "size-full",
				Image = getRbxThumb(ThumbnailType.Avatar, t1.person.UserId, ThumbnailSize.Medium)
			})
		}),
		ThumbnailHeaderBar = React.createElement(View, {
			tag = "row size-full-0 auto-y align-x-right padding-small"
		}, {
			CardMenuBackground = if not v23 and not v43 then nil else React.createElement(View, {
				AutomaticSize = Enum.AutomaticSize.XY,
				selection = {
					Selectable = false
				},
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				onStateChanged = v42,
				Visible = if not v23 then nil else v43
			}, {
				CardMenu = React.createElement(CardMenu, {
					person = t1.person,
					onIsOpenChanged = v39
				})
			})
		})
	})
end

return React.memo(CardThumbnail)
