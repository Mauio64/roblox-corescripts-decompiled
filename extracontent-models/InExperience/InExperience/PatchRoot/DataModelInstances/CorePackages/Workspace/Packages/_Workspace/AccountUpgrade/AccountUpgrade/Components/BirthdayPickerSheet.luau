local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AuthSignup = require(parent.AuthSignup)
local SharedFlags = require(parent.SharedFlags)

local useRequireManualSelection = require(AccountUpgrade.Hooks.useRequireManualSelection)
local FFlagAccountUpgradeOAuthTelemetry = require(AccountUpgrade.Flags.FFlagAccountUpgradeOAuthTelemetry)
local AccountUpgradeDialog = require(AccountUpgrade.SuccessModal.AccountUpgradeDialog)
local AccountUpgradeDialogActions = require(AccountUpgrade.SuccessModal.AccountUpgradeDialogActions)

local BirthdayPicker = AuthSignup.Components.BirthdayPicker
local useValidatedBirthday = AuthSignup.Hooks.useValidatedBirthday

local FIntSinglePageSignupMinimumAge = SharedFlags.FIntSinglePageSignupMinimumAge

local ButtonVariant = Foundation.Enums.ButtonVariant

local function BirthdayPickerDialog(props)
	local v, v2 = useValidatedBirthday(FIntSinglePageSignupMinimumAge)

	local requireManualSelection = useRequireManualSelection()

	local onAllPicked = props.onAllPicked
	local ref

	if FFlagAccountUpgradeOAuthTelemetry then
		ref = React.useRef(false)
	else
		ref = nil
	end

	local v3

	if FFlagAccountUpgradeOAuthTelemetry then
		v3 = React.useCallback(function(p: number?, p2: number?, p3: number?)
			v2(p, p2, p3)

			if onAllPicked and ref and not ref.current and p and p2 and p3 then
				ref.current = true
				onAllPicked()
			end
		end, { v2, onAllPicked, ref })
	end

	local onConfirm = props.onConfirm
	local onActivated = React.useCallback(function()
		if v ~= nil then
			onConfirm(v)
		end
	end, { v, onConfirm })

	local onClose = props.onClose
	local onClose2 = React.useCallback(function(_)
		onClose()
	end, { onClose })

	local v4 = useLocalization({
		titleText = "Authentication.SignUp.Label.SelectBirthdaySentenceCase",
		confirmText = "Authentication.SignUp.Button.OKCaptialized"
	})

	local birthday = props.birthday
	local month

	if birthday then
		month = birthday.Month
	end

	local day

	if birthday then
		day = birthday.Day
	end

	local initialYear

	if birthday then
		initialYear = birthday.Year
	end

	return React.createElement(AccountUpgradeDialog, {
		title = v4.titleText,
		onClose = onClose2,
		hasBackdrop = true,
		testId = "account-upgrade-birthday-dialog",
		children = {
			Picker = React.createElement(BirthdayPicker, {
				layoutOrder = 1,
				minAgeAllowed = FIntSinglePageSignupMinimumAge,
				requireManualSelection = requireManualSelection,
				updateBirthday = v3 or v2,
				initialMonth = month,
				initialDay = day,
				initialYear = initialYear
			})
		},
		actions = React.createElement(AccountUpgradeDialogActions, {
			LayoutOrder = 3,
			testId = "account-upgrade-birthday-dialog-actions",
			buttons = {
				{
					text = v4.confirmText,
					variant = ButtonVariant.Emphasis,
					onActivated = onActivated,
					isDisabled = v == nil
				}
			}
		})
	})
end

local function BirthdayPickerSheet(p)
	if p.isOpen then
		return React.createElement(BirthdayPickerDialog, p)
	end

	return nil
end

return BirthdayPickerSheet
