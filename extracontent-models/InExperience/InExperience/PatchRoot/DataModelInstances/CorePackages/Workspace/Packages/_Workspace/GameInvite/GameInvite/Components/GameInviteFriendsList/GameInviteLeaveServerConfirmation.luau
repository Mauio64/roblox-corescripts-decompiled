local parent = script:FindFirstAncestor("GameInvite").Parent

local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local NotificationsCommon = require(parent.NotificationsCommon)
local DeeplinkConfirmationModal = NotificationsCommon.DeeplinkConfirmationModal

local useGameInviteLeaveServerConfirmationViewModel = require(script.Parent.useGameInviteLeaveServerConfirmationViewModel)

local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function GameInviteLeaveServerConfirmation(p)
	local v = useGameInviteLeaveServerConfirmationViewModel(p)
	return React.createElement(FocusRoot, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = v.focusEventHandlers
	}, {
		Confirmation = React.createElement(DeeplinkConfirmationModal, {
			closeCallback = v.closeCallback,
			titleKey = v.titleKey,
			bodyKey = v.bodyKey
		})
	})
end

return GameInviteLeaveServerConfirmation
