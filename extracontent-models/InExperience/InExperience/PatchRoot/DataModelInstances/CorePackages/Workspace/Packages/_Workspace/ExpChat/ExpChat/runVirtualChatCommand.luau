local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SharedFlags = require(ExpChatParent.SharedFlags)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local UniverseChatSystemMessageAdded = require(ExpChat.Actions.UniverseChatSystemMessageAdded)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local Analytics = ExpChatShared.Analytics
local FFlagExpChatReportVirtualCommandTelemetry = ExpChatShared.Flags.FFlagExpChatReportVirtualCommandTelemetry
local context = ExpChatShared.context
local v13 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

return function(s1: string, n1: number, t1: {[any]: any}, s2: string) -- line: 23
	-- upvalues: context (copy), v13 (copy), FFlagExpChatReportVirtualCommandTelemetry (copy), Analytics (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), UniverseChatSystemMessageAdded (copy)
	if not context.translator then
		v13:warning("context.translator is nil, cannot execute command")

		return false
	end

	for _, v in ipairs(t1) do
		for _, v2 in ipairs(v.alias) do
			if s1 == v2 or string.find(s1, "^" .. v2 .. "%s") ~= nil then
				if FFlagExpChatReportVirtualCommandTelemetry then
					Analytics:reportTextChatCommandClientSent(v.name)
				end

				task.spawn(function() -- line: 40
					-- upvalues: v (copy), context (copy), n1 (copy), s1 (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), s2 (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), UniverseChatSystemMessageAdded (copy)
					local v22 = v.clientRun(context.store, n1, s1, context)

					if v22 ~= nil then
						local key = v22.key
						local v24 = nil

						if type(key) == "string" and key ~= "" then
							v24 = context.translator:FormatByKey(key, v22.args)
						elseif type(key) == "table" and #key > 0 then
							local t2 = {}

							for _, v27 in key do
								table.insert(t2, context.translator:FormatByKey(v27, v22.args))
							end

							v24 = table.concat(t2, "\n")
						end

						if v24 then
							if FFlagExpChatUseMessagesStore then
								GetMessagesStore(false).addSystemMessage(v24, s2, v22.metadata)

								if FFlagExpChatUseChannelTabsStore then
									GetChannelTabsStore(false).markChannelUnread(s2)

									return
								end
							else
								context.store:dispatch(UniverseChatSystemMessageAdded(v24, s2, v22.metadata))
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
