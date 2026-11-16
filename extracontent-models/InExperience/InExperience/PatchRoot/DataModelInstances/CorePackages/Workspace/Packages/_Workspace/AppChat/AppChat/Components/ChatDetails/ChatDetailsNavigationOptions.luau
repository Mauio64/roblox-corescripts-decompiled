local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)

local ChatDetailsNavigationOptions = {}

function ChatDetailsNavigationOptions.getHeaderText()
	return {
		raw = GetFFlagIsSquadEnabled() and "Feature.Chat.Label.Details" or "Feature.Chat.Label.ChatDetails",
		shouldLocalize = true
	}
end

function ChatDetailsNavigationOptions.getIsRooted(p)
	return getFFlagAppChatEnableRootedNavigation() and p and p.getParam and p.getParam("isRooted", false) or false
end

function ChatDetailsNavigationOptions.getNavigationOptions(p, options)
	local navigation = p and p.navigation
	local joined = {
		headerText = ChatDetailsNavigationOptions.getHeaderText(),
		backButtonTestId = 0
	}
	local backButtonTestId

	if FFlagDebugAppChatEnableDomLocators then
		backButtonTestId = DomLocators.chatDetailsTopBarActionButton("back")
	end

	joined.backButtonTestId = backButtonTestId

	if getFFlagAppChatEnableRootedNavigation() then
		joined = Cryo.Dictionary.join(joined, {
			backButtonEnabled = true,
			isRoot = ChatDetailsNavigationOptions.getIsRooted(navigation)
		})
	end

	return Cryo.Dictionary.join(joined, options or {})
end

function ChatDetailsNavigationOptions.getTopBarConfig(p)
	local joined = {
		headerText = ChatDetailsNavigationOptions.getHeaderText(),
		backButtonEnabled = true
	}

	if getFFlagAppChatEnableRootedNavigation() then
		joined = Cryo.Dictionary.join(joined, {
			isRoot = ChatDetailsNavigationOptions.getIsRooted(p)
		})
	end

	return joined
end

return ChatDetailsNavigationOptions
