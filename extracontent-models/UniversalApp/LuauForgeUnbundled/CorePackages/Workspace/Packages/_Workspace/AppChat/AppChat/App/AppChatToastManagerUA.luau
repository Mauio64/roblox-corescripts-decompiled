local AppChatToastEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/AppChatToastEventReceiver")
local EnteredChatFromEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/EnteredChatFromEntryPoint")
local NavigateIntoChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/NavigateIntoChat")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")

local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/OSA/OverlayHost")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

function LUAUFORGE_MODULE_GLOBALS_ilH_AppChatToastManagerUA()
	local v5 = useDispatch()

	local v6 = React.useCallback(function(p2)
		v5(NavigateIntoChat({ conversationId = p2 }, true))

		v5(EnteredChatFromEntryPoint(SocialCommon.Enums.ChatEntryPointNames.ToastUniversalApp))
	end, { v5 })

	return React.createElement(React.Fragment, nil, {
		ToastEventReceiver = React.createElement(AppChatToastEventReceiver, { navigateToChat = v6 }),
		OverlayHost = React.createElement(module7)
	})
end

return LUAUFORGE_MODULE_GLOBALS_ilH_AppChatToastManagerUA
