local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local dialog = Foundation.Dialog
local view = Foundation.View
local text = Foundation.Text
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local orientation = Foundation.Enums.Orientation

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Localization").Hooks.useLocalization
local useMobilePage = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/MobilePage/useMobilePage")

local function CloseConfirmationDialog(p2)
	local v5 = Foundation.Hooks.useTokens()
	local v6 = useMobilePage()
	local v7 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true
	})

	local v8 = useLocalization({
		titleText = "Authentication.SignUp.Header.CancelAccountCreation",
		bodyText = "Authentication.SignUp.Subtitle.YoureAlmostThereClose",
		continueSetupText = "Authentication.SignUp.Action.ContinueSetup",
		cancelText = "Authentication.SignUp.Action.Cancel"
	})

	local state, setState = React.useState(false)
	local ref = React.useRef(false)
	local onSignOut = p2.onSignOut
	local v9 = React.useCallback(function()
		if ref.current then
			return
		end

		ref.current = true
		setState(true)
		onSignOut()
	end, { onSignOut })

	local onBack = p2.onBack
	local v10 = React.useCallback(function()
		if not ref.current then
			onBack()
		end
	end, { onBack })

	local v11 = {
		{
			text = v8.continueSetupText,
			variant = buttonVariant.Emphasis,
			onActivated = v10,
			isDisabled = state
		},
		{
			text = v8.cancelText,
			variant = buttonVariant.Standard,
			onActivated = v9,
			isLoading = state
		}
	}

	local createElement = React.createElement
	local root = dialog.Root
	local v12 = {
		ref = v7,
		size = dialogSize.Small,
		disablePortal = false,
		hasBackdrop = true,
		testId = "account-upgrade-close-dialog"
	}

	local v13 = {
		Header = React.createElement(view, {
			tag = "col gap-xsmall size-full-0 auto-y",
			padding = {
				top = UDim.new(0, v5.Size.Size_450),
				bottom = UDim.new(0, v5.Padding.Large)
			},
			LayoutOrder = 1,
			testId = "account-upgrade-close-dialog--header"
		}, {
			Title = React.createElement(text, {
				Text = v8.titleText,
				tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
				LayoutOrder = 1,
				testId = "account-upgrade-close-dialog--title"
			}),
			Body = React.createElement(dialog.Text, {
				Text = v8.bodyText,
				LayoutOrder = 2
			})
		}),
		Actions = 0
	}

	local createElement2 = React.createElement
	local actions = dialog.Actions

	local v15 = if v6 then orientation.Vertical else orientation.Horizontal
	v13.Actions = createElement2(actions, {
		LayoutOrder = 3,
		actions = v11,
		orientation = v15
	})
	return createElement(root, v12, v13)
end

return CloseConfirmationDialog
