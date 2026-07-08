local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local ExpChatShared = require(CorePackages.Workspace.Packages.ExpChatShared)
local React = require(CorePackages.Packages.React)
local FFlagExpChatUseMessagesStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagExpChatUseMessagesStore
local useExpChatMessagesReducerSlice = ExpChat.Hooks.useExpChatMessagesReducerSlice

local function useOrderedMessages() -- line: 13
	-- upvalues: FFlagExpChatUseMessagesStore (copy), ExpChatShared (copy), useExpChatMessagesReducerSlice (copy), React (copy), Cryo (copy)
	local u10, u11

	if FFlagExpChatUseMessagesStore then
		local messagesStore = ExpChatShared.context.messagesStore

		if not messagesStore then
			return {}
		end

		u10 = messagesStore.getByMessageId(false) or {}
		u11 = messagesStore.getWindowMessagesInOrder(false) or {}
	else
		local v12 = useExpChatMessagesReducerSlice()

		if not v12 then
			return {}
		end

		u10 = v12.byMessageId
		u11 = v12.windowMessagesInOrder
	end

	return React.useMemo(function() -- line: 33
		-- upvalues: Cryo (copy), u11 (ref), u10 (ref)
		return Cryo.List.map(u11, function(p1) -- line: 34
			-- upvalues: u10 (ref)
			return u10[p1]
		end)
	end, {
		u10,
		u11
	})
end

return useOrderedMessages
