local parent = script:FindFirstAncestor("AuthSignup").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local AuthAnalytics = require(parent.AuthAnalytics)

local authModalShown = AuthAnalytics.Events.authModalShown
local authButtonClick = AuthAnalytics.Events.authButtonClick
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local InputSize = Foundation.Enums.InputSize
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(parent.InputHandlers)

local confirms = {
	[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.Confirm,
	[Enum.KeyCode.Return] = FocusNavigationEventNameEnum.Confirm
}

local function useFocusNavigationBindings(p)
	local v = ReactFocusNavigation.useEventMap(confirms, p)
	local v2 = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.Confirm] = {
				handler = InputHandlers.onRelease(function() end)
			}
		}
	end, {})
	return ReactFocusNavigation.useEventHandlerMap(v2, v)
end

local function SignUpExitModal(p)
	local v = useLocalization({
		cancel = "Authentication.SignUp.Action.Cancel",
		confirm = "Authentication.SignUp.Action.ExitModalLeave",
		title = "Authentication.SignUp.Label.ExitModalTitle",
		subtitle = "Authentication.SignUp.Label.ExitModalSubtitle"
	})

	local v2 = useFocusGuiObject()
	local ref = React.useRef(nil)
	local ref2 = useFocusNavigationBindings(nil)

	React.useEffect(function()
		v2(ref.current)
		authModalShown(EventStreamConstants.Context.SignUpExitModal, EventStreamConstants.State.Success)
	end, {})

	local onActivated = React.useCallback(function()
		authButtonClick(EventStreamConstants.Context.SignUpExitModal, EventStreamConstants.Button.SignUpExitModalLeave)

		p.onConfirm()
	end, { p.onConfirm })

	local onActivated2 = React.useCallback(function()
		authButtonClick(EventStreamConstants.Context.SignUpExitModal, EventStreamConstants.Button.SignUpExitModalCancel)

		p.onClose()
	end, { p.onClose })

	return React.createElement(Dialog.Root, {
		size = DialogSize.Small,
		hasBackdrop = true,
		ref = ref2
	}, {
		DialogTitle = React.createElement(Dialog.Title, { text = v.title }),
		DialogContent = React.createElement(Dialog.Content, {}, {
			DialogView = React.createElement(Foundation.View, {
				tag = "col fill auto-xy items-start gap-medium"
			}, {
				DialogText = React.createElement(Dialog.Text, { Text = v.subtitle, LayoutOrder = 1 }),
				PrimaryButton = React.createElement(Foundation.Button, {
					text = v.confirm,
					variant = ButtonVariant.Alert,
					size = InputSize.Small,
					width = UDim.new(1, 0),
					TextTruncate = Enum.TextTruncate.None,
					onActivated = onActivated,
					LayoutOrder = 2
				}),
				SecondaryButton = React.createElement(Foundation.Button, {
					text = v.cancel,
					variant = ButtonVariant.Standard,
					size = InputSize.Small,
					width = UDim.new(1, 0),
					TextTruncate = Enum.TextTruncate.None,
					onActivated = onActivated2,
					LayoutOrder = 3,
					ref = ref
				})
			})
		})
	})
end

return SignUpExitModal
