local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Signals = require(ParentParent.Signals)
local ChatApp = require(script.Parent.ChatApp)
local mountToTargetInstance = require(script.Parent.mountToTargetInstance)
local TextChatServiceIntegration = require(script.Parent.TextChatServiceIntegration)
local useTextChannelWindowProps = require(script.Parent.useTextChannelWindowProps)
local useLocalUserInTextChannel = require(script.Parent.useLocalUserInTextChannel)
local useRobloxSystemMessage = require(script.Parent.useRobloxSystemMessage)
local ChatAvailabilityContext = require(script.Parent.ChatAvailabilityContext)
local MessageWriterContext = require(script.Parent.MessageWriterContext)
local useLocalUserChatAvailability = ChatAvailabilityContext.useLocalUserChatAvailability

local function TextChannelWindowRoot(t1: {[any]: any}) -- line: 24
	-- upvalues: useTextChannelWindowProps (copy), useLocalUserInTextChannel (copy), useLocalUserChatAvailability (copy), useRobloxSystemMessage (copy), React (copy), TextChatServiceIntegration (copy), ChatApp (copy)
	local v16 = useTextChannelWindowProps(t1.textChannelWindow)
	local target = v16.target
	local v18 = useLocalUserInTextChannel(target, t1.localUserId)
	local v19 = if target ~= nil then v18 and "member" or "not-member" else "no-channel"
	local v20 = if v19 ~= "member" then nil else target
	local v21 = useLocalUserChatAvailability()
	local v22 = useRobloxSystemMessage()

	React.useEffect(function() -- line: 42
		-- upvalues: t1 (copy), TextChatServiceIntegration (copy), v20 (copy)
		t1.setMessages(function() -- line: 43
			return {}
		end)

		return TextChatServiceIntegration.subscribeToMessages({
			channel = v20,
			textChatService = t1.textChatService,
			localUserId = t1.localUserId,
			setMessages = t1.setMessages
		})
	end, {
		v20,
		t1.localUserId,
		t1.setMessages,
		t1.textChatService
	})
	React.useEffect(function() -- line: 54
		-- upvalues: v21 (copy), v22 (copy)
		if v21.messageKey then
			v22.displayRobloxSystemMessage(v21.messageKey, v21.messageFallback or "")
		end

		return v22.clearAvailabilityMessage
	end, {
		v22,
		v21.messageKey,
		v21.messageFallback
	})

	return React.createElement(ChatApp, {
		messagesSignal = t1.getMessages,
		localUserId = t1.localUserId,
		targetChannel = v20,
		channelState = v19,
		canLocalUserChat = v21.canChat,
		backgroundColor = v16.backgroundColor
	})
end

local t2 = {}

return {
	start = function() -- line: 73
		-- upvalues: t2 (copy), Signals (copy), React (copy), MessageWriterContext (copy), ChatAvailabilityContext (copy), TextChannelWindowRoot (copy), mountToTargetInstance (copy)
		local function onRemoved(p1) -- line: 74
			-- upvalues: t2 (copy)
			local v29 = t2[p1]

			if v29 then
				v29()
				t2[p1] = nil
			end
		end
		local function onAdded(p2) -- line: 82
			-- upvalues: Signals (copy), React (copy), MessageWriterContext (copy), ChatAvailabilityContext (copy), TextChannelWindowRoot (copy), mountToTargetInstance (copy), t2 (copy)
			local LocalPlayer = game:GetService("Players").LocalPlayer

			if not LocalPlayer then
				return
			end

			local str = tostring(LocalPlayer.UserId)
			local TextChatService = game:GetService("TextChatService")
			local v34, v35 = Signals.createSignal({})
			local v36 = React.createElement(MessageWriterContext.Provider, {
				setMessages = v35
			}, {
				availability = React.createElement(ChatAvailabilityContext.Provider, {
					subjectPlayer = LocalPlayer
				}, {
					root = React.createElement(TextChannelWindowRoot, {
						localUserId = str,
						textChannelWindow = p2,
						textChatService = TextChatService,
						getMessages = v34,
						setMessages = v35
					})
				})
			})
			local v37 = mountToTargetInstance(p2, v36)

			if v37 then
				t2[p2] = v37
			end

			p2.AncestryChanged:Connect(function() -- line: 110
				-- upvalues: p2 (copy), t2 (copy)
				if not p2:IsDescendantOf(game) then
					local v38 = p2
					local v39 = t2[v38]

					if v39 then
						v39()
						t2[v38] = nil
					end
				end
			end)
		end

		local TextChatService = game:GetService("TextChatService")

		for _, v27 in TextChatService:GetTextChannelWindows() do
			onAdded(v27)
		end

		TextChatService.TextChannelWindowAdded:Connect(onAdded)
		TextChatService.TextChannelWindowRemoved:Connect(onRemoved)
	end
}
