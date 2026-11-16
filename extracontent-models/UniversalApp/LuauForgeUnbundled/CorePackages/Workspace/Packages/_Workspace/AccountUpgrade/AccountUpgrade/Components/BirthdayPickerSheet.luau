local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Localization").Hooks.useLocalization
local AuthSignup = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthSignup")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/SharedFlags")

local useRequireManualSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Hooks/useRequireManualSelection")
local FFlagAccountUpgradeOAuthTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeOAuthTelemetry")
local AccountUpgradeDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/SuccessModal/AccountUpgradeDialog")
local AccountUpgradeDialogActions = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/SuccessModal/AccountUpgradeDialogActions")

local birthdayPicker = AuthSignup.Components.BirthdayPicker
local useValidatedBirthday = AuthSignup.Hooks.useValidatedBirthday

local fIntSinglePageSignupMinimumAge = SharedFlags.FIntSinglePageSignupMinimumAge

local buttonVariant = Foundation.Enums.ButtonVariant

local function BirthdayPickerDialog(props)
	local v5, v6 = useValidatedBirthday(fIntSinglePageSignupMinimumAge)

	local v7 = useRequireManualSelection()

	local onAllPicked = props.onAllPicked
	local ref = if FFlagAccountUpgradeOAuthTelemetry then React.useRef(false) else nil
	local v8

	if FFlagAccountUpgradeOAuthTelemetry then
		v8 = React.useCallback(function(p2, p3, p4)
			v6(p2, p3, p4)

			if onAllPicked and ref and not ref.current and p2 and p3 and p4 then
				ref.current = true
				onAllPicked()
			end
		end, { v6, onAllPicked, ref })
	end

	local onConfirm = props.onConfirm
	local v9 = React.useCallback(function()
		if v5 ~= nil then
			onConfirm(v5)
		end
	end, { v5, onConfirm })

	local onClose = props.onClose
	local v10 = React.useCallback(function(p2)
		onClose()
	end, { onClose })

	local v11 = useLocalization({
		titleText = "Authentication.SignUp.Label.SelectBirthdaySentenceCase",
		confirmText = "Authentication.SignUp.Button.OKCaptialized"
	})

	local birthday = props.birthday
	local month = if birthday then birthday.Month else nil
	local day = if birthday then birthday.Day else nil
	local v12 = if birthday then birthday.Year else nil

	return React.createElement(AccountUpgradeDialog, {
		title = v11.titleText,
		onClose = v10,
		hasBackdrop = true,
		testId = "account-upgrade-birthday-dialog",
		children = {
			Picker = React.createElement(birthdayPicker, {
				layoutOrder = 1,
				minAgeAllowed = fIntSinglePageSignupMinimumAge,
				requireManualSelection = v7,
				updateBirthday = v8 or v6,
				initialMonth = month,
				initialDay = day,
				initialYear = v12
			})
		},
		actions = React.createElement(AccountUpgradeDialogActions, {
			LayoutOrder = 3,
			testId = "account-upgrade-birthday-dialog-actions",
			buttons = {
				{
					text = v11.confirmText,
					variant = buttonVariant.Emphasis,
					onActivated = v9,
					isDisabled = v5 == nil
				}
			}
		})
	})
end

local function BirthdayPickerSheet(p2)
	if p2.isOpen then
		return React.createElement(BirthdayPickerDialog, p2)
	end

	return nil
end

return BirthdayPickerSheet
