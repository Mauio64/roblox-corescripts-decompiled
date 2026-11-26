local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local v5 = {}

function v5.getHeaderText()
	return {
		raw = getFFlagIsSquadEnabled() and "Feature.Chat.Label.Details" or "Feature.Chat.Label.ChatDetails",
		shouldLocalize = true
	}
end

function v5.getIsRooted(p2)
	return p2 and p2.getParam and p2.getParam("isRooted", false) or false
end

function v5.getNavigationOptions(p2, options)
	local navigation = p2 and p2.navigation
	local v6 = {
		headerText = v5.getHeaderText(),
		backButtonTestId = 0,
		backButtonEnabled = true,
		isRoot = 0
	}

	local v7 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatDetailsTopBarActionButton("back") else nil
	v6.backButtonTestId = v7

	v6.isRoot = v5.getIsRooted(navigation)

	return Cryo.Dictionary.join(v6, options or {})
end

function v5.getTopBarConfig(p2)
	return {
		headerText = v5.getHeaderText(),
		backButtonEnabled = true,
		isRoot = v5.getIsRooted(p2)
	}
end

return v5
