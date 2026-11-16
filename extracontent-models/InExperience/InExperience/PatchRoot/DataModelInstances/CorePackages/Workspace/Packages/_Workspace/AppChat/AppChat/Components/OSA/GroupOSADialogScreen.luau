local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local AppChatNetworking = require(parent.AppChatNetworking)
local api = AppChatNetworking.rodux.GetConversationDetails.API
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)

local EnumScreens = require(AppChat.EnumScreens)
local GroupOSADialog = require(script.Parent.GroupOSADialog)

local function GroupOSADialogScreen()
	local v = useNavigation()
	local v2 = useDispatch()
	local param = v.getParam("conversationId", nil)
	local param2 = v.getParam("impressionId", nil)
	local param3 = v.getParam("modalVariant", nil)

	local onClose = React.useCallback(function()
		if v.isFocused() then
			v.goBack()
		end
	end, { v })

	local onJoin = React.useCallback(function()
		if param then
			v2(api(param))
		end

		v.navigate(EnumScreens.ChatConversation, {
			conversationId = param,
			isNavigatedFromGroupOSAJoin = true
		})
	end, { v, param, v2 })

	local onDecline = React.useCallback(function()
		if param then
			v2(RemovedConversation(param))
		end

		if v.isFocused() then
			v.goBack()
		end
	end, { v, v2, param })

	return React.createElement(GroupOSADialog, {
		conversationId = param,
		onClose = onClose,
		onJoin = onJoin,
		onDecline = onDecline,
		impressionId = param2,
		modalVariant = param3
	})
end

return GroupOSADialogScreen
