local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatToastEventReceiver = require(AppChat.Components.EventReceivers.AppChatToastEventReceiver)
local EnteredChatFromEntryPoint = require(AppChat.Actions.EnteredChatFromEntryPoint)
local NavigateIntoChat = require(AppChat.Conversations.Thunks.NavigateIntoChat)
local React = require(AppChatParent.React)
local RoactUtils = require(AppChatParent.RoactUtils)
local SocialCommon = require(AppChatParent.SocialCommon)
local OverlayHost = require(AppChat.Components.OSA.OverlayHost)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

function AppChatToastManagerUA() -- line: 16
	-- upvalues: useDispatch (copy), React (copy), NavigateIntoChat (copy), EnteredChatFromEntryPoint (copy), SocialCommon (copy), AppChatToastEventReceiver (copy), OverlayHost (copy)
	local v11 = useDispatch()
	local v12 = React.useCallback(function(s1: string) -- line: 19
		-- upvalues: v11 (copy), NavigateIntoChat (copy), EnteredChatFromEntryPoint (copy), SocialCommon (copy)
		v11(NavigateIntoChat({
			conversationId = s1
		}, true))
		v11(EnteredChatFromEntryPoint(SocialCommon.Enums.ChatEntryPointNames.ToastUniversalApp))
	end, { v11 })

	return React.createElement(React.Fragment, nil, {
		ToastEventReceiver = React.createElement(AppChatToastEventReceiver, {
			navigateToChat = v12
		}),
		OverlayHost = React.createElement(OverlayHost)
	})
end

return AppChatToastManagerUA
