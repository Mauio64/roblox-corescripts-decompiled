local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local Promise = require(AppChatParent.Promise)
local getDeepValue = require(AppChat.Utils.getDeepValue)
local multiGetConversationDetails = require(AppChat.Conversations.Thunks.multiGetConversationDetails)
local v7 = require(AppChat.Logger):new(script.Name)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local refreshConversationUnfilteredThreadsDetails = require(script.Parent.refreshConversationUnfilteredThreadsDetails)
local FFlagAppChatEnableDoubleOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableDoubleOptIn
local FIntUnfilteredThreadsPvDelayMs = require(AppChat.Flags.FIntUnfilteredThreadsPvDelayMs)

return function(s1: string?, b1: boolean?) -- line: 21
	-- upvalues: getDeepValue (copy), Cryo (copy), Promise (copy), FIntUnfilteredThreadsPvDelayMs (copy), multiGetConversationDetails (copy), v7 (copy), AppChatNetworking (copy), FFlagAppChatEnableDoubleOptIn (copy), refreshConversationUnfilteredThreadsDetails (copy)
	return function(p1) -- line: 22
		-- upvalues: getDeepValue (copy), Cryo (copy), Promise (copy), FIntUnfilteredThreadsPvDelayMs (copy), multiGetConversationDetails (copy), v7 (copy), AppChatNetworking (copy), b1 (copy), s1 (copy), FFlagAppChatEnableDoubleOptIn (copy), refreshConversationUnfilteredThreadsDetails (copy)
		local v15 = p1:getState()
		local v16 = getDeepValue(v15, "ChatAppReducer.Conversations") or {}
		local v17 = Cryo.List.filterMap(Cryo.Dictionary.values(v16), function(p2) -- line: 25
			if p2 and (p2.id and p2.source ~= "friends") then
				return p2.id
			end

			return nil
		end)

		return Promise.delay(FIntUnfilteredThreadsPvDelayMs / 1000):andThen(function() -- line: 34
			-- upvalues: v17 (copy), p1 (copy), multiGetConversationDetails (copy), v7 (copy), AppChatNetworking (copy), b1 (copy), s1 (copy), FFlagAppChatEnableDoubleOptIn (copy), refreshConversationUnfilteredThreadsDetails (copy)
			if v17 then
				p1:dispatch(multiGetConversationDetails(v17)):catch(function(p3) -- line: 36
					-- upvalues: v7 (copy)
					v7:warning("Error in multiGetConversationDetails thunk. Error: {}", (tostring(p3)))
				end)
			end

			p1:dispatch(AppChatNetworking.rodux.GetChatLandingModal.API(b1)):catch(function(p4) -- line: 40
				-- upvalues: v7 (copy)
				v7:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p4)))
			end)

			if s1 then
				if FFlagAppChatEnableDoubleOptIn then
					p1:dispatch(refreshConversationUnfilteredThreadsDetails(s1, b1))

					return
				end

				p1:dispatch(AppChatNetworking.rodux.GetConversationTopModal.API(s1, b1)):catch(function(p5) -- line: 53
					-- upvalues: v7 (copy)
					v7:warning("Error in refreshAllUnfilteredThreadsDetails->GetConversationTopModal. Error: {}", (tostring(p5)))
				end)
			end
		end)
	end
end
