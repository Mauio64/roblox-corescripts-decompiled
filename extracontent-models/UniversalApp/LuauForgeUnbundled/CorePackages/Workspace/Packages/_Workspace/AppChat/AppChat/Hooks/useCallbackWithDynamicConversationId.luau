require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")
local useGetOneToOneFriendIdFromConversationId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetOneToOneFriendIdFromConversationId")

local function useCallbackWithDynamicConversationId(p2, p3)
	local v5 = useGetConversationFromId(p3)
	local v6 = v5 ~= nil
	local v7 = useGetOneToOneFriendIdFromConversationId(p3)

	local v8 = if v5 then v5.source == "friends" and v7 else v5

	if v5 then
		v5 = not (v5.source == "friends") and p3
	end

	return React.useCallback(function(options)
		return p2(Cryo.Dictionary.union(options or {}, {
			conversationId = if v5 then p3 else nil,
			friendId = if v8 then v7 else nil
		}))
	end, { p2, p3, v8, v5, v7 }), v6
end

return useCallbackWithDynamicConversationId
