local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local SharedFlags = require(parent.SharedFlags)

local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)

local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local context = ExpChatShared.context
local GlobalCommands = ExpChatShared.GlobalCommands
local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

return function(value: string, p: number): boolean
	if not context.translator then
		v:warning("context.translator is nil, cannot execute command")
		return false
	end

	for _, v2 in ipairs(GlobalCommands.getGlobalEnabledCommands()) do
		for _, alia in ipairs(v2.alias) do
			if value == alia or string.find(value, "^" .. alia .. "%s") ~= nil then
				local clientRun = v2.clientRun(context.store, p, value, context)

				if clientRun == nil then
					return true
				end

				local key = clientRun.key
				local v3 = nil

				if type(key) == "string" and key ~= "" then
					v3 = context.translator:FormatByKey(key, clientRun.args)
				elseif type(key) == "table" and #key > 0 then
					local v4 = {}

					for _, item in key do
						table.insert(v4, context.translator:FormatByKey(item, clientRun.args))
					end

					v3 = table.concat(v4, "\n")
				end

				if v3 then
					GetMessagesStore(false).addSystemMessage(v3, "RBXGlobal")

					if FFlagExpChatUseChannelTabsStore then
						GetChannelTabsStore(false).markChannelUnread("RBXGlobal")
					end
				end

				return true
			end
		end
	end

	return false
end
