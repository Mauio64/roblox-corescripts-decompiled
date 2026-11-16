local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local parent = script.Parent.Parent
local FFlagTopBarDeprecateChatRodux = require(parent.Flags.FFlagTopBarDeprecateChatRodux)

if FFlagTopBarDeprecateChatRodux then
	return nil
end

local Actions = script.Parent.Parent.Actions
local UpdateChatMessages = require(Actions.UpdateChatMessages)
local UpdateUnreadMessagesBadge = require(Actions.UpdateUnreadMessagesBadge)
local UpdateChatVisible = require(Actions.UpdateChatVisible)
local SetCanChat = require(Actions.SetCanChat)

return (Rodux.createReducer({
	canChat = false,
	visible = true,
	lastReadMessages = 0,
	unreadMessages = 0
}, {
	[UpdateUnreadMessagesBadge.name] = function(p, p2)
		if p.visible then
			return { canChat = p.canChat, visible = true, lastReadMessages = 0, unreadMessages = 0 }
		end

		return {
			canChat = p.canChat,
			visible = false,
			lastReadMessages = 0,
			unreadMessages = p2.messages
		}
	end,
	[UpdateChatMessages.name] = function(data, p)
		if data.visible then
			return {
				canChat = data.canChat,
				visible = true,
				lastReadMessages = p.messages,
				unreadMessages = 0
			}
		end

		return {
			canChat = data.canChat,
			visible = false,
			lastReadMessages = data.lastReadMessages,
			unreadMessages = p.messages - data.lastReadMessages
		}
	end,
	[UpdateChatVisible.name] = function(data, p)
		if p.visible then
			return {
				canChat = data.canChat,
				visible = true,
				lastReadMessages = data.lastReadMessages + data.unreadMessages,
				unreadMessages = 0
			}
		end

		return {
			canChat = data.canChat,
			visible = false,
			lastReadMessages = data.lastReadMessages,
			unreadMessages = data.unreadMessages
		}
	end,
	[SetCanChat.name] = function(data, p)
		return {
			canChat = p.canChat,
			visible = data.visible,
			lastReadMessages = data.lastReadMessages,
			unreadMessages = data.unreadMessages
		}
	end
}))
