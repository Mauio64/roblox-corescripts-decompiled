local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/FocusNavigationUtils")
local deeplinkConfirmationModal = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/NotificationsCommon").DeeplinkConfirmationModal

local useGameInviteLeaveServerConfirmationViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/useGameInviteLeaveServerConfirmationViewModel")

local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function GameInviteLeaveServerConfirmation(p2)
	local v5 = useGameInviteLeaveServerConfirmationViewModel(p2)
	return React.createElement(focusRoot, {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = v5.focusEventHandlers
	}, {
		Confirmation = React.createElement(deeplinkConfirmationModal, {
			closeCallback = v5.closeCallback,
			titleKey = v5.titleKey,
			bodyKey = v5.bodyKey
		})
	})
end

return GameInviteLeaveServerConfirmation
