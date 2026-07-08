local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local EnumScreens = require(AppChat.EnumScreens)
local React = require(AppChatParent.React)
local useCallback = React.useCallback
local useEffectOnMount = require(AppChatParent.RoactUtils).Hooks.useEffectOnMount
local CreateUnfilteredChatPartialModalContainer = require(script.Parent.CreateUnfilteredChatPartialModalContainer)
local Logger = require(script.Parent.Logger)
local t1 = {}

local function CreateUnfilteredChatPartialModalScreen(t2: {[any]: any}) -- line: 19
	-- upvalues: Cryo (copy), t1 (copy), useEffectOnMount (copy), Logger (copy), useCallback (copy), EnumScreens (copy), React (copy), CreateUnfilteredChatPartialModalContainer (copy)
	local v13 = Cryo.Dictionary.union(t1, t2)
	local navigation = v13.navigation

	assert(type(navigation) ~= "nil", "CreateUnfilteredChatPartialModalScreen should be wrapped with React Navigation")

	local v15 = navigation and (navigation.getParam and navigation.getParam("conversationId", nil))

	useEffectOnMount(function() -- line: 25
		-- upvalues: Logger (copy)
		Logger:info("LearnMorePartialModalScreen mounted")
	end)

	local v16 = useCallback(function() -- line: 29
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v17 = useCallback(function(p1) -- line: 33
		-- upvalues: navigation (copy), EnumScreens (copy)
		navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = p1
		})
	end, { navigation })
	local v18 = useCallback(function(p2) -- line: 37
		-- upvalues: v13 (copy), EnumScreens (copy)
		v13.navigation.navigate(EnumScreens.RoactChatToast, {
			toastProps = {
				toastContent = {
					toastTitle = p2
				}
			}
		})
	end, { navigation })

	if v15 == nil then
		Logger:warning("ConversationId is required to open CreateUnfilteredChatPartialModalScreen")

		return nil
	end

	return React.createElement(CreateUnfilteredChatPartialModalContainer, {
		conversationId = v15,
		onDismissed = v16,
		navigateToConversation = v17,
		navigateToToast = v18
	})
end

return CreateUnfilteredChatPartialModalScreen
