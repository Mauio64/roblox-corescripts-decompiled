local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SharedFlags = require(ExpChatParent.SharedFlags)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local UniverseChatSystemMessageAdded = require(ExpChat.Actions.UniverseChatSystemMessageAdded)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local context = ExpChatShared.context
local GlobalCommands = ExpChatShared.GlobalCommands
local v12 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

return function(s1: string, n1: number) -- line: 18
	-- upvalues: context (copy), v12 (copy), GlobalCommands (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), UniverseChatSystemMessageAdded (copy)
	if not context.translator then
		v12:warning("context.translator is nil, cannot execute command")

		return false
	end

	for _, v in ipairs(GlobalCommands.getGlobalEnabledCommands()) do
		for _, v2 in ipairs(v.alias) do
			if s1 == v2 or string.find(s1, "^" .. v2 .. "%s") ~= nil then
				local v19 = v.clientRun(context.store, n1, s1, context)

				if v19 ~= nil then
					local key = v19.key
					local v21 = nil

					if type(key) == "string" and key ~= "" then
						v21 = context.translator:FormatByKey(key, v19.args)
					elseif type(key) == "table" and #key > 0 then
						local t1 = {}

						for _, v24 in key do
							table.insert(t1, context.translator:FormatByKey(v24, v19.args))
						end

						v21 = table.concat(t1, "\n")
					end

					if v21 then
						if FFlagExpChatUseMessagesStore then
							GetMessagesStore(false).addSystemMessage(v21, "RBXGlobal")

							if FFlagExpChatUseChannelTabsStore then
								GetChannelTabsStore(false).markChannelUnread("RBXGlobal")
							end
						else
							context.store:dispatch(UniverseChatSystemMessageAdded(v21, "RBXGlobal"))
						end
					end
				end

				return true
			end
		end
	end

	return false
end
