local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local useBuildPageEligibility = require(BuildExperience.useBuildPageEligibility)

local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize

local function BuildEligibilityDialog(p)
	local v = useLocalization({
		dialogAction = LocalizationStrings.BUILD_ELIGIBILITY_DIALOG_ACTION,
		errorDescription = LocalizationStrings.BUILD_ELIGIBILITY_ERROR_DESCRIPTION,
		errorTitle = LocalizationStrings.BUILD_ELIGIBILITY_ERROR_TITLE,
		ineligibleDescription = LocalizationStrings.BUILD_ELIGIBILITY_INELIGIBLE_DESCRIPTION,
		ineligibleTitle = LocalizationStrings.BUILD_ELIGIBILITY_INELIGIBLE_TITLE
	})

	local v2 = p.variant == useBuildPageEligibility.Status.Ineligible
	local text = if v2 then v.ineligibleTitle else v.errorTitle
	local text2

	if v2 then
		text2 = v.ineligibleDescription
	else
		text2 = v.errorDescription
	end

	return React.createElement(Dialog.Root, {
		size = DialogSize.Small,
		testId = "build-eligibility-dialog"
	}, {
		Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = text }),
		Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			Description = React.createElement(Dialog.Text, { Text = text2 })
		}),
		Actions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v.dialogAction,
					variant = ButtonVariant.Emphasis,
					onActivated = p.onDismiss
				}
			}
		})
	})
end

return BuildEligibilityDialog
