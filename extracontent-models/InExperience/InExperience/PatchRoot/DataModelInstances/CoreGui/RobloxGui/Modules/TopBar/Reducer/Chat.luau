local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent

if require(ParentParent.Flags.FFlagTopBarDeprecateChatRodux) then
	return nil
end

local Actions = script.Parent.Parent.Actions
local UpdateChatMessages = require(Actions.UpdateChatMessages)
local UpdateUnreadMessagesBadge = require(Actions.UpdateUnreadMessagesBadge)
local UpdateChatVisible = require(Actions.UpdateChatVisible)
local SetCanChat = require(Actions.SetCanChat)
local t1 = {
	canChat = false,
	visible = true,
	lastReadMessages = 0,
	unreadMessages = 0
}

return (Rodux.createReducer(t1, {
	[UpdateUnreadMessagesBadge.name] = function(p1, p2) -- line: 28
		if p1.visible then
			return {
				visible = true,
				lastReadMessages = 0,
				unreadMessages = 0,
				canChat = p1.canChat
			}
		end

		return {
			visible = false,
			lastReadMessages = 0,
			canChat = p1.canChat,
			unreadMessages = p2.messages
		}
	end,
	[UpdateChatMessages.name] = function(p3, p4) -- line: 46
		if p3.visible then
			return {
				visible = true,
				unreadMessages = 0,
				canChat = p3.canChat,
				lastReadMessages = p4.messages
			}
		end

		return {
			visible = false,
			canChat = p3.canChat,
			lastReadMessages = p3.lastReadMessages,
			unreadMessages = p4.messages - p3.lastReadMessages
		}
	end,
	[UpdateChatVisible.name] = function(p5, p6) -- line: 64
		if p6.visible then
			return {
				visible = true,
				unreadMessages = 0,
				canChat = p5.canChat,
				lastReadMessages = p5.lastReadMessages + p5.unreadMessages
			}
		end

		return {
			visible = false,
			canChat = p5.canChat,
			lastReadMessages = p5.lastReadMessages,
			unreadMessages = p5.unreadMessages
		}
	end,
	[SetCanChat.name] = function(p7, p8) -- line: 82
		return {
			canChat = p8.canChat,
			visible = p7.visible,
			lastReadMessages = p7.lastReadMessages,
			unreadMessages = p7.unreadMessages
		}
	end
}))
