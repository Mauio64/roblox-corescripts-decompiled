local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/EventNames")
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Hooks").useCurrentSquadId
local squadButtonClickIntentionEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/Enums").SquadButtonClickIntentionEnum
local squadButtonSourceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/Enums").SquadButtonSourceEnum

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

local function useStartPartySuggestion(p2, p3)
	local v5 = useNavigation()
	local v6 = useCurrentSquadId()
	local v7 = React.useContext(squadExternalContractContext)
	local fireSquadAnalytics = v7.fireSquadAnalytics
	local v8 = v7.useParentChannelHasGroupUp(p2)
	local squadLocation = v7.squadLocation
	local v9 = p3 and v6 == nil
	return {
		canStartParty = v9,
		startParty = React.useCallback(function(p4)
			if not v9 then
				return
			end

			local enterSquadButtonPressed = EventNames.EnterSquadButtonPressed
			local v11 = {
				conversationId = p4,
				squadButtonSource = squadButtonSourceEnum.ChatConversationSmartSuggestion,
				squadLocation = squadLocation,
				userIntention = 0
			}

			local v12 = if v8 then squadButtonClickIntentionEnum.Join else squadButtonClickIntentionEnum.Create
			v11.userIntention = v12
			fireSquadAnalytics(enterSquadButtonPressed, v11)

			v5.navigate(EnumScreens.SquadLobby, { conversationId = p4 })
		end, { v9, fireSquadAnalytics, v8, v5, squadLocation })
	}
end

return useStartPartySuggestion
