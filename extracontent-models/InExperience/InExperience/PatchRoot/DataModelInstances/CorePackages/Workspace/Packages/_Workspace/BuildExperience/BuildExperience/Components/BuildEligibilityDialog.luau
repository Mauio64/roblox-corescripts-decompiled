local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local useBuildPageEligibility = require(BuildExperience.useBuildPageEligibility)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize

local function BuildEligibilityDialog(t1: {[any]: any}) -- line: 20
	-- upvalues: useBuildPageEligibility (copy), LocalizationStrings (copy), React (copy), Dialog (copy), DialogSize (copy), ButtonVariant (copy)
	local v12 = t1.variant == useBuildPageEligibility.Status.Ineligible
	local v13 = if not v12 then LocalizationStrings.BUILD_ELIGIBILITY_ERROR_TITLE else LocalizationStrings.BUILD_ELIGIBILITY_INELIGIBLE_TITLE
	local v14 = if not v12 then LocalizationStrings.BUILD_ELIGIBILITY_ERROR_DESCRIPTION else LocalizationStrings.BUILD_ELIGIBILITY_INELIGIBLE_DESCRIPTION

	return React.createElement(Dialog.Root, {
		testId = "build-eligibility-dialog",
		size = DialogSize.Small
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v13
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			Description = React.createElement(Dialog.Text, {
				Text = v14
			})
		}),
		Actions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {{
				text = LocalizationStrings.BUILD_ELIGIBILITY_DIALOG_ACTION,
				variant = ButtonVariant.Emphasis,
				onActivated = t1.onDismiss
			}}
		})
	})
end

return BuildEligibilityDialog
