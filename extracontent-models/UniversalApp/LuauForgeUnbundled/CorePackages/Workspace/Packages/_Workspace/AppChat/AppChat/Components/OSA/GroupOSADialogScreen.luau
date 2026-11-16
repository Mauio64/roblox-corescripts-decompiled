local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation

local api = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking").rodux.GetConversationDetails.API
local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local GroupOSADialog = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/OSA/GroupOSADialog")

local function GroupOSADialogScreen()
	local v5 = useNavigation()
	local v6 = useDispatch()
	local param = v5.getParam("conversationId", nil)
	local param2 = v5.getParam("impressionId", nil)
	local param3 = v5.getParam("modalVariant", nil)

	local v7 = React.useCallback(function()
		if v5.isFocused() then
			v5.goBack()
		end
	end, { v5 })

	local v8 = React.useCallback(function()
		if param then
			v6(api(param))
		end

		v5.navigate(EnumScreens.ChatConversation, {
			conversationId = param,
			isNavigatedFromGroupOSAJoin = true
		})
	end, { v5, param, v6 })

	local v9 = React.useCallback(function()
		if param then
			v6(RemovedConversation(param))
		end

		if v5.isFocused() then
			v5.goBack()
		end
	end, { v5, v6, param })

	return React.createElement(GroupOSADialog, {
		conversationId = param,
		onClose = v7,
		onJoin = v8,
		onDecline = v9,
		impressionId = param2,
		modalVariant = param3
	})
end

return GroupOSADialogScreen
