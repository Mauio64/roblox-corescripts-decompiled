local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local SharedFlags = require(parent.SharedFlags)

local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)

local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local Analytics = ExpChatShared.Analytics
local FFlagExpChatReportVirtualCommandTelemetry = ExpChatShared.Flags.FFlagExpChatReportVirtualCommandTelemetry
local context = ExpChatShared.context
local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

return function(value: string, p: number, list, p2: string): boolean
	if not context.translator then
		v:warning("context.translator is nil, cannot execute command")
		return false
	end

	for _, item in ipairs(list) do
		for _, alia in ipairs(item.alias) do
			if value == alia or string.find(value, "^" .. alia .. "%s") ~= nil then
				if FFlagExpChatReportVirtualCommandTelemetry then
					Analytics:reportTextChatCommandClientSent(item.name)
				end

				task.spawn(function()
					local clientRun = item.clientRun(context.store, p, value, context)

					if clientRun ~= nil then
						local key = clientRun.key
						local v2 = nil

						if type(key) == "string" and key ~= "" then
							v2 = context.translator:FormatByKey(key, clientRun.args)
						elseif type(key) == "table" and #key > 0 then
							local v3 = {}

							for _, item2 in key do
								table.insert(v3, context.translator:FormatByKey(item2, clientRun.args))
							end

							v2 = table.concat(v3, "\n")
						end

						if v2 then
							GetMessagesStore(false).addSystemMessage(v2, p2, clientRun.metadata)

							if FFlagExpChatUseChannelTabsStore then
								GetChannelTabsStore(false).markChannelUnread(p2)
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
