local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")
local multiGetConversationDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/multiGetConversationDetails")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("refreshAllUnfilteredThreadsDetails")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local refreshConversationUnfilteredThreadsDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/refreshConversationUnfilteredThreadsDetails")

local FIntUnfilteredThreadsPvDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntUnfilteredThreadsPvDelayMs")

return function(p2, p3)
	return function(object)
		local v6 = getDeepValue(object:getState(), "ChatAppReducer.Conversations") or {}
		local filterMap = Cryo.List.filterMap(Cryo.Dictionary.values(v6), function(p4)
			if p4 and p4.id and p4.source ~= "friends" then
				return p4.id
			end

			return nil
		end)

		return Promise.delay(FIntUnfilteredThreadsPvDelayMs / 1000):andThen(function()
			if filterMap then
				object:dispatch(multiGetConversationDetails(filterMap)):catch(function(p4)
					v5:warning("Error in multiGetConversationDetails thunk. Error: {}", (tostring(p4)))
				end)
			end

			object:dispatch(AppChatNetworking.rodux.GetChatLandingModal.API(p3)):catch(function(p4)
				v5:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p4)))
			end)

			if p2 then
				object:dispatch(refreshConversationUnfilteredThreadsDetails(p2, p3))
			end
		end)
	end
end
