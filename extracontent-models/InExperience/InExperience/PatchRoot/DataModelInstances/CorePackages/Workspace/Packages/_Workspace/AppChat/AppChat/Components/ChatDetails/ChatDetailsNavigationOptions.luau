local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)
local t2 = {
	getHeaderText = function() -- line: 29
		-- upvalues: GetFFlagIsSquadEnabled (copy)
		return {
			shouldLocalize = true,
			raw = not GetFFlagIsSquadEnabled() and "Feature.Chat.Label.ChatDetails" or "Feature.Chat.Label.Details"
		}
	end,
	getIsRooted = function(t1: {[any]: any}?) -- line: 36
		-- upvalues: getFFlagAppChatEnableRootedNavigation (copy)
		return not not getFFlagAppChatEnableRootedNavigation() and (not not t1 and (not not t1.getParam and (t1.getParam("isRooted", false) or false)))
	end
}

function t2.getNavigationOptions(t3: {[any]: any}?, t4: {[any]: any}?) -- line: 44
	-- upvalues: t2 (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), getFFlagAppChatEnableRootedNavigation (copy), Cryo (copy)
	local v12 = t3 and t3.navigation
	local t5 = {
		headerText = t2.getHeaderText(),
		backButtonTestId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatDetailsTopBarActionButton("back")
	}

	if getFFlagAppChatEnableRootedNavigation() then
		t5 = Cryo.Dictionary.join(t5, {
			backButtonEnabled = true,
			isRoot = t2.getIsRooted(v12)
		})
	end

	return Cryo.Dictionary.join(t5, t4 or {})
end
function t2.getTopBarConfig(t6: {[any]: any}?) -- line: 64
	-- upvalues: t2 (copy), getFFlagAppChatEnableRootedNavigation (copy), Cryo (copy)
	local t7 = {
		backButtonEnabled = true,
		headerText = t2.getHeaderText()
	}

	if getFFlagAppChatEnableRootedNavigation() then
		t7 = Cryo.Dictionary.join(t7, {
			isRoot = t2.getIsRooted(t6)
		})
	end

	return t7
end

return t2
