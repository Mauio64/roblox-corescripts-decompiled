local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatToastEventReceiver = require(AppChat.Components.EventReceivers.AppChatToastEventReceiver)
local EnteredChatFromEntryPoint = require(AppChat.Actions.EnteredChatFromEntryPoint)
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local RoactUtils = require(AppChatParent.RoactUtils)
local SocialCommon = require(AppChatParent.SocialCommon)
local GetFFlagAppChatInExpToastSnoozeMenuDismissFix = require(AppChatParent.SharedFlags).GetFFlagAppChatInExpToastSnoozeMenuDismissFix
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local t1 = {
	hideAllChatToasts = false,
	isAppChatVisible = false
}

function AppChatToastManagerInExp(t2: {[any]: any}) -- line: 28
	-- upvalues: Cryo (copy), t1 (copy), useDispatch (copy), React (copy), EnteredChatFromEntryPoint (copy), SocialCommon (copy), AppChatToastEventReceiver (copy), GetFFlagAppChatInExpToastSnoozeMenuDismissFix (copy)
	local v13 = Cryo.Dictionary.join(t1, t2)
	local v14 = useDispatch()
	local v15 = React.useCallback(function(s1: string) -- line: 33
		-- upvalues: v13 (copy), v14 (copy), EnteredChatFromEntryPoint (copy), SocialCommon (copy)
		v13.navigateToChat(s1)
		v14(EnteredChatFromEntryPoint(SocialCommon.Enums.ChatEntryPointNames.ToastInExp))
	end, {
		v14,
		v13.navigateToChat
	})

	return React.createElement(AppChatToastEventReceiver, {
		isInExperience = true,
		navigateToChat = v15,
		hideAllChatToasts = if not GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then v13.hideAllChatToasts else nil,
		isAppChatVisible = if not GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then nil else v13.isAppChatVisible
	})
end

return AppChatToastManagerInExp
