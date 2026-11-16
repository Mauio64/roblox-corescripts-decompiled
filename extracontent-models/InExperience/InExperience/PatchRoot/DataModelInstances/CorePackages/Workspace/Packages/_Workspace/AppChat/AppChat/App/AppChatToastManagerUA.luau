local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatToastEventReceiver = require(AppChat.Components.EventReceivers.AppChatToastEventReceiver)
local EnteredChatFromEntryPoint = require(AppChat.Actions.EnteredChatFromEntryPoint)
local NavigateIntoChat = require(AppChat.Conversations.Thunks.NavigateIntoChat)

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local SocialCommon = require(parent.SocialCommon)

local OverlayHost = require(AppChat.Components.OSA.OverlayHost)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

function AppChatToastManagerUA()
	local v = useDispatch()

	local navigateToChat = React.useCallback(function(conversationId: string)
		v(NavigateIntoChat({ conversationId = conversationId }, true))

		v(EnteredChatFromEntryPoint(SocialCommon.Enums.ChatEntryPointNames.ToastUniversalApp))
	end, { v })

	return React.createElement(React.Fragment, nil, {
		ToastEventReceiver = React.createElement(AppChatToastEventReceiver, {
			navigateToChat = navigateToChat
		}),
		OverlayHost = React.createElement(OverlayHost)
	})
end

return AppChatToastManagerUA
