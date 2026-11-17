local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)

local ChatDetailsNavigationOptions = {}

function ChatDetailsNavigationOptions.getHeaderText()
	return {
		raw = GetFFlagIsSquadEnabled() and "Feature.Chat.Label.Details" or "Feature.Chat.Label.ChatDetails",
		shouldLocalize = true
	}
end

function ChatDetailsNavigationOptions.getIsRooted(p)
	return p and p.getParam and p.getParam("isRooted", false) or false
end

function ChatDetailsNavigationOptions.getNavigationOptions(p, options)
	local navigation = p and p.navigation
	local v = {
		headerText = ChatDetailsNavigationOptions.getHeaderText(),
		backButtonTestId = 0,
		backButtonEnabled = true,
		isRoot = 0
	}
	local backButtonTestId

	if FFlagDebugAppChatEnableDomLocators then
		backButtonTestId = DomLocators.chatDetailsTopBarActionButton("back")
	end

	v.backButtonTestId = backButtonTestId

	v.isRoot = ChatDetailsNavigationOptions.getIsRooted(navigation)

	return Cryo.Dictionary.join(v, options or {})
end

function ChatDetailsNavigationOptions.getTopBarConfig(p)
	return {
		headerText = ChatDetailsNavigationOptions.getHeaderText(),
		backButtonEnabled = true,
		isRoot = ChatDetailsNavigationOptions.getIsRooted(p)
	}
end

return ChatDetailsNavigationOptions
