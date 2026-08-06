local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local useNavigation = require(AppChatParent.Navigation).useNavigation
local SquadExternalContractContext = require(AppChatParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local EventNames = require(AppChatParent.SquadsCore.EventNames)
local useCurrentSquadId = require(AppChatParent.SquadsCore.Hooks).useCurrentSquadId
local SquadButtonClickIntentionEnum = require(AppChatParent.Squads.Enums).SquadButtonClickIntentionEnum
local SquadButtonSourceEnum = require(AppChatParent.Squads.Enums).SquadButtonSourceEnum
local EnumScreens = require(AppChat.EnumScreens)

local function useStartPartySuggestion(s1: string, b1: boolean) -- line: 21
	-- upvalues: useNavigation (copy), useCurrentSquadId (copy), React (copy), SquadExternalContractContext (copy), EventNames (copy), SquadButtonSourceEnum (copy), SquadButtonClickIntentionEnum (copy), EnumScreens (copy)
	local v14 = useNavigation()
	local v15 = useCurrentSquadId()
	local v16 = React.useContext(SquadExternalContractContext)
	local fireSquadAnalytics = v16.fireSquadAnalytics
	local v18 = v16.useParentChannelHasGroupUp(s1)
	local squadLocation = v16.squadLocation
	local v20 = b1 and v15 == nil
	local v21 = React.useCallback(function(s2: string) -- line: 31
		-- upvalues: v20 (copy), fireSquadAnalytics (copy), EventNames (copy), SquadButtonSourceEnum (copy), squadLocation (copy), v18 (copy), SquadButtonClickIntentionEnum (copy), v14 (copy), EnumScreens (copy)
		if not v20 then
			return
		end

		fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			conversationId = s2,
			squadButtonSource = SquadButtonSourceEnum.ChatConversationSmartSuggestion,
			squadLocation = squadLocation,
			userIntention = if not v18 then SquadButtonClickIntentionEnum.Create else SquadButtonClickIntentionEnum.Join
		})
		v14.navigate(EnumScreens.SquadLobby, {
			conversationId = s2
		})
	end, {
		v20,
		fireSquadAnalytics,
		v18,
		v14,
		squadLocation
	})

	return {
		canStartParty = v20,
		startParty = v21
	}
end

return useStartPartySuggestion
