local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require(parent.SquadsCore.EventNames)
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadId = Hooks.useCurrentSquadId
local Enums = require(parent.Squads.Enums)
local SquadButtonClickIntentionEnum = Enums.SquadButtonClickIntentionEnum
local Enums2 = require(parent.Squads.Enums)
local SquadButtonSourceEnum = Enums2.SquadButtonSourceEnum

local EnumScreens = require(AppChat.EnumScreens)

local function useStartPartySuggestion(p: string, flag: boolean)
	local v = useNavigation()
	local v2 = useCurrentSquadId()
	local v3 = React.useContext(SquadExternalContractContext)
	local fireSquadAnalytics = v3.fireSquadAnalytics
	local v4 = v3.useParentChannelHasGroupUp(p)
	local squadLocation = v3.squadLocation
	local canStartParty = flag and v2 == nil
	return {
		canStartParty = canStartParty,
		startParty = React.useCallback(function(conversationId: string)
			if not canStartParty then
				return
			end

			local enterSquadButtonPressed = EventNames.EnterSquadButtonPressed
			local v5 = {
				conversationId = conversationId,
				squadButtonSource = SquadButtonSourceEnum.ChatConversationSmartSuggestion,
				squadLocation = squadLocation,
				userIntention = 0
			}
			local userIntention

			if v4 then
				userIntention = SquadButtonClickIntentionEnum.Join
			else
				userIntention = SquadButtonClickIntentionEnum.Create
			end

			v5.userIntention = userIntention
			fireSquadAnalytics(enterSquadButtonPressed, v5)

			v.navigate(EnumScreens.SquadLobby, { conversationId = conversationId })
		end, { canStartParty, fireSquadAnalytics, v4, v, squadLocation })
	}
end

return useStartPartySuggestion
