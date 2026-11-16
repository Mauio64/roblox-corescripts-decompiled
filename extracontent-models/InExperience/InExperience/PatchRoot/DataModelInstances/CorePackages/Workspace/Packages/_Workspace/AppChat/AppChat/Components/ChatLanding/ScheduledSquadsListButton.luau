local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)

local DomLocators = require(AppChat.Utils.DomLocators)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)

local Enums = require(parent.Squads.Enums)
local ScheduledSquadActionEnum = Enums.ScheduledSquadActionEnum

local EventNames = require(parent.SquadsCore.EventNames)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadId = Hooks.useCurrentSquadId

local IconButton = Foundation.IconButton

local Components = require(parent.Squads.Components)
local ScheduledSquadsListSheet = Components.ScheduledSquadsListSheet

return function(p)
	local squadId = useCurrentSquadId()
	local v = React.useContext(SquadExternalContractContext)

	local state, setState = React.useState(false)

	local onActivated = React.useCallback(function()
		v.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = ScheduledSquadActionEnum.ViewSubscribedScheduledSquadsList,
			source = p.source,
			squadId = squadId,
			squadLocation = v.squadLocation
		})

		setState(true)
	end, { squadId, setState, v.fireSquadAnalytics, v.squadLocation })

	local onClose = React.useCallback(function()
		setState(false)
	end, { setState })

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v2 = {
		icon = Foundation.Enums.IconName.Calendar,
		LayoutOrder = p.layoutOrder,
		onActivated = onActivated,
		testId = 0
	}
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = DomLocators.chatLandingTopBarIconButton("scheduledSquads")
	end

	v2.testId = testId
	return createElement(fragment, nil, {
		ScheduledSquadsListButton = createElement2(IconButton, v2),
		ScheduledSquadsListSheet = React.createElement(ScheduledSquadsListSheet, {
			isOpen = state,
			onClose = onClose
		})
	})
end
