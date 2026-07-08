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
local v11 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

return function(s1: string, n1: number, t1: {[any]: any}, s2: string) -- line: 21
	-- upvalues: context (copy), v11 (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), UniverseChatSystemMessageAdded (copy)
	if not context.translator then
		v11:warning("context.translator is nil, cannot execute command")

		return false
	end

	for _, v in ipairs(t1) do
		for _, v2 in ipairs(v.alias) do
			if s1 == v2 or string.find(s1, "^" .. v2 .. "%s") ~= nil then
				task.spawn(function() -- line: 34
					-- upvalues: v (copy), context (copy), n1 (copy), s1 (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), s2 (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), UniverseChatSystemMessageAdded (copy)
					local v20 = v.clientRun(context.store, n1, s1, context)

					if v20 ~= nil then
						local key = v20.key
						local v22 = nil

						if type(key) == "string" and key ~= "" then
							v22 = context.translator:FormatByKey(key, v20.args)
						elseif type(key) == "table" and #key > 0 then
							local t2 = {}

							for _, v25 in key do
								table.insert(t2, context.translator:FormatByKey(v25, v20.args))
							end

							v22 = table.concat(t2, "\n")
						end

						if v22 then
							if FFlagExpChatUseMessagesStore then
								GetMessagesStore(false).addSystemMessage(v22, s2, v20.metadata)

								if FFlagExpChatUseChannelTabsStore then
									GetChannelTabsStore(false).markChannelUnread(s2)

									return
								end
							else
								context.store:dispatch(UniverseChatSystemMessageAdded(v22, s2, v20.metadata))
							end
						end
					end
				end)

				return true
			end
		end
	end

	return false
end
