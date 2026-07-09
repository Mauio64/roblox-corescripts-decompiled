local ParentParent = script.Parent.Parent

require(script.Parent.ChatApp)

local getFFlagExpChatProtectedChatInternalAPIs = require(ParentParent.SharedFlags).getFFlagExpChatProtectedChatInternalAPIs
local getTextAndTranslation = require(script.Parent.getTextAndTranslation)

local function buildUserMessage(p1, p2, b1: boolean) -- line: 13
	-- upvalues: getTextAndTranslation (copy), getFFlagExpChatProtectedChatInternalAPIs (copy)
	local v12 = getTextAndTranslation(p1)

	return {
		messageType = "user",
		status = nil,
		messageId = p1.MessageId,
		senderUserId = tostring(p2.UserId),
		prefixText = if not getFFlagExpChatProtectedChatInternalAPIs() then p1.PrefixText else p1.PrefixTextInternal,
		content = v12,
		wasRewritten = not not p1.WasRewritten or nil,
		originalText = if not p1.WasRewritten then nil else p1.OriginalText,
		timestamp = p1.Timestamp,
		isOutgoing = b1
	}
end
local function mapTextChatMessage(p3, s1: string) -- line: 32
	-- upvalues: buildUserMessage (copy), getFFlagExpChatProtectedChatInternalAPIs (copy)
	if p3.TextSource then
		return (buildUserMessage(p3, p3.TextSource, s1 == tostring(p3.TextSource.UserId)))
	end

	return {
		messageType = "system-roblox",
		messageId = p3.MessageId,
		content = if not getFFlagExpChatProtectedChatInternalAPIs() then p3.Text else p3.TextInternal,
		timestamp = p3.Timestamp
	}
end
local function mapSendingMessage(p4) -- line: 47
	-- upvalues: buildUserMessage (copy)
	return (buildUserMessage(p4, p4.TextSource, true))
end
local function applyMessage(t1: {[any]: any}, p5) -- line: 56
	for v18, v19 in t1 do
		if v19.messageId == p5.messageId then
			local v20 = table.clone(t1)

			if p5.content == "" then
				table.remove(v20, v18)

				return v20
			end

			v20[v18] = p5

			return v20
		end
	end

	if p5.content == "" then
		return t1
	end

	local v21 = table.clone(t1)

	table.insert(v21, p5)

	return v21
end
local function applyOutgoingMessage(t2: {[any]: any}, p6) -- line: 80
	for _, v25 in t2 do
		if v25.messageId == p6.messageId then
			return t2
		end
	end

	local v26 = table.clone(t2)

	table.insert(v26, p6)

	return v26
end

return {
	mapTextChatMessage = mapTextChatMessage,
	applyMessage = applyMessage,
	subscribeToMessages = function(t3: {[any]: any}) -- line: 103
		-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), buildUserMessage (copy), mapTextChatMessage (copy), applyMessage (copy)
		local channel = t3.channel

		if not channel then
			return function() -- line: 106
			end
		end

		local t4 = {}
		local localUserId = t3.localUserId
		local setMessages = t3.setMessages

		table.insert(t4, t3.textChatService.SendingMessage:Connect(function(message) -- line: 115
			-- upvalues: channel (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), buildUserMessage (copy), setMessages (copy)
			if not message.TextSource then
				return
			end

			if message.TextChannel ~= channel then
				return
			end

			if ((if not getFFlagExpChatProtectedChatInternalAPIs() then message.Text else message.TextInternal)) == "" then
				return
			end

			local v34 = buildUserMessage(message, message.TextSource, true)

			setMessages(function(p7) -- line: 131
				-- upvalues: v34 (copy)
				local v40 = v34

				for _, v42 in p7 do
					if v42.messageId == v40.messageId then
						return p7
					end
				end

				local v43 = table.clone(p7)

				table.insert(v43, v40)

				return v43
			end)
		end))

		local v32 = channel.Name == "RBXSystem"

		table.insert(t4, channel.MessageReceived:Connect(function(p8) -- line: 140
			-- upvalues: v32 (copy), mapTextChatMessage (copy), localUserId (copy), setMessages (copy), applyMessage (copy)
			if not p8.TextSource and not v32 then
				return
			end

			local v36 = mapTextChatMessage(p8, localUserId)

			setMessages(function(p9) -- line: 146
				-- upvalues: applyMessage (copy), v36 (copy)
				return (applyMessage(p9, v36))
			end)
		end))

		return function() -- line: 152
			-- upvalues: t4 (copy)
			for _, v38 in t4 do
				v38:Disconnect()
			end
		end
	end
}
