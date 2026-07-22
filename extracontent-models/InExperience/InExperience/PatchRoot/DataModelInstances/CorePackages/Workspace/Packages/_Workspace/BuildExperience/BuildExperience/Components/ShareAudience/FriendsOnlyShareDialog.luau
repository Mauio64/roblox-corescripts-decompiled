local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize

local function FriendsOnlyShareDialog(t1: {[any]: any}) -- line: 22
	-- upvalues: LocalizationStrings (copy), ButtonVariant (copy), React (copy), Dialog (copy), DialogSize (copy)
	local t2 = {
		LayoutOrder = 3,
		actions = {
			{
				text = LocalizationStrings.SHARE_AUDIENCE_SHARE,
				variant = ButtonVariant.Emphasis,
				onActivated = t1.onShare
			},
			{
				text = LocalizationStrings.SHARE_AUDIENCE_CANCEL,
				variant = ButtonVariant.Standard,
				onActivated = t1.onCancel
			}
		}
	}

	return React.createElement(Dialog.Root, {
		testId = "build-friends-only-share-dialog",
		disablePortal = t1.disablePortal == true,
		hasBackdrop = t1.hasBackdrop == nil or t1.hasBackdrop,
		onClose = t1.onCancel,
		size = DialogSize.Small
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = LocalizationStrings.SHARE_AUDIENCE_FRIENDS_ONLY_TITLE
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			Description = React.createElement(Dialog.Text, {
				Text = LocalizationStrings.SHARE_AUDIENCE_FRIENDS_ONLY_DESCRIPTION
			})
		}),
		Actions = React.createElement(Dialog.Actions, t2)
	})
end

return FriendsOnlyShareDialog
