local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useCallback = React.useCallback
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useEffectOnMount

local CreateUnfilteredChatPartialModalContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/CreateUnfilteredChatPartialModalContainer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/Logger")

local v5 = {}

local function CreateUnfilteredChatPartialModalScreen(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local navigation = union.navigation
	assert(
		type(navigation) ~= "nil",
		"CreateUnfilteredChatPartialModalScreen should be wrapped with React Navigation"
	)
	local v6 = navigation and navigation.getParam and navigation.getParam("conversationId", nil)

	useEffectOnMount(function()
		Logger:info("LearnMorePartialModalScreen mounted")
	end)

	local v7 = useCallback(function()
		navigation.goBack()
	end, { navigation })

	local v8 = useCallback(function(p3)
		navigation.navigate(EnumScreens.ChatConversation, { conversationId = p3 })
	end, { navigation })

	local v9 = useCallback(function(p3)
		union.navigation.navigate(EnumScreens.RoactChatToast, {
			toastProps = {
				toastContent = { toastTitle = p3 }
			}
		})
	end, { navigation })

	if v6 ~= nil then
		return React.createElement(CreateUnfilteredChatPartialModalContainer, {
			conversationId = v6,
			onDismissed = v7,
			navigateToConversation = v8,
			navigateToToast = v9
		})
	end

	Logger:warning("ConversationId is required to open CreateUnfilteredChatPartialModalScreen")
	return nil
end

return CreateUnfilteredChatPartialModalScreen
