local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local View = Foundation.View
local Text = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local Orientation = Foundation.Enums.Orientation

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useMobilePage = require(AccountUpgrade.MobilePage.useMobilePage)

local function CloseConfirmationDialog(p)
	local v = Foundation.Hooks.useTokens()
	local v2 = useMobilePage()
	local ref2 = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true
	})

	local v3 = useLocalization({
		titleText = "Authentication.SignUp.Header.CancelAccountCreation",
		bodyText = "Authentication.SignUp.Subtitle.YoureAlmostThereClose",
		continueSetupText = "Authentication.SignUp.Action.ContinueSetup",
		cancelText = "Authentication.SignUp.Action.Cancel"
	})

	local state, setState = React.useState(false)
	local ref = React.useRef(false)
	local onSignOut = p.onSignOut
	local onActivated = React.useCallback(function()
		if ref.current then
			return
		end

		ref.current = true
		setState(true)
		onSignOut()
	end, { onSignOut })

	local onBack = p.onBack
	local onActivated2 = React.useCallback(function()
		if not ref.current then
			onBack()
		end
	end, { onBack })

	local actions2 = {
		{
			text = v3.continueSetupText,
			variant = ButtonVariant.Emphasis,
			onActivated = onActivated2,
			isDisabled = state
		},
		{
			text = v3.cancelText,
			variant = ButtonVariant.Standard,
			onActivated = onActivated,
			isLoading = state
		}
	}

	local createElement = React.createElement
	local root = Dialog.Root
	local v4 = {
		ref = ref2,
		size = DialogSize.Small,
		disablePortal = false,
		hasBackdrop = true,
		testId = "account-upgrade-close-dialog"
	}

	local v5 = {
		Header = React.createElement(View, {
			tag = "col gap-xsmall size-full-0 auto-y",
			padding = { top = UDim.new(0, v.Size.Size_450), bottom = UDim.new(0, v.Padding.Large) },
			LayoutOrder = 1,
			testId = "account-upgrade-close-dialog--header"
		}, {
			Title = React.createElement(Text, {
				Text = v3.titleText,
				tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
				LayoutOrder = 1,
				testId = "account-upgrade-close-dialog--title"
			}),
			Body = React.createElement(Dialog.Text, { Text = v3.bodyText, LayoutOrder = 2 })
		}),
		Actions = 0
	}

	local createElement2 = React.createElement
	local actions = Dialog.Actions
	local orientation

	if v2 then
		orientation = Orientation.Vertical
	else
		orientation = Orientation.Horizontal
	end

	v5.Actions = createElement2(actions, {
		LayoutOrder = 3,
		actions = actions2,
		orientation = orientation
	})
	return createElement(root, v4, v5)
end

return CloseConfirmationDialog
