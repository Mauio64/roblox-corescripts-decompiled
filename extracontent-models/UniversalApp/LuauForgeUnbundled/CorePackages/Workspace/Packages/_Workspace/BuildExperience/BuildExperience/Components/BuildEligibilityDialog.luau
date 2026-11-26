local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local useBuildPageEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useBuildPageEligibility")

local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize

local function BuildEligibilityDialog(p2)
	local v5 = useLocalization({
		dialogAction = LocalizationStrings.BUILD_ELIGIBILITY_DIALOG_ACTION,
		errorDescription = LocalizationStrings.BUILD_ELIGIBILITY_ERROR_DESCRIPTION,
		errorTitle = LocalizationStrings.BUILD_ELIGIBILITY_ERROR_TITLE,
		ineligibleDescription = LocalizationStrings.BUILD_ELIGIBILITY_INELIGIBLE_DESCRIPTION,
		ineligibleTitle = LocalizationStrings.BUILD_ELIGIBILITY_INELIGIBLE_TITLE
	})

	local v6 = p2.variant == useBuildPageEligibility.Status.Ineligible
	local v7 = if v6 then v5.ineligibleTitle else v5.errorTitle
	local v8 = if v6 then v5.ineligibleDescription else v5.errorDescription

	return React.createElement(
		dialog.Root,
		{ size = dialogSize.Small, testId = "build-eligibility-dialog" },
		{
			Title = React.createElement(dialog.Title, { LayoutOrder = 1, text = v7 }),
			Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				Description = React.createElement(dialog.Text, { Text = v8 })
			}),
			Actions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v5.dialogAction,
						variant = buttonVariant.Emphasis,
						onActivated = p2.onDismiss
					}
				}
			})
		}
	)
end

return BuildEligibilityDialog
