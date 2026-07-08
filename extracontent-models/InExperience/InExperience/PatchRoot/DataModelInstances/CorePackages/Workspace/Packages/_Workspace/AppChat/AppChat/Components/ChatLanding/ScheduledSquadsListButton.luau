local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Foundation = require(AppChatParent.Foundation)
local React = require(AppChatParent.React)
local SquadExternalContractProvider = require(AppChatParent.SquadsCore.SquadExternalContractProvider)
local DomLocators = require(AppChat.Utils.DomLocators)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local ScheduledSquadActionEnum = require(AppChatParent.Squads.Enums).ScheduledSquadActionEnum
local EventNames = require(AppChatParent.SquadsCore.EventNames)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local useCurrentSquadId = require(AppChatParent.SquadsCore.Hooks).useCurrentSquadId
local IconButton = Foundation.IconButton
local ScheduledSquadsListSheet = require(AppChatParent.Squads.Components).ScheduledSquadsListSheet

return function(t1: {[any]: any}) -- line: 32
	-- upvalues: useCurrentSquadId (copy), React (copy), SquadExternalContractContext (copy), EventNames (copy), ScheduledSquadActionEnum (copy), IconButton (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ScheduledSquadsListSheet (copy)
	local v15 = useCurrentSquadId()
	local v16 = React.useContext(SquadExternalContractContext)
	local v17, v18 = React.useState(false)
	local v19 = React.useCallback(function() -- line: 38
		-- upvalues: v16 (copy), EventNames (copy), ScheduledSquadActionEnum (copy), t1 (copy), v15 (copy), v18 (copy)
		v16.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = ScheduledSquadActionEnum.ViewSubscribedScheduledSquadsList,
			source = t1.source,
			squadId = v15,
			squadLocation = v16.squadLocation
		})
		v18(true)
	end, {
		v15,
		v18,
		v16.fireSquadAnalytics,
		v16.squadLocation
	})
	local v20 = React.useCallback(function() -- line: 54
		-- upvalues: v18 (copy)
		v18(false)
	end, { v18 })

	return React.createElement(React.Fragment, nil, {
		ScheduledSquadsListButton = React.createElement(IconButton, {
			icon = Foundation.Enums.IconName.Calendar,
			LayoutOrder = t1.layoutOrder,
			onActivated = v19,
			testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("scheduledSquads")
		}),
		ScheduledSquadsListSheet = React.createElement(ScheduledSquadsListSheet, {
			isOpen = v17,
			onClose = v20
		})
	})
end
