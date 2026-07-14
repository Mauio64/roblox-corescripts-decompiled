local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Signals = require(ParentParent.Signals)
local ChatApp = require(script.Parent.ChatApp)

require(script.Parent.Message)

local mountToTargetInstance = require(script.Parent.mountToTargetInstance)
local useTextChannelWindowProps = require(script.Parent.useTextChannelWindowProps)
local useLocalUserInTextChannel = require(script.Parent.useLocalUserInTextChannel)
local useRobloxSystemMessage = require(script.Parent.useRobloxSystemMessage)
local ChatAvailabilityContext = require(script.Parent.ChatAvailabilityContext)
local MessageWriterContext = require(script.Parent.MessageWriterContext)
local createChannelMessagesStore = require(script.Parent.createChannelMessagesStore)
local TextChatServiceBridge = require(script.Parent.TextChatServiceBridge)
local useLocalUserChatAvailability = ChatAvailabilityContext.useLocalUserChatAvailability
local v14 = Signals.createSignal({})

local function TextChannelWindowRoot(t1: {[any]: any}) -- line: 27
	-- upvalues: useTextChannelWindowProps (copy), useLocalUserInTextChannel (copy), useLocalUserChatAvailability (copy), useRobloxSystemMessage (copy), React (copy), v14 (copy), ChatApp (copy)
	local v18 = useTextChannelWindowProps(t1.textChannelWindow)
	local target = v18.target
	local v20 = useLocalUserInTextChannel(target, t1.localUserId)
	local v21 = if target ~= nil then v20 and "member" or "not-member" else "no-channel"
	local v22 = if v21 ~= "member" then nil else target
	local v23 = useLocalUserChatAvailability()
	local v24 = useRobloxSystemMessage()
	local v25 = React.useMemo(function() -- line: 47
		-- upvalues: v22 (copy), t1 (copy), v14 (copy)
		if v22 then
			return t1.getChannelMessages(v22)
		end

		return v14
	end, {
		v22,
		t1.getChannelMessages,
		v14
	})

	React.useEffect(function() -- line: 54
		-- upvalues: v23 (copy), v24 (copy)
		if v23.messageKey then
			v24.displayRobloxSystemMessage(v23.messageKey, v23.messageFallback or "")
		end

		return v24.clearAvailabilityMessage
	end, {
		v24,
		v23.messageKey,
		v23.messageFallback
	})

	return React.createElement(ChatApp, {
		messagesSignal = v25,
		localUserId = t1.localUserId,
		targetChannel = v22,
		channelState = v21,
		canLocalUserChat = v23.canChat,
		backgroundColor = v18.backgroundColor
	})
end

local t2 = {}

return {
	start = function() -- line: 73
		-- upvalues: createChannelMessagesStore (copy), t2 (copy), React (copy), MessageWriterContext (copy), ChatAvailabilityContext (copy), TextChannelWindowRoot (copy), mountToTargetInstance (copy), TextChatServiceBridge (copy)
		local LocalPlayer = game:GetService("Players").LocalPlayer

		if not LocalPlayer then
			return
		end

		local str = tostring(LocalPlayer.UserId)
		local v28 = createChannelMessagesStore()

		local function onRemoved(p1) -- line: 83
			-- upvalues: t2 (copy)
			local v35 = t2[p1]

			if v35 then
				v35()
				t2[p1] = nil
			end
		end
		local function onAdded(p2) -- line: 91
			-- upvalues: v28 (copy), React (copy), MessageWriterContext (copy), ChatAvailabilityContext (copy), LocalPlayer (copy), TextChannelWindowRoot (copy), str (copy), mountToTargetInstance (copy), t2 (copy)
			local v37 = React.createElement(MessageWriterContext.Provider, {
				upsertMessage = function(p3) -- line: 92
					-- upvalues: p2 (copy), v28 (copy)
					local p2Target = p2.Target

					if p2Target and p2Target:IsA("TextChannel") then
						v28.upsertMessage(p2Target, p3)
					end
				end,
				removeMessage = function(s1: string) -- line: 99
					-- upvalues: p2 (copy), v28 (copy)
					local p2Target = p2.Target

					if p2Target and p2Target:IsA("TextChannel") then
						v28.removeMessage(p2Target, s1)
					end
				end
			}, {
				availability = React.createElement(ChatAvailabilityContext.Provider, {
					subjectPlayer = LocalPlayer
				}, {
					root = React.createElement(TextChannelWindowRoot, {
						localUserId = str,
						textChannelWindow = p2,
						getChannelMessages = v28.getMessagesForChannel
					})
				})
			})
			local v38 = mountToTargetInstance(p2, v37)

			if v38 then
				t2[p2] = v38
			end

			p2.AncestryChanged:Connect(function() -- line: 126
				-- upvalues: p2 (copy), t2 (copy)
				if not p2:IsDescendantOf(game) then
					local v43 = p2
					local v44 = t2[v43]

					if v44 then
						v44()
						t2[v43] = nil
					end
				end
			end)
		end

		local TextChatService = game:GetService("TextChatService")

		TextChatServiceBridge(TextChatService, str, v28)

		for _, v33 in TextChatService:GetTextChannelWindows() do
			onAdded(v33)
		end

		TextChatService.TextChannelWindowAdded:Connect(onAdded)
		TextChatService.TextChannelWindowRemoved:Connect(onRemoved)
	end
}
