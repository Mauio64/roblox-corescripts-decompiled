local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Signals = require(AppChatParent.Signals)

require(AppChat.MessageData.Types)

local Enums = require(AppChat.MessageData.Enums)

require(script.Parent.Parent.GetConversationMessageStore.createConversationMessageStore)
require(script.Parent.Parent.GetConversationMessageListStore.createConversationMessageListStore)

local GroupedMessageVariant = Enums.GroupedMessageVariant
local MessageStatus = Enums.MessageStatus
local MessageType = Enums.MessageType
local MessageVisibility = Enums.MessageVisibility

local function isChatMessage(p1) -- line: 43
	-- upvalues: MessageType (copy)
	if p1 == nil then
		return false
	end

	return p1.type == MessageType.User
end
local function parseTimestamp(s1: string?) -- line: 50
	if s1 == nil then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(s1)

	if dateTime then
		return dateTime.UnixTimestamp
	end

	return nil
end
local function timeDiffExceedsThreshold(p2, p3) -- line: 61
	if p2 == nil or p3 == nil then
		return false
	end

	local created_at = p2.created_at
	local v24

	if created_at == nil then
		v24 = nil
	else
		local dateTime = DateTime.fromIsoDate(created_at)

		v24 = if not dateTime then nil else dateTime.UnixTimestamp
	end

	local created_at2 = p3.created_at
	local v27

	if created_at2 == nil then
		v27 = nil
	else
		local dateTime = DateTime.fromIsoDate(created_at2)

		v27 = if not dateTime then nil else dateTime.UnixTimestamp
	end

	if v24 == nil or v27 == nil then
		return false
	end

	return math.abs(v24 - v27) > 300
end
local function isModeratedMessage(p4) -- line: 73
	-- upvalues: MessageStatus (copy)
	return p4 ~= nil and p4.status == MessageStatus.Moderated
end
local function isHiddenMessage(p5) -- line: 77
	-- upvalues: MessageVisibility (copy)
	return p5 ~= nil and p5.visibility == MessageVisibility.Hidden
end
local function isReplyMessage(p6) -- line: 81
	return p6 ~= nil and p6.replies_to ~= nil
end
local function canGroupWithAdjacent(p7, p8) -- line: 85
	-- upvalues: MessageType (copy), MessageVisibility (copy), MessageStatus (copy)
	local v34 = false

	if p8 ~= nil then
		v34 = p8 ~= nil and p8.type == MessageType.User

		if v34 then
			v34 = false

			if p8.sender_user_id == p7.sender_user_id then
				v34 = not (p7 ~= nil and p7.visibility == MessageVisibility.Hidden)

				if v34 then
					v34 = not (p8 ~= nil and p8.visibility == MessageVisibility.Hidden)

					if v34 then
						v34 = not (p7 ~= nil and p7.status == MessageStatus.Moderated)

						if v34 then
							v34 = not (p8 ~= nil and p8.status == MessageStatus.Moderated)

							if v34 then
								local v35

								if p8 == nil or p7 == nil then
									v35 = false
								else
									local created_at = p8.created_at
									local v37

									if created_at == nil then
										v37 = nil
									else
										local dateTime = DateTime.fromIsoDate(created_at)

										v37 = if not dateTime then nil else dateTime.UnixTimestamp
									end

									local created_at3 = p7.created_at
									local v40

									if created_at3 == nil then
										v40 = nil
									else
										local dateTime = DateTime.fromIsoDate(created_at3)

										v40 = if not dateTime then nil else dateTime.UnixTimestamp
									end

									v35 = v37 ~= nil and (v40 ~= nil and math.abs(v37 - v40) > 300)
								end

								v34 = not v35
							end
						end
					end
				end
			end
		end
	end

	return v34
end
local function computeGroupedVariant(p9, p10, p11) -- line: 96
	-- upvalues: MessageType (copy), canGroupWithAdjacent (copy), GroupedMessageVariant (copy)
	if p9 == nil or p9.type ~= MessageType.User then
		return nil
	end

	local v45 = canGroupWithAdjacent(p9, p10) and not (p10 ~= nil and p10.replies_to ~= nil)
	local v46 = canGroupWithAdjacent(p9, p11) and not (p9 ~= nil and p9.replies_to ~= nil)

	if not v45 and not v46 then
		return GroupedMessageVariant.Single
	end

	if not v45 and v46 then
		return GroupedMessageVariant.Last
	end

	if v45 and not v46 then
		return GroupedMessageVariant.First
	end

	return GroupedMessageVariant.Middle
end
local function createConversationMessageViewModelStore(p12, p13) -- line: 126
	-- upvalues: Signals (copy), MessageType (copy), GroupedMessageVariant (copy), computeGroupedVariant (copy)
	local t1 = {}

	return {
		conversationMessageStore = p12,
		conversationMessageListStore = p13,
		getGroupedVariant = function(s2: string, s3: string) -- line: 132
			-- upvalues: t1 (copy), Signals (copy), p12 (copy), MessageType (copy), p13 (copy), GroupedMessageVariant (copy), computeGroupedVariant (copy)
			local v52 = t1[s3]

			if v52 then
				local v53 = v52[s2]

				if v53 ~= nil then
					return v53
				end
			else
				v52 = {}
				t1[s3] = v52
			end

			local v54 = Signals.createComputed(function(p14) -- line: 145
				-- upvalues: p12 (copy), s2 (copy), MessageType (copy), p13 (copy), s3 (copy), GroupedMessageVariant (copy), computeGroupedVariant (copy)
				local v57 = p12.messages(p14)
				local v58 = v57[s2]

				if v58 == nil then
					return nil
				end

				if v58 == nil or v58.type ~= MessageType.User then
					return nil
				end

				if p13.getIndex(s3, s2, p14) == nil then
					return GroupedMessageVariant.Single
				end

				local v59 = p13.getPrevId(s3, s2, p14)
				local v60 = p13.getNextId(s3, s2, p14)
				local v61 = if v59 == nil then nil else v57[v59]
				local v62 = if v60 == nil then nil else v57[v60]

				return (computeGroupedVariant(v58, v61, v62))
			end)

			v52[s2] = v54

			return v54
		end,
		evictConversation = function(s4: string) -- line: 174
			-- upvalues: t1 (copy)
			t1[s4] = nil
		end
	}
end

return createConversationMessageViewModelStore
