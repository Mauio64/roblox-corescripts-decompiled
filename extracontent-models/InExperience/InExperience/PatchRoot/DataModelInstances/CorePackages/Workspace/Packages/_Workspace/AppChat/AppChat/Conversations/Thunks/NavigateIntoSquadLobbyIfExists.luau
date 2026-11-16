local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)
local NavigationRodux = require(parent.NavigationRodux)
local Thunks = NavigationRodux.Thunks
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local EnumScreens = require(AppChat.EnumScreens)
local Http = require(parent.SquadsCore.Http)
local NetworkingSquads = Http.NetworkingSquads
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSquadDeeplinkWithChatId = SharedFlags.FFlagEnableSquadDeeplinkWithChatId
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags2.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local v = {
	{ name = AppPage.Chat }
}

return function(p, flag: boolean)
	return function(object)
		local conversationId

		if FFlagEnableSquadDeeplinkWithChatId then
			conversationId = p.conversationId
		else
			conversationId = nil
		end

		local partyId = nil
		local deepValue2 = getDeepValue2(object:getState(), "Squad.Squad.currentSquad")
		local squadId = deepValue2 and deepValue2.squadId

		local fn = FFlagEnableSquadDeeplinkWithChatId and function()
			if FFlagSignalsNavP3Dispatch then
				navigationCommands.to(navigationCommands.fromLegacyPage(v[#v]), flag)
			else
				object:dispatch(Thunks.NavigateToRoute(v, flag))
			end

			if conversationId and conversationId ~= "" then
				if partyId and partyId ~= "" then
					local v2 = { screen = EnumScreens.SquadLobby, params = 0 }
					local params = { conversationId = conversationId, squadId = 0 }
					local squadId2

					if squadId and squadId ~= partyId then
						squadId2 = partyId
					end

					params.squadId = squadId2
					v2.params = params
					object:dispatch(NavigateIntoChat(v2))
				else
					object:dispatch(NavigateIntoChat({
						screen = EnumScreens.ChatConversation,
						params = { conversationId = conversationId }
					}))
				end
			end
		end or nil

		if FFlagEnableSquadDeeplinkWithChatId then
			if p.partyId and p.partyId ~= "" then
				object:dispatch(NetworkingSquads.GetSquadFromSquadId.API({ squadId = p.partyId })):andThen(function(p2)
					if getDeepValue2(p2, "responseBody.groupUp.parentChannelId") then
						partyId = p.partyId
						conversationId = p2.responseBody.groupUp.parentChannelId
					end

					fn()
				end):catch(function(_)
					fn()
				end)
			else
				fn()
			end
		else
			object:dispatch(NetworkingSquads.GetSquadFromSquadId.API({ squadId = p.partyId })):andThen(function(p2)
				if getDeepValue2(p2, "responseBody.groupUp.parentChannelId") then
					local params = {
						conversationId = p2.responseBody.groupUp.parentChannelId,
						squadId = 0
					}
					local squadId2

					if squadId and squadId ~= p.partyId then
						squadId2 = p.partyId
					end

					params.squadId = squadId2

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.to(navigationCommands.fromLegacyPage(v[#v]), flag)
					else
						object:dispatch(Thunks.NavigateToRoute(v, flag))
					end

					object:dispatch(NavigateIntoChat({
						screen = EnumScreens.SquadLobby,
						params = params
					}))
				end
			end):catch(function(_) end)
		end
	end
end
