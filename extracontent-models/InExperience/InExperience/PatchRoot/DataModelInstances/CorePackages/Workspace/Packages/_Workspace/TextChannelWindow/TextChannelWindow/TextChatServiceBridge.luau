local Parent = script:FindFirstAncestor("TextChannelWindow").Parent
local SharedFlags = require(Parent.SharedFlags)
local TextChatServiceIntegration = require(script.Parent.TextChatServiceIntegration)

require(script.Parent.createChannelMessagesStore)

local isTextSourceMuted = require(script.Parent.isTextSourceMuted)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local getFFlagExpChatUseChatMuteStore = require(script.Parent.getFFlagExpChatUseChatMuteStore)

local function createTextChatServiceBridge(p1, s1: string, p2) -- line: 23
	-- upvalues: getFFlagExpChatUseChatMuteStore (copy), isTextSourceMuted (copy), TextChatServiceIntegration (copy), getFFlagExpChatProtectedChatInternalAPIs (copy)
	local function connectChannel(p3) -- line: 28
		-- upvalues: getFFlagExpChatUseChatMuteStore (copy), isTextSourceMuted (copy), TextChatServiceIntegration (copy), s1 (copy), p2 (copy)
		local v16 = p3.Name == "RBXSystem"

		p3.MessageReceived:Connect(function(p4) -- line: 30
			-- upvalues: v16 (copy), getFFlagExpChatUseChatMuteStore (copy), isTextSourceMuted (copy), TextChatServiceIntegration (copy), s1 (copy), p2 (copy), p3 (copy)
			if not p4.TextSource and not v16 then
				return
			end

			if getFFlagExpChatUseChatMuteStore() and p4.TextSource and isTextSourceMuted(p4.TextSource) then
				return
			end

			local v25 = TextChatServiceIntegration.mapTextChatMessage(p4, s1)

			if v25.content == "" then
				p2.removeMessage(p3, v25.messageId)

				return
			end

			p2.upsertMessage(p3, v25)
		end)
	end

	p1.SendingMessage:Connect(function(message) -- line: 46
		-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), TextChatServiceIntegration (copy), s1 (copy), p2 (copy)
		if not message.TextSource then
			return
		end

		if ((if not getFFlagExpChatProtectedChatInternalAPIs() then message.Text else message.TextInternal)) == "" then
			return
		end

		local TextChannel = message.TextChannel

		if not TextChannel then
			return
		end

		local v19 = TextChatServiceIntegration.mapSendingMessage(message, s1)

		p2.insertIfAbsent(TextChannel, v19)
	end)

	for _, descendant in p1:GetDescendants() do
		if descendant:IsA("TextChannel") then
			local v14 = descendant.Name == "RBXSystem"

			descendant.MessageReceived:Connect(function(p5) -- line: 30
				-- upvalues: v14 (copy), getFFlagExpChatUseChatMuteStore (copy), isTextSourceMuted (copy), TextChatServiceIntegration (copy), s1 (copy), p2 (copy), descendant (copy)
				if not p5.TextSource and not v14 then
					return
				end

				if getFFlagExpChatUseChatMuteStore() and p5.TextSource and isTextSourceMuted(p5.TextSource) then
					return
				end

				local v21 = TextChatServiceIntegration.mapTextChatMessage(p5, s1)

				if v21.content == "" then
					p2.removeMessage(descendant, v21.messageId)

					return
				end

				p2.upsertMessage(descendant, v21)
			end)
		end
	end

	p1.DescendantAdded:Connect(function(descendant) -- line: 68
		-- upvalues: getFFlagExpChatUseChatMuteStore (copy), isTextSourceMuted (copy), TextChatServiceIntegration (copy), s1 (copy), p2 (copy)
		if descendant:IsA("TextChannel") then
			local v23 = descendant.Name == "RBXSystem"

			descendant.MessageReceived:Connect(function(p6) -- line: 30
				-- upvalues: v23 (copy), getFFlagExpChatUseChatMuteStore (copy), isTextSourceMuted (copy), TextChatServiceIntegration (copy), s1 (copy), p2 (copy), descendant (copy)
				if not p6.TextSource and not v23 then
					return
				end

				if getFFlagExpChatUseChatMuteStore() and p6.TextSource and isTextSourceMuted(p6.TextSource) then
					return
				end

				local v27 = TextChatServiceIntegration.mapTextChatMessage(p6, s1)

				if v27.content == "" then
					p2.removeMessage(descendant, v27.messageId)

					return
				end

				p2.upsertMessage(descendant, v27)
			end)
		end
	end)
end

return createTextChatServiceBridge
