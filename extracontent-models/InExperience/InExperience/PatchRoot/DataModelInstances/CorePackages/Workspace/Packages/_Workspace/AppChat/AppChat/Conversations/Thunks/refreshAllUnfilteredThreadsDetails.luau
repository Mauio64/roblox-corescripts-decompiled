local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local Promise = require(parent.Promise)
local getDeepValue = require(AppChat.Utils.getDeepValue)
local multiGetConversationDetails = require(AppChat.Conversations.Thunks.multiGetConversationDetails)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local AppChatNetworking = require(parent.AppChatNetworking)
local refreshConversationUnfilteredThreadsDetails = require(script.Parent.refreshConversationUnfilteredThreadsDetails)

local FIntUnfilteredThreadsPvDelayMs = require(AppChat.Flags.FIntUnfilteredThreadsPvDelayMs)

return function(p: string?, flag: boolean?)
	return function(object)
		local v2 = getDeepValue(object:getState(), "ChatAppReducer.Conversations") or {}
		local filterMap = Cryo.List.filterMap(Cryo.Dictionary.values(v2), function(p2)
			if p2 and p2.id and p2.source ~= "friends" then
				return p2.id
			end

			return nil
		end)

		return Promise.delay(FIntUnfilteredThreadsPvDelayMs / 1000):andThen(function()
			if filterMap then
				object:dispatch(multiGetConversationDetails(filterMap)):catch(function(p2)
					v:warning("Error in multiGetConversationDetails thunk. Error: {}", (tostring(p2)))
				end)
			end

			object:dispatch(AppChatNetworking.rodux.GetChatLandingModal.API(flag)):catch(function(p2)
				v:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p2)))
			end)

			if p then
				object:dispatch(refreshConversationUnfilteredThreadsDetails(p, flag))
			end
		end)
	end
end
