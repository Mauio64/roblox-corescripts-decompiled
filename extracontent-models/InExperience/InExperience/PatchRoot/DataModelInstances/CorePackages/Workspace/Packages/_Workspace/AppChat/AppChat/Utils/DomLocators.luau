local DomLocators = {}

local function coerceToString(p) -- 1 equivalent call inferred from this helper
	if p == nil then
		return ""
	end

	return (tostring(p))
end

function DomLocators.sanitizeSegment(p)
	return (coerceToString(p):gsub("%s+", "_"):gsub("[^%w_]", "")) -- inferred equivalent call
end

function DomLocators.build(items)
	local v = {}

	for _, item in items do
		local v2 = DomLocators.sanitizeSegment(item)

		if v2 ~= "" then
			table.insert(v, v2)
		end
	end

	return table.concat(v, "-")
end

function DomLocators.chatLandingTopBarIconButton(p: string)
	return DomLocators.build({ "chat", "chatLanding", "topBar", "button", p })
end

function DomLocators.appChatLoadingOverlayBackButton()
	return DomLocators.build({ "chat", "loadingOverlay", "button", "back" })
end

function DomLocators.chatLandingConversationListHeader(p: string)
	return DomLocators.build({
		"chat",
		"chatLanding",
		"conversationList",
		"conversationListHeader",
		p
	})
end

function DomLocators.chatLandingConversationEntry(p: string)
	return DomLocators.build({ "chat", "chatLanding", "conversationList", "conversationEntry", p })
end

function DomLocators.chatLandingConversationEntrySquadButton(p: string)
	return DomLocators.build({
		"chat",
		"chatLanding",
		"conversationList",
		"conversationEntry",
		"button",
		`squad_{p}`
	})
end

function DomLocators.chatDetailsTopBarActionButton(p: string)
	return DomLocators.build({ "chat", "chatDetails", "topBar", "button", p })
end

function DomLocators.chatDetailsListActionButton(p: string)
	return DomLocators.build({ "chat", "chatDetails", "detailsList", "button", p })
end

function DomLocators.chatDetailsParticipantMoreButton(p: string)
	return DomLocators.build({
		"chat",
		"chatDetails",
		"detailsList",
		"participantList",
		"participantEntry",
		"button",
		`{p}_moreDetails`
	})
end

function DomLocators.chatConversationTopBarButton(p: string)
	return DomLocators.build({ "chat", "chatConversation", "topBar", "button", p })
end

function DomLocators.chatConversationSystemMessageCard(list)
	local build = DomLocators.build

	if type(list) == "table" then
		list = table.concat(list, "_")
	end

	return build({ "chat", "chatConversation", "messageList", "systemMessageCard", list })
end

function DomLocators.chatConversationSystemMessage(p: string)
	return DomLocators.build({ "chat", "chatConversation", "messageList", "systemMessageText", p })
end

function DomLocators.selectChatMembersUserCellWithCheckbox(p: string, flag: boolean)
	return DomLocators.build({
		"chat",
		"selectChatMembers",
		"friendsList",
		"userCellWithCheckbox",
		"checkbox",
		`{p}_{flag and "checked" or "unchecked"}`
	})
end

function DomLocators.selectChatMembersSearchInput(p: string?)
	return DomLocators.build({ "chat", "selectChatMembers", "searchBar", "textInput", p })
end

function DomLocators.selectChatMembersTopBarActionButton(p: string)
	return DomLocators.build({ "chat", "selectChatMembers", "topBar", "button", p })
end

return DomLocators
