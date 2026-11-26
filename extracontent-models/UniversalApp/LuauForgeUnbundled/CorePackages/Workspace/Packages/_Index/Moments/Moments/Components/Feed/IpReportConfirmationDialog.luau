local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local dialog = Foundation.Dialog
local text = Foundation.Text
local view = Foundation.View

local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	ipReportCodeLabel = "Feature.ReportAbuse.Label.YourReportCode",
	ipReportSubmittedBody = "Feature.ReportAbuse.Description.IpInfringementReportModal",
	ipReportSubmittedClose = "Feature.ReportAbuse.Action.Close",
	ipReportSubmittedTitle = "Feature.ReportAbuse.Title.SelectInSceneIpReport"
}

local function IpReportConfirmationDialog(p2)
	local v6 = useLocalization(v5)

	return React.createElement(
		dialog.Root,
		{
			disablePortal = false,
			hasBackdrop = true,
			onClose = p2.onClose,
			size = Foundation.Enums.DialogSize.Medium
		},
		{
			DialogTitle = React.createElement(dialog.Title, {
				text = v6.ipReportSubmittedTitle,
				LayoutOrder = 1
			}),
			DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				ReportCodeContent = React.createElement(
					view,
					{ tag = "col align-x-center gap-small size-full-0 auto-y" },
					{
						ReportCodeLabel = React.createElement(text, {
							Text = v6.ipReportCodeLabel,
							tag = "auto-xy text-title-medium text-align-x-center content-default",
							LayoutOrder = 1
						}),
						ReportCode = React.createElement(text, {
							Text = p2.reportCode,
							tag = "auto-xy text-heading-medium text-align-x-center content-emphasis",
							LayoutOrder = 2
						}),
						ReportSubmittedBody = React.createElement(text, {
							Text = v6.ipReportSubmittedBody,
							tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default",
							RichText = true,
							LayoutOrder = 3
						})
					}
				)
			}),
			DialogActions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v6.ipReportSubmittedClose,
						variant = Foundation.Enums.ButtonVariant.Emphasis,
						onActivated = p2.onClose
					}
				}
			})
		}
	)
end

return IpReportConfirmationDialog
