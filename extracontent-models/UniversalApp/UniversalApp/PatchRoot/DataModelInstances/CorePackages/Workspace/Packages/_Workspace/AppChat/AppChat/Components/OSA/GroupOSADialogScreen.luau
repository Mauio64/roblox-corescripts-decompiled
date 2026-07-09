local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(AppChatParent.Navigation).useNavigation
local API = require(AppChatParent.AppChatNetworking).rodux.GetConversationDetails.API
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local EnumScreens = require(AppChat.EnumScreens)
local GroupOSADialog = require(script.Parent.GroupOSADialog)
local v10 = game:DefineFastFlag("AppChatGroupOsaDisablePortal", false)

local function GroupOSADialogScreen() -- line: 17
	-- upvalues: useNavigation (copy), useDispatch (copy), React (copy), API (copy), EnumScreens (copy), RemovedConversation (copy), GroupOSADialog (copy), v10 (copy)
	local v12 = useNavigation()
	local v13 = useDispatch()
	local v14 = v12.getParam("conversationId", nil)
	local v15 = v12.getParam("impressionId", nil)
	local v16 = v12.getParam("modalVariant", nil)
	local v17 = React.useCallback(function() -- line: 24
		-- upvalues: v12 (copy)
		if v12.isFocused() then
			v12.goBack()
		end
	end, { v12 })
	local v18 = React.useCallback(function() -- line: 30
		-- upvalues: v14 (copy), v13 (copy), API (copy), v12 (copy), EnumScreens (copy)
		if v14 then
			v13(API(v14))
		end

		v12.navigate(EnumScreens.ChatConversation, {
			isNavigatedFromGroupOSAJoin = true,
			conversationId = v14
		})
	end, {
		v12,
		v14,
		v13
	})
	local v19 = React.useCallback(function() -- line: 41
		-- upvalues: v14 (copy), v13 (copy), RemovedConversation (copy), v12 (copy)
		if v14 then
			v13(RemovedConversation(v14))
		end

		if v12.isFocused() then
			v12.goBack()
		end
	end, {
		v12,
		v13,
		v14
	})

	return React.createElement(GroupOSADialog, {
		conversationId = v14,
		onClose = v17,
		onJoin = v18,
		onDecline = v19,
		disablePortal = v10,
		impressionId = v15,
		modalVariant = v16
	})
end

return GroupOSADialogScreen
