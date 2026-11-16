local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local EnumScreens = require(AppChat.EnumScreens)
local React = require(parent.React)
local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount

local CreateUnfilteredChatPartialModalContainer = require(script.Parent.CreateUnfilteredChatPartialModalContainer)
local Logger = require(script.Parent.Logger)

local v = {}

local function CreateUnfilteredChatPartialModalScreen(p)
	local union = Cryo.Dictionary.union(v, p)
	local navigation = union.navigation
	assert(type(navigation) ~= "nil", "CreateUnfilteredChatPartialModalScreen should be wrapped with React Navigation")
	local conversationId = navigation and navigation.getParam and navigation.getParam("conversationId", nil)

	useEffectOnMount(function()
		Logger:info("LearnMorePartialModalScreen mounted")
	end)

	local onDismissed = useCallback(function()
		navigation.goBack()
	end, { navigation })

	local navigateToConversation = useCallback(function(conversationId2)
		navigation.navigate(EnumScreens.ChatConversation, { conversationId = conversationId2 })
	end, { navigation })

	local navigateToToast = useCallback(function(toastTitle)
		union.navigation.navigate(EnumScreens.RoactChatToast, {
			toastProps = {
				toastContent = { toastTitle = toastTitle }
			}
		})
	end, { navigation })

	if conversationId ~= nil then
		return React.createElement(CreateUnfilteredChatPartialModalContainer, {
			conversationId = conversationId,
			onDismissed = onDismissed,
			navigateToConversation = navigateToConversation,
			navigateToToast = navigateToToast
		})
	end

	Logger:warning("ConversationId is required to open CreateUnfilteredChatPartialModalScreen")
	return nil
end

return CreateUnfilteredChatPartialModalScreen
