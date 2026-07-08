local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)
local Thunks = require(AppChatParent.NavigationRodux).Thunks
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local EnumScreens = require(AppChat.EnumScreens)
local NetworkingSquads = require(AppChatParent.SquadsCore.Http).NetworkingSquads
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local FFlagEnableSquadDeeplinkWithChatId = require(AppChatParent.SharedFlags).FFlagEnableSquadDeeplinkWithChatId
local FFlagSignalsNavP3Dispatch = require(AppChatParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(AppChatParent.RobloxAppNavigation).NavigationCommands
local t1 = {{
	name = AppPage.Chat
}}

return function(t2: {[any]: any}, b1: boolean) -- line: 27
	-- upvalues: FFlagEnableSquadDeeplinkWithChatId (copy), getDeepValue2 (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), t1 (copy), Thunks (copy), NavigateIntoChat (copy), EnumScreens (copy), NetworkingSquads (copy)
	return function(p1) -- line: 28
		-- upvalues: FFlagEnableSquadDeeplinkWithChatId (copy), t2 (copy), getDeepValue2 (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), t1 (copy), b1 (copy), Thunks (copy), NavigateIntoChat (copy), EnumScreens (copy), NetworkingSquads (copy)
		local u16 = if not FFlagEnableSquadDeeplinkWithChatId then nil else t2.conversationId
		local partyId = nil
		local v18 = p1:getState()
		local v19 = getDeepValue2(v18, "Squad.Squad.currentSquad")
		local u20 = v19 and v19.squadId
		local v21 = if not FFlagEnableSquadDeeplinkWithChatId then nil else function() -- line: 37
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v11 (copy), t1 (copy), b1 (copy), p1 (copy), Thunks (copy), u16 (ref), partyId (ref), NavigateIntoChat (copy), EnumScreens (copy), u20 (ref)
			if FFlagSignalsNavP3Dispatch then
				v11.to(v11.fromLegacyPage(t1[#t1]), b1)
			else
				p1:dispatch(Thunks.NavigateToRoute(t1, b1))
			end

			if u16 and u16 ~= "" then
				if partyId and partyId ~= "" then
					p1:dispatch(NavigateIntoChat({
						screen = EnumScreens.SquadLobby,
						params = {
							conversationId = u16,
							squadId = if not u20 or u20 == partyId then nil else partyId
						}
					}))

					return
				end

				p1:dispatch(NavigateIntoChat({
					screen = EnumScreens.ChatConversation,
					params = {
						conversationId = u16
					}
				}))
			end
		end

		if FFlagEnableSquadDeeplinkWithChatId then
			if t2.partyId and t2.partyId ~= "" then
				p1:dispatch(NetworkingSquads.GetSquadFromSquadId.API({
					squadId = t2.partyId
				})):andThen(function(p2) -- line: 69
					-- upvalues: getDeepValue2 (copy), partyId (ref), t2 (copy), u16 (ref), v21 (copy)
					if getDeepValue2(p2, "responseBody.groupUp.parentChannelId") then
						partyId = t2.partyId
						u16 = p2.responseBody.groupUp.parentChannelId
					end

					v21()
				end):catch(function(_) -- line: 77
					-- upvalues: v21 (copy)
					v21()
				end)
			else
				v21()
			end
		else
			p1:dispatch(NetworkingSquads.GetSquadFromSquadId.API({
				squadId = t2.partyId
			})):andThen(function(p4) -- line: 86
				-- upvalues: getDeepValue2 (copy), u20 (ref), t2 (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), t1 (copy), b1 (copy), p1 (copy), Thunks (copy), NavigateIntoChat (copy), EnumScreens (copy)
				if getDeepValue2(p4, "responseBody.groupUp.parentChannelId") then
					local t3 = {
						conversationId = p4.responseBody.groupUp.parentChannelId,
						squadId = if not u20 or u20 == t2.partyId then nil else t2.partyId
					}

					if FFlagSignalsNavP3Dispatch then
						v11.to(v11.fromLegacyPage(t1[#t1]), b1)
					else
						p1:dispatch(Thunks.NavigateToRoute(t1, b1))
					end

					p1:dispatch(NavigateIntoChat({
						screen = EnumScreens.SquadLobby,
						params = t3
					}))
				end
			end):catch(function(_) -- line: 105
			end)
		end
	end
end
