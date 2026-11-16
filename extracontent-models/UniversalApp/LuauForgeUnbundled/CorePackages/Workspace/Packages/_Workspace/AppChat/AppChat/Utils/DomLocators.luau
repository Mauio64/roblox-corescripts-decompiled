local v5 = {}

local function coerceToString(p2)
	if p2 == nil then
		return ""
	end

	return (tostring(p2))
end

function v5.sanitizeSegment(p2)
	return ((p2 == nil and "" or tostring(p2)):gsub("%s+", "_"):gsub("[^%w_]", ""))
end

function v5.build(items)
	local v6 = {}

	for k, item in items do
		local v7 = v5.sanitizeSegment(item)

		if v7 ~= "" then
			table.insert(v6, v7)
		end
	end

	return table.concat(v6, "-")
end

function v5.chatLandingTopBarIconButton(p2)
	return v5.build({ "chat", "chatLanding", "topBar", "button", p2 })
end

function v5.appChatLoadingOverlayBackButton()
	return v5.build({ "chat", "loadingOverlay", "button", "back" })
end

function v5.chatLandingConversationListHeader(p2)
	return v5.build({
		"chat",
		"chatLanding",
		"conversationList",
		"conversationListHeader",
		p2
	})
end

function v5.chatLandingConversationEntry(p2)
	return v5.build({
		"chat",
		"chatLanding",
		"conversationList",
		"conversationEntry",
		p2
	})
end

function v5.chatLandingConversationEntrySquadButton(p2)
	return v5.build({
		"chat",
		"chatLanding",
		"conversationList",
		"conversationEntry",
		"button",
		`squad_{p2}`
	})
end

function v5.chatDetailsTopBarActionButton(p2)
	return v5.build({ "chat", "chatDetails", "topBar", "button", p2 })
end

function v5.chatDetailsListActionButton(p2)
	return v5.build({ "chat", "chatDetails", "detailsList", "button", p2 })
end

function v5.chatDetailsParticipantMoreButton(p2)
	return v5.build({
		"chat",
		"chatDetails",
		"detailsList",
		"participantList",
		"participantEntry",
		"button",
		`{p2}_moreDetails`
	})
end

function v5.chatConversationTopBarButton(p2)
	return v5.build({ "chat", "chatConversation", "topBar", "button", p2 })
end

function v5.chatConversationSystemMessageCard(list)
	local build = v5.build

	if type(list) == "table" then
		list = table.concat(list, "_")
	end

	return build({
		"chat",
		"chatConversation",
		"messageList",
		"systemMessageCard",
		list
	})
end

function v5.chatConversationSystemMessage(p2)
	return v5.build({
		"chat",
		"chatConversation",
		"messageList",
		"systemMessageText",
		p2
	})
end

function v5.selectChatMembersUserCellWithCheckbox(p2, p3)
	return v5.build({
		"chat",
		"selectChatMembers",
		"friendsList",
		"userCellWithCheckbox",
		"checkbox",
		`{p2}_{p3 and "checked" or "unchecked"}`
	})
end

function v5.selectChatMembersSearchInput(p2)
	return v5.build({ "chat", "selectChatMembers", "searchBar", "textInput", p2 })
end

function v5.selectChatMembersTopBarActionButton(p2)
	return v5.build({ "chat", "selectChatMembers", "topBar", "button", p2 })
end

return v5
