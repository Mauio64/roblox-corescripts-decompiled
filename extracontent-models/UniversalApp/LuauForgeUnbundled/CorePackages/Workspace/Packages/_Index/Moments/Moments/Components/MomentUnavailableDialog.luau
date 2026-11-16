local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	title = "Feature.Moments.Label.MomentUnavailable",
	body = "Feature.Moments.Label.MomentUnavailableDefault",
	ok = "Feature.Moments.Action.Ok"
}

local function MomentUnavailableDialog(p2)
	local v6 = useLocalization(v5)

	return React.createElement(
		dialog.Root,
		{
			disablePortal = false,
			size = Foundation.Enums.DialogSize.Medium,
			hasBackdrop = true
		},
		{
			DialogTitle = React.createElement(dialog.Title, {
				text = v6.title,
				LayoutOrder = 1
			}),
			DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				DialogText = React.createElement(dialog.Text, { Text = v6.body })
			}),
			DialogActions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v6.ok,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = p2.onDismiss
					}
				}
			})
		}
	)
end

return MomentUnavailableDialog
