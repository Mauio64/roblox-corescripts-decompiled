local NavigateIntoChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/NavigateIntoChat")
local thunks = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NavigationRodux").Thunks
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local networkingSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Http").NetworkingSquads
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
local fFlagEnableSquadDeeplinkWithChatId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableSquadDeeplinkWithChatId
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppNavigation").NavigationCommands else nil

local v5 = {
	{ name = appPage.Chat }
}

return function(p2, p3)
	return function(object)
		local v6 = if fFlagEnableSquadDeeplinkWithChatId then p2.conversationId else nil
		local partyId = nil
		local v7 = getDeepValue2(object:getState(), "Squad.Squad.currentSquad")
		local squadId = v7 and v7.squadId

		local fn = fFlagEnableSquadDeeplinkWithChatId and function()
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.to(navigationCommands.fromLegacyPage(v5[#v5]), p3)
			else
				object:dispatch(thunks.NavigateToRoute(v5, p3))
			end

			if v6 and v6 ~= "" then
				if partyId and partyId ~= "" then
					local v10 = { screen = EnumScreens.SquadLobby, params = 0 }
					local v11 = { conversationId = v6, squadId = 0 }
					local v12 = if squadId and squadId ~= partyId then partyId else nil
					v11.squadId = v12
					v10.params = v11
					object:dispatch(NavigateIntoChat(v10))
				else
					object:dispatch(NavigateIntoChat({
						screen = EnumScreens.ChatConversation,
						params = { conversationId = v6 }
					}))
				end
			end
		end or nil

		if fFlagEnableSquadDeeplinkWithChatId then
			if p2.partyId and p2.partyId ~= "" then
				object:dispatch(networkingSquads.GetSquadFromSquadId.API({
					squadId = p2.partyId
				})):andThen(function(p4)
					if getDeepValue2(p4, "responseBody.groupUp.parentChannelId") then
						partyId = p2.partyId
						v6 = p4.responseBody.groupUp.parentChannelId
					end

					fn()
				end):catch(function(p4)
					fn()
				end)
			else
				fn()
			end
		else
			object:dispatch(networkingSquads.GetSquadFromSquadId.API({
				squadId = p2.partyId
			})):andThen(function(p4)
				if getDeepValue2(p4, "responseBody.groupUp.parentChannelId") then
					local v8 = {
						conversationId = p4.responseBody.groupUp.parentChannelId,
						squadId = 0
					}
					local v9 = if squadId and squadId ~= p2.partyId then p2.partyId else nil
					v8.squadId = v9

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.to(navigationCommands.fromLegacyPage(v5[#v5]), p3)
					else
						object:dispatch(thunks.NavigateToRoute(v5, p3))
					end

					object:dispatch(NavigateIntoChat({ screen = EnumScreens.SquadLobby, params = v8 }))
				end
			end):catch(function(p4) end)
		end
	end
end
