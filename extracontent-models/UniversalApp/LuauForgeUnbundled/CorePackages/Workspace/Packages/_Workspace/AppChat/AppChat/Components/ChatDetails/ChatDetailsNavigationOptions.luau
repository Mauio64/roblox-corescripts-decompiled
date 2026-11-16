local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")
local getFFlagAppChatEnableRootedNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagAppChatEnableRootedNavigation")

local v5 = {}

function v5.getHeaderText()
	return {
		raw = getFFlagIsSquadEnabled() and "Feature.Chat.Label.Details" or "Feature.Chat.Label.ChatDetails",
		shouldLocalize = true
	}
end

function v5.getIsRooted(p2)
	return getFFlagAppChatEnableRootedNavigation() and p2 and p2.getParam and p2.getParam("isRooted", false) or false
end

function v5.getNavigationOptions(p2, options)
	local navigation = p2 and p2.navigation
	local joined = { headerText = v5.getHeaderText(), backButtonTestId = 0 }

	local v6 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatDetailsTopBarActionButton("back") else nil
	joined.backButtonTestId = v6

	if getFFlagAppChatEnableRootedNavigation() then
		joined = Cryo.Dictionary.join(joined, {
			backButtonEnabled = true,
			isRoot = v5.getIsRooted(navigation)
		})
	end

	return Cryo.Dictionary.join(joined, options or {})
end

function v5.getTopBarConfig(p2)
	local joined = { headerText = v5.getHeaderText(), backButtonEnabled = true }

	if getFFlagAppChatEnableRootedNavigation() then
		joined = Cryo.Dictionary.join(joined, { isRoot = v5.getIsRooted(p2) })
	end

	return joined
end

return v5
