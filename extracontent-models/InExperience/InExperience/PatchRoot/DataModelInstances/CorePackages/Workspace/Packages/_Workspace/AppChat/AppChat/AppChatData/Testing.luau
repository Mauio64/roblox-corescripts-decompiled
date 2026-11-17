local AppChat = script:FindFirstAncestor("AppChat")

local GetConversationMessageListStore = require(AppChat.Stores.GetConversationMessageListStore)
local GetConversationMessageStore = require(AppChat.Stores.GetConversationMessageStore)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local GetUnreadMessageCountStore = require(AppChat.Stores.GetUnreadMessageCountStore)
local searchIntroducedConversationIds = require(AppChat.Stores.searchIntroducedConversationIds)

local Ports = require(AppChat.AppChatData.Ports)
local createHttpPort = require(AppChat.AppChatData.Ports.createHttpPort)
local createFakeRealtime = require(script.createFakeRealtime)
local createFakeServer = require(script.createFakeServer)

local v = nil

local function clearStores()
	GetConversationStore(false).clear()
	GetConversationMessageStore(false).clear()
	GetConversationMessageListStore(false).clear()
	GetUnreadMessageCountStore(false).reset()
	searchIntroducedConversationIds.clear()
end

return {
	install = function()
		assert(v == nil, "AppChatData.Testing.install() called again before restore()")

		local current = Ports.current
		local fakeServer = createFakeServer()
		local fakeRealtime = createFakeRealtime()

		Ports.current = {
			http = createHttpPort(fakeServer.request),
			realtime = fakeRealtime.port
		}

		clearStores()
		local function restore()
			if v ~= restore then
				return
			end

			Ports.current = current
			clearStores()
			v = nil
		end
		v = restore

		return { server = fakeServer, realtime = fakeRealtime, restore = restore }
	end
}
