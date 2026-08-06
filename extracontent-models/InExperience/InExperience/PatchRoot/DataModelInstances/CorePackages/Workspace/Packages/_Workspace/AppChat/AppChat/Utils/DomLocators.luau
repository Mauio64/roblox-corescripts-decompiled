local t1 = {}

local function coerceToString(p1) -- line: 33
	if p1 == nil then
		return ""
	end

	return (tostring(p1))
end

function t1.sanitizeSegment(p2) -- line: 40
	return (((if p2 ~= nil then tostring(p2) else "")):gsub("%s+", "_"):gsub("[^%w_]", ""))
end
function t1.build(t2: {[any]: any}) -- line: 51
	-- upvalues: t1 (copy)
	local t3 = {}

	for _, v8 in t2 do
		local v9 = t1.sanitizeSegment(v8)

		if v9 ~= "" then
			table.insert(t3, v9)
		end
	end

	return table.concat(t3, "-")
end
function t1.chatLandingTopBarIconButton(s1: string) -- line: 62
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"chatLanding",
		"topBar",
		"button",
		s1
	})
end
function t1.appChatLoadingOverlayBackButton() -- line: 72
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"loadingOverlay",
		"button",
		"back"
	})
end
function t1.chatLandingConversationListHeader(s2: string) -- line: 81
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"chatLanding",
		"conversationList",
		"conversationListHeader",
		s2
	})
end
function t1.chatLandingConversationEntry(s3: string) -- line: 91
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"chatLanding",
		"conversationList",
		"conversationEntry",
		s3
	})
end
function t1.chatLandingConversationEntrySquadButton(s4: string) -- line: 101
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"chatLanding",
		"conversationList",
		"conversationEntry",
		"button",
		`squad_{ s4 }`
	})
end
function t1.chatDetailsTopBarActionButton(s5: string) -- line: 112
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"chatDetails",
		"topBar",
		"button",
		s5
	})
end
function t1.chatDetailsListActionButton(s6: string) -- line: 122
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"chatDetails",
		"detailsList",
		"button",
		s6
	})
end
function t1.chatDetailsParticipantMoreButton(s7: string) -- line: 132
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"chatDetails",
		"detailsList",
		"participantList",
		"participantEntry",
		"button",
		`{ s7 }_moreDetails`
	})
end
function t1.chatConversationTopBarButton(s8: string) -- line: 144
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"chatConversation",
		"topBar",
		"button",
		s8
	})
end
function t1.chatConversationSystemMessageCard(p3) -- line: 154
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"chatConversation",
		"messageList",
		"systemMessageCard",
		if type(p3) ~= "table" then p3 else table.concat(p3, "_")
	})
end
function t1.chatConversationSystemMessage(s9: string) -- line: 164
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"chatConversation",
		"messageList",
		"systemMessageText",
		s9
	})
end
function t1.selectChatMembersUserCellWithCheckbox(s10: string, b1: boolean) -- line: 174
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"selectChatMembers",
		"friendsList",
		"userCellWithCheckbox",
		"checkbox",
		`{ s10 }_{ not b1 and "unchecked" or "checked" }`
	})
end
function t1.selectChatMembersSearchInput(s11: string?) -- line: 185
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"selectChatMembers",
		"searchBar",
		"textInput",
		s11
	})
end
function t1.selectChatMembersTopBarActionButton(s12: string) -- line: 195
	-- upvalues: t1 (copy)
	return t1.build({
		"chat",
		"selectChatMembers",
		"topBar",
		"button",
		s12
	})
end

return t1
